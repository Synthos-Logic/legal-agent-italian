# Abbiamo chiesto a un'IA di citare solo il diritto che esiste. Ecco cosa è successo.

**Synthos Logic Lab · Caso di studio n. 1** — *adattamento editoriale per synthoslogic.com; versione integrale e dati nel [repository pubblico](https://github.com/Synthos-Logic/legal-agent-italian)*

---

C'è una domanda che chiunque lavori con il diritto si fa davanti a un modello linguistico: *scrive bene, ma cita il vero?* Perché nel diritto una citazione inventata non è un'imperfezione di stile — è un difetto squalificante. Un avvocato che cita una sentenza inesistente non ha sbagliato una virgola: ha compromesso l'atto.

Nel nostro laboratorio abbiamo deciso di trasformare questa domanda in un numero. Abbiamo preso un modello open-weights di frontiera — **GLM-5.2** — lo abbiamo ancorato a un corpus chiuso di **52 fonti ufficiali** sul diritto degli appalti italiano, gli abbiamo imposto di citare solo da lì, e abbiamo contato. Non "ci sembra affidabile": contato.

**Il risultato: 39 citazioni emesse, 39 risolte. Zero inventate.** Su una prova le cui regole erano state congelate *prima* di vedere un solo output.

## La scommessa: verificabilità by design

Il trucco — se di trucco si può parlare — è che la verificabilità non è un controllo aggiunto alla fine: è l'architettura stessa.

Abbiamo costruito il corpus come un piccolo wiki per macchine: una pagina per ogni unità citabile — un articolo del Codice dei contratti, una sentenza del TAR o del Consiglio di Stato, un parere ANAC — dove **il nome del file è l'identificativo ufficiale** (URN per le norme, ECLI per le sentenze, numero e data per i pareri). Ogni pagina porta l'impronta crittografica del documento originale scaricato; l'intero snapshot è congelato: 52 unità, piccole e fissate, che battono qualunque banca dati grande e alla deriva.

A valle, un **risolutore volutamente stupido**: legge le citazioni del modello, le cerca nell'indice, e per ognuna risponde solo "esiste" o "non esiste". Nessun giudizio, nessuna intelligenza: il tasso di citazioni non risolvibili è la nostra **metrica di invenzione** — oggettiva, meccanica, riproducibile da chiunque cloni il repository.

E per non farci raccontare i numeri a posteriori, l'intera prova è stata **pre-registrata**: rubrica di valutazione, 18 prompt (ogni quesito in tre formulazioni equivalenti, per misurare la stabilità), verità di riferimento ancorate a sentenze e pareri reali, e soglie di lettura — tutto congelato in un commit *prima* della prima chiamata al modello.

## I casi limite, dove le prove facili muoiono

Una prova che il modello può superare a memoria non misura niente. Il sotto-tema scelto — il **soccorso istruttorio** (art. 101 del Codice), l'istituto che decide quando un errore documentale in gara si può rimediare e quando costa l'esclusione — ha confini sottili, e li abbiamo cercati apposta.

Due esempi. I **costi della manodopera omessi nell'offerta**: di regola esclusione secca, *salvo* la finestra eccezionale che la prassi ANAC più recente apre quando è stata la stazione appaltante, con i suoi moduli, a indurre l'errore. Il modello ha enunciato regola, eccezione e presupposti cumulativi — distinguendo due pareri ANAC del 2025 che su fatti simili arrivano a esiti opposti. E il **documento d'offerta tecnica dimenticato**: qui il modello ha tenuto il muro, negando il soccorso in tutte e quattro le sue figure, termine di decadenza incluso, senza farsi sedurre dal *favor partecipationis*.

Avevamo perfino piazzato una trappola: nelle verità di riferimento era annotato un errore ricorrente in letteratura, un potere generale di integrazione documentale che viene spesso attribuito all'art. 107 — e che nel testo vigente **non esiste**. Il modello non ci è cascato.

## Il giudizio è rimasto umano. Ed è lì che si vede tutto.

Le metriche meccaniche non bastano: zero citazioni false non significa zero interpretazioni sbagliate. Per questo il centro del metodo è la **revisione legale umana** su scale ancorate, con un'istruttoria particolare: i nostri agenti hanno affiancato, per ogni affermazione del modello, la frase esatta della fonte di riferimento — **senza mai emettere un giudizio**. Le evidenze le prepara la macchina; il punteggio lo dà una persona.

Ed è proprio questo assetto ad aver fatto emergere i difetti veri, quelli che una valutazione automatica avrebbe lisciato: qualche refuso («sanzamento», «distintece»), segnaposto non compilati in un atto, e — il più rivelatore — **un'incursione di caratteri cinesi nel mezzo di una parola italiana** («in via自动istica»). Difetti di superficie, pesati dal revisore nei voti; ma il fatto che il sistema li *veda* è la differenza tra una demo e un metodo.

I numeri finali, contro le soglie fissate in anticipo: invenzione di fonti **0,000** · stabilità sulle parafrasi **perfetta** · registro, fedeltà e ragionamento a **mediana 5 su 5** · concordanza delle conclusioni **100%**. Con i limiti dichiarati per iscritto, revisione interna in testa — perché un risultato senza limiti dichiarati non è un risultato, è una pubblicità.

## Quello che ci portiamo via (e che porta via chi costruisce agenti)

La lezione più esportabile non è giuridica, è ingegneristica. Durante il progetto abbiamo **cambiato fornitore del modello due volte**, per cause di forza maggiore: API sature del modello inizialmente scelto, poi credenziali cloud rifiutate. Costo del cambio, entrambe le volte: **una riga di JSON**. Perché nel nostro harness il provider — Vercel AI Gateway, Ollama, API dirette — è configurazione, non codice. La resilienza al fornitore non si improvvisa a valle: si progetta a monte.

E poi: gli agenti scalano l'istruttoria, non il giudizio. Un team di agenti specializzati ha selezionato le fonti verificandole sul web, ricostruito l'accesso programmatico al portale della Giustizia Amministrativa (correggendo, per inciso, quattro errori delle riviste di rassegna — compreso un numero di sentenza sbagliato), ingerito e verificato tutto con hash, preparato i fascicoli di revisione. Ma ogni voto è stato umano. Il metodo regge davanti a lettori esperti proprio per questo.

## Aperto, riproducibile, replicabile

Tutto — corpus con hash, risolutore, harness, prompt, log integrali delle run, verbali di revisione e perfino la memoria decisionale con ogni deviazione datata e motivata — è nel repository pubblico:

**→ [github.com/Synthos-Logic/legal-agent-italian](https://github.com/Synthos-Logic/legal-agent-italian)**

Chiunque può rieseguire la catena in dry-run senza chiavi, o puntare l'harness su un altro modello cambiando quella famosa riga di JSON. Il prossimo passo naturale è duplice: la validazione di un revisore terzo indipendente sul fascicolo già pronto, e il secondo giro tematico — l'offerta economicamente più vantaggiosa — sullo stesso metodo.

*La domanda da cui eravamo partiti — "cita il vero?" — ha, per questo modello, su questo dominio, con questo metodo, una risposta misurata: sì. E adesso sappiamo anche come misurarlo la prossima volta.*

---

*Synthos Logic Lab — costruiamo agenti verificabili per domini in cui l'errore costa. Il caso di studio integrale, con metodo e limiti dichiarati, è nel repository.*
