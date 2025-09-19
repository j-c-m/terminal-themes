# Template Configuration

The `templates/config.json` file defines how themes are rendered. Each entry specifies a template, output directory, and filename pattern.

## Entry Structure

Each config entry is a key-value pair where:

- **Key** (string): Unique identifier (e.g., "iterm").
- **Value** (object): Configuration with:
  - `directory` (string): Output subdirectory under `build/` (e.g., "iterm").
  - `filename` (string): Mustache template for output filename (e.g., "{{theme-slug}}.itermcolors").
  - `template` (string or array): Template file(s).
  - `dual_mode` (boolean, optional): Enables dual-mode handling.

## Template Formats

### Non-Dual Templates
`"template": "file.mustache"`
- Renders once per context (per mode for single-mode themes, once for dual-mode if both modes exist).

### Dual-Mode Templates
`"template": ["single.mustache", "dual.mustache"]`
- Used with `"dual_mode": true`.
- For single-mode: Uses `single.mustache`.
- For dual-mode themes (both dark and light): Uses `dual.mustache` with a merged context.

## Example Config

```json
{
  "iterm": {
    "directory": "iterm",
    "filename": "{{theme-slug}}.itermcolors",
    "template": "iterm.mustache"
  },
  "vim": {
    "directory": "vim",
    "filename": "{{theme-slug}}.vim",
    "template": ["vim-single.mustache", "vim-dual.mustache"],
    "dual_mode": true
  }
}
```

Note: Missing `template` or invalid structure skips the entry with a warning.
```
