"""Test dell'harness di esecuzione (TDD: aggiornati PRIMA del refactor GLM).

Proprieta' verificate: parsing prompt, montaggio messaggi ancorati al corpus,
configurazione per-modello {model, endpoint, api_key_env} con normalizzazione
della stringa nuda, dry-run senza rete, risoluzione chiavi per modello con
errore chiaro, endpoint locale senza chiave, logging integrale (endpoint
incluso, mai il valore della chiave).
"""
import json
import shutil
import tempfile
import unittest
from pathlib import Path

from runner import (
    DEFAULT_ENDPOINT,
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

MODELLO_GLM = {
    "model": "zai/glm-5.2",
    "endpoint": "https://ai-gateway.vercel.sh/v1/chat/completions",
    "api_key_env": "AI_GATEWAY_API_KEY",
}


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
        self.models = {"glm": dict(MODELLO_GLM)}

    def esegui(self, **override):
        parametri = dict(
            prompt_files=[self.prompt_file],
            corpus_dir=self.corpus,
            models=self.models,
            snapshot_file=self.snapshot,
            out_dir=self.runs,
            dry_run=True,
            transport=None,
            env={"AI_GATEWAY_API_KEY": "chiave-di-test"},
        )
        parametri.update(override)
        return run_all(**parametri)


class TestLoadPrompt(HarnessFixture):
    def test_parsa_frontmatter_e_corpo(self):
        prompt = load_prompt(self.prompt_file)
        self.assertEqual(prompt["id"], "task:t2-qa-01")
        self.assertEqual(prompt["task"], "qa-ancorata")
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

    def test_contesto_mancante_dal_corpus_e_errore(self):
        prompt = dict(load_prompt(self.prompt_file))
        prompt["contesto"] = ["urn:nir:stato:legge:1990-08-07;241~art1"]
        with self.assertRaises(RunnerError):
            build_messages(prompt, self.corpus)


class TestConfig(HarnessFixture):
    def scrivi_config(self, contenuto):
        config_file = self.dir / "models.json"
        config_file.write_text(contenuto, encoding="utf-8")
        return config_file

    def test_schema_esplicito_valido(self):
        config = load_models_config(self.scrivi_config(json.dumps(self.models)))
        self.assertEqual(config["glm"], MODELLO_GLM)

    def test_stringa_nuda_normalizzata_al_gateway(self):
        config = load_models_config(self.scrivi_config('{"glm": "zai/glm-5.2"}'))
        self.assertEqual(config["glm"]["model"], "zai/glm-5.2")
        self.assertEqual(config["glm"]["endpoint"], DEFAULT_ENDPOINT)
        self.assertEqual(config["glm"]["api_key_env"], "AI_GATEWAY_API_KEY")

    def test_api_key_env_null_ammessa(self):
        config = load_models_config(self.scrivi_config(json.dumps({
            "glm-locale": {"model": "glm-x", "endpoint": "http://localhost:11434/v1/chat/completions", "api_key_env": None}
        })))
        self.assertIsNone(config["glm-locale"]["api_key_env"])

    def test_endpoint_http_remoto_rifiutato(self):
        with self.assertRaises(RunnerError):
            load_models_config(self.scrivi_config(json.dumps({
                "glm": {"model": "x", "endpoint": "http://esempio.it/v1", "api_key_env": None}
            })))

    def test_model_mancante_e_errore(self):
        with self.assertRaises(RunnerError):
            load_models_config(self.scrivi_config(json.dumps({
                "glm": {"endpoint": "https://esempio.it/v1", "api_key_env": None}
            })))

    def test_json_malformato_e_errore(self):
        with self.assertRaises(RunnerError):
            load_models_config(self.scrivi_config("{non json"))


class TestRunAll(HarnessFixture):
    def test_dry_run_non_chiama_la_rete_e_logga(self):
        def transport_vietato(endpoint, model, messages, api_key):
            raise AssertionError("dry-run non deve chiamare la rete")

        run_dir = self.esegui(dry_run=True, transport=transport_vietato, env={})
        manifest = json.loads((run_dir / "manifest.json").read_text(encoding="utf-8"))
        self.assertTrue(manifest["dry_run"])
        self.assertEqual(manifest["snapshot_sha256"], compute_snapshot_hash(self.snapshot))
        self.assertEqual(manifest["modelli"]["glm"]["endpoint"], MODELLO_GLM["endpoint"])
        self.assertNotIn("chiave-di-test", json.dumps(manifest))
        chiamate = [p for p in sorted(run_dir.glob("*.json")) if p.name != "manifest.json"]
        self.assertEqual(len(chiamate), 1)  # 1 prompt x 1 modello
        record = json.loads(chiamate[0].read_text(encoding="utf-8"))
        self.assertEqual(record["stato"], "dry_run")
        self.assertEqual(record["modello"], "zai/glm-5.2")
        self.assertEqual(record["endpoint"], MODELLO_GLM["endpoint"])
        self.assertEqual(len(record["prompt_sha256"]), 64)

    def test_run_reale_con_transport_finto_logga_tutto(self):
        ricevute = []

        def transport_finto(endpoint, model, messages, api_key):
            ricevute.append((endpoint, model, api_key))
            return {"output": f"Risposta di {model}",
                    "usage": {"prompt_tokens": 10, "completion_tokens": 5},
                    "raw": {"model": "glm-5.2-20260616"}}

        run_dir = self.esegui(dry_run=False, transport=transport_finto)
        self.assertEqual(ricevute, [(MODELLO_GLM["endpoint"], "zai/glm-5.2", "chiave-di-test")])
        chiamate = [p for p in sorted(run_dir.glob("*.json")) if p.name != "manifest.json"]
        record = json.loads(chiamate[0].read_text(encoding="utf-8"))
        self.assertEqual(record["stato"], "ok")
        self.assertTrue(record["output"].startswith("Risposta di"))
        self.assertEqual(record["usage"]["prompt_tokens"], 10)
        self.assertGreaterEqual(record["latency_ms"], 0)
        self.assertEqual(record["modello_effettivo"], "glm-5.2-20260616")

    def test_variabile_chiave_assente_errore_che_la_nomina(self):
        def transport(endpoint, model, messages, api_key):
            raise AssertionError("non deve arrivare al transport")

        with self.assertRaises(RunnerError) as contesto:
            self.esegui(dry_run=False, transport=transport, env={})
        self.assertIn("AI_GATEWAY_API_KEY", str(contesto.exception))

    def test_endpoint_locale_senza_chiave_funziona(self):
        modelli = {"glm-locale": {
            "model": "glm-x",
            "endpoint": "http://localhost:11434/v1/chat/completions",
            "api_key_env": None,
        }}
        ricevute = []

        def transport_finto(endpoint, model, messages, api_key):
            ricevute.append(api_key)
            return {"output": "ok", "usage": {}, "raw": {}}

        self.esegui(models=modelli, dry_run=False, transport=transport_finto, env={})
        self.assertEqual(ricevute, [None])


if __name__ == "__main__":
    unittest.main()
