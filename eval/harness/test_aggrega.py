"""Test dell'aggregatore metriche (TDD: scritti prima dell'implementazione).

Verifica: D4 per record (risolutore su ogni output), aggregati per modello,
D5a stabilita' sulle terne di parafrasi, gestione record dry-run/errore.
"""
import json
import shutil
import tempfile
import unittest
from pathlib import Path

from aggrega import aggrega_run

PAGINA_ART101 = """---
id: "urn:nir:stato:decreto.legislativo:2023-03-31;36~art101"
tipo: norma
titolo: "Art. 101"
fonte_ufficiale: "https://esempio.it/art101"
data_vigenza: 2026-07-21
---

Testo.
"""

URN = "urn:nir:stato:decreto.legislativo:2023-03-31;36~art101"


def record(prompt_id, modello, output, stato="ok", equivalente_a=None):
    dati = {
        "prompt_id": prompt_id,
        "modello": modello,
        "stato": stato,
        "output": output,
        "usage": {"prompt_tokens": 10, "completion_tokens": 5},
        "latency_ms": 100,
    }
    if equivalente_a:
        dati["equivalente_a"] = equivalente_a
    return dati


class TestAggregaRun(unittest.TestCase):
    def setUp(self):
        self.dir = Path(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, self.dir)
        self.corpus = self.dir / "corpus"
        self.corpus.mkdir()
        nome = "urn-nir-stato-decreto.legislativo-2023-03-31-36-art101.md"
        (self.corpus / nome).write_text(PAGINA_ART101, encoding="utf-8")
        self.run_dir = self.dir / "run-x"
        self.run_dir.mkdir()
        (self.run_dir / "manifest.json").write_text(
            json.dumps({"dry_run": False}), encoding="utf-8"
        )

    def scrivi(self, nome, dati):
        (self.run_dir / nome).write_text(json.dumps(dati), encoding="utf-8")

    def test_d4_per_record_e_aggregato_per_modello(self):
        self.scrivi("a--glm.json", record(
            "task:t2-qa-01", "glm", f"Risposta.\n### Riferimenti\n{URN}"))
        self.scrivi("a--claude.json", record(
            "task:t2-qa-01", "claude",
            "Risposta.\n### Riferimenti\nECLI:IT:CDS:2020:1 \n" + URN))
        report = aggrega_run(self.run_dir, self.corpus)
        per_record = {r["file"]: r for r in report["records"]}
        self.assertEqual(per_record["a--glm.json"]["tasso_non_risolvibili"], 0.0)
        self.assertEqual(per_record["a--claude.json"]["tasso_non_risolvibili"], 0.5)
        self.assertEqual(report["per_modello"]["glm"]["citazioni_totali"], 1)
        self.assertEqual(report["per_modello"]["claude"]["citazioni_non_risolte"], 1)

    def test_output_senza_citazioni_conta_come_zero_citazioni(self):
        self.scrivi("b--glm.json", record("task:t2-qa-01", "glm", "Nessun riferimento."))
        report = aggrega_run(self.run_dir, self.corpus)
        self.assertEqual(report["records"][0]["citazioni"], 0)

    def test_record_non_ok_esclusi_ma_contati(self):
        self.scrivi("c--glm.json", record("task:x", "glm", None, stato="dry_run"))
        report = aggrega_run(self.run_dir, self.corpus)
        self.assertEqual(report["records"], [])
        self.assertEqual(report["esclusi"], 1)

    def test_stabilita_terne(self):
        for suffisso, pid, eq in (("", "task:t2-qa-01", None),
                                  ("-p1", "task:t2-qa-01-p1", "task:t2-qa-01"),
                                  ("-p2", "task:t2-qa-01-p2", "task:t2-qa-01")):
            self.scrivi(f"t2{suffisso}--glm.json", record(
                pid, "glm", f"R.\n### Riferimenti\n{URN}", equivalente_a=eq))
        report = aggrega_run(self.run_dir, self.corpus)
        terne = report["per_modello"]["glm"]["stabilita_terne"]
        self.assertEqual(len(terne), 1)
        self.assertEqual(terne[0]["canonico"], "task:t2-qa-01")
        self.assertEqual(terne[0]["varianti"], 3)
        self.assertEqual(terne[0]["escursione_tasso"], 0.0)


if __name__ == "__main__":
    unittest.main()
