"""Ingestione di decisioni GA (HTML/PDF) e atti ANAC (PDF) nel corpus (BRIEF §7).

I portali GA e ANAC non offrono bulk testuale: il documento arriva come file
locale (scaricato a mano o via fetch) o come URL diretto. Lo script converte
(pandoc -t gfm --wrap=none per HTML, pdftotext -layout per PDF), scrive la
pagina LLM Wiki con frontmatter completo e aggiorna snapshot.lock.

Uso (decisione GA):
    python3 atti.py --tipo decisione --ecli "ECLI:IT:CDS:2024:3985" \
        --file scaricati/cds-3985-2024.html --data 2024-05-02 \
        --titolo "Cons. Stato, sez. V, 2 maggio 2024, n. 3985" \
        --fonte "https://..." --massima "..." --figura sanante

Uso (atto ANAC):
    python3 atti.py --tipo parere --numero 25 --data 2024-01-17 \
        --file scaricati/parere-25-2024.pdf \
        --titolo "ANAC, parere di precontenzioso n. 25 del 17/01/2024" \
        --fonte "https://..." --massima "..." --figura completivo
"""
import argparse
import datetime
import hashlib
import re
import shutil
import subprocess
import sys
import urllib.request
from pathlib import Path

from normattiva import CORPUS_MD, CORPUS_ORIG, USER_AGENT, _aggiorna_snapshot, id_to_filename

FIGURE_SOCCORSO = ("integrativo", "completivo", "sanante", "procedimentale", "correttivo", "nessuna")


def _converti_html(percorso):
    if not shutil.which("pandoc"):
        raise ValueError("pandoc non installato: brew install pandoc")
    esito = subprocess.run(
        ["pandoc", "-f", "html", "-t", "gfm", "--wrap=none", str(percorso)],
        capture_output=True, text=True, timeout=120,
    )
    if esito.returncode != 0:
        raise ValueError(f"pandoc fallito su {percorso}: {esito.stderr[:300]}")
    return esito.stdout


def _converti_pdf(percorso):
    if not shutil.which("pdftotext"):
        raise ValueError("pdftotext non installato: brew install poppler")
    esito = subprocess.run(
        ["pdftotext", "-layout", str(percorso), "-"],
        capture_output=True, text=True, timeout=120,
    )
    if esito.returncode != 0:
        raise ValueError(f"pdftotext fallito su {percorso}: {esito.stderr[:300]}")
    return esito.stdout


def converti(percorso):
    suffisso = Path(percorso).suffix.lower()
    if suffisso in (".html", ".htm"):
        return _converti_html(percorso), suffisso
    if suffisso == ".pdf":
        return _converti_pdf(percorso), suffisso
    raise ValueError(f"Formato non gestito: {suffisso} (attesi .html/.htm/.pdf)")


def pulisci_testo(testo):
    """Normalizza il testo convertito: righe vuote multiple e spazi di coda."""
    testo = re.sub(r"[ \t]+\n", "\n", testo)
    return re.sub(r"\n{3,}", "\n\n", testo).strip()


def build_id(args):
    if args.tipo == "decisione":
        if not args.ecli or not re.fullmatch(r"ECLI:[A-Z]{2}:[A-Z0-9]+:\d{4}:\d+", args.ecli):
            raise ValueError("--ecli obbligatorio e in formato ECLI:IT:...:<anno>:<n>")
        return args.ecli
    if not args.numero:
        raise ValueError("--numero obbligatorio per pareri/delibere ANAC")
    return f"anac:{args.tipo}:{args.data};{args.numero}"


