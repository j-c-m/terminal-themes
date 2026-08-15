# Template Context

Templates receive a context object for rendering. This is built from theme YAML and includes colors, metadata, and generated data.

## Core Fields

- **`theme-name`**: Display name (e.g., "Oceanic Next Dark").
- **`theme-slug`**: URL-safe slug (e.g., "oceanic-next-dark").
- **`theme-mode`**: "dark", "light", or "both" (for merged).
- **`theme-modifier`**: Modifier string (e.g., "Dimmed") or empty.
- **`theme-source`**: Source info or empty.
- **`theme-license`**: Required SPDX license id.
- **`theme-notice`**: Leading `#` comment block from the theme YAML (the license grant), without `#` prefixes.
- **`theme-notice-hash`**: Same notice formatted as `#` comments for templates, or empty.

## Color Maps

- **`normal` / `bright`**: Objects with keys `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`. Each is `{hex: "#ffffff", hexterm: "255/255/255"}`.
  - `hex`: Original hex value.
  - `hexterm`: Decimal RGB for terminals (e.g., "255/255/255").

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
    "black": {"hex": "#000000", "hexterm": "0/0/0"},
    // ...
  },
  "bright": { /* similar */ },
  "foreground": {"hex": "#ffffff", "hexterm": "255/255/255"},
  "background": {"hex": "#1e2d31", "hexterm": "30/45/49"},
  // ... others
  "theme-itermcolors-plist": "<?xml version=\"1.0\"...>",
  "theme-json": "{...}"
}
```

Note: Contexts are validated; invalid colors skip rendering.
