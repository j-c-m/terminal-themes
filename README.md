# terminal-themes

A curated set of terminal color themes. Each theme has a license that allows free redistribution and a `source` for provenance.

YAML in `themes/` is the source of truth. The build writes Alacritty, Ghostty, iTerm, shell, and JSON files under `build/`. Open `build/index.html` for a gallery.

The generator and templates are [MIT](LICENSE.md). Each theme keeps its own SPDX id and leading comment block. Generated files for a theme are derivatives of that theme.

## Build

```bash
./do-build-themes.sh
```

This creates `.venv` if needed, installs `requirements.txt`, and renders `build/`. Rebuild after you edit YAML.

## Preview

```bash
python tools/preview_theme.py -s solarized
```

Preview reads `build/json/`. It does not change the terminal palette.

## Add a theme

See [docs/themes.md](docs/themes.md). Required fields: `name`, `source`, `license`, and at least one of `dark` or `light`.
