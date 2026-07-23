# Un modello cinese alla prova del diritto italiano: la verificabilità si può misurare

**Synthos Logic Lab · Caso di studio n. 1** — *adattamento editoriale per synthoslogic.com; metodo integrale e dati nel [repository pubblico](https://github.com/Synthos-Logic/legal-agent-italian)*

---

Abbiamo messo alla prova **GLM-5.2**, uno dei più avanzati modelli linguistici open-weights sviluppati in Cina, su uno dei terreni più difficili per qualunque intelligenza artificiale: la **lingua giuridica italiana**. Gli abbiamo affidato quesiti reali di diritto degli appalti, ancorandolo a un corpus di 52 fonti ufficiali, e abbiamo misurato tre cose: quante citazioni inventa, quanto è stabile, quanto regge il giudizio di un giurista.

I risultati, su una prova con regole fissate prima di vedere qualunque risposta: **39 citazioni emesse, 39 verificate come esistenti**. Stabilità piena su quesiti riformulati. Registro, fedeltà alle fonti e ragionamento valutati dal revisore legale con mediana 5 su 5.

## Perché proprio un modello cinese sull'italiano giuridico

Questo era il cuore della prova, ed è bene dirlo subito. GLM-5.2 nasce da un ecosistema linguistico e giuridico lontanissimo dal nostro: addestramento a dominanza cinese e inglese, tradizione giuridica diversa, zero familiarità "nativa" con il formulario delle nostre stazioni appaltanti. L'italiano giuridico, per giunta, è una lingua nella lingua: registro rigido, lessico tecnico dove *onere* e *obbligo* sono cose diverse, partizioni normative (commi, lettere, alinea) che vanno citate con esattezza notarile.

La domanda di ricerca era quindi doppia. La prima: un modello open-weights di frontiera, nato altrove, sa *scrivere da giurista italiano*? La seconda, più importante per l'uso professionale: ancorato a fonti verificabili, **cita solo il diritto che esiste**?

La risposta alla seconda domanda è un numero: zero invenzioni. La risposta alla prima è più sfumata, ed è la parte più interessante del caso: il modello ha prodotto atti e pareri in registro pieno, ha maneggiato correttamente le quattro figure del soccorso istruttorio, e insieme ha lasciato qualche traccia della sua origine — refusi, e in un caso **due caratteri cinesi comparsi dentro una parola italiana** («in via自动istica»). Il nostro sistema li ha rilevati automaticamente e il revisore li ha pesati nel voto. È esattamente il livello di dettaglio a cui una valutazione seria deve arrivare.

## Come si misura l'invenzione: la verificabilità come architettura

Il principio del progetto è che la verificabilità va progettata, non aggiunta alla fine come un controllo di cortesia.

Il corpus è costruito come un piccolo wiki per macchine: una pagina per ogni unità citabile — un articolo del Codice dei contratti, una sentenza del TAR o del Consiglio di Stato, un parere ANAC — e **il nome di ogni pagina è l'identificativo ufficiale** del documento (URN per le norme, ECLI per le sentenze, numero e data per i pareri). Ogni pagina conserva l'impronta crittografica del documento originale; l'insieme è congelato in uno snapshot: 52 unità curate e fissate, ricostruibili una per una dalla fonte ufficiale.

A valle lavora un **risolutore deterministico**: legge le citazioni prodotte dal modello e verifica, per ciascuna, che l'identificativo esista nel corpus e conduca alla fonte ufficiale. È un controllo rigorosamente meccanico, e questa è la sua forza: niente interpretazioni, niente margini, lo stesso esito per chiunque lo esegua. Il **tasso di citazioni non risolvibili** diventa così la metrica di invenzione: oggettiva, riproducibile, confrontabile nel tempo.

Al rigore del controllo corrisponde il rigore della prova: rubrica di valutazione, 18 quesiti (ognuno in tre formulazioni equivalenti, per misurare la stabilità), verità di riferimento ancorate a sentenze e pareri reali, soglie di lettura — tutto **pre-registrato e congelato in un commit prima della prima chiamata al modello**. È la garanzia che i numeri finali sono misure, e restano tali anche davanti al lettore più esigente.

## I casi limite: dove si vede la differenza

Una prova su casi facili dice poco. Il soccorso istruttorio — l'istituto che stabilisce quando un errore documentale in gara è rimediabile e quando costa l'esclusione — offre confini sottili, e li abbiamo cercati apposta.

Sui **costi della manodopera omessi nell'offerta economica**, il modello ha ricostruito regola ed eccezione come nella prassi ANAC più recente: esclusione come principio, apertura eccezionale quando è la stessa stazione appaltante, con moduli e disciplinare, ad aver indotto l'errore — con i presupposti cumulativi al posto giusto. Sul **documento d'offerta tecnica dimenticato**, ha mantenuto il limite: soccorso escluso in tutte e quattro le sue figure, termine di decadenza compreso.

Nelle verità di riferimento avevamo inserito anche una trappola documentata: un potere generale di integrazione documentale che la letteratura attribuisce spesso all'art. 107 del Codice, e che nel testo vigente è assente. Il modello lo ha ignorato, correttamente.

## Il giudizio resta umano, gli agenti fanno l'istruttoria

Le metriche meccaniche misurano l'invenzione; la qualità giuridica la giudica una persona. La revisione è avvenuta su scale ancorate e fascicoli preparati da un team di agenti con un mandato preciso: affiancare a ogni affermazione del modello la frase esatta della fonte di riferimento, **e fermarsi lì**. Le evidenze le organizza la macchina; ogni voto è del revisore. È questa divisione del lavoro che rende il metodo difendibile: gli agenti scalano l'istruttoria, il giudizio resta umano.

Lo stesso team di agenti ha costruito il corpus verificando ogni fonte: nel farlo ha ricostruito l'accesso programmatico al portale della Giustizia Amministrativa e ha corretto quattro errori presenti nelle riviste di rassegna, compreso un numero di sentenza sbagliato. Anche questa è una lezione: la chiave affidabile è il documento ufficiale.

## La lezione ingegneristica: il fornitore del modello è configurazione

Durante il progetto abbiamo cambiato fornitore del modello due volte, per cause esterne: prima la saturazione delle API del modello inizialmente adottato, poi un problema di credenziali sulla via cloud. Entrambe le volte il cambio è costato **una riga di JSON**, perché l'harness tratta modello, endpoint e chiave come configurazione: Vercel AI Gateway, Ollama, API dirette sono rotte intercambiabili sullo stesso codice. Per chi costruisce agenti in produzione, questa resilienza è un requisito di progetto, e conviene deciderla il primo giorno.

C'è anche una lettura di sovranità: GLM-5.2 è distribuito con pesi aperti in licenza MIT. Il percorso verso un'installazione su infrastruttura europea, sotto controllo pieno di chi la usa, è concreto — e questa POC ne è il primo passo documentato.

## Aperto e riproducibile

Corpus con impronte crittografiche, risolutore, harness, quesiti, log integrali delle run, verbali di revisione e memoria decisionale completa — ogni scelta e ogni deviazione dal protocollo è una scheda datata — sono nel repository pubblico:

**→ [github.com/Synthos-Logic/legal-agent-italian](https://github.com/Synthos-Logic/legal-agent-italian)**

La catena si può rieseguire in dry-run senza alcuna chiave; con una riga di configurazione, chiunque può ripetere la prova su un altro modello. I prossimi passi dichiarati: la validazione di un revisore terzo indipendente sul fascicolo già pronto, e il secondo giro tematico sull'offerta economicamente più vantaggiosa.

---

*Synthos Logic Lab — costruiamo agenti verificabili per domini in cui l'errore costa. Il caso di studio integrale, con metodo, risultati e limiti dichiarati, è nel repository.*
