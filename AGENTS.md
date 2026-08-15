# AGENTS — terminal-themes

Curated terminal themes. YAML in `themes/` is the source of truth. `build-themes.py` renders Mustache templates from `templates/` (see `templates/config.json`) into `build/`.

## Commands

- Setup + build: `./do-build-themes.sh` (creates `.venv`, installs deps, `rm -rf build`, renders).
- Build only: `python build-themes.py` (exit 1 if any theme, template, or index write failed).
- Preview: `python tools/preview_theme.py -s <name-or-slug>` — reads `build/json/`, does not change the palette. Rebuild after YAML edits.
- Tests: `python tools/test_build_themes.py` and `python tools/test_preview_theme.py`.

## Theme YAML

Required: `name`, `source`, `license`, and at least one of `dark` / `light`. Hex is `#rgb` or `#rrggbb`. See [docs/themes.md](docs/themes.md).

`license` must be an SPDX id in `ALLOWED_LICENSES` (`build-themes.py`) that allows free redistribution. The leading `#` comment block is the legal grant; the build copies it onto outputs with `SPDX-License-Identifier`.

`source` is provenance (attribution or upstream URL). Missing or blank fails the build.

Combined files set `dark` / `light` to another YAML filename. They feed dual-mode templates only (iTerm, debug) and are omitted from the index. Use a `-meta` suffix only when the family name already exists (`rose-pine-meta.yaml`).

