# legal-agent-italian — Un agente legale verificabile per il diritto degli appalti italiano

**Synthos Logic Lab — Caso di studio n. 1** · Owner: Pablo Liuzzi · 2026

POC che misura come si comporta **GLM-5.2** (Z.ai, open-weights) sulla lingua giuridica italiana quando è ancorato a un **corpus verificabile di 52 fonti ufficiali** sul soccorso istruttorio (art. 101 D.Lgs. 36/2023). Ogni citazione emessa dal modello si risolve meccanicamente a una pagina del corpus e alla fonte ufficiale: **il tasso di citazioni non risolvibili è la metrica di invenzione**.

## Risultati (prova pre-registrata, run del 21/07/2026)

| Dimensione | Risultato | Soglia pre-registrata |
|---|---|---|
| **D4** — citazioni non risolvibili | **0,000** (39/39 risolte) | ≤ 0,05 eccellente |
| **D5a** — stabilità sulle parafrasi | escursione 0,0 (6/6 terne) | — |
| **D1-D3** — registro, fedeltà, ragionamento (revisione umana) | mediana **5**/5 | ≥ 4 |
| **D5b** — concordanza delle conclusioni | **100%** (12/12) | ≥ 90% |

📄 **[Il caso di studio completo](corpus/06-report/bozza-caso-di-studio.md)** — architettura, metodo, risultati, limiti dichiarati e lezioni.
📊 **[Risultati finali e verbali](eval/runs/run-20260721T150631Z/risultati-finali.md)** — tutte le metriche contro le soglie.

## Cosa c'è nel repository

```
corpus/            52 pagine LLM Wiki con hash (norme, sentenze GA, pareri ANAC) + snapshot.lock
eval/resolver/     risolutore di citazioni deterministico (19 test)
eval/harness/      harness multi-provider: il modello è configurazione, non codice (runner, aggregatore, 18+ test)
eval/prompts/      18 prompt pre-registrati (6 item × 3 varianti) + verità di riferimento
eval/runs/         log integrali delle run, metriche, fascicolo di revisione e verbali
ingest/            pipeline di ingestione (Normattiva per articolo, portale GA, PDF ANAC)
docs/              registro pubblico del protocollo metodologico (decisioni datate)
```

## Riprodurre la prova

Senza chiavi (dry-run dell'intera catena):

```sh
cd eval/harness
python3 runner.py --tasks-dir ../prompts/tasks --corpus ../../corpus/01-markdown \
  --snapshot ../../corpus/snapshot.lock --out ../runs --dry-run
```

Con un modello reale: configurare `eval/harness/models.json` (`{model, endpoint, api_key_env}` — Vercel AI Gateway, Ollama o qualunque endpoint OpenAI-compatibile) e la variabile d'ambiente indicata. Le chiavi non toccano mai repository o log.

## Metodo in una riga

Rubrica, prompt, verità di riferimento e soglie **congelati prima di osservare qualunque output**; risolutore meccanico per l'invenzione; **nessun LLM valuta i contenuti** — l'istruttoria è assistita da agenti, il giudizio è integralmente umano. Decisioni metodologiche e deviazioni, datate: [registro del protocollo](docs/protocollo-metodologico.md). Limiti dichiarati nel caso di studio.

## Licenza e fonti

Codice e documentazione originale: **MIT** ([LICENSE](LICENSE)). I documenti del corpus sono atti pubblici ufficiali riprodotti a fini di ricerca con indicazione della provenienza: Normattiva (URN:NIR), Giustizia Amministrativa (ECLI; Open GA in CC-BY 4.0), ANAC (numero e data); ogni pagina del corpus riporta l'URL della fonte ufficiale nel frontmatter. Le riproduzioni non hanno carattere di ufficialità: fa fede esclusivamente il testo pubblicato dalla fonte.

> Nota storica: il progetto nasce come "kimi-appalti"; il modello oggetto del test e il nome sono cambiati in corso d'opera, come documentato nel [registro del protocollo](docs/protocollo-metodologico.md).
