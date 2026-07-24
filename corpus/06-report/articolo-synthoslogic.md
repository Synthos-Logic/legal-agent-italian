# Si può usare un modello AI cinese in un ambiente protetto? L'abbiamo messo alla prova sull'italiano giuridico

**Synthos Logic Lab · Caso di studio n. 1** — *versione per synthoslogic.com; dati, codice e metodo completi nel [repository pubblico](https://github.com/Synthos-Logic/legal-agent-italian)*

*Tutti parlano dei modelli AI cinesi. Noi ne abbiamo preso uno dei più potenti — gratuito e open source — e gli abbiamo fatto l'esame più difficile che conosciamo: il diritto italiano degli appalti. L'obiettivo: capire se la strada per usarlo in un ambiente privato e protetto è percorribile davvero. Ecco che cosa abbiamo scoperto, e come.*

---

## 1. Perché mettere alla prova un modello cinese

Nell'ultimo anno i modelli linguistici sviluppati in Cina sono entrati stabilmente nella conversazione tecnologica mondiale. Non per curiosità esotica: alcuni di essi competono alla pari con i migliori sistemi americani, e — a differenza della gran parte di questi — vengono pubblicati **gratuitamente e con i pesi aperti**, cioè con la possibilità di scaricarli e installarli su macchine proprie.

Per un'azienda o uno studio professionale, questa combinazione apre una prospettiva concreta e molto interessante: **usare un'intelligenza artificiale di prima fascia dentro un ambiente tutelato** — i propri server, la propria infrastruttura, il proprio perimetro — senza che i dati escano mai verso servizi esterni. Per chi tratta informazioni sensibili (un ufficio legale, una pubblica amministrazione, una società regolata) non è un dettaglio: è spesso *la* condizione per poter usare l'AI.

Il modello che abbiamo scelto è **GLM-5.2**, sviluppato da Z.ai: uno dei più avanzati modelli aperti in circolazione, 756 miliardi di parametri, rilasciato con licenza MIT — la più permissiva che esista. Sulla carta, il candidato ideale per un percorso di adozione in ambienti privati.

Ma "sulla carta" non basta. Prima di investire su un'installazione protetta, bisogna rispondere a una domanda preliminare: **questo modello, sulla nostra lingua e sulle nostre materie, funziona davvero?** La nostra sperimentazione nasce esattamente per questo.

## 2. La barriera linguistica: un modello nato in cinese capisce l'italiano dei giuristi?

È l'obiezione che sentiamo più spesso, ed è sensata: un modello addestrato prevalentemente su testi cinesi e inglesi come si comporta con le altre lingue? Non con l'italiano da conversazione — quello lo maneggiano tutti — ma con l'italiano più difficile che abbiamo: **la lingua giuridica**.

Chi non è del mestiere fatica a immaginare quanto sia esigente. È un linguaggio in cui *onere* e *obbligo* non sono sinonimi, in cui la differenza tra la lettera a) e la lettera b) di un comma può decidere se un'impresa resta in gara o viene esclusa, e in cui ogni affermazione deve poggiare su una fonte citata con precisione assoluta: articolo, comma, numero di sentenza.

Abbiamo scelto come terreno di prova il **diritto degli appalti pubblici** — le regole con cui lo Stato compra beni e servizi — e in particolare il *soccorso istruttorio*: l'istituto che stabilisce quando un'impresa che ha commesso un errore nei documenti di gara può rimediare e quando invece viene esclusa. Una materia dove norme, sentenze e pareri dell'Autorità anticorruzione si intrecciano fitto, e dove gli errori dell'AI avrebbero conseguenze immediate e misurabili.

Il rischio più temuto ha un nome preciso: **allucinazione** — la tendenza dei modelli linguistici a citare, con perfetta sicurezza, sentenze e norme che non esistono. Nel diritto è il difetto che squalifica tutto il resto.

**I risultati.** Abbiamo sottoposto al modello 18 quesiti da professionista — redigere un atto, rispondere a domande su casi concreti, ragionare su situazioni al confine tra il rimediabile e l'irrimediabile — obbligandolo ad appoggiarsi a un archivio controllato di 52 fonti ufficiali. Poi abbiamo verificato tutto, con un doppio controllo: una verifica automatica su ogni citazione, e la revisione di un giurista su qualità e correttezza.

- **Citazioni inventate: zero.** Su 39 riferimenti a norme, sentenze e pareri, tutti e 39 esistono e corrispondono. Nemmeno una fonte immaginaria.
- **Qualità del ragionamento giuridico: il massimo della scala** nella revisione umana, anche sui due casi costruiti apposta per essere ambigui.
- **Coerenza: piena.** Ponendo la stessa domanda in tre formulazioni diverse, le conclusioni non cambiano — un requisito essenziale per qualunque uso professionale.
- E la barriera linguistica? Ha lasciato una sola traccia visibile, quasi simbolica: in una risposta, dentro una parola italiana, sono comparsi **due caratteri cinesi** («in via自动istica»). Il nostro sistema l'ha rilevato automaticamente e il revisore l'ha messo a verbale. È l'eccezione che fotografa la regola: la distanza linguistica di partenza c'è, ma sul piano della sostanza giuridica non ha impedito al modello di lavorare al livello richiesto.

