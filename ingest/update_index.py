"""Rigenera corpus/_index.md dalle pagine di corpus/01-markdown/ (idempotente).

Manifest in stile llms.txt: per ogni pagina una riga con link e descrizione
(titolo + massima se presente). Sezioni per tipo: norme, decisioni, pareri.
"""
import re
import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
CORPUS_MD = BASE_DIR / "corpus" / "01-markdown"
INDEX = BASE_DIR / "corpus" / "_index.md"

INTESTAZIONE = """# Corpus appalti — soccorso istruttorio (snapshot POC)

> Manifest in stile llms.txt. Indice di tutte le pagine atomiche del corpus in `01-markdown/`.
> Una pagina per unità citabile: articolo di norma (URN:NIR), decisione (ECLI), parere/delibera ANAC (n. + data).
> Il nome file è l'identificativo (slug): wiki e risolutore condividono una sola chiave.
> Rigenerato da `ingest/update_index.py`: non modificare a mano.

Corpus congelato di fonti verificabili sul soccorso istruttorio (art. 101 D.Lgs. 36/2023) e articoli collegati, con le decisioni della Giustizia Amministrativa e i pareri ANAC che lo applicano. Ogni pagina porta frontmatter con id, hash SHA-256 del sorgente, data di fetch e — per le norme — data di vigenza congelata."""

SEZIONI = (
    ("norma", "Norme (Normattiva, URN:NIR)"),
    ("decisione", "Decisioni (Giustizia Amministrativa, ECLI)"),
    ("parere", "Pareri e delibere (ANAC)"),
)


def parse_frontmatter(testo):
    if not testo.startswith("---"):
        return {}
    campi = {}
    for riga in testo.split("\n")[1:]:
        if riga.strip() == "---":
            break
        match = re.match(r"^([A-Za-z_][A-Za-z0-9_]*):\s*(.*)$", riga)
        if match and match.group(2).strip():
            campi[match.group(1)] = match.group(2).strip().strip('"')
    return campi


def chiave_ordinamento(voce):
    """Norme per numero di articolo, altrimenti per id."""
    articolo = re.search(r"~art(\d+)", voce["id"])
    return (int(articolo.group(1)) if articolo else 0, voce["id"])


def main():
    voci = []
    for pagina in sorted(CORPUS_MD.glob("*.md")):
        campi = parse_frontmatter(pagina.read_text(encoding="utf-8"))
        if not campi.get("id"):
            print(f"Errore: pagina senza id: {pagina.name}", file=sys.stderr)
            return 1
        voci.append({
            "id": campi["id"],
            "file": pagina.name,
            "tipo": campi.get("tipo", ""),
            "titolo": campi.get("titolo", pagina.name),
            "massima": campi.get("massima", ""),
        })
    blocchi = [INTESTAZIONE]
    for tipo, titolo_sezione in SEZIONI:
        gruppo = sorted((v for v in voci if v["tipo"] == tipo), key=chiave_ordinamento)
        blocchi.append(f"\n## {titolo_sezione}\n")
        if not gruppo:
            blocchi.append("*(vuoto)*")
        for voce in gruppo:
            descrizione = voce["massima"] or voce["titolo"]
            blocchi.append(f"- [{voce['id']}](01-markdown/{voce['file']}) — {descrizione}")
    fuori_tipo = [v for v in voci if v["tipo"] not in {t for t, _ in SEZIONI}]
    if fuori_tipo:
        print(f"Errore: tipi non riconosciuti: {[v['id'] for v in fuori_tipo]}", file=sys.stderr)
        return 1
    INDEX.write_text("\n".join(blocchi) + "\n", encoding="utf-8")
    print(f"Indice rigenerato: {len(voci)} pagine")
    return 0


if __name__ == "__main__":
    sys.exit(main())
