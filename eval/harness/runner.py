"""Harness di esecuzione della POC kimi-appalti (BRIEF §4, §9.6).

Stesso harness, stessi prompt, per moonshotai/kimi-k2.6 e per Claude baseline
sul Vercel AI Gateway. Nessun ramo condizionale sul modello oltre alla stringa.
Logging integrale per ogni chiamata in eval/runs/<run>/: prompt (id, versione,
sha256), modello, output grezzo, usage, latency, hash dello snapshot del corpus.

Uso:
    python3 runner.py --tasks-dir ../prompts/tasks --corpus ../../corpus/01-markdown \
        --snapshot ../../corpus/snapshot.lock --out ../runs [--dry-run]

La chiave arriva SOLO dall'ambiente (AI_GATEWAY_API_KEY). Senza chiave: --dry-run.
"""
import argparse
import datetime
import hashlib
import json
import os
import re
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

GATEWAY_URL = "https://ai-gateway.vercel.sh/v1/chat/completions"
SYSTEM_TEMPLATE = """Sei un giurista esperto di contratti pubblici italiani. Rispondi in italiano, in registro giuridico, basandoti ESCLUSIVAMENTE sui documenti del corpus riportati sotto.

Regole di citazione (obbligatorie):
1. Ogni affermazione giuridica deve essere ancorata a un documento del corpus.
2. Chiudi SEMPRE la risposta con una sezione "### Riferimenti" che elenca, uno per riga, gli identificativi canonici dei documenti citati, esattamente come compaiono nel campo id (es. urn:nir:stato:decreto.legislativo:2023-03-31;36~art101, ECLI:IT:CDS:2024:1234, anac:parere:2024-01-17;25).
3. Non citare fonti assenti dal corpus fornito.

=== CORPUS FORNITO ===
{contesto}
=== FINE CORPUS ==="""


class RunnerError(Exception):
    """Errore dell'harness con messaggio leggibile."""


def _sha256(testo):
    return hashlib.sha256(testo.encode("utf-8")).hexdigest()


def _slug(doc_id):
    return "".join(c if re.match(r"[a-z0-9._-]", c) else "-" for c in doc_id.lower()) + ".md"


def _parse_frontmatter(testo):
    """Parser minimale del frontmatter: chiavi piatte e liste di stringhe."""
    if not testo.startswith("---"):
        return {}, testo
    righe = testo.split("\n")
    campi = {}
    chiave_lista = None
    fine = 0
    for i, riga in enumerate(righe[1:], start=1):
        if riga.strip() == "---":
            fine = i
            break
        item = re.match(r"^\s+-\s+(.*)$", riga)
        if item and chiave_lista:
            campi[chiave_lista].append(item.group(1).strip().strip('"'))
            continue
        piatta = re.match(r"^([A-Za-z_][A-Za-z0-9_]*):\s*(.*)$", riga)
        if piatta:
            chiave, valore = piatta.group(1), piatta.group(2).strip().strip('"')
            if valore:
                campi[chiave] = valore
                chiave_lista = None
            else:
                campi[chiave] = []
                chiave_lista = chiave
    corpo = "\n".join(righe[fine + 1:]).strip()
    return campi, corpo


def load_prompt(percorso):
    """Carica un prompt: frontmatter (id, task, versione, contesto) + corpo."""
    campi, corpo = _parse_frontmatter(Path(percorso).read_text(encoding="utf-8"))
    if not campi.get("id"):
        raise RunnerError(f"Prompt senza id nel frontmatter: {percorso}")
    return {
        "id": campi["id"],
        "task": campi.get("task", ""),
        "versione": str(campi.get("versione", "")),
        "contesto": list(campi.get("contesto", [])),
        "corpo": corpo,
        "file": str(percorso),
    }


def build_messages(prompt, corpus_dir):
    """Monta i messaggi: system con le pagine del corpus richieste + domanda."""
    blocchi = []
    for doc_id in prompt["contesto"]:
        pagina = Path(corpus_dir) / _slug(doc_id)
        if not pagina.is_file():
            raise RunnerError(f"Contesto assente dal corpus: {doc_id} ({pagina.name})")
        blocchi.append(pagina.read_text(encoding="utf-8"))
    sistema = SYSTEM_TEMPLATE.format(contesto="\n\n---\n\n".join(blocchi))
    return [
        {"role": "system", "content": sistema},
        {"role": "user", "content": prompt["corpo"]},
    ]


