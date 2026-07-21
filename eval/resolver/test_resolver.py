"""Test del risolutore di citazioni (TDD: scritti prima dell'implementazione).

Proprieta' verificate: determinismo, meccanicita' (match su identificativi),
multivigenza non silenziosa, immutabilita' degli input, tasso di non risolvibili.
"""
import json
import shutil
import tempfile
import unittest
from pathlib import Path

from resolver import (
    extract_citations,
    id_to_filename,
    load_corpus_index,
    resolve,
)

URN_101 = "urn:nir:stato:decreto.legislativo:2023-03-31;36~art101"
URN_94 = "urn:nir:stato:decreto.legislativo:2023-03-31;36~art94"
ECLI_CDS = "ECLI:IT:CDS:2024:3985"
ANAC_PARERE = "anac:parere:2024-01-17;25"


def make_page(directory, doc_id, tipo, data_vigenza=None):
    """Scrive una pagina LLM Wiki minima e ne restituisce il percorso."""
    lines = [
        "---",
        f'id: "{doc_id}"',
        f"tipo: {tipo}",
        'titolo: "Pagina di test"',
        'fonte_ufficiale: "https://esempio.it/fonte"',
        "lingua: it",
    ]
    if data_vigenza:
        lines.append(f"data_vigenza: {data_vigenza}")
    lines += ["---", "", "Corpo della pagina."]
    path = Path(directory) / id_to_filename(doc_id)
    path.write_text("\n".join(lines), encoding="utf-8")
    return path


class TestIdToFilename(unittest.TestCase):
    def test_urn_slug(self):
        self.assertEqual(
            id_to_filename(URN_101),
            "urn-nir-stato-decreto.legislativo-2023-03-31-36-art101.md",
        )

    def test_ecli_slug(self):
        self.assertEqual(id_to_filename(ECLI_CDS), "ecli-it-cds-2024-3985.md")

    def test_anac_slug(self):
        self.assertEqual(id_to_filename(ANAC_PARERE), "anac-parere-2024-01-17-25.md")

    def test_deterministico(self):
        self.assertEqual(id_to_filename(URN_101), id_to_filename(URN_101))


class TestExtractCitations(unittest.TestCase):
    def test_estrae_i_tre_formati(self):
        testo = (
            "Ai sensi dell'art. 101, vedi "
            f"{URN_101} e la sentenza {ECLI_CDS}; conforme {ANAC_PARERE}."
        )
        self.assertEqual(extract_citations(testo), [URN_101, ECLI_CDS, ANAC_PARERE])

    def test_dedup_preservando_ordine(self):
        testo = f"{ECLI_CDS} poi {URN_101} e ancora {ECLI_CDS}"
        self.assertEqual(extract_citations(testo), [ECLI_CDS, URN_101])

    def test_urn_con_vigenza(self):
        testo = f"Cfr. {URN_101}!vig=2026-07-20 in tema di soccorso."
        self.assertEqual(extract_citations(testo), [f"{URN_101}!vig=2026-07-20"])

    def test_testo_senza_citazioni(self):
        self.assertEqual(extract_citations("Nessun riferimento canonico qui."), [])


class TestLoadCorpusIndex(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.dir)

    def test_indicizza_per_id(self):
        make_page(self.dir, URN_101, "norma", data_vigenza="2026-07-20")
        make_page(self.dir, ECLI_CDS, "decisione")
        index = load_corpus_index(self.dir)
        self.assertIn(URN_101, index)
        self.assertEqual(index[URN_101]["tipo"], "norma")
        self.assertEqual(index[URN_101]["data_vigenza"], "2026-07-20")
        self.assertEqual(index[ECLI_CDS]["fonte_ufficiale"], "https://esempio.it/fonte")

    def test_nome_file_incoerente_e_errore_di_corpus(self):
        pagina = make_page(self.dir, URN_101, "norma")
        pagina.rename(Path(self.dir) / "nome-sbagliato.md")
        with self.assertRaises(ValueError):
            load_corpus_index(self.dir)


class TestResolve(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.dir)
        make_page(self.dir, URN_101, "norma", data_vigenza="2026-07-20")
        make_page(self.dir, ECLI_CDS, "decisione")
        self.index = load_corpus_index(self.dir)

    def test_citazione_esistente_risolve(self):
        report = resolve([URN_101], self.index)
        self.assertEqual(len(report["risolti"]), 1)
        risolto = report["risolti"][0]
        self.assertEqual(risolto["id"], URN_101)
        self.assertEqual(risolto["pagina"], id_to_filename(URN_101))
        self.assertEqual(risolto["fonte_ufficiale"], "https://esempio.it/fonte")
        self.assertEqual(report["tasso_non_risolvibili"], 0.0)

    def test_citazione_inesistente_non_risolve(self):
        report = resolve([URN_94], self.index)
        self.assertEqual(report["risolti"], [])
        self.assertEqual(report["non_risolti"][0]["id"], URN_94)
        self.assertEqual(report["non_risolti"][0]["motivo"], "assente_dal_corpus")
        self.assertEqual(report["tasso_non_risolvibili"], 1.0)

    def test_id_malformato_non_risolve(self):
        report = resolve(["art. 101 del codice"], self.index)
        self.assertEqual(report["non_risolti"][0]["motivo"], "formato_non_riconosciuto")

    def test_vigenza_coincidente_risolve(self):
        report = resolve([f"{URN_101}!vig=2026-07-20"], self.index)
        self.assertEqual(len(report["risolti"]), 1)

    def test_vigenza_diversa_non_risolve_mai_silenziosamente(self):
        report = resolve([f"{URN_101}!vig=2024-01-01"], self.index)
        self.assertEqual(report["risolti"], [])
        self.assertEqual(report["non_risolti"][0]["motivo"], "vigenza_mismatch")

    def test_tasso_misto(self):
        report = resolve([URN_101, URN_94, ECLI_CDS, "anac:parere:2020-01-01;1"], self.index)
        self.assertEqual(len(report["risolti"]), 2)
        self.assertEqual(len(report["non_risolti"]), 2)
        self.assertEqual(report["tasso_non_risolvibili"], 0.5)

    def test_zero_citazioni(self):
        report = resolve([], self.index)
        self.assertEqual(report["totale"], 0)
        self.assertEqual(report["tasso_non_risolvibili"], 0.0)

    def test_non_muta_gli_input(self):
        citazioni = [URN_101, URN_94]
        copia = list(citazioni)
        indice_copia = dict(self.index)
        resolve(citazioni, self.index)
        self.assertEqual(citazioni, copia)
        self.assertEqual(self.index, indice_copia)

    def test_deterministico_e_serializzabile(self):
        r1 = resolve([URN_101, URN_94], self.index)
        r2 = resolve([URN_101, URN_94], self.index)
        self.assertEqual(json.dumps(r1, sort_keys=True), json.dumps(r2, sort_keys=True))


if __name__ == "__main__":
    unittest.main()
