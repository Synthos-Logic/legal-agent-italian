"""Risolutore di citazioni della POC legal-agent-italian (BRIEF §8).

Deterministico e meccanico: una citazione risolve se e solo se il suo
identificativo canonico esiste nell'indice del corpus e — per gli URN con
suffisso !vig= — la data coincide con la data_vigenza congelata della pagina.
Nessun giudizio, nessun ramo condizionale sul modello valutato.

Identificativi canonici (memoria/decisioni/2026-07-21-schema-id-e-nomi-file.md):
- norme:      urn:nir:stato:decreto.legislativo:2023-03-31;36~art101[!vig=YYYY-MM-DD]
- decisioni:  ECLI:IT:<UFFICIO>:<ANNO>:<NUMERO>
- atti ANAC:  anac:<delibera|parere>:<YYYY-MM-DD>;<numero>

Uso da riga di comando:
    python3 resolver.py --corpus ../../corpus/01-markdown --input output_modello.txt
"""
import argparse
import json
import re
import sys
from pathlib import Path

RE_URN = re.compile(
    r"urn:nir:[a-z.;:0-9-]+~art[0-9a-z.-]+(?:!vig=\d{4}-\d{2}-\d{2})?",
    re.IGNORECASE,
)
RE_ECLI = re.compile(r"ECLI:[A-Z]{2}:[A-Z0-9]+:\d{4}:\d+")
RE_ANAC = re.compile(r"anac:(?:delibera|parere):\d{4}-\d{2}-\d{2};\d+")
RE_VIG = re.compile(r"!vig=(\d{4}-\d{2}-\d{2})$")

MOTIVO_ASSENTE = "assente_dal_corpus"
MOTIVO_MALFORMATO = "formato_non_riconosciuto"
MOTIVO_VIGENZA = "vigenza_mismatch"


def id_to_filename(doc_id):
    """Slug deterministico id -> nome file. Unica implementazione condivisa
    da ingest e risolutore: minuscole, caratteri fuori [a-z0-9._-] -> '-'."""
    slug = "".join(c if re.match(r"[a-z0-9._-]", c) else "-" for c in doc_id.lower())
    return slug + ".md"


def _parse_frontmatter(text):
    """Parser minimale del frontmatter YAML piatto (chiave: valore)."""
    if not text.startswith("---"):
        return {}
    lines = text.split("\n")
    campi = {}
    for line in lines[1:]:
        if line.strip() == "---":
            break
        match = re.match(r"^([A-Za-z_][A-Za-z0-9_]*):\s*(.*)$", line)
        if match:
            chiave, valore = match.group(1), match.group(2).strip().strip('"')
            if valore:
                campi[chiave] = valore
    return campi


def load_corpus_index(corpus_dir):
    """Indicizza il corpus: id (dal frontmatter) -> metadati della pagina.

    Verifica la coerenza nome file == id_to_filename(id): una pagina
    incoerente e' un errore di corpus (ValueError), non un mancato match.
    """
    corpus_path = Path(corpus_dir)
    if not corpus_path.is_dir():
        raise ValueError(f"Directory corpus inesistente: {corpus_dir}")
    index = {}
    for pagina in sorted(corpus_path.glob("*.md")):
        if pagina.name.startswith("_"):
            continue
        campi = _parse_frontmatter(pagina.read_text(encoding="utf-8"))
        doc_id = campi.get("id")
        if not doc_id:
            raise ValueError(f"Pagina senza id nel frontmatter: {pagina.name}")
        atteso = id_to_filename(doc_id)
        if pagina.name != atteso:
            raise ValueError(
                f"Nome file incoerente: {pagina.name!r} != {atteso!r} per id {doc_id!r}"
            )
        if doc_id in index:
            raise ValueError(f"Id duplicato nel corpus: {doc_id}")
        index[doc_id] = {
            "pagina": pagina.name,
            "tipo": campi.get("tipo", ""),
            "titolo": campi.get("titolo", ""),
            "fonte_ufficiale": campi.get("fonte_ufficiale", ""),
            "data_vigenza": campi.get("data_vigenza", ""),
        }
    return index


def extract_citations(text):
    """Estrae gli identificativi canonici dal testo, dedup preservando l'ordine."""
    trovati = []
    for match in re.finditer(
        f"({RE_URN.pattern})|({RE_ECLI.pattern})|({RE_ANAC.pattern})", text
    ):
        citazione = match.group(0)
        if citazione not in trovati:
            trovati.append(citazione)
    return trovati


def _classifica(citazione, index):
    """Classifica una singola citazione: (risolto | None, non_risolto | None)."""
    vig_match = RE_VIG.search(citazione)
    base = RE_VIG.sub("", citazione)
    riconosciuta = (
        RE_URN.fullmatch(citazione)
        or RE_ECLI.fullmatch(citazione)
        or RE_ANAC.fullmatch(citazione)
    )
    if not riconosciuta:
        return None, {"id": citazione, "motivo": MOTIVO_MALFORMATO}
    voce = index.get(base)
    if voce is None:
        return None, {"id": citazione, "motivo": MOTIVO_ASSENTE}
    if vig_match and vig_match.group(1) != voce.get("data_vigenza"):
        return None, {
            "id": citazione,
            "motivo": MOTIVO_VIGENZA,
            "vigenza_citata": vig_match.group(1),
            "vigenza_corpus": voce.get("data_vigenza", ""),
        }
    return {
        "id": base,
        "pagina": voce["pagina"],
        "fonte_ufficiale": voce["fonte_ufficiale"],
        "tipo": voce["tipo"],
    }, None


def resolve(citations, index):
    """Risolve la lista di citazioni contro l'indice. Funzione pura:
    non muta gli input, output serializzabile JSON, deterministico."""
    risolti = []
    non_risolti = []
    for citazione in citations:
        risolto, non_risolto = _classifica(citazione, index)
        if risolto:
            risolti.append(risolto)
        else:
            non_risolti.append(non_risolto)
    totale = len(citations)
    tasso = (len(non_risolti) / totale) if totale else 0.0
    return {
        "totale": totale,
        "risolti": risolti,
        "non_risolti": non_risolti,
        "tasso_non_risolvibili": tasso,
    }


def main(argv=None):
    parser = argparse.ArgumentParser(description="Risolutore di citazioni legal-agent-italian")
    parser.add_argument("--corpus", required=True, help="directory corpus/01-markdown")
    parser.add_argument("--input", required=True, help="file di testo con l'output del modello")
    args = parser.parse_args(argv)
    try:
        index = load_corpus_index(args.corpus)
        testo = Path(args.input).read_text(encoding="utf-8")
    except (OSError, ValueError) as errore:
        print(f"Errore: {errore}", file=sys.stderr)
        return 2
    report = resolve(extract_citations(testo), index)
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