def gateway_transport(model, messages, api_key):
    """Chiamata al Vercel AI Gateway (endpoint OpenAI-compatibile)."""
    corpo = json.dumps({"model": model, "messages": messages}).encode("utf-8")
    richiesta = urllib.request.Request(
        GATEWAY_URL,
        data=corpo,
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(richiesta, timeout=300) as risposta:
            dati = json.loads(risposta.read().decode("utf-8"))
    except urllib.error.HTTPError as errore:
        dettaglio = errore.read().decode("utf-8", errors="replace")[:500]
        raise RunnerError(f"Gateway HTTP {errore.code} per {model}: {dettaglio}") from errore
    except (urllib.error.URLError, TimeoutError) as errore:
        raise RunnerError(f"Gateway irraggiungibile per {model}: {errore}") from errore
    try:
        output = dati["choices"][0]["message"]["content"]
    except (KeyError, IndexError) as errore:
        raise RunnerError(f"Risposta gateway inattesa per {model}: {dati}") from errore
    return {"output": output, "usage": dati.get("usage", {}), "raw": dati}


def compute_snapshot_hash(snapshot_file):
    return _sha256(Path(snapshot_file).read_text(encoding="utf-8"))


def load_models_config(percorso):
    try:
        modelli = json.loads(Path(percorso).read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as errore:
        raise RunnerError(f"models.json illeggibile: {errore}") from errore
    if not isinstance(modelli, dict) or not modelli:
        raise RunnerError("models.json deve essere un oggetto {alias: stringa_modello}")
    return modelli


def _record_base(prompt, model, messages, snapshot_sha):
    testo_prompt = json.dumps(messages, ensure_ascii=False, sort_keys=True)
    return {
        "prompt_id": prompt["id"],
        "prompt_file": prompt["file"],
        "prompt_versione": prompt["versione"],
        "task": prompt["task"],
        "modello": model,
        "prompt_sha256": _sha256(testo_prompt),
        "snapshot_sha256": snapshot_sha,
        "timestamp_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
    }


def run_all(prompt_files, corpus_dir, models, snapshot_file, out_dir,
            api_key, dry_run, transport):
    """Esegue tutti i prompt su tutti i modelli, identicamente. Ritorna la dir della run."""
    if not dry_run and not api_key:
        raise RunnerError(
            "AI_GATEWAY_API_KEY assente: esportala nell'ambiente oppure usa --dry-run"
        )
    snapshot_sha = compute_snapshot_hash(snapshot_file)
    marca = datetime.datetime.now(datetime.timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    run_dir = Path(out_dir) / f"run-{marca}{'-dry' if dry_run else ''}"
    run_dir.mkdir(parents=True, exist_ok=False)
    manifest = {
        "dry_run": dry_run,
        "modelli": models,
        "snapshot_sha256": snapshot_sha,
        "prompt_files": [str(p) for p in prompt_files],
        "gateway": GATEWAY_URL,
    }
    (run_dir / "manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    for prompt_file in prompt_files:
        prompt = load_prompt(prompt_file)
        messages = build_messages(prompt, corpus_dir)
        for alias, model in sorted(models.items()):
            record = _record_base(prompt, model, messages, snapshot_sha)
            if dry_run:
                record.update({"stato": "dry_run", "output": None, "usage": None,
                               "latency_ms": None})
            else:
                inizio = time.monotonic()
                try:
                    risposta = transport(model, messages, api_key)
                    record.update({
                        "stato": "ok",
                        "output": risposta["output"],
                        "usage": risposta.get("usage", {}),
                        "latency_ms": round((time.monotonic() - inizio) * 1000),
                    })
                except RunnerError as errore:
                    record.update({"stato": "errore", "errore": str(errore),
                                   "output": None, "usage": None,
                                   "latency_ms": round((time.monotonic() - inizio) * 1000)})
            nome = f"{re.sub(r'[^a-z0-9-]', '-', prompt['id'].lower())}--{alias}.json"
            (run_dir / nome).write_text(
                json.dumps(record, ensure_ascii=False, indent=2), encoding="utf-8"
            )
    return run_dir


def main(argv=None):
    parser = argparse.ArgumentParser(description="Harness kimi-appalti")
    parser.add_argument("--tasks-dir", required=True)
    parser.add_argument("--corpus", required=True)
    parser.add_argument("--snapshot", required=True)
    parser.add_argument("--out", required=True)
    parser.add_argument("--models", default=str(Path(__file__).parent / "models.json"))
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args(argv)
    try:
        modelli = load_models_config(args.models)
        prompt_files = sorted(Path(args.tasks_dir).glob("*.md"))
        if not prompt_files:
            raise RunnerError(f"Nessun prompt trovato in {args.tasks_dir}")
        run_dir = run_all(
            prompt_files=prompt_files,
            corpus_dir=args.corpus,
            models=modelli,
            snapshot_file=args.snapshot,
            out_dir=args.out,
            api_key=os.environ.get("AI_GATEWAY_API_KEY"),
            dry_run=args.dry_run,
            transport=gateway_transport,
        )
    except RunnerError as errore:
        print(f"Errore: {errore}", file=sys.stderr)
        return 2
    print(f"Run completata: {run_dir}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
