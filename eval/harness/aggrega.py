"""Aggregatore delle metriche meccaniche di una run (D4 e D5a della rubrica).

Applica il risolutore congelato a ogni output loggato e produce metriche.json:
- per record: citazioni estratte, non risolte, tasso_non_risolvibili (D4);
- per modello: aggregati micro/macro e stabilita' sulle terne di parafrasi (D5a).

Le dimensioni D1-D3 e D5b restano al revisore umano in cieco: questo script
non esprime alcun giudizio sui contenuti.

Uso:
    python3 aggrega.py --run ../runs/run-<timestamp> --corpus ../../corpus/01-markdown
"""
import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "resolver"))
from resolver import extract_citations, load_corpus_index, resolve  # noqa: E402


def _analizza_record(percorso, index):
    dati = json.loads(percorso.read_text(encoding="utf-8"))
    if dati.get("stato") != "ok":
        return None
    report = resolve(extract_citations(dati.get("output") or ""), index)
    return {
        "file": percorso.name,
        "prompt_id": dati.get("prompt_id", ""),
        "equivalente_a": dati.get("equivalente_a") or None,
        "modello": dati.get("modello", ""),
        "citazioni": report["totale"],
        "non_risolte": len(report["non_risolti"]),
        "tasso_non_risolvibili": report["tasso_non_risolvibili"],
        "dettaglio_non_risolte": report["non_risolti"],
        "latency_ms": dati.get("latency_ms"),
        "usage": dati.get("usage"),
    }


def _aggrega_modello(records):
    citazioni = sum(r["citazioni"] for r in records)
    non_risolte = sum(r["non_risolte"] for r in records)
    tassi = [r["tasso_non_risolvibili"] for r in records]
    gruppi = {}
    for r in records:
        canonico = r["equivalente_a"] or r["prompt_id"]
        gruppi.setdefault(canonico, []).append(r)
    terne = []
    for canonico, gruppo in sorted(gruppi.items()):
        if len(gruppo) < 2:
            continue
        tassi_gruppo = [g["tasso_non_risolvibili"] for g in gruppo]
        terne.append({
            "canonico": canonico,
            "varianti": len(gruppo),
            "escursione_tasso": max(tassi_gruppo) - min(tassi_gruppo),
        })
    return {
        "records": len(records),
        "citazioni_totali": citazioni,
        "citazioni_non_risolte": non_risolte,
        "tasso_micro": (non_risolte / citazioni) if citazioni else 0.0,
        "tasso_macro": (sum(tassi) / len(tassi)) if tassi else 0.0,
        "stabilita_terne": terne,
    }


def aggrega_run(run_dir, corpus_dir):
    """Funzione pura sul filesystem: legge la run, non la modifica."""
    run_path = Path(run_dir)
    index = load_corpus_index(corpus_dir)
    records = []
    esclusi = 0
    for percorso in sorted(run_path.glob("*.json")):
        if percorso.name in ("manifest.json", "metriche.json"):
            continue
        analisi = _analizza_record(percorso, index)
        if analisi is None:
            esclusi += 1
        else:
            records.append(analisi)
    per_modello = {}
    for modello in sorted({r["modello"] for r in records}):
        per_modello[modello] = _aggrega_modello(
            [r for r in records if r["modello"] == modello]
        )
    return {"records": records, "esclusi": esclusi, "per_modello": per_modello}


def main(argv=None):
    parser = argparse.ArgumentParser(description="Metriche meccaniche di una run")
    parser.add_argument("--run", required=True)
    parser.add_argument("--corpus", required=True)
    args = parser.parse_args(argv)
    try:
        report = aggrega_run(args.run, args.corpus)
    except (OSError, ValueError, json.JSONDecodeError) as errore:
        print(f"Errore: {errore}", file=sys.stderr)
        return 2
    destinazione = Path(args.run) / "metriche.json"
    destinazione.write_text(
        json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    for modello, dati in report["per_modello"].items():
        print(f"{modello}: {dati['records']} record, "
              f"D4 micro {dati['tasso_micro']:.3f}, macro {dati['tasso_macro']:.3f}")
    print(f"Scritto: {destinazione}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
