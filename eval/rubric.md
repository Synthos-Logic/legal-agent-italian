# Rubrica di valutazione (pre-registrata)

> Stato: **finalizzata il 2026-07-21, da congelare col commit di checkpoint**. Nessuna modifica dopo la prima run: ogni cambiamento richiede nuova decisione in `memoria/decisioni/` e invalida i risultati precedenti.
> Vincoli di indipendenza (BRIEF §10): rubrica neutrale rispetto al modello, applicata in modo identico a Kimi K2.6 e Claude baseline; revisione umana legale in cieco su output anonimizzati e randomizzati; il risolutore è meccanico.

## Task (tassonomia, BRIEF §9.1)

| Codice | Task | Descrizione |
|---|---|---|
| T1 | Redazione in registro | Produrre un testo giuridico (es. richiesta di soccorso istruttorio, memoria) in registro adeguato |
| T2 | Q&A ancorata al corpus | Rispondere a quesiti sul soccorso istruttorio citando solo il corpus fornito |
| T3 | Ragionamento su fatto concreto | Qualificare un caso (sanabile/escluso; figura del soccorso) applicando le fonti |
| T4 | Fedeltà di citazione | Riferire correttamente contenuto e estremi di documenti del corpus |

Ogni task ha un prompt canonico + 2 parafrasi semanticamente equivalenti (stabilità).

## Dimensioni e scale

### D1 — Registro giuridico (revisore umano, scala 1-5)
1 = registro inadeguato (colloquiale o tecnicamente sgrammaticato); 3 = registro corretto con imprecisioni lessicali; 5 = registro professionale pieno, lessico tecnico esatto (es. distingue onere/obbligo, esclusione/decadenza).

### D2 — Fedeltà alle fonti fornite (revisore umano, scala 1-5)
1 = attribuisce alle fonti contenuti che non hanno; 3 = fedele nella sostanza con forzature minori; 5 = ogni affermazione riflette fedelmente il contenuto della fonte citata, incluse le distinzioni (es. documentazione dell'offerta tecnica/economica esclusa dal soccorso).

### D3 — Correttezza del ragionamento (revisore umano vs verità di riferimento, scala 1-5)
1 = conclusione errata; 3 = conclusione corretta con percorso lacunoso; 5 = conclusione e percorso conformi alla verità di riferimento (decisioni ANAC/sentenze come risposte ragionate), incluse le figure del soccorso correttamente qualificate.

### D4 — Tasso di citazioni non risolvibili (meccanico, risolutore congelato)
`tasso_non_risolvibili` dal report del risolutore su ogni output. Metrica di invenzione. Nessun giudizio umano.

### D5 — Stabilità su parafrasi (meccanico + revisore)
Per ogni terna canonico+parafrasi: (a) varianza di D4 sulla terna; (b) concordanza delle conclusioni (T3: stessa qualificazione sì/no) giudicata dal revisore in cieco. Riportata come % di terne concordanti.

## Protocollo di revisione in cieco

1. Gli output vengono anonimizzati (etichette `A`/`B` assegnate con permutazione casuale per item, mappa custodita fuori dal materiale di revisione in `eval/runs/<run>/blind_map.json`).
2. Il revisore riceve: fascicolo del caso, fonti del corpus, coppie di output anonimizzati, scheda di punteggio (D1-D3 + concordanza D5).
3. Nessun agente o modello valuta gli output: solo risolutore (D4/D5a) e revisore umano (D1-D3, D5b).

## Logging obbligatorio per ogni run

Prompt (id, versione, sha256), output grezzo, usage/costo, latency, stringa modello pinnata, sha256 di `corpus/snapshot.lock`. Implementato nell'harness (`eval/harness/runner.py`).
