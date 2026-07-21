"""Test del generatore di fascicolo di revisione in cieco (TDD: prima del codice).

Proprieta': determinismo dell'ordine, terne mai adiacenti, nessun metadato
di modello nel fascicolo, mappa di anonimizzazione fuori dal fascicolo.
"""
import json
import shutil
import tempfile
import unittest
from pathlib import Path

from blind_package import genera_fascicolo

PROMPT_TEMPLATE = """---
id: "task:{pid}"
task: {task}
versione: 1
variante: {variante}
{eq}contesto:
  - "urn:nir:stato:decreto.legislativo:2023-03-31;36~art101"
---
Domanda del caso {pid}.
"""


class BlindFixture(unittest.TestCase):
    def setUp(self):
        self.dir = Path(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, self.dir)
        self.run = self.dir / "run-x"
        self.run.mkdir()
        (self.run / "manifest.json").write_text("{}", encoding="utf-8")
        self.tasks = self.dir / "tasks"
        self.tasks.mkdir()
        # 2 terne da 3 varianti = 6 record
        for base in ("t2-qa-01", "t3-rag-01"):
            for variante, suffisso in (("canonico", ""), ("parafrasi-1", "-p1"), ("parafrasi-2", "-p2")):
                pid = base + suffisso
                eq = f'equivalente_a: "task:{base}"\n' if suffisso else ""
                pf = self.tasks / f"{pid}.md"
                pf.write_text(PROMPT_TEMPLATE.format(pid=pid, task="qa", variante=variante, eq=eq), encoding="utf-8")
                record = {
                    "prompt_id": f"task:{pid}", "prompt_file": str(pf),
                    "variante": variante, "equivalente_a": f"task:{base}" if suffisso else "",
                    "task": "qa", "modello": "glm-5.2:cloud",
                    "endpoint": "http://localhost:11434/v1/chat/completions",
                    "stato": "ok", "output": f"Risposta del modello al caso {pid}.",
                    "usage": {"total_tokens": 10}, "latency_ms": 123,
                }
                (self.run / f"task-{pid}--glm.json").write_text(json.dumps(record), encoding="utf-8")


class TestGeneraFascicolo(BlindFixture):
    def test_struttura_e_conteggi(self):
        fascicolo = genera_fascicolo(self.run)
        items = sorted(fascicolo.glob("item-*.md"))
        self.assertEqual(len(items), 6)
        self.assertTrue((fascicolo / "scheda-punteggio.md").is_file())
        self.assertTrue((self.run / "blind_map.json").is_file())
        # la mappa NON sta dentro il fascicolo
        self.assertFalse((fascicolo / "blind_map.json").exists())

    def test_nessun_metadato_di_modello_nel_fascicolo(self):
        fascicolo = genera_fascicolo(self.run)
        for f in fascicolo.glob("*.md"):
            testo = f.read_text(encoding="utf-8").lower()
            for vietato in ("glm", "ollama", "modello_effettivo", "latency", "token", "parafrasi", "canonico", "equivalente"):
                self.assertNotIn(vietato, testo, f"{vietato!r} presente in {f.name}")

    def test_ordine_deterministico(self):
        f1 = genera_fascicolo(self.run)
        mappa1 = json.loads((self.run / "blind_map.json").read_text())
        shutil.rmtree(f1)
        genera_fascicolo(self.run)
        mappa2 = json.loads((self.run / "blind_map.json").read_text())
        self.assertEqual(mappa1, mappa2)

    def test_terne_mai_adiacenti(self):
        genera_fascicolo(self.run)
        mappa = json.loads((self.run / "blind_map.json").read_text())
        etichette = sorted(mappa)  # item-01, item-02, ... in ordine di presentazione
        gruppi = [mappa[e]["equivalente_a"] or mappa[e]["prompt_id"] for e in etichette]
        for prima, dopo in zip(gruppi, gruppi[1:]):
            self.assertNotEqual(prima, dopo, "due item della stessa terna adiacenti")

    def test_item_contiene_domanda_fonti_output(self):
        fascicolo = genera_fascicolo(self.run)
        testo = (sorted(fascicolo.glob("item-*.md"))[0]).read_text(encoding="utf-8")
        self.assertIn("Domanda del caso", testo)
        self.assertIn("urn:nir:stato:decreto.legislativo:2023-03-31;36~art101", testo)
        self.assertIn("Risposta del modello", testo.replace("Risposta del modello", "Risposta del modello"))  # output presente
        self.assertIn("## Output da valutare", testo)


if __name__ == "__main__":
    unittest.main()
