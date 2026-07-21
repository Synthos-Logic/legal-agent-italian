"""Generatore del fascicolo di revisione (rubrica, protocollo aggiornato).

Meccanico e deterministico: anonimizza gli output di una run in item con
etichette neutre, ordine pseudo-casuale con seme derivato dal nome della run,
varianti dello stesso caso mai adiacenti, nessun metadato (modello, usage,
latency) nel fascicolo. La mappa di anonimizzazione resta FUORI dal fascicolo
(blind_map.json nella directory della run) e si usa solo in aggregazione.

Uso:
    python3 blind_package.py --run ../runs/run-<timestamp>
"""
import argparse
import hashlib
import json
import random
import sys
from pathlib import Path

from runner import load_prompt

INTESTAZIONE_SCHEDA = """# Scheda di punteggio — revisione legale

Valutare OGNI item in autonomia, nell'ordine dato, contro le scale D1-D3 della
rubrica (`eval/rubric.md`) e le verità di riferimento (`eval/ground_truth/`).
Non consultare i log della run né la mappa di anonimizzazione prima di aver
consegnato i punteggi. Nella colonna "Conclusione sintetica" riportare in una
riga l'esito giuridico sostenuto dall'output (es. "sanabile con condizioni",
"soccorso inammissibile"): serve alla misura di concordanza D5b.

| Item | D1 registro (1-5) | D2 fedeltà (1-5) | D3 ragionamento (1-5) | Conclusione sintetica | Note |
|------|-------------------|------------------|------------------------|------------------------|------|
"""


def _record_validi(run_dir):
    esclusi = {"manifest.json", "metriche.json", "blind_map.json"}
    records = []
    for percorso in sorted(Path(run_dir).glob("*.json")):
        if percorso.name in esclusi:
            continue
        dati = json.loads(percorso.read_text(encoding="utf-8"))
        if dati.get("stato") == "ok":
            dati["_file"] = percorso.name
            records.append(dati)
    return records


def _ordina_senza_adiacenze(records, seme):
    """Ordine pseudo-casuale deterministico, a round-robin sui casi: in ogni
    giro compare al più una variante per caso, quindi due varianti dello
    stesso caso non sono mai adiacenti (con almeno due casi)."""
    rng = random.Random(seme)
    gruppi = {}
    for record in records:
        chiave = record.get("equivalente_a") or record["prompt_id"]
        gruppi.setdefault(chiave, []).append(record)
    if len(gruppi) == 1 and len(records) > 1:
        raise ValueError("Impossibile evitare adiacenze: un solo caso con più varianti")
    for varianti in gruppi.values():
        rng.shuffle(varianti)
    ordine = []
    code = {chiave: list(varianti) for chiave, varianti in gruppi.items()}
    while any(code.values()):
        giro = [chiave for chiave in code if code[chiave]]
        rng.shuffle(giro)
        if ordine and giro[0] == (ordine[-1].get("equivalente_a") or ordine[-1]["prompt_id"]):
            giro.append(giro.pop(0))
        for chiave in giro:
            ordine.append(code[chiave].pop(0))
    return ordine


def _scrivi_item(fascicolo, etichetta, record):
    prompt = load_prompt(record["prompt_file"])
    fonti = "\n".join(f"- `{doc_id}`" for doc_id in prompt["contesto"])
    contenuto = (
        f"# {etichetta}\n\n"
        f"## Quesito\n\n{prompt['corpo']}\n\n"
        f"## Fonti fornite (corpus)\n\n{fonti}\n\n"
        f"## Output da valutare\n\n{record['output'].strip()}\n"
    )
    (fascicolo / f"{etichetta}.md").write_text(contenuto, encoding="utf-8")


def genera_fascicolo(run_dir, out_name="revisione"):
    run_path = Path(run_dir)
    records = _record_validi(run_path)
    if not records:
        raise ValueError(f"Nessun record valido in {run_dir}")
    seme = int(hashlib.sha256(run_path.name.encode("utf-8")).hexdigest(), 16)
    ordine = _ordina_senza_adiacenze(records, seme)
    fascicolo = run_path / out_name
    fascicolo.mkdir(exist_ok=True)
    mappa = {}
    righe_scheda = []
    for indice, record in enumerate(ordine, start=1):
        etichetta = f"item-{indice:02d}"
        _scrivi_item(fascicolo, etichetta, record)
        mappa[etichetta] = {
            "record_file": record["_file"],
            "prompt_id": record["prompt_id"],
            "variante": record.get("variante", ""),
            "equivalente_a": record.get("equivalente_a", ""),
            "modello": record.get("modello", ""),
        }
        righe_scheda.append(f"| {etichetta} |  |  |  |  |  |")
    (fascicolo / "scheda-punteggio.md").write_text(
        INTESTAZIONE_SCHEDA + "\n".join(righe_scheda) + "\n", encoding="utf-8"
    )
    (run_path / "blind_map.json").write_text(
        json.dumps(mappa, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    return fascicolo


def main(argv=None):
    parser = argparse.ArgumentParser(description="Fascicolo di revisione anonimizzato")
    parser.add_argument("--run", required=True)
    args = parser.parse_args(argv)
    try:
        fascicolo = genera_fascicolo(args.run)
    except (OSError, ValueError, json.JSONDecodeError) as errore:
        print(f"Errore: {errore}", file=sys.stderr)
        return 2
    print(f"Fascicolo generato: {fascicolo} ({len(list(fascicolo.glob('item-*.md')))} item)")
    print(f"Mappa di anonimizzazione: {Path(args.run) / 'blind_map.json'} (non consegnarla al revisore)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
