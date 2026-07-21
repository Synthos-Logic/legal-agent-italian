"""Test del parser Normattiva su fixture reale (art. 101 D.Lgs. 36/2023).

Verifica che la conversione preservi la granularita' di articolo e i confini
di comma come ancore (vulnerabilita' n. 2 del brief: perdita di struttura).
"""
import unittest
from pathlib import Path

from normattiva import build_page, parse_article

FIXTURE = Path(__file__).parent / "test_fixtures" / "art101_bodyTesto.html"


class TestParseArticle(unittest.TestCase):
    def setUp(self):
        self.html = FIXTURE.read_text(encoding="utf-8")
        self.articolo = parse_article(self.html)

    def test_numero_e_rubrica(self):
        self.assertEqual(self.articolo["numero"], "101")
        self.assertEqual(self.articolo["rubrica"], "Soccorso istruttorio")

    def test_commi_come_ancore(self):
        corpo = self.articolo["corpo"]
        self.assertIn("**Comma 1.**", corpo)
        self.assertIn("**Comma 2.**", corpo)
        self.assertIn("**Comma 3.**", corpo)

    def test_lettere_preservate(self):
        corpo = self.articolo["corpo"]
        self.assertIn("a) integrare di ogni elemento mancante", corpo)
        self.assertIn("b) sanare ogni omissione", corpo)

    def test_entita_html_decodificate_e_niente_tag(self):
        corpo = self.articolo["corpo"]
        self.assertIn("è", corpo)
        self.assertNotIn("&egrave;", corpo)
        self.assertNotIn("<div", corpo)
        self.assertNotIn("<span", corpo)

    def test_contenuto_normativo_presente(self):
        self.assertIn("cinque giorni", self.articolo["corpo"])
        self.assertIn("escluso dalla procedura", self.articolo["corpo"])


class TestBuildPage(unittest.TestCase):
    def test_frontmatter_completo(self):
        articolo = parse_article(FIXTURE.read_text(encoding="utf-8"))
        pagina = build_page(
            articolo,
            data_vigenza="2026-07-21",
            data_fetch="2026-07-21",
            hash_sorgente="a" * 64,
        )
        self.assertTrue(pagina.startswith("---\n"))
        for atteso in (
            'id: "urn:nir:stato:decreto.legislativo:2023-03-31;36~art101"',
            "tipo: norma",
            "data_vigenza: 2026-07-21",
            f'hash_sha256: "{"a" * 64}"',
            "data_fetch: 2026-07-21",
            "dominio: appalti",
            "fonte_ufficiale:",
            "# Art. 101 - Soccorso istruttorio",
            "**Comma 1.**",
        ):
            self.assertIn(atteso, pagina)


if __name__ == "__main__":
    unittest.main()
