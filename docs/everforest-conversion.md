# Everforest to YAML Theme Conversion

## Purpose

This document is the project map from sainnhe’s named Everforest palette onto our YAML / ANSI 16. Hex comes from [`palette.md`](https://github.com/sainnhe/everforest/blob/master/palette.md). That file is syntax and UI names, not a terminal table.

Do not replace this map with sainnhe’s vim `:terminal` / Alacritty gist 16. That assignment is different (`black` = `bg3` in dark, `fg` in light; bright = normal). Ours is the one in `themes/everforest-*.yaml`.

## Source

- Palette: https://github.com/sainnhe/everforest/blob/master/palette.md
- License: MIT, sainnhe, 2019
- YAML: `themes/everforest-hard.yaml`, `themes/everforest-medium.yaml`, `themes/everforest-soft.yaml`

Each file is one contrast. `modifier` is `Hard`, `Medium`, or `Soft`. Medium is the default in upstream.

`palette.md` has two modes (`dark`, `light`). Background names (`bg0`–`bg5`, `bg_visual`, …) change with contrast. Foreground names (`fg`, accents, greys) do not.

`orange` has no ANSI slot. Leave it unused.

## Mapping Table

Names below are `palette.md` identifiers. Accents and greys use that mode’s `palette2`. `bg0` uses that mode and contrast.

| Terminal role | Dark | Light |
|---------------|------|-------|
| background | `bg0` | `bg0` |
| foreground | `fg` | `fg` |
| cursor | `fg` | dark `fg` |
| normal.black | `bg0` | `bg0` |
| normal.red | `red` | `red` |
| normal.green | `green` | `green` |
| normal.yellow | `yellow` | `yellow` |
| normal.blue | `blue` | `blue` |
| normal.magenta | `purple` | `purple` |
| normal.cyan | `aqua` | `aqua` |
| normal.white | `fg` | `fg` |
| bright.black | `grey0` | `grey0` |
| bright.red | `red` | `red` |
| bright.green | `green` | `green` |
| bright.yellow | `yellow` | `yellow` |
| bright.blue | `blue` | `blue` |
| bright.magenta | `purple` | `purple` |
| bright.cyan | `aqua` | `aqua` |
| bright.white | light `bg0` | dark `bg0` |

Rules:

- ANSI black matches the chrome background (`bg0`), not a lifted grey.
- ANSI white is default text (`fg`).
- Bright hues copy the same named accents. `palette.md` has no second accent set.
- Bright black is `grey0` (line numbers and UI chrome): dim, still on-palette.
- Bright white is the other mode’s `bg0` at the same contrast: a real paper/ink swap, not another grey.
- Light cursor stays the dark `fg` (`#d3c6aa`) so the caret keeps the warm forest tone on the light page.

Hard and soft only change `bg0` (and therefore `background`, `normal.black`, and the opposite-mode `bright.white`).

## Hex (medium)

Worked example. Hard and soft substitute the `bg0` row in [Contrast](#contrast).

| Role | Dark | Light |
|------|------|-------|
| `bg0` | `#2d353b` | `#fdf6e3` |
| `fg` | `#d3c6aa` | `#5c6a72` |
| `red` | `#e67e80` | `#f85552` |
| `green` | `#a7c080` | `#8da101` |
| `yellow` | `#dbbc7f` | `#dfa000` |
| `blue` | `#7fbbb3` | `#3a94c5` |
| `purple` | `#d699b6` | `#df69ba` |
| `aqua` | `#83c092` | `#35a77c` |
| `grey0` | `#7a8478` | `#a6b0a0` |

## Contrast

| Contrast | Dark `bg0` | Light `bg0` |
|----------|------------|-------------|
| Hard | `#272e33` | `#fffbef` |
| Medium | `#2d353b` | `#fdf6e3` |
| Soft | `#333c43` | `#f3ead3` |

Dark `bright.white` is that row’s light `bg0`. Light `bright.white` is that row’s dark `bg0`.

## Generated YAML (medium)

```yaml
name: "Everforest"
modifier: "Medium"
# Mapping: docs/everforest-conversion.md
source: "https://github.com/sainnhe/everforest/blob/master/palette.md"
license: MIT
dark:
  foreground: "#d3c6aa"
  background: "#2d353b"
  cursor: "#d3c6aa"
  colors:
    normal:
      black: "#2d353b"
      red: "#e67e80"
      green: "#a7c080"
      yellow: "#dbbc7f"
      blue: "#7fbbb3"
      magenta: "#d699b6"
      cyan: "#83c092"
      white: "#d3c6aa"
    bright:
      black: "#7a8478"
      red: "#e67e80"
      green: "#a7c080"
      yellow: "#dbbc7f"
      blue: "#7fbbb3"
      magenta: "#d699b6"
      cyan: "#83c092"
      white: "#fdf6e3"
light:
  foreground: "#5c6a72"
  background: "#fdf6e3"
  cursor: "#d3c6aa"
  colors:
    normal:
      black: "#fdf6e3"
      red: "#f85552"
      green: "#8da101"
      yellow: "#dfa000"
      blue: "#3a94c5"
      magenta: "#df69ba"
      cyan: "#35a77c"
      white: "#5c6a72"
    bright:
      black: "#a6b0a0"
      red: "#f85552"
      green: "#8da101"
      yellow: "#dfa000"
      blue: "#3a94c5"
      magenta: "#df69ba"
      cyan: "#35a77c"
      white: "#2d353b"
```

## Steps

1. Read `palette.md` for the mode and contrast.
2. Assign names from the mapping table. Do not invent hex.
3. Write or update the matching `themes/everforest-{hard,medium,soft}.yaml`.
4. Run `./do-build-themes.sh`.