def build_page(doc_id, corpo, args, hash_sorgente, data_fetch):
    frontmatter = [
        "---",
        f'id: "{doc_id}"',
        f"tipo: {'decisione' if args.tipo == 'decisione' else 'parere'}",
        f'titolo: "{args.titolo}"',
        f'fonte_ufficiale: "{args.fonte}"',
        f"data_documento: {args.data}",
        "lingua: it",
        f'hash_sha256: "{hash_sorgente}"',
        f"data_fetch: {data_fetch}",
        "dominio: appalti",
        f'massima: "{args.massima}"',
        f"figura_soccorso: {args.figura}",
    ]
    if getattr(args, "ecli_portale", None):
        frontmatter.append(f'ecli_portale: "{args.ecli_portale}"')
    if args.cross_ref:
        frontmatter.append("cross_ref:")
        frontmatter += [f'  - "{r}"' for r in args.cross_ref]
    else:
        frontmatter.append("cross_ref: []")
    frontmatter.append("---")
    return "\n".join(frontmatter) + f"\n\n# {args.titolo}\n\n{corpo}\n"


def scarica(url, destinazione):
    richiesta = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(richiesta, timeout=120) as risposta:
        destinazione.write_bytes(risposta.read())


def main(argv=None):
    parser = argparse.ArgumentParser(description="Ingest decisioni GA / atti ANAC")
    parser.add_argument("--tipo", required=True, choices=("decisione", "parere", "delibera"))
    parser.add_argument("--ecli", help="ECLI (per le decisioni)")
    parser.add_argument("--numero", help="numero atto ANAC")
    parser.add_argument("--data", required=True, help="data documento YYYY-MM-DD")
    parser.add_argument("--file", help="file locale HTML/PDF")
    parser.add_argument("--url", help="URL diretto del documento")
    parser.add_argument("--titolo", required=True)
    parser.add_argument("--fonte", required=True, help="URL fonte ufficiale")
    parser.add_argument("--massima", default="", help="massima/principio (campo di recupero)")
    parser.add_argument("--figura", default="nessuna", choices=FIGURE_SOCCORSO)
    parser.add_argument(
        "--ecli-portale", dest="ecli_portale", default="",
        help="ECLI originale del portale GA (con suffisso tipo atto, es. 7870SENT)",
    )
    parser.add_argument("--cross-ref", nargs="*", default=[], dest="cross_ref")
    args = parser.parse_args(argv)
    try:
        if not re.fullmatch(r"\d{4}-\d{2}-\d{2}", args.data):
            raise ValueError("--data deve essere YYYY-MM-DD")
        if bool(args.file) == bool(args.url):
            raise ValueError("indicare esattamente uno tra --file e --url")
        doc_id = build_id(args)
        data_fetch = datetime.date.today().isoformat()
        CORPUS_ORIG.mkdir(parents=True, exist_ok=True)
        CORPUS_MD.mkdir(parents=True, exist_ok=True)
        if args.url:
            suffisso = ".pdf" if args.url.lower().endswith(".pdf") else ".html"
            sorgente = CORPUS_ORIG / (id_to_filename(doc_id).removesuffix(".md") + suffisso)
            scarica(args.url, sorgente)
        else:
            originale = Path(args.file)
            if not originale.is_file():
                raise ValueError(f"File inesistente: {args.file}")
            sorgente = CORPUS_ORIG / (
                id_to_filename(doc_id).removesuffix(".md") + originale.suffix.lower()
            )
            shutil.copyfile(originale, sorgente)
        hash_sorgente = hashlib.sha256(sorgente.read_bytes()).hexdigest()
        corpo, _ = converti(sorgente)
        corpo = pulisci_testo(corpo)
        if len(corpo) < 200:
            raise ValueError(
                f"Testo convertito sospettosamente corto ({len(corpo)} caratteri): verificare il sorgente"
            )
        pagina = build_page(doc_id, corpo, args, hash_sorgente, data_fetch)
        (CORPUS_MD / id_to_filename(doc_id)).write_text(pagina, encoding="utf-8")
        _aggiorna_snapshot(doc_id, hash_sorgente, data_fetch)
    except ValueError as errore:
        print(f"Errore: {errore}", file=sys.stderr)
        return 2
    print(f"OK  {doc_id} -> {id_to_filename(doc_id)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
