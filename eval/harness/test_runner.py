"""Test dell'harness di esecuzione (TDD: scritti prima dell'implementazione).

Proprieta' verificate: parsing prompt con frontmatter e contesto, montaggio
messaggi ancorati al corpus, dry-run senza chiamate di rete, logging integrale
(prompt hash, versioni, snapshot hash, latency, usage), errore chiaro senza chiave.
"""
import json
import shutil
import tempfile
import unittest
from pathlib import Path

from runner import (
    RunnerError,
    build_messages,
    compute_snapshot_hash,
    load_models_config,
    load_prompt,
    run_all,
)

FRONTMATTER_PROMPT = """---
id: "task:t2-qa-01"
task: qa-ancorata
versione: 1
contesto:
  - "urn:nir:stato:decreto.legislativo:2023-03-31;36~art101"
---
Il concorrente ha omesso la dichiarazione X. La carenza e' sanabile?
"""

PAGINA_ART101 = """---
id: "urn:nir:stato:decreto.legislativo:2023-03-31;36~art101"
tipo: norma
titolo: "Art. 101 - Soccorso istruttorio"
fonte_ufficiale: "https://esempio.it/art101"
data_vigenza: 2026-07-20
---

Testo dell'articolo 101.
"""


class HarnessFixture(unittest.TestCase):
    def setUp(self):
        self.dir = Path(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, self.dir)
        self.corpus = self.dir / "corpus"
        self.corpus.mkdir()
        nome = "urn-nir-stato-decreto.legislativo-2023-03-31-36-art101.md"
        (self.corpus / nome).write_text(PAGINA_ART101, encoding="utf-8")
        self.prompt_file = self.dir / "t2-qa-01.md"
        self.prompt_file.write_text(FRONTMATTER_PROMPT, encoding="utf-8")
        self.snapshot = self.dir / "snapshot.lock"
        self.snapshot.write_text("# snapshot\n", encoding="utf-8")
        self.runs = self.dir / "runs"
        self.models = {"kimi": "moonshotai/kimi-k2.6", "claude": "anthropic/claude-sonnet-4.5"}


class TestLoadPrompt(HarnessFixture):
    def test_parsa_frontmatter_e_corpo(self):
        prompt = load_prompt(self.prompt_file)
        self.assertEqual(prompt["id"], "task:t2-qa-01")
        self.assertEqual(prompt["task"], "qa-ancorata")
        self.assertEqual(prompt["versione"], "1")
        self.assertEqual(
            prompt["contesto"],
            ["urn:nir:stato:decreto.legislativo:2023-03-31;36~art101"],
        )
        self.assertIn("sanabile", prompt["corpo"])

    def test_prompt_senza_id_e_errore(self):
        malformato = self.dir / "malformato.md"
        malformato.write_text("---\ntask: qa\n---\ncorpo", encoding="utf-8")
        with self.assertRaises(RunnerError):
            load_prompt(malformato)


class TestBuildMessages(HarnessFixture):
    def test_include_sistema_contesto_e_domanda(self):
        prompt = load_prompt(self.prompt_file)
        messages = build_messages(prompt, self.corpus)
        self.assertEqual(messages[0]["role"], "system")
        self.assertIn("### Riferimenti", messages[0]["content"])
        self.assertIn("Testo dell'articolo 101", messages[0]["content"])
        self.assertEqual(messages[1]["role"], "user")
        self.assertIn("sanabile", messages[1]["content"])

    def test_contesto_mancante_dal_corpus_e_errore(self):
        prompt = dict(load_prompt(self.prompt_file))
        prompt["contesto"] = ["urn:nir:stato:legge:1990-08-07;241~art1"]
        with self.assertRaises(RunnerError):
            build_messages(prompt, self.corpus)


class TestRunAll(HarnessFixture):
    def test_dry_run_non_chiama_la_rete_e_logga(self):
        def transport_vietato(model, messages, api_key):
            raise AssertionError("dry-run non deve chiamare la rete")

        run_dir = run_all(
            prompt_files=[self.prompt_file],
            corpus_dir=self.corpus,
            models=self.models,
            snapshot_file=self.snapshot,
            out_dir=self.runs,
            api_key=None,
            dry_run=True,
            transport=transport_vietato,
        )
        records = sorted(run_dir.glob("*.json"))
        manifest = json.loads((run_dir / "manifest.json").read_text(encoding="utf-8"))
        self.assertEqual(manifest["dry_run"], True)
        self.assertEqual(manifest["snapshot_sha256"], compute_snapshot_hash(self.snapshot))
        chiamate = [r for r in records if r.name != "manifest.json"]
        self.assertEqual(len(chiamate), 2)  # 1 prompt x 2 modelli
        record = json.loads(chiamate[0].read_text(encoding="utf-8"))
        self.assertEqual(record["stato"], "dry_run")
        self.assertIn(record["modello"], self.models.values())
        self.assertEqual(len(record["prompt_sha256"]), 64)

    def test_run_reale_con_transport_finto_logga_tutto(self):
        def transport_finto(model, messages, api_key):
            return {
                "output": f"Risposta di {model}",
                "usage": {"prompt_tokens": 10, "completion_tokens": 5},
                "raw": {"choices": []},
            }

        run_dir = run_all(
            prompt_files=[self.prompt_file],
            corpus_dir=self.corpus,
            models=self.models,
            snapshot_file=self.snapshot,
            out_dir=self.runs,
            api_key="chiave-di-test",
            dry_run=False,
            transport=transport_finto,
        )
        chiamate = [p for p in sorted(run_dir.glob("*.json")) if p.name != "manifest.json"]
        record = json.loads(chiamate[0].read_text(encoding="utf-8"))
        self.assertEqual(record["stato"], "ok")
        self.assertTrue(record["output"].startswith("Risposta di"))
        self.assertEqual(record["usage"]["prompt_tokens"], 10)
        self.assertGreaterEqual(record["latency_ms"], 0)
        self.assertEqual(record["prompt_id"], "task:t2-qa-01")

    def test_senza_chiave_e_senza_dry_run_errore_chiaro(self):
        with self.assertRaises(RunnerError):
            run_all(
                prompt_files=[self.prompt_file],
                corpus_dir=self.corpus,
                models=self.models,
                snapshot_file=self.snapshot,
                out_dir=self.runs,
                api_key=None,
                dry_run=False,
                transport=None,
            )


class TestConfig(HarnessFixture):
    def test_models_config_da_file(self):
        config_file = self.dir / "models.json"
        config_file.write_text(json.dumps(self.models), encoding="utf-8")
        self.assertEqual(load_models_config(config_file), self.models)

    def test_models_config_malformato_e_errore(self):
        config_file = self.dir / "models.json"
        config_file.write_text("{non json", encoding="utf-8")
        with self.assertRaises(RunnerError):
            load_models_config(config_file)


if __name__ == "__main__":
    unittest.main()
