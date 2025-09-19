# Output Structure

Outputs are written to `build/` based on `templates/config.json`.

## File Paths

- **Directory**: `build/{directory}` (from config, e.g., `build/iterm`).
- **Filename**: Rendered from `filename` template using context (e.g., "oceanic-next-dark.itermcolors").
- Subdirectories created automatically.

## Index Generation

- **File**: `build/index.html` (aggregated from `index.mustache`).
- **Content**: Sorted list of themes (merged for dual-mode, per-mode for single).
- Includes `theme-json` for each entry.

## Processing Summary

- Processes all valid themes.
- For each config entry, renders templates accordingly (per-mode or merged).
- Generates iTerm plists on-demand.
- Logs successes/errors to console.

## Example Build Structure

```
build/
├── iterm/
│   ├── oceanic-next-dark.itermcolors
│   └── oceanic-next-light.itermcolors
├── vim/
│   ├── oceanic-next-dual.vim
└── index.html
```

Note: Failed renders are logged; successful ones show paths.