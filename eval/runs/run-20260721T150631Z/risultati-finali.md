# Risultati finali della POC — run-20260721T150631Z

Modello oggetto del test: **GLM-5.2** (Ollama cloud via proxy locale) · Corpus: 52 unità congelate (snapshot sha256 nel manifest) · Rubrica pre-registrata (commit `df2a3ec`), protocollo di ratifica rapida (decisione 2026-07-23) · Revisore: Consulente interno Synthos Logic.

## Tutte le metriche contro le soglie pre-registrate

| Dimensione | Risultato | Soglia "eccellente" | Esito |
|---|---|---|---|
| **D4** — tasso citazioni non risolvibili (meccanico) | **0,000** (39/39 risolte) | ≤ 0,05 | **eccellente** |
| **D5a** — stabilità del tasso sulle terne (meccanico) | escursione 0,0 su 6/6 terne | — | massima |
| **D1** — registro giuridico (umano) | voti 5,5,5,5,4,5 → **mediana 5** | mediana ≥ 4 | **eccellente** |
| **D2** — fedeltà alle fonti (umano) | voti 5,5,5,5,5,4 → **mediana 5** | mediana ≥ 4 | **eccellente** |
| **D3** — correttezza del ragionamento (umano) | voti 4,5,5,5,5,5 → **mediana 5** | mediana ≥ 4 | **eccellente** |
| **D5b** — concordanza delle conclusioni sulle terne (umano) | **12/12 concordi = 100%** | ≥ 90% | **eccellente** |
| Canarino di pipeline (T4) | superato | — | prova valida |

## Conclusioni del revisore per caso

| Caso | Conclusione ratificata |
|---|---|
| 1 — Redazione atto di soccorso | Atto conforme al quesito (D3=4: manca la clausola del fascicolo virtuale; «termine perentorio» senza riscontro testuale nella norma) |
| 2 — Garanzia provvisoria omessa | Sanabile con condizioni (data certa); nessuna fonte fuori corpus |
| 3 — DGUE del tutto omesso | Soccorso obbligatorio, no esclusione immediata (riconduzione alla lett. b ritenuta accettabile) |
| 4 — Costi manodopera (caso limite) | Soccorso eccezionalmente ammissibile, presupposti cumulativi correttamente enucleati |
| 5 — LUL su offerta tecnica (caso limite) | Richiesta respinta, soccorso inammissibile in tutte le figure (D1=4: refusi nella terna) |
| 6 — Fedeltà di citazione art. 101 | Esposizione fedele con partizioni esatte (D2=4: alinea del co. 1 non riportata) |

## Rilievi oggettivi a margine (istruttoria meccanica)

Anomalie di lingua negli output, pesate dal revisore in D1: caratteri non latini («in via自动istica», item-15), «sanzamento» (item-06), «distintece» (item-08), «detata» (item-10), «esprimeamente» (item-04), «adempiimento» (item-01), segnaposto non compilati nell'atto (item-06, item-11).

## Limiti dichiarati (da riportare integralmente nel caso di studio)

1. Revisione interna (owner = revisore), non di terza parte; mitigata da pre-registrazione di scale/soglie/verità di riferimento e istruttoria documentale assistita a giudizio integralmente umano.
2. Protocollo di ratifica rapida: valutazione piena di 1 item per caso + concordanza sulle varianti; cieco sulle terne rimosso e verbalizzato.
3. Nessuna baseline: risultati assoluti contro verità di riferimento e soglie pre-registrate.
4. Modello servito da cloud Ollama senza digest dei pesi: pinning su nome versione + `modello_effettivo` loggato.
