#!/usr/bin/env python3

import importlib.util
import subprocess
import sys
import textwrap
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).parent.parent
BUILD = REPO_ROOT / "build-themes.py"
THEMES = REPO_ROOT / "themes"

_MINIMAL_MODE = textwrap.dedent(
    """\
    foreground: "#ffffff"
    background: "#000000"
    colors:
      normal:
        black: "#000000"
        red: "#ff0000"
        green: "#00ff00"
        yellow: "#ffff00"
        blue: "#0000ff"
        magenta: "#ff00ff"
        cyan: "#00ffff"
        white: "#ffffff"
      bright:
        black: "#7f7f7f"
        red: "#ff7f7f"
        green: "#7fff7f"
        yellow: "#ffff7f"
        blue: "#7f7fff"
        magenta: "#ff7fff"
        cyan: "#7fffff"
        white: "#ffffff"
    """
)


def _load_builder():
    spec = importlib.util.spec_from_file_location("build_themes", BUILD)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def _theme_yaml(*, license_id: str) -> str:
    return (
        f"name: License Test\n"
        f"source: test\n"
        f"license: {license_id}\n"
        f"dark:\n"
        + textwrap.indent(_MINIMAL_MODE, "  ")
    )


class BuildThemesLicenseTests(unittest.TestCase):
    def test_disallowed_license_raises(self) -> None:
        builder = _load_builder()
        with self.assertRaises(ValueError) as raised:
            builder.validate_theme_top_level(
                {
                    "name": "License Test",
                    "source": "test",
                    "license": "CC-BY-NC-4.0",
                    "dark": {},
                },
                Path("themes/license-test.yaml"),
            )
        self.assertIn("not allowed", str(raised.exception))
        self.assertIn("CC-BY-NC-4.0", str(raised.exception))

    def test_allowed_license_passes_top_level(self) -> None:
        builder = _load_builder()
        builder.validate_theme_top_level(
            {
                "name": "License Test",
                "source": "test",
                "license": "MIT",
                "dark": {},
            },
            Path("themes/license-test.yaml"),
        )

    def test_incompatible_license_fails_build(self) -> None:
        path = THEMES / "_test_incompatible_license.yaml"
        self.addCleanup(path.unlink, missing_ok=True)
        path.write_text(_theme_yaml(license_id="CC-BY-NC-4.0"), encoding="utf-8")
        result = subprocess.run(
            [sys.executable, str(BUILD)],
            cwd=REPO_ROOT,
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 1, msg=result.stderr)
        self.assertIn("not allowed", result.stdout)
        self.assertIn("CC-BY-NC-4.0", result.stdout)
        self.assertIn("Build failed with", result.stderr)


class BuildThemesSourceTests(unittest.TestCase):
    def test_missing_source_raises(self) -> None:
        builder = _load_builder()
        with self.assertRaises(ValueError) as raised:
            builder.validate_theme_top_level(
                {
                    "name": "Source Test",
                    "license": "MIT",
                    "dark": {},
                },
                Path("themes/source-test.yaml"),
            )
        self.assertIn("source", str(raised.exception))

    def test_blank_source_raises(self) -> None:
        builder = _load_builder()
        with self.assertRaises(ValueError) as raised:
            builder.validate_theme_top_level(
                {
                    "name": "Source Test",
                    "source": "   ",
                    "license": "MIT",
                    "dark": {},
                },
                Path("themes/source-test.yaml"),
            )
        self.assertIn("source", str(raised.exception))

    def test_missing_source_fails_build(self) -> None:
        path = THEMES / "_test_missing_source.yaml"
        self.addCleanup(path.unlink, missing_ok=True)
        path.write_text(
            "name: Source Test\nlicense: MIT\ndark:\n"
            + textwrap.indent(_MINIMAL_MODE, "  "),
            encoding="utf-8",
        )
        result = subprocess.run(
            [sys.executable, str(BUILD)],
            cwd=REPO_ROOT,
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 1, msg=result.stderr)
        self.assertIn("source", result.stdout)
        self.assertIn("Build failed with", result.stderr)


if __name__ == "__main__":
    unittest.main()
