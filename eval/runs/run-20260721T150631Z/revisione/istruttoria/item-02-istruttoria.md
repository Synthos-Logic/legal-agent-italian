# item-02 — scheda istruttoria

## 1. Verità di riferimento pertinente

`eval/ground_truth/t2-qa-01.md` (id `gt:t2-qa-01`) — «T2-01: garanzia provvisoria omessa». Individuata dal testo del quesito: domanda di partecipazione presentata senza garanzia provvisoria, costituita con data certa anteriore al termine di presentazione delle offerte; sanabilità, limiti e termine.

Punti della verità di riferimento:

1. «sì, la carenza è sanabile»
2. «L'art. 101, comma 1, lettera a), D.Lgs. 36/2023 prevede espressamente che la mancata presentazione della garanzia provvisoria è sanabile mediante documenti aventi data certa anteriore al termine fissato per la presentazione delle offerte — condizione soddisfatta nel caso proposto»
3. «La stazione appaltante assegna un termine non inferiore a cinque e non superiore a dieci giorni (co. 1)»
4. «l'inadempimento nel termine comporta l'esclusione (co. 2)»
5. «Limite: la sanatoria non può estendersi a documentazione dell'offerta tecnica o economica»
6. Citazioni attese: «`urn:nir:stato:decreto.legislativo:2023-03-31;36~art101` (eventuale richiamo pertinente all'art. 106 se fornito nel contesto — non lo è: citarlo senza fonte nel corpus è un'invenzione che il risolutore deve intercettare)»

## 2. Affermazioni chiave dell'output (citazioni testuali)

- «La carenza in esame è sanabile tramite soccorso istruttorio, alle condizioni e nei termini di seguito illustrati.»
- «Ai sensi dell'art. 101, comma 1, lettera a), del Codice dei contratti pubblici, la mancata presentazione della garanzia provvisoria rientra espressamente tra le ipotesi sanabili mediante soccorso istruttorio, a condizione che la regolarizzazione avvenga tramite documenti aventi data certa anteriore al termine fissato per la presentazione delle offerte.»
- «Pertanto, ove la garanzia sia stata costituita con data certa anteriore alla scadenza del termine di presentazione delle offerte, l'operatore economico può sanare la carenza documentale.»
- «Il soccorso istruttorio opera tuttavia solo ove il documento non sia già presente nel fascicolo virtuale dell'operatore economico al momento della scadenza del termine per la presentazione dell'offerta: in tal caso, non vi è spazio per il soccorso, dovendo considerarsi la documentazione già acquisita d'ufficio.»
- «la stazione appaltante assegna all'operatore economico un termine non inferiore a cinque giorni e non superiore a dieci giorni per integrare la documentazione mancante.»
- «il mancato adempimento dell'operatore economico alle richieste della stazione appaltante nel termine stabilito comporta l'esclusione dalla procedura di gara, ex art. 101, comma 2.»

## 3. Tabella di affiancamento

| Punto della verità di riferimento | Frase dell'output |
|---|---|
| 1. Conclusione: la carenza è sanabile | «La carenza in esame è sanabile tramite soccorso istruttorio, alle condizioni e nei termini di seguito illustrati.» (par. 1) |
| 2. Fondamento: art. 101, co. 1, lett. a); sanabilità mediante documenti con data certa anteriore; condizione soddisfatta nel caso proposto | «Ai sensi dell'art. 101, comma 1, lettera a), del Codice dei contratti pubblici, la mancata presentazione della garanzia provvisoria rientra espressamente tra le ipotesi sanabili mediante soccorso istruttorio, a condizione che la regolarizzazione avvenga tramite documenti aventi data certa anteriore al termine fissato per la presentazione delle offerte. Pertanto, ove la garanzia sia stata costituita con data certa anteriore alla scadenza del termine di presentazione delle offerte, l'operatore economico può sanare la carenza documentale.» (par. 2) |
| 3. Termine non inferiore a cinque e non superiore a dieci giorni (co. 1) | «la stazione appaltante assegna all'operatore economico un termine non inferiore a cinque giorni e non superiore a dieci giorni per integrare la documentazione mancante.» (par. 4) |
| 4. Inadempimento nel termine → esclusione (co. 2) | «il mancato adempimento dell'operatore economico alle richieste della stazione appaltante nel termine stabilito comporta l'esclusione dalla procedura di gara, ex art. 101, comma 2.» (par. 5) |
| 5. Limite: la sanatoria non si estende a documentazione dell'offerta tecnica o economica | nessuna frase corrispondente trovata |
| 6. Citazioni attese: URN art. 101 | «urn:nir:stato:decreto.legislativo:2023-03-31;36~art101» (sezione «### Riferimenti») |

Passaggio dell'output senza punto corrispondente nella verità di riferimento (riportato senza commento): «Il soccorso istruttorio opera tuttavia solo ove il documento non sia già presente nel fascicolo virtuale dell'operatore economico al momento della scadenza del termine per la presentazione dell'offerta: in tal caso, non vi è spazio per il soccorso, dovendo considerarsi la documentazione già acquisita d'ufficio.» (par. 3)

## 4. Errori tipici da rilevare (riscontro testuale, senza qualificazione)

| Tema dell'errore tipico | Frase dell'output riconducibile al tema |
|---|---|
| «negare la sanabilità» | «La carenza in esame è sanabile tramite soccorso istruttorio» (par. 1) |
| «omettere la condizione della data certa anteriore» | «a condizione che la regolarizzazione avvenga tramite documenti aventi data certa anteriore al termine fissato per la presentazione delle offerte» (par. 2) |
| «termine sbagliato» | «un termine non inferiore a cinque giorni e non superiore a dieci giorni» (par. 4) |
| «citare fonti fuori corpus» | in «### Riferimenti» compare il solo identificativo «urn:nir:stato:decreto.legislativo:2023-03-31;36~art101»; nel corpo del testo i richiami sono «art. 101, comma 1, lettera a), del Codice dei contratti pubblici» (par. 2) e «art. 101, comma 2» (par. 5); nessuna menzione dell'art. 106 |

## 5. Riscontri meccanici

- «art. 101, comma 1, lettera a)» — par. 2.
- «data certa anteriore al termine fissato per la presentazione delle offerte» — par. 2.
- «fascicolo virtuale dell'operatore economico» — par. 3.
- «termine non inferiore a cinque giorni e non superiore a dieci giorni» — par. 4.
- «art. 101, comma 2» — par. 5.
- Identificativi in «### Riferimenti»: `urn:nir:stato:decreto.legislativo:2023-03-31;36~art101` (unico).
- Termini ricorrenti: «garanzia provvisoria» (par. 2), «soccorso istruttorio» (par. 1, 3), «esclusione dalla procedura di gara» (par. 5).

## 6. Blocco per il revisore

D1: __  D2: __  D3: __  Conclusione sintetica: __