## 3. La novità tecnica: un "centralino" per i modelli AI

C'è un terzo protagonista in questa storia, ed è quello che di solito sfugge ai racconti sull'intelligenza artificiale: **l'infrastruttura**. Vale la pena spiegarlo bene, perché è una delle novità più importanti del settore in questo momento.

Fino a ieri, collegare un'applicazione a un modello AI significava integrarsi con il singolo fornitore: le sue API, le sue chiavi, le sue fatture. Cambiare modello — perché ne esce uno migliore, o perché il fornitore ha problemi — significava rimettere mano al software.

La risposta a questo problema è il **gateway AI**: un servizio che funziona come un centralino universale. L'applicazione si collega a un unico punto; da lì può raggiungere **centinaia di modelli di decine di fornitori**, scegliendo quale usare con una semplice riga di configurazione. Vercel — una delle aziende di riferimento dell'infrastruttura web mondiale — ne ha fatto uno dei pilastri della propria piattaforma per l'AI, e noi abbiamo costruito il nostro banco di prova esattamente su questo paradigma.

Perché è importante, al di là del gergo? Per tre ragioni molto concrete, che chiunque gestisca un budget può apprezzare:

1. **Controllo dei costi.** Le chiavi di accesso si creano con un tetto di spesa: la nostra, dedicata al progetto, aveva un limite di 20 dollari. L'automazione non può sforare, per costruzione.
2. **Tracciabilità totale.** Ogni chiamata al modello viene registrata: quale modello ha risposto davvero, quanto è costato, quanto ci ha messo. Quando le automazioni lavorano da sole — ed è il futuro degli *agenti AI*, programmi che eseguono compiti in autonomia — questa tracciabilità è ciò che separa un sistema governato da una scatola nera.
3. **Libertà di cambiare.** Il fornitore del modello diventa un parametro, non un vincolo. E qui la nostra sperimentazione ha offerto la prova più convincente possibile, perché il piano è cambiato **due volte** in corso d'opera: il modello scelto inizialmente è diventato irraggiungibile per saturazione dei servizi del fornitore, e più avanti un problema di credenziali ci ha imposto un secondo cambio di strada. In entrambi i casi, l'adeguamento è costato **la modifica di una riga di configurazione**. Zero codice riscritto, zero giorni persi.

Per chi progetta automazioni e agenti AI in azienda, questa è la lezione da portare a casa: **la resilienza al fornitore si decide il primo giorno**, quando costa una riga — non dopo, quando costa una migrazione.

## 4. Come abbiamo garantito la serietà della prova

Un risultato vale quanto il metodo che lo produce. Tre regole hanno governato l'esperimento:

- **Le regole del gioco sono state fissate prima di iniziare.** Domande, criteri di valutazione, risposte di riferimento e soglie di giudizio sono stati congelati e registrati *prima* di vedere una sola risposta del modello. Nessuna possibilità di aggiustare il metro a risultati noti.
- **Le citazioni le verifica una macchina.** Ogni riferimento del modello passa per un controllo automatico che risponde a una sola domanda: questo documento esiste nell'archivio e corrisponde alla fonte ufficiale? Stesso esito per chiunque ripeta il controllo, oggi o tra un anno.
- **La qualità la giudica una persona.** Nessuna AI ha valutato un'altra AI: il giudizio su registro, fedeltà alle fonti e correttezza del ragionamento è stato interamente umano, su scale definite in anticipo. Gli agenti automatici hanno preparato il fascicolo di revisione — citazioni già affiancate alle fonti — ma senza esprimere un solo voto.

Tutto — archivio, software, domande, risposte del modello, verbali di revisione e registro datato delle decisioni di metodo — è **pubblico e riproducibile**: [github.com/Synthos-Logic/legal-agent-italian](https://github.com/Synthos-Logic/legal-agent-italian).

## 5. Che cosa ci portiamo a casa

La domanda di partenza era: *la strada per usare un modello cinese di frontiera in un ambiente privato e tutelato è percorribile?* Dopo questa sperimentazione, la nostra risposta è: **sì, e ora sappiamo anche come verificarlo, caso per caso**.

Il modello ha superato la prova linguistica più dura che potessimo costruirgli, con zero fonti inventate e un giudizio professionale ai massimi della scala. I suoi pesi sono aperti e gratuiti: l'installazione su infrastruttura propria — in Italia, in Europa, dentro il perimetro di chi la usa — è tecnicamente ed economicamente alla portata, e il banco di prova che abbiamo costruito funziona identico su un modello installato in casa: si cambia, ancora una volta, una riga di configurazione.

I prossimi passi del laboratorio: la validazione dei risultati da parte di un revisore esterno indipendente, e l'estensione della prova a un secondo tema del diritto degli appalti. Il metodo è pubblico: chi vuole replicarlo, criticarlo o adattarlo al proprio dominio trova tutto nel repository.

---

*Synthos Logic Lab — costruiamo agenti AI verificabili per i domini in cui l'errore costa. Ringraziamenti: a Fausto, per la proposta del nome del progetto.*
