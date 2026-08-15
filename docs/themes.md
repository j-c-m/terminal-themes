# Theme YAML Structure

Themes are defined in YAML files within the `themes/` directory. Each theme file describes color schemes for terminal applications. This document explains required vs optional fields, data types, how colors map to terminal concepts (ANSI indices, cursor, selection), and provides examples.

## Overview

- **Format**: Human-friendly YAML.
- **Purpose**: Define terminal color themes with one or more display modes (commonly `dark` and `light`).
- **Canonical Example**: `themes/ayu.yaml`.

## Required Fields

- **`name` (string)**: The display name of the theme (e.g., "Oceanic Next" or "Ayu").
- **`license` (string)**: SPDX identifier that allows free redistribution.
  - Permissive / public domain: `MIT`, `ISC`, `Apache-2.0`, `BSD-2-Clause`, `BSD-3-Clause`, `0BSD`, `MIT-0`, `Unlicense`, `CC0-1.0`, `BlueOak-1.0.0`, `PostgreSQL`, `Zlib`.
  - Copyleft: `GPL-2.0-only`, `GPL-2.0-or-later`, `GPL-3.0-only`, `GPL-3.0-or-later`, `AGPL-3.0-only`, `AGPL-3.0-or-later`, `LGPL-2.1-only`, `LGPL-2.1-or-later`, `LGPL-3.0-only`, `LGPL-3.0-or-later`, `MPL-2.0`.
  - Shipping an unmodified theme file next to other themes is aggregation, not a derivative of the collection. Generated outputs for that theme (Alacritty, iTerm, etc.) are derivatives of that file and stay under its license.
  - The leading `#` comment block is the legal grant. The build copies it onto derived files with `SPDX-License-Identifier`.
- **At least one mode**: Either `dark` or `light` (or both), as top-level keys.

## Mode Structure

Each mode (`dark` or `light`) must include:

- **`foreground`** (hex string): Text color (e.g., "#ffffff").
- **`background`** (hex string): Background color (e.g., "#000000").
- **`colors.normal`** (object): Normal intensity colors for `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`.
- **`colors.bright`** (object): Bright intensity colors for the same keys.

Hex values can be 3-digit (`#rgb`) or 6-digit (`#rrggbb`). Invalid hex will cause an error.

## Identical normal and bright colors

Many palettes use the same hex for a `normal` color and its `bright` pair (Solarized red, Catppuccin accents, and others). The YAML keeps that pair as the author wrote it.

The build invents a distinct bright so ANSI 8–15 are not a copy of 0–7. `white` is never rewritten, even when it matches.

After hex normalize (`#rgb` / `#rrggbb` → lowercase `#rrggbb`):

- If `colors.normal.<name>` and `colors.bright.<name>` differ, both are used as written.
- If they are the same and `<name>` is not `white`, the bright color is derived from the normal color in HLS:
  - If lightness `L < 0.8`: `L *= 1.10` (hue and saturation unchanged).
  - If `L >= 0.8`: `L *= 0.90` and saturation `S *= 1.10`.

This is a ~10% HLS-lightness change, not a 10% change in perceived luminance. Typical rewritten accents land around 1.2× relative luminance; already-light colors on the second path get darker.

Adjusted brights appear in every generated file under `build/` (Alacritty, Ghostty, iTerm, JSON, shell, index). `tools/preview_theme` reads `build/json/`, so preview matches those files. Rebuild after editing YAML before previewing.

## Optional Fields per Mode

- **`cursor`** (hex string): Cursor color (defaults to `foreground` if missing).
- **`cursor-text`** (hex string): Text color inside cursor (defaults to `background` if missing).
- **`selection-background`** (hex string): Background for selected text (defaults to `foreground`).
- **`selection-foreground`** (hex string): Foreground for selected text (defaults to `background`).

## Additional Top-Level Fields

- **`modifier`** (string, optional): Appended to theme name/slug (e.g., "Dimmed" or "Soft").
- **`source`** (string, optional but recommended): Attribution or upstream URL for provenance.

## References to External Files (Combined Themes)

Modes can reference external YAML files instead of inline objects. If `dark` or `light` is a string (filename), it loads from that file. That file is **combined**: it feeds dual-mode templates only and is omitted from the index. Use a `-meta` suffix only when the family name already exists as a standalone theme (`rose-pine-meta.yaml`). See [Dual-Mode Behavior](dual-mode.md).

## ANSI Mapping

Typical mapping to terminal ANSI indices:

- `normal.black` → ANSI 0
- `normal.red` → ANSI 1
- `normal.green` → ANSI 2
- `normal.yellow` → ANSI 3
- `normal.blue` → ANSI 4
- `normal.magenta` → ANSI 5
- `normal.cyan` → ANSI 6
- `normal.white` → ANSI 7
- `bright.black` → ANSI 8
- `bright.red` → ANSI 9
- `bright.green` → ANSI 10
- `bright.yellow` → ANSI 11
- `bright.blue` → ANSI 12
- `bright.magenta` → ANSI 13
- `bright.cyan` → ANSI 14
- `bright.white` → ANSI 15

## Validation Checklist

**Required**:
- `name` (string)
- `license` (SPDX id from the allowed list)
- At least one top-level mode: `dark` or `light`
- For each mode:
  - `foreground` (hex)
  - `background` (hex)
  - `colors.normal` with all eight keys
  - `colors.bright` with all eight keys

**Optional (Recommended)**:
- `modifier`, `source`
- `cursor`, `cursor-text`, `selection-foreground`, `selection-background`

**Color Format**:
- Strings starting with `#` and 3 or 6 hex digits (case-insensitive). Tools may normalize to 6-digit lowercase hex.

## Examples

### Short Example

```yaml
name: Oceanic Next
modifier: Dark
source: vscode-themes
license: MIT
dark:
  foreground: "#ffffff"
  background: "#1e2d31"
  colors:
    normal:
      black: "#000000"
      red: "#e06c75"
      # ... (rest of normal colors)
    bright:
      black: "#546e7a"
      red: "#f07178"
      # ... (bright colors)
  cursor: "#ffffff"
  selection-background: "#4e5b5e"
# light mode could be defined similarly
```

## Minimal Template

Use this as a starting point:
```yaml
name: "MyTheme"
modifier: ""                # optional
source: "My Theme (https://example.com/mytheme)"
license: MIT                # required SPDX id from the allowed list

dark:
  foreground: "#cccccc"
  background: "#101214"
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
```

## Best Practices

- Populate `source` for provenance. `license` is required and must be an allowed SPDX id.
- Put the license grant in the leading `#` comment block. The build copies that block onto derived files.
- Use `modifier` to produce distinct variant names.
- Specify cursor and selection colors for improved UX.
- If only one visual style is targeted, include only the corresponding top-level key (`dark` or `light`).
- Confirm downstream tools expect the ANSI mapping above.
- Rebuild (`./do-build-themes.sh`) after YAML edits. Preview and other outputs read `build/`, not the YAML colors directly.
- For invalid YAML, missing fields, or incorrect hex, tools will log errors and skip the theme.

## Next Steps (Optional)

I can:
- Produce a JSON Schema for validation.
- Provide a small validator script (Node/Python).
- Convert a theme into a target format for a specific terminal emulator.

If you want any of those, tell me which and I will produce it.

Note: This merged document combines the simplicity of the newer `themes.md` with the depth of the older `theme-format.md` for a complete reference.
```
