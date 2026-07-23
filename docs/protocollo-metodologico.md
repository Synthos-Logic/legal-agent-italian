# Registro pubblico del protocollo metodologico

Registro sintetico e datato delle decisioni metodologiche della POC, nell'ordine in cui sono state assunte. Ogni voce è verificabile nella storia del repository (date e contenuti dei commit). Le regole indicate come "pre-registrate" sono state fissate **prima** di osservare qualunque output del modello oggetto del test.

| Data | Decisione metodologica |
|---|---|
| 2026-07-20 | Impostazione della POC: guardrail di verificabilità (ogni citazione risolve a una pagina del corpus e alla fonte ufficiale; tasso di non risolvibili = metrica di invenzione); granularità del corpus: una pagina per unità citabile. |
| 2026-07-21 | Ratifica di granularità e dimensione dello snapshot (target 40-60 unità). Schema degli identificativi canonici e slug deterministico id → nome file; regola di multivigenza (citazione con vigenza diversa da quella congelata = non risolta). |
| 2026-07-21 | Normalizzazione ECLI: identificativi estratti esclusivamente dai documenti ufficiali del portale GA, suffisso di tipo atto rimosso nell'id, originale conservato nei metadati; documenti privi di ECLI verificabile esclusi dal corpus. |
| 2026-07-21 | **Congelamento pre-run** di rubrica, 18 prompt (6 item × 3 varianti), verità di riferimento e risolutore. |
| 2026-07-21 | Passaggio a valutazione **assoluta a modello singolo** (GLM-5.2; nessuna baseline comparativa): salvaguardie riformulate — nessun adattamento della prova al modello; nessun LLM valuta i contenuti; revisione umana in cieco sull'identità del modello; **soglie pre-registrate** (D4 ≤ 0,05 eccellente / ≤ 0,15 accettabile; D1-D3 mediana ≥ 4; D5b ≥ 90%; item canarino di pipeline). |
| 2026-07-21 | Corpus definitivo congelato: 52 unità (20 norme, 20 decisioni GA, 12 pareri ANAC) con hash SHA-256 per documento; 2 articoli aggiunti in esito a verifica di integrità per rendere risolvibili tutti i cross-ref. |
| 2026-07-21 | Run unica di valutazione (18/18 completati) con logging integrale; fascicolo di revisione anonimizzato: etichette neutre, ordine deterministico pseudo-casuale, varianti mai adiacenti, nessun metadato di modello; mappa di anonimizzazione custodita fuori dal fascicolo. |
| 2026-07-21 | Revisore dichiarato: **consulente interno** (non revisione indipendente di terza parte — limite riportato nel caso di studio); mitigazioni: pre-registrazione integrale e istruttoria documentale assistita con divieto di giudizi da parte degli agenti. |
| 2026-07-23 | **Protocollo di ratifica rapida**, deciso prima dell'inizio della revisione: valutazione piena di un item per caso (6) + verifica di concordanza sulle varianti (12), giustificata dall'identità quasi letterale delle terne (D5a = 0); rimozione del cieco sulle terne, verbalizzata. Scale e soglie invariate. |
| 2026-07-23 | Revisione completata e verbalizzata (convenzione di risposta e chiarimenti a verbale nei moduli di ratifica, pubblicati in `eval/runs/.../revisione/ratifica/`); risultati aggregati contro le soglie pre-registrate. |

Limiti dichiarati della POC: revisione interna; protocollo di ratifica compresso; assenza di baseline; serving cloud senza digest dei pesi (pinning su nome versione + modello effettivo loggato); la verificabilità blocca la citazione inesistente, non l'interpretazione errata di una fonte vera — per questo il giudizio resta umano.
