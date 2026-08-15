# Output Structure

Outputs are written to `build/` based on `templates/config.json`.

## File Paths

- **Directory**: `build/{directory}` (from config, e.g., `build/iterm`).
- **Filename**: Rendered from `filename` template using context (e.g., "oceanic-next-dark.itermcolors").
- Subdirectories created automatically.

## Index Generation

- **File**: `build/index.html` (from `index.mustache`).
- **Content**: One card per mode from non-combined theme files, sorted by `theme-name`. Combined / `-meta` files are omitted; their members appear from their own YAML.
- Each card is a single-pane preview (not a merged `theme-mode: "both"` entry).
- Includes `theme-json` for each entry.

## JSON catalog

`build/json/{{theme-slug}}.json` is the generated context for one mode. Bright hex values are post-adjustment. `tools/preview_theme` loads this directory, not `themes/*.yaml`.

## Processing Summary

- Processes all valid themes.
- For each config entry, renders templates accordingly (per-mode or merged).
- Generates iTerm plists on-demand.
- Logs successes/errors to console.

## Example Build Structure

```
build/
├── alacritty/
│   ├── solarized-dark.toml
│   └── solarized-light.toml
├── ghostty/
├── itermcolors/
│   └── solarized.itermcolors
├── json/
│   ├── solarized-dark.json
│   └── solarized-light.json
├── shell/
├── debug-txt/
└── index.html
```

Note: Failed renders are logged; successful ones show paths.