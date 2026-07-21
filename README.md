# kimi-appalti — POC GLM su diritto degli appalti italiano

Synthos Logic · Owner: Pablo Liuzzi · Avvio: 2026-07-20

POC che verifica come si comporta **GLM (Zhipu/Z.ai, versione flagship)** su lingua giuridica italiana, ancorato a un corpus verificabile di diritto degli appalti (D.Lgs. 36/2023, sotto-tema: soccorso istruttorio, art. 101). **Valutazione assoluta a modello singolo** contro verità di riferimento e soglie pre-registrate: nessun confronto con altri modelli ([decisione 2026-07-21](memoria/decisioni/2026-07-21-cambio-modello-glm-no-baseline.md)).

> Nota sul nome: "kimi-appalti"/"kimi-poc-ita" è il nome storico del progetto (il modello inizialmente adottato era Kimi K2.6, sostituito da GLM per saturazione delle API); resta invariato per non rompere percorsi e memoria.

**Guardrail non negoziabile:** verificabilità. Ogni citazione deve risolversi a una pagina del corpus e da lì alla fonte ufficiale. Il tasso di riferimenti non risolvibili è la metrica di invenzione.

## Documenti di riferimento

- [BRIEF.md](BRIEF.md) — brief operativo agent-facing (da leggere per primo a ogni nuova sessione)
- [memoria/_index.md](memoria/_index.md) — indice WikiLM della memoria di progetto (decisioni, documenti, agenti, diario)
- [memoria/documenti/prerequisiti-poc-kimi-appalti.md](memoria/documenti/prerequisiti-poc-kimi-appalti.md) — prerequisiti (conversione MD del docx human-facing)

## Struttura

```
corpus/            snapshot del corpus (00-originali, 01-markdown, _index.md, snapshot.lock)
ingest/            script di download e conversione
eval/              rubrica, risolutore citazioni, prompt, run
memoria/           archivio memoria MD (WikiLM): documenti, decisioni, agenti, programmi, diario
.claude/agents/    team di agenti di progetto
```

## Regole operative permanenti

1. Il team di agenti di progetto è definito in `.claude/agents/` e documentato in [memoria/agenti/team-agenti.md](memoria/agenti/team-agenti.md).
2. Ogni programma, decisione e configurazione produce un file Markdown in `memoria/`, indicizzato in `memoria/_index.md`.
3. Ogni file caricato dall'esterno viene convertito in Markdown e archiviato in `memoria/documenti/` con frontmatter (hash sorgente, data, provenienza).

## Chiavi e ambiente

Le variabili sono elencate in [.env.example](.env.example). Le chiavi (Kimi, Vercel) restano nell'ambiente locale e nella configurazione Vercel — mai nel repository.
