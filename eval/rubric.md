# Rubrica di valutazione (pre-registrata)

> Stato: **riformulata il 2026-07-21 per la valutazione assoluta a modello singolo** ([[2026-07-21-cambio-modello-glm-no-baseline]], PRIMA di qualsiasi run reale), da ri-congelare col commit di checkpoint. Nessuna modifica dopo la prima run: ogni cambiamento richiede nuova decisione in `memoria/decisioni/` e invalida i risultati precedenti.
> Vincoli di indipendenza (BRIEF §10 riformulato): rubrica neutrale rispetto al modello e definita prima di osservare qualunque output; nessun adattamento di rubrica, prompt o risolutore al modello oggetto del test; revisione umana legale in cieco sull'identità del modello; il risolutore è meccanico; nessun agente o LLM valuta i contenuti degli output.

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

## Protocollo di revisione in cieco (valutazione assoluta, modello singolo)

1. **Cieco sull'identità del modello**: gli output sono anonimizzati — nessun nome del modello, nessun metadato (usage, latency, endpoint) nel materiale di revisione. Il bias verso/contro un modello esiste anche a modello singolo; il cieco lo neutralizza.
2. **Etichette e ordine**: ogni output riceve un'etichetta neutra (`item-01`…`item-N`); l'ordine di presentazione è randomizzato e le tre varianti di una stessa terna non sono mai adiacenti né riconoscibili come terna.
3. **Mappa di anonimizzazione**: `eval/runs/<run>/blind_map.json` collega etichetta → record (prompt_id, variante, modello); custodita fuori dal fascicolo di revisione, usata solo in aggregazione per de-anonimizzare i punteggi e ricostruire le terne (D5b).
4. Il revisore riceve: fascicolo del caso, fonti del corpus, output anonimizzati, verità di riferimento (per D3), scheda di punteggio (D1-D3 + concordanza D5b) — e valuta **in assoluto** contro le scale ancorate e le verità di riferimento.
5. Nessun agente o LLM valuta i contenuti degli output: solo risolutore meccanico (D4/D5a) e revisore umano (D1-D3, D5b).

## Soglie assolute di lettura (pre-registrate — unico metro in assenza di baseline)

| Metrica | Eccellente | Accettabile | Inadeguato |
|---|---|---|---|
| D4 (tasso citazioni non risolvibili, micro) | ≤ 0,05 | ≤ 0,15 | > 0,15 (invenzione sistematica) |
| D1-D3 (mediana per dimensione) | ≥ 4 | ≥ 3 | < 3 |
| D5b (terne con conclusioni concordanti) | ≥ 90% | ≥ 80% | < 80% (instabile) |

**Controllo canarino di pipeline**: la run include un item T4 a risposta meccanicamente verificabile; un fallimento sul canarino segnala un difetto della prova (harness/prompt), non del modello, e sospende la lettura dei risultati.

## Logging obbligatorio per ogni run

Prompt (id, versione, sha256), output grezzo, usage/costo, latency, stringa modello pinnata, sha256 di `corpus/snapshot.lock`. Implementato nell'harness (`eval/harness/runner.py`).

## Addendum 2026-07-21 (post-run, dichiarato) — configurazione del revisore

Il revisore è **Pablo Liuzzi, nel ruolo di "Consulente interno Synthos Logic"** ([[2026-07-21-revisore-interno]]). Il cieco sull'identità del modello decade di fatto (revisore = owner); restano attive la pre-registrazione di scale/soglie/verità di riferimento (antecedente a ogni output) e l'anonimizzazione strutturale del fascicolo (ordine randomizzato deterministico, terne non riconoscibili, nessun metadato). Scale e soglie di questa rubrica restano invariate. Limite da dichiarare nel caso di studio: revisione interna, non di terza parte.
