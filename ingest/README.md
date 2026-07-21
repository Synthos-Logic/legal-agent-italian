# ingest — pipeline di ingestione del corpus

Convenzioni bloccate dal [BRIEF.md](../BRIEF.md) §7:

| Sorgente | Formato | Conversione |
|---|---|---|
| Giustizia Amministrativa | HTML | `pandoc -t gfm --wrap=none` |
| ANAC (delibere/pareri) | PDF | `pdftotext -layout` |
| Normattiva | XML strutturato (Akoma Ntoso / XML NIR) | passo Python3 per articolo: frontmatter + corpo, granularità di articolo preservata |

Regole:

- Shell `sh` senza brace expansion; ciclo `for` per i `mkdir`.
- Python3 per la manipolazione testuale multi-file.
- Originali grezzi in `../corpus/00-originali/`, pagine markdown in `../corpus/01-markdown/`.
- Ogni download registra hash SHA-256 e data di fetch in `../corpus/snapshot.lock`.
- Trappola multivigenza: fissare `data_vigenza` per ogni norma.
- Il passo XML deve preservare i confini di articolo e comma (ancore), non solo estrarre testo.

Nota ambiente (verificato 2026-07-20): `pandoc` non è installato sulla macchina — installarlo (es. `brew install pandoc`) prima dell'ingestione GA; verificare anche `pdftotext` (poppler).
