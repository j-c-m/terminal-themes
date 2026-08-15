# Template Context

Templates receive a context object for rendering. This is built from theme YAML and includes colors, metadata, and generated data.

## Core Fields

- **`theme-name`**: Display name (e.g., "Oceanic Next Dark").
- **`theme-slug`**: URL-safe slug (e.g., "oceanic-next-dark").
- **`theme-mode`**: "dark", "light", or "both" (for merged).
- **`theme-modifier`**: Modifier string (e.g., "Dimmed") or empty.
- **`theme-source`**: Attribution or upstream URL from the required YAML `source` field.
- **`theme-license`**: Required SPDX license id.
- **`theme-notice`**: Leading `#` comment block from the theme YAML (the license grant), without `#` prefixes.
- **`theme-notice-hash`**: Same notice formatted as `#` comments for templates, or empty.

## Color Maps

- **`normal` / `bright`**: Objects with keys `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`. Each is `{hex: "#ffffff", hexterm: "ff/ff/ff"}`.
  - `hex`: Six-digit lowercase hex. For `bright`, this is the post-adjustment value when the YAML pair was identical (see [Identical normal and bright colors](themes.md#identical-normal-and-bright-colors)).
  - `hexterm`: The same color as `rr/gg/bb` hex pairs for OSC 4 / OSC 10 (e.g., `"00/2b/36"`).

## Primary Colors

- **`foreground`**, **`background`**: `{hex, hexterm}` or absent if not defined.
- **`cursor`**, **`cursor-text`**: `{hex, hexterm}` or defaults if missing.
- **`selection-background`**, **`selection-foreground`**: `{hex, hexterm}` or defaults.

## Generated Data

- **`theme-itermcolors-plist`**: XML plist string for iTerm (generated automatically).
- **`theme-json`**: Pretty JSON dump of context (excluding plist) for debugging.

## Merged Dual Context

For dual-mode:
- Includes all above plus `light` and `dark` subcontexts.
- Primaries default to light values.

## Example Context (Single-Mode)

```json
{
  "theme-name": "Oceanic Next Dark",
  "theme-slug": "oceanic-next-dark",
  "theme-mode": "dark",
  "theme-modifier": "Dark",
  "theme-source": "vscode-themes",
  "theme-license": "MIT",
  "normal": {
    "black": {"hex": "#000000", "hexterm": "00/00/00"},
    // ...
  },
  "bright": { /* similar */ },
  "foreground": {"hex": "#ffffff", "hexterm": "ff/ff/ff"},
  "background": {"hex": "#1e2d31", "hexterm": "1e/2d/31"},
  // ... others
  "theme-itermcolors-plist": "<?xml version=\"1.0\"...>",
  "theme-json": "{...}"
}
```

Note: Contexts are validated; invalid colors skip rendering.
