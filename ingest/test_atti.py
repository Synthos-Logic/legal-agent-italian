"""Test dell'ingest atti (conversione + frontmatter), senza rete."""
import types
import unittest

from atti import build_id, build_page, pulisci_testo


def argomenti(**extra):
    base = dict(
        tipo="decisione", ecli="ECLI:IT:CDS:2024:3985", numero=None,
        data="2024-05-02", titolo="Cons. Stato, sez. V, n. 3985/2024",
        fonte="https://esempio.it/decisione", massima="La carenza era sanabile.",
        figura="sanante", cross_ref=[], ecli_portale="",
    )
    base.update(extra)
    return types.SimpleNamespace(**base)


class TestBuildId(unittest.TestCase):
    def test_decisione_usa_ecli(self):
        self.assertEqual(build_id(argomenti()), "ECLI:IT:CDS:2024:3985")

    def test_ecli_malformato_e_errore(self):
        with self.assertRaises(ValueError):
            build_id(argomenti(ecli="CDS 3985/2024"))

    def test_atto_anac_canonico(self):
        args = argomenti(tipo="parere", ecli=None, numero="25", data="2024-01-17")
        self.assertEqual(build_id(args), "anac:parere:2024-01-17;25")

    def test_anac_senza_numero_e_errore(self):
        with self.assertRaises(ValueError):
            build_id(argomenti(tipo="delibera", ecli=None, numero=None))


class TestBuildPage(unittest.TestCase):
    def test_frontmatter_e_corpo(self):
        pagina = build_page(
            "ECLI:IT:CDS:2024:3985", "Testo della decisione.", argomenti(),
            "b" * 64, "2026-07-21",
        )
        for atteso in (
            'id: "ECLI:IT:CDS:2024:3985"',
            "tipo: decisione",
            "figura_soccorso: sanante",
            'massima: "La carenza era sanabile."',
            "cross_ref: []",
            "Testo della decisione.",
        ):
            self.assertIn(atteso, pagina)

    def test_ecli_portale_presente_solo_se_indicato(self):
        senza = build_page(
            "ECLI:IT:CDS:2024:3985", "Testo.", argomenti(), "b" * 64, "2026-07-21",
        )
        self.assertNotIn("ecli_portale", senza)
        con = build_page(
            "ECLI:IT:CDS:2024:3985", "Testo.",
            argomenti(ecli_portale="ECLI:IT:CDS:2024:3985SENT"), "b" * 64, "2026-07-21",
        )
        self.assertIn('ecli_portale: "ECLI:IT:CDS:2024:3985SENT"', con)

    def test_cross_ref_lista(self):
        pagina = build_page(
            "ECLI:IT:CDS:2024:3985", "Testo.",
            argomenti(cross_ref=["urn:nir:stato:decreto.legislativo:2023-03-31;36~art101"]),
            "b" * 64, "2026-07-21",
        )
        self.assertIn('  - "urn:nir:stato:decreto.legislativo:2023-03-31;36~art101"', pagina)


class TestPulisciTesto(unittest.TestCase):
    def test_normalizza_righe_vuote_e_spazi(self):
        sporco = "Riga.   \n\n\n\nAltra riga.\t\n"
        self.assertEqual(pulisci_testo(sporco), "Riga.\n\nAltra riga.")


if __name__ == "__main__":
    unittest.main()
