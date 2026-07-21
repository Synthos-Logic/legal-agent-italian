# Risolutore di citazioni — specifica (BRIEF §8)

**Input:** le citazioni emesse dal modello.
**Controllo:** per ciascuna citazione, verificare che l'identificativo (URN:NIR / ECLI / n.+data ANAC) esista nel corpus, risolva a una pagina in `../../corpus/01-markdown/`, e da lì alla `fonte_ufficiale` nel frontmatter.
**Output:** elenco di riferimenti risolti e non risolti; il **tasso di non risolvibili è la metrica di invenzione**.

Proprietà non negoziabili:

- Deterministico e meccanico: basato sugli identificativi, non su un giudizio.
- Applicato in modo identico a Kimi e a Claude.
- La chiave di risoluzione è il nome file della pagina (= identificativo): nessuna mappa parallela.
- Attenzione multivigenza: un riferimento a una versione temporale diversa da `data_vigenza` non deve risolvere silenziosamente.
