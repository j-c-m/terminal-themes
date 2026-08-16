#!/usr/bin/env python3

import subprocess
import sys
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).parent.parent
PREVIEW = REPO_ROOT / "tools" / "preview_theme.py"


def run_preview(*args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(PREVIEW), *args],
        cwd=REPO_ROOT,
        capture_output=True,
        text=True,
    )


class PreviewThemeTests(unittest.TestCase):
    def test_scheme_renders_hex_values(self) -> None:
        result = run_preview("-s", "dracula")
        self.assertEqual(result.returncode, 0, msg=result.stderr)
        self.assertIn("Dracula", result.stdout)
        self.assertIn("#", result.stdout)
        self.assertIn("Semantic samples", result.stdout)
        self.assertIn("Display-only preview", result.stdout)
        self.assertNotIn("\033[2J", result.stdout)

    def test_clear_flag_clears_screen(self) -> None:
        result = run_preview("-s", "dracula", "--clear")
        self.assertEqual(result.returncode, 0, msg=result.stderr)
        self.assertIn("\033[2J", result.stdout)

    def test_no_osc_palette_sequences(self) -> None:
        result = run_preview("-s", "dracula")
        self.assertEqual(result.returncode, 0, msg=result.stderr)
        self.assertNotIn("\033]4;", result.stdout)
        self.assertNotIn("\033]10;", result.stdout)
        self.assertNotIn("\033]11;", result.stdout)

    def test_json_source(self) -> None:
        result = run_preview("build/json/dracula.json")
        self.assertEqual(result.returncode, 0, msg=result.stderr)
        self.assertIn("Dracula", result.stdout)

    def test_yaml_path_resolves_generated_json(self) -> None:
        result = run_preview("themes/dracula.yaml")
        self.assertEqual(result.returncode, 0, msg=result.stderr)
        self.assertIn("Dracula", result.stdout)

    def test_dual_mode_family_renders_both(self) -> None:
        result = run_preview("-s", "solarized")
        self.assertEqual(result.returncode, 0, msg=result.stderr)
        self.assertIn("Solarized · dark", result.stdout)
        self.assertIn("Solarized · light", result.stdout)
        self.assertIn("48;2;0;43;54m", result.stdout)
        self.assertIn("48;2;253;246;227m", result.stdout)

    def test_preview_uses_generated_bright_hex(self) -> None:
        result = run_preview("-s", "solarized-dark")
        self.assertEqual(result.returncode, 0, msg=result.stderr)
        self.assertIn("#DC322F", result.stdout)

    def test_json_slugs_select_variants(self) -> None:
        result = run_preview("-s", "catppuccin-mocha", "catppuccin-latte")
        self.assertEqual(result.returncode, 0, msg=result.stderr)
        self.assertIn("Catppuccin Mocha · dark", result.stdout)
        self.assertIn("Catppuccin Latte · light", result.stdout)
        self.assertIn("48;2;30;30;46m", result.stdout)
        self.assertIn("48;2;239;241;245m", result.stdout)

    def test_composed_name_selects_one_mode(self) -> None:
        result = run_preview("-s", "Solarized Light")
        self.assertEqual(result.returncode, 0, msg=result.stderr)
        self.assertIn("Solarized · light", result.stdout)
        self.assertNotIn("Solarized · dark", result.stdout)
        self.assertIn("48;2;253;246;227m", result.stdout)
        self.assertNotIn("48;2;0;43;54m", result.stdout)

    def test_every_generated_theme_loads(self) -> None:
        result = run_preview("build/json")
        self.assertEqual(result.returncode, 0, msg=result.stderr)
        self.assertIn("Display-only preview", result.stdout)

    def test_missing_scheme_exits_nonzero(self) -> None:
        result = run_preview("-s", "No Such Theme 99999")
        self.assertEqual(result.returncode, 1)
        self.assertIn("not found", result.stderr)

    def test_static_mode_uses_truecolor(self) -> None:
        result = run_preview("-s", "dracula")
        self.assertIn("38;2;", result.stdout)
        self.assertIn("48;2;", result.stdout)


if __name__ == "__main__":
    unittest.main()
