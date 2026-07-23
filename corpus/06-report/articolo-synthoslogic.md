# Un modello cinese di frontiera alla prova della lingua giuridica italiana, su infrastruttura di nuova generazione

## Fattibilità, correttezza e allucinazioni di GLM-5.2 sul diritto degli appalti, misurate con un metodo pre-registrato e un harness costruito sul paradigma del Vercel AI Gateway

**Synthos Logic Lab · Caso di studio n. 1** · Paper — versione per synthoslogic.com
Dati, codice e memoria decisionale: [github.com/Synthos-Logic/legal-agent-italian](https://github.com/Synthos-Logic/legal-agent-italian)

---

### In sintesi

- Abbiamo valutato **GLM-5.2** — modello open-weights di frontiera sviluppato da Z.ai (Pechino), 756 miliardi di parametri, pesi pubblicati in licenza MIT — sulla **lingua giuridica italiana**, nel dominio dei contratti pubblici.
- Il modello ha lavorato ancorato a un **corpus verificabile di 52 fonti ufficiali** (Codice dei contratti, sentenze di TAR e Consiglio di Stato, pareri ANAC), organizzato secondo la convenzione **llms.txt**: una base documentale progettata per il consumo da parte di modelli e agenti.
- Tre le misure, con regole e soglie **pre-registrate** prima di osservare qualunque output: **allucinazioni** (citazioni inventate: **0 su 39**), **correttezza** (revisione legale umana: mediana 5/5 su registro, fedeltà e ragionamento; concordanza piena su quesiti riformulati), **fattibilità** (pipeline interamente automatizzata, dall'ingestione delle fonti al fascicolo di revisione).
- L'infrastruttura di esecuzione è costruita sul paradigma che Vercel ha introdotto con l'**AI Gateway**: un'unica interfaccia verso centinaia di modelli, con il fornitore ridotto a configurazione. Questa scelta è stata collaudata dai fatti: due cambi di fornitura in corso d'opera, zero righe di codice modificate.
- A nostra conoscenza, è tra i primi lavori documentati in Italia che uniscono questi tre elementi: un modello cinese di frontiera, un dominio giuridico italiano ad alta specializzazione, e una valutazione riproducibile pubblicata integralmente.

---

## 1. La sfida: la distanza massima tra modello e dominio

Chi valuta un modello linguistico sceglie, spesso senza dichiararlo, quanto rendersi la vita facile. Noi abbiamo scelto la configurazione più difficile che potessimo costruire con mezzi verificabili.

Da un lato **GLM-5.2**: un modello addestrato a dominanza cinese e inglese, espressione di un ecosistema tecnologico e giuridico lontano dal nostro. Dall'altro la **lingua giuridica italiana**, che è una lingua nella lingua: un registro formale codificato da secoli di prassi, un lessico in cui *onere* e *obbligo*, *esclusione* e *decadenza* designano istituti diversi, e una struttura delle fonti — commi, lettere, alinea, periodi — che va citata con esattezza notarile, perché nel diritto la differenza tra la lettera a) e la lettera b) è la differenza tra un concorrente riammesso e uno escluso.

In mezzo, il dominio scelto: il **soccorso istruttorio** (art. 101 del D.Lgs. 36/2023), l'istituto che stabilisce quando un errore documentale in una gara pubblica può essere rimediato e quando comporta l'esclusione. È un banco di prova ideale per tre ragioni: ha una verità di riferimento netta (una carenza è sanabile oppure no), ha l'incastro più fitto tra norma, giurisprudenza e prassi amministrativa, e ha una tassonomia — le quattro figure del soccorso — con confini sottili su cui la prassi discute ancora oggi.

Le tre domande della prova, nell'ordine che conta per l'adozione professionale:

1. **Allucinazioni**: ancorato a fonti verificabili, il modello cita solo il diritto che esiste?
2. **Correttezza**: il registro, la fedeltà alle fonti e il ragionamento reggono il giudizio di un giurista?
3. **Fattibilità**: l'intero processo — corpus, esecuzione, controllo, revisione — è automatizzabile e riproducibile a costi da laboratorio?

## 2. Il corpus: una base documentale progettata per gli agenti

"Ancorato a un corpus" è un'espressione che merita di essere spiegata per intero, perché la qualità dell'ancoraggio decide la qualità di tutto il resto.

Il corpus segue la convenzione **llms.txt**, lo standard emergente per rendere una base documentale leggibile in modo affidabile da modelli e agenti automatizzati. La struttura è a due livelli. Un **indice** (il manifest) descrive il corpus e ne elenca ogni pagina con una riga di sintesi: è la mappa che il modello riceve per orientarsi. Sotto, le **pagine atomiche**: una per ogni unità citabile — un articolo di legge, una sentenza, un parere — con un blocco di metadati strutturati (identificativo ufficiale, fonte, data del documento, data di vigenza della norma, impronta SHA-256 del file originale scaricato, data di acquisizione) e il testo integrale ripulito, con i confini di comma e paragrafo preservati come ancore.

La scelta di progettazione decisiva è che **il nome di ogni pagina è l'identificativo ufficiale del documento**: l'URN di Normattiva per le norme, il codice ECLI per le sentenze, numero e data per gli atti ANAC. Non esiste una mappa di corrispondenza separata che possa divergere: il corpus e il sistema di controllo condividono una sola chiave.

La composizione: **20 articoli** del Codice dei contratti (versione vigente congelata alla data di acquisizione — la multivigenza delle norme italiane è una trappola nota, e va disinnescata per costruzione), **20 decisioni** di TAR e Consiglio di Stato a testo integrale, **12 pareri di precontenzioso ANAC**. Tutto acquisito dalle fonti ufficiali con pipeline automatizzate — inclusa la ricostruzione dell'accesso programmatico al portale della Giustizia Amministrativa, che non offre API documentate — e verificato con impronte crittografiche. Un dato di colore istruttivo: nel verificare gli estremi sulle fonti ufficiali, la pipeline ha corretto **quattro errori presenti nelle riviste di rassegna**, compreso un numero di sentenza sbagliato. La chiave affidabile è il documento ufficiale; tutto il resto è approssimazione.

Il principio riassuntivo, che abbiamo adottato come regola del laboratorio: **piccolo e congelato batte grande e alla deriva**. Cinquantadue unità curate, fissate e verificabili valgono più di una banca dati vasta di cui nessuno può garantire lo stato.

## 3. L'infrastruttura: il paradigma Vercel AI Gateway, implementato e messo alla prova

Qui sta la parte del lavoro che riteniamo più innovativa sul piano ingegneristico, ed è il caso di spiegarla per filo e per segno.

### 3.1 Che cosa è l'AI Gateway, e perché è una svolta

Con l'AI Gateway, Vercel — l'azienda che ha definito lo standard del deployment web moderno — ha spostato il proprio baricentro verso l'**infrastruttura per applicazioni e agenti AI**. L'idea è semplice da enunciare e profonda nelle conseguenze: **un unico endpoint, un'unica chiave, un'unica interfaccia OpenAI-compatibile davanti a centinaia di modelli di decine di fornitori**. Il modello si sceglie con una stringa (`zai/glm-5.2`, nel nostro caso); il Gateway instrada la richiesta al provider di serving — per GLM-5.2, una rosa di dodici fornitori tra cui lo stesso Z.ai — e restituisce risposta, consumi e costi in formato uniforme.

Per chi costruisce agenti, i benefici concreti sono quattro. **Governo della spesa**: le chiavi si creano con tetti di spesa nativi — la nostra, dedicata al progetto, è nata con un limite di 20 dollari, un guardrail che nessuna integrazione diretta offre con questa semplicità. **Osservabilità**: token, costi e latenze per chiamata, senza strumentazione aggiuntiva. **Governo del dato**: opzioni di data retention configurabili a livello di gateway. **Portabilità**: cambiare modello o fornitore è una modifica di configurazione, non un progetto di integrazione.

### 3.2 Come l'abbiamo implementato

Il nostro harness di valutazione è costruito nativamente su questo paradigma. Ogni modello è descritto da tre soli campi di configurazione:

```json
{ "glm": { "model": "zai/glm-5.2",
           "endpoint": "https://ai-gateway.vercel.sh/v1/chat/completions",
           "api_key_env": "AI_GATEWAY_API_KEY" } }
```

Un unico transport OpenAI-compatibile serve qualunque rotta; le chiavi vivono esclusivamente in variabili d'ambiente e vengono verificate all'avvio, prima di qualunque chiamata; ogni esecuzione produce un log integrale — identificativo e versione del prompt con relativa impronta, modello richiesto **e modello effettivo restituito dal fornitore** (l'antidoto agli aggiornamenti silenziosi degli alias), endpoint, consumi, latenza, impronta dello snapshot del corpus. È il livello di tracciabilità che serve perché una valutazione sia un esperimento e non un aneddoto.

Sul Gateway abbiamo predisposto la rotta end-to-end: catalogo verificato, stringa del modello confermata, chiave di progetto creata con tetto di spesa. La run di valutazione finale è poi transitata dal cloud di Ollama attraverso il proxy locale — la via d'accesso nella disponibilità del laboratorio in quel momento — e l'API diretta di Z.ai resta configurata come terza rotta. Diciamo tutto questo con precisione perché è esattamente il punto: **tre rotte, lo stesso codice, lo stesso formato di log**.

### 3.3 La prova dei fatti: due cambi di fornitura, zero righe di codice

Il valore di un'architettura si misura quando le cose vanno storte, e in questo progetto sono andate storte due volte. Il modello inizialmente adottato per la POC (Kimi K2.6) è diventato inaccessibile per saturazione delle API del fornitore, a progetto avviato. Più avanti, la prima via cloud scelta per GLM ha rifiutato le credenziali. In entrambi i casi la continuità è costata **la modifica di un oggetto JSON**: nessuna riga di codice, nessuna modifica ai prompt, nessuna al formato dei log.

Questa resilienza non è un colpo di fortuna: è la conseguenza dell'aver adottato dal primo giorno il paradigma dell'interfaccia unificata che il Gateway rappresenta. Per un laboratorio — o un'impresa — che voglia costruire agenti in produzione, è la lezione ingegneristica centrale del progetto: **il fornitore del modello va trattato come configurazione**, e la decisione va presa all'inizio, quando costa una riga, non dopo, quando costa una migrazione.

## 4. Il controllo delle allucinazioni: un risolutore deterministico

La misura dell'invenzione è affidata a un componente volutamente essenziale: il **risolutore di citazioni**. Il modello è obbligato dal prompt a chiudere ogni risposta con un blocco di riferimenti in formato canonico; il risolutore estrae ciascun identificativo e verifica che esista nel corpus e conduca alla fonte ufficiale. Una regola aggiuntiva presidia la multivigenza: una citazione che indichi una versione temporale della norma diversa da quella congelata nel corpus viene respinta, mai risolta silenziosamente.

Il controllo è **rigorosamente deterministico**, ed è la sua forza: nessuna interpretazione, nessun margine, lo stesso esito per chiunque lo esegua, oggi o tra un anno. Il **tasso di citazioni non risolvibili** è la metrica di invenzione del progetto: oggettiva, riproducibile, confrontabile tra run e tra modelli.

## 5. Il metodo: pre-registrazione e giudizio umano

Due regole hanno governato la valutazione.

**Prima regola: tutto si congela prima di vedere il primo output.** Rubrica con scale ancorate, 18 quesiti su quattro tipi di compito (redazione di un atto, domanda-risposta ancorata, ragionamento su un caso concreto, fedeltà di citazione) — ciascun quesito in tre formulazioni semanticamente equivalenti, per misurare la stabilità —, verità di riferimento costruite su sentenze e pareri reali, e soglie di lettura dei risultati. Il tutto committato nel repository prima della prima chiamata al modello. Senza pre-registrazione, i numeri assoluti si prestano a letture di comodo; con le soglie fissate ex ante, sono misure.

**Seconda regola: nessun modello giudica un modello.** Le metriche meccaniche misurano l'invenzione e la stabilità; la qualità giuridica — registro, fedeltà interpretativa, correttezza del ragionamento — la giudica una persona, su scale ancorate. Il ruolo degli agenti nella revisione è stato istruttorio e rigorosamente delimitato: affiancare a ogni affermazione del modello la frase esatta della verità di riferimento, segnalare i riscontri oggettivi, e fermarsi lì. Le evidenze le organizza la macchina; ogni punteggio è umano. Nelle verità di riferimento era inserita anche una trappola documentata — un potere generale di integrazione documentale che la letteratura attribuisce talvolta all'art. 107 del Codice e che nel testo vigente è assente — per verificare che il modello non assecondasse un errore ricorrente.

I limiti del metodo sono dichiarati nel caso di studio integrale, revisione interna in testa: il revisore coincide con l'owner del progetto, nel ruolo di consulente interno — mitigazione nella pre-registrazione e nell'istruttoria assistita, non equivalenza a una revisione indipendente, che resta l'estensione naturale del lavoro.

## 6. I risultati

**Allucinazioni: zero.** Su 18 esecuzioni, il modello ha emesso 39 citazioni — articoli per URN, sentenze per ECLI, pareri ANAC per numero e data: il terreno classico dell'allucinazione giuridica — e il risolutore le ha risolte tutte e 39. Nessuna citazione fuori corpus; la trappola dell'art. 107 è stata ignorata correttamente.

**Correttezza: sopra la soglia di eccellenza pre-registrata su ogni dimensione.** Registro giuridico, fedeltà alle fonti e correttezza del ragionamento a mediana 5 su 5; concordanza delle conclusioni sulle formulazioni equivalenti al 100% (12 su 12). Sui due casi limite costruiti apposta, il modello ha ricostruito regola, eccezione e presupposti cumulativi dell'ammissibilità eccezionale sui costi della manodopera — distinguendo la prassi ANAC più recente — e ha mantenuto il perimetro dell'offerta tecnica contro tutte e quattro le figure del soccorso, termine di decadenza incluso.

**Le tracce dell'origine, rilevate e pesate.** La valutazione ha fatto emergere anche i difetti, ed è un pregio del metodo: refusi («sanzamento», «distintece»), segnaposto non compilati in un atto e, in un caso, **due caratteri cinesi comparsi all'interno di una parola italiana** («in via自动istica») — la traccia più eloquente della distanza linguistica di partenza. I riscontri sono stati rilevati automaticamente dall'istruttoria e pesati dal revisore nei voti. Un modello che supera la prova con i suoi difetti documentati è più credibile di un modello presentato senza difetti.

**Fattibilità: dimostrata, a costi da laboratorio.** L'intera pipeline — selezione delle fonti con verifica sul web, ingestione e conversione, congelamento con impronte, esecuzione, controllo, fascicolo di revisione — è automatizzata da un team di agenti con mandati scritti e vincoli espliciti. La run di valutazione: 18 esecuzioni, circa 157.000 token, latenza media 26 secondi per risposta.

## 7. Che cosa significa

Per il mercato italiano, il combinato di questi elementi — un modello cinese di frontiera, un dominio giuridico nazionale ad alta specializzazione, una valutazione pre-registrata pubblicata integralmente, un'infrastruttura costruita sul paradigma delle piattaforme AI di nuova generazione — è, a nostra conoscenza, tra i primi lavori documentati di questo tipo. Non lo diciamo come vanto ma come invito: il metodo è pubblico e riproducibile, e vorremmo che altri lo replicassero, lo criticassero e lo migliorassero.

C'è infine una lettura di **sovranità tecnologica**, che per il nostro laboratorio è un criterio di progetto: GLM-5.2 è distribuito con pesi aperti in licenza MIT. La strada verso un'installazione su infrastruttura europea, sotto pieno controllo di chi la usa, è concreta; questa POC ne è il primo passo documentato, e il disegno multi-rotta dell'harness è pensato esattamente per percorrerla senza riscritture.

## 8. Aperto e riproducibile

Corpus con impronte crittografiche, risolutore, harness, quesiti, log integrali, verbali di revisione e memoria decisionale completa — ogni scelta e ogni deviazione dal protocollo è una scheda datata — sono pubblici:

**→ [github.com/Synthos-Logic/legal-agent-italian](https://github.com/Synthos-Logic/legal-agent-italian)**

La catena si riesegue in dry-run senza alcuna chiave; con una modifica di configurazione, la stessa prova si ripete su qualunque modello raggiungibile via interfaccia OpenAI-compatibile — a partire dal catalogo del Vercel AI Gateway. I prossimi passi dichiarati: validazione di un revisore terzo indipendente sul fascicolo già pronto, e il secondo giro tematico sull'offerta economicamente più vantaggiosa.

---

*Synthos Logic Lab — costruiamo agenti verificabili per domini in cui l'errore costa. Ringraziamenti: a Fausto, per la proposta del nome del progetto.*
