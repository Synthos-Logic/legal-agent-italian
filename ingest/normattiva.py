"""Ingestione articoli del D.Lgs. 36/2023 da Normattiva (BRIEF §7).

Scarica ogni articolo dal permalink URN:NIR, preserva la granularita' di
articolo e i confini di comma come ancore, scrive la pagina LLM Wiki in
corpus/01-markdown/, l'originale in corpus/00-originali/ e aggiorna
corpus/snapshot.lock.

Uso:
    python3 normattiva.py --articoli 101 94 95 --vigenza 2026-07-21
    python3 normattiva.py --lista articoli.txt --vigenza 2026-07-21
"""
import argparse
import datetime
import hashlib
import html as html_lib
import re
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
CORPUS_MD = BASE_DIR / "corpus" / "01-markdown"
CORPUS_ORIG = BASE_DIR / "corpus" / "00-originali"
SNAPSHOT = BASE_DIR / "corpus" / "snapshot.lock"

URN_BASE = "urn:nir:stato:decreto.legislativo:2023-03-31;36"
PERMALINK = "https://www.normattiva.it/uri-res/N2Ls?{urn}~art{num}!vig={vig}"
USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) kimi-appalti-poc"
PAUSA_SECONDI = 2


def _strip_tags(frammento):
    testo = re.sub(r"<br\s*/?>", "\n", frammento)
    testo = re.sub(r"<[^>]+>", " ", testo)
    testo = html_lib.unescape(testo)
    testo = re.sub(r"[ \t]+", " ", testo)
    return re.sub(r" ?\n ?", "\n", testo).strip()


def parse_article(pagina_html):
    """Estrae numero, rubrica e corpo (commi come ancore) dall'HTML Normattiva."""
    num_match = re.search(
        r'<h2 class="article-num-akn"[^>]*>\s*Articolo\s+([0-9a-z.-]+)', pagina_html
    )
    rubrica_match = re.search(
        r'<div class="article-heading-akn">\s*([^<]+?)\s*</div>', pagina_html
    )
    if not num_match:
        raise ValueError("Struttura Normattiva inattesa: numero articolo non trovato")
    numero = num_match.group(1)
    rubrica = html_lib.unescape(rubrica_match.group(1).strip()) if rubrica_match else ""

    inizio = pagina_html.find('<div class="art-commi-div-akn">')
    if inizio == -1:
        raise ValueError("Struttura Normattiva inattesa: blocco commi non trovato")
    blocco = pagina_html[inizio:]
    fine = blocco.find("</div><!-- fine")
    commi_html = blocco if fine == -1 else blocco[:fine]

    commi = re.split(r'<div class="art-comma-div-akn">', commi_html)[1:]
    if not commi:
        raise ValueError("Struttura Normattiva inattesa: nessun comma estratto")
    paragrafi = []
    for comma_html in commi:
        testo = _strip_tags(comma_html)
        numero_comma = re.match(r"^(\d+(?:-[a-z]+)?)\.\s*", testo)
        if numero_comma:
            testo = (
                f"**Comma {numero_comma.group(1)}.** "
                + testo[numero_comma.end():]
            )
        paragrafi.append(testo.strip())
    corpo = "\n\n".join(p for p in paragrafi if p)
    return {"numero": numero, "rubrica": rubrica, "corpo": corpo}


def id_to_filename(doc_id):
    """Stessa funzione del risolutore (decisione 2026-07-21-schema-id-e-nomi-file)."""
    return "".join(
        c if re.match(r"[a-z0-9._-]", c) else "-" for c in doc_id.lower()
    ) + ".md"


def build_page(articolo, data_vigenza, data_fetch, hash_sorgente):
    doc_id = f"{URN_BASE}~art{articolo['numero']}"
    fonte = PERMALINK.format(urn=URN_BASE, num=articolo["numero"], vig=data_vigenza)
    titolo = f"Codice dei contratti pubblici, art. {articolo['numero']} - {articolo['rubrica']}"
    frontmatter = "\n".join([
        "---",
        f'id: "{doc_id}"',
        "tipo: norma",
        f'titolo: "{titolo}"',
        f'fonte_ufficiale: "{fonte}"',
        "data_documento: 2023-03-31",
        f"data_vigenza: {data_vigenza}",
        "lingua: it",
        f'hash_sha256: "{hash_sorgente}"',
        f"data_fetch: {data_fetch}",
        "dominio: appalti",
        "cross_ref: []",
        "---",
    ])
    intestazione = f"# Art. {articolo['numero']} - {articolo['rubrica']}"
    return f"{frontmatter}\n\n{intestazione}\n\n{articolo['corpo']}\n"


