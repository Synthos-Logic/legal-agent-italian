# Un agente legale verificabile per il diritto degli appalti italiano
## Caso di studio: GLM-5.2 su corpus ancorato, con pipeline multi-agente e harness multi-provider — BOZZA v1

Synthos Logic · 2026-07-23 · Progetto [legal-agent-italian](https://github.com/Synthos-Logic/legal-agent-italian) · Owner: Pablo Liuzzi

---

### 1. Il problema: l'invenzione è il rischio, la verificabilità è il metodo

I modelli linguistici scrivono diritto in modo fluente; il punto è se citano il vero. Questa POC misura come si comporta un modello open-weights di frontiera — **GLM-5.2** (Z.ai, 756B MoE, pesi MIT) — sulla lingua giuridica italiana quando è ancorato a un corpus di fonti verificabili sul **soccorso istruttorio** (art. 101 D.Lgs. 36/2023). Il guardrail è uno solo: ogni citazione deve risolversi a una pagina del corpus e da lì alla fonte ufficiale. Il **tasso di citazioni non risolvibili è la metrica di invenzione**, meccanica e riproducibile.

### 2. Architettura

**Corpus "LLM Wiki" congelato (52 unità).** Una pagina Markdown per unità citabile — 20 articoli del Codice da Normattiva (vigenza congelata, commi come ancore), 20 decisioni TAR/Consiglio di Stato con testo integrale ufficiale ed ECLI estratti dai documenti del portale GA, 12 pareri di precontenzioso ANAC da PDF ufficiali. Il nome file è lo slug dell'identificativo (URN:NIR, ECLI, `anac:`): wiki e risolutore condividono una sola chiave. Ogni pagina porta hash SHA-256 del sorgente; `snapshot.lock` congela l'insieme.

**Risolutore deterministico.** Nessun giudizio: regex sui tre formati canonici, match sull'indice del corpus, multivigenza mai risolta silenziosamente. Output: risolte/non risolte e tasso.

**Harness endpoint-agnostico.** La lezione operativa più esportabile: il modello e la sua via d'accesso sono **configurazione, non codice** — `{model, endpoint, api_key_env}` in un JSON. Il **Vercel AI Gateway** è la rotta di default progettata (catalogo modelli, chiave con spend cap, ZDR configurabile: l'abbiamo predisposta end-to-end); la run di valutazione è passata dal **cloud Ollama via proxy locale** per scelta d'accesso dell'owner; l'API diretta Z.ai resta un fallback attivabile in una riga. Il cambio di provider — sperimentato davvero, due volte (saturazione delle API Kimi prima, chiave cloud invalida poi) — non ha toccato una riga di codice. Logging integrale per chiamata: prompt (id, versione, sha256), modello richiesto ed effettivo, endpoint, usage, latenza, hash dello snapshot.

**Pipeline multi-agente.** Sette agenti specializzati hanno costruito e custodito la POC: selezione giuridica del corpus (con verifica web delle fonti), ingestione (incluso il reverse-engineering degli endpoint del portale GA), custode di riproducibilità (hash, segreti, coerenza), istruttoria della revisione. Ogni programma, decisione e deviazione è una scheda Markdown in una memoria WikiLM versionata su git.

### 3. Metodo: pre-registrazione e giudizio umano

Rubrica, prompt (18: 6 item × canonico + 2 parafrasi sui task redazione / Q&A / ragionamento su casi limite / fedeltà di citazione), verità di riferimento e **soglie di lettura** sono stati congelati **prima di osservare qualunque output**. Salvaguardie: nessun adattamento della prova al modello; nessun LLM giudica i contenuti (l'istruttoria assistita organizza le evidenze — citazioni verbatim affiancate ai punti delle verità di riferimento — ma ogni punteggio è umano); valutazione assoluta contro verità di riferimento, senza baseline.

Deviazioni dichiarate (tutte verbalizzate in decisioni datate): revisione interna (consulente Synthos Logic, non terza parte); protocollo di **ratifica rapida** — valutazione piena di un item per caso e verifica di concordanza sulle varianti, resa legittima dall'identità quasi letterale delle terne emersa dalle metriche meccaniche.

### 4. Risultati (run-20260721T150631Z, 18/18 completati)

| Dimensione | Risultato | Soglia pre-registrata (eccellente) |
|---|---|---|
| D4 — citazioni non risolvibili | **0,000** (39/39 risolte) | ≤ 0,05 |
| D5a — stabilità del tasso sulle terne | escursione 0,0 (6/6) | — |
| D1 — registro giuridico | mediana **5**/5 | ≥ 4 |
| D2 — fedeltà alle fonti | mediana **5**/5 | ≥ 4 |
| D3 — correttezza del ragionamento | mediana **5**/5 | ≥ 4 |
| D5b — concordanza conclusioni | **12/12 = 100%** | ≥ 90% |

**Zero invenzioni di fonti** su 39 citazioni, incluse quelle "difficili" (ECLI, pareri ANAC per numero e data). Sui **casi limite** pre-selezionati per non banalizzare la prova, il modello ha distinto l'eccezione dalla regola (costi manodopera: soccorso eccezionalmente ammissibile sui presupposti cumulativi dei pareri ANAC 15 e 50/2025) e ha tenuto il limite dell'offerta tecnica (LUL: inammissibile in tutte e quattro le figure). Il rilievo negativo più interessante è di **registro**: refusi e un'incursione di caratteri cinesi in un output («in via自动istica»), intercettati meccanicamente dall'istruttoria e pesati dal revisore (D1=4 su un caso) — il tipo di difetto che una valutazione solo automatica avrebbe rischiato di non far emergere.

### 5. Limiti dichiarati

(1) Revisione interna, non indipendente; (2) protocollo compresso di ratifica; (3) nessuna baseline comparativa — i numeri sono assoluti contro soglie pre-registrate; l'harness è già N-ario e un confronto multi-modello è un'estensione a costo di sola configurazione; (4) modello servito da cloud senza digest dei pesi (pinning su versione + modello effettivo loggato); (5) la verificabilità blocca la citazione falsa, non l'interpretazione errata: per questo la revisione umana resta il centro del metodo.

### 6. Lezioni per chi costruisce agenti

1. **La verificabilità si progetta, non si aggiunge**: identificativo = nome file = chiave del risolutore. Tutto il resto ne discende.
2. **Endpoint come configurazione**: la resilienza al cambio provider (Gateway Vercel ↔ Ollama ↔ API dirette) è la vera automazione, e costa una riga di JSON.
3. **Gli agenti scalano l'istruttoria, non il giudizio**: il lavoro pesante (selezione fonti, ingestione, affiancamenti verbatim) è automatizzabile con vincoli espliciti; il punteggio resta umano e il metodo regge.
4. **Pre-registrare le soglie** è ciò che rende leggibile un risultato assoluto senza baseline.
5. **Piccolo e congelato batte grande e alla deriva**: 52 unità con hash hanno retto l'intera prova.

---

*Bozza v1 — da rifinire per pubblicazione (Synthos Logic). Dati, log e memoria decisionale integrali nel repository.*