def _aggiorna_snapshot(doc_id, hash_sorgente, data_fetch):
    """Riscrive snapshot.lock con la riga nuova/aggiornata, ordinato per id."""
    righe = {}
    commenti = []
    if SNAPSHOT.exists():
        for riga in SNAPSHOT.read_text(encoding="utf-8").splitlines():
            if riga.startswith("#"):
                commenti.append(riga)
            elif riga.strip():
                campi = riga.split("\t")
                righe[campi[0]] = riga
    righe[doc_id] = f"{doc_id}\t{hash_sorgente}\t{data_fetch}"
    contenuto = "\n".join(commenti + [righe[k] for k in sorted(righe)]) + "\n"
    SNAPSHOT.write_text(contenuto, encoding="utf-8")


def ingest_articolo(numero, data_vigenza, data_fetch, fetcher):
    url = PERMALINK.format(urn=URN_BASE, num=numero, vig=data_vigenza)
    pagina_html = fetcher(url)
    hash_sorgente = hashlib.sha256(pagina_html.encode("utf-8")).hexdigest()
    articolo = parse_article(pagina_html)
    if articolo["numero"] != str(numero):
        raise ValueError(
            f"Richiesto art. {numero} ma la pagina contiene art. {articolo['numero']}"
        )
    doc_id = f"{URN_BASE}~art{articolo['numero']}"
    CORPUS_ORIG.mkdir(parents=True, exist_ok=True)
    CORPUS_MD.mkdir(parents=True, exist_ok=True)
    originale = CORPUS_ORIG / (id_to_filename(doc_id).removesuffix(".md") + ".html")
    originale.write_text(pagina_html, encoding="utf-8")
    pagina = build_page(articolo, data_vigenza, data_fetch, hash_sorgente)
    (CORPUS_MD / id_to_filename(doc_id)).write_text(pagina, encoding="utf-8")
    _aggiorna_snapshot(doc_id, hash_sorgente, data_fetch)
    return doc_id, articolo["rubrica"]


def http_fetch(url):
    richiesta = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    try:
        with urllib.request.urlopen(richiesta, timeout=60) as risposta:
            return risposta.read().decode("utf-8", errors="replace")
    except (urllib.error.URLError, TimeoutError) as errore:
        raise ValueError(f"Download fallito per {url}: {errore}") from errore


def main(argv=None):
    parser = argparse.ArgumentParser(description="Ingest Normattiva D.Lgs. 36/2023")
    parser.add_argument("--articoli", nargs="*", default=[], help="numeri articolo")
    parser.add_argument("--lista", help="file con un numero articolo per riga")
    parser.add_argument("--vigenza", required=True, help="data di vigenza YYYY-MM-DD")
    args = parser.parse_args(argv)
    numeri = list(args.articoli)
    if args.lista:
        righe = Path(args.lista).read_text(encoding="utf-8").splitlines()
        numeri += [r.strip() for r in righe if r.strip() and not r.startswith("#")]
    if not numeri:
        print("Errore: nessun articolo indicato", file=sys.stderr)
        return 2
    if not re.match(r"^\d{4}-\d{2}-\d{2}$", args.vigenza):
        print("Errore: --vigenza deve essere YYYY-MM-DD", file=sys.stderr)
        return 2
    data_fetch = datetime.date.today().isoformat()
    errori = []
    for numero in numeri:
        try:
            doc_id, rubrica = ingest_articolo(numero, args.vigenza, data_fetch, http_fetch)
            print(f"OK  art. {numero} - {rubrica}  ({doc_id})")
        except ValueError as errore:
            errori.append((numero, str(errore)))
            print(f"ERR art. {numero}: {errore}", file=sys.stderr)
        time.sleep(PAUSA_SECONDI)
    print(f"\nCompletato: {len(numeri) - len(errori)} ok, {len(errori)} errori")
    return 1 if errori else 0


if __name__ == "__main__":
    sys.exit(main())
