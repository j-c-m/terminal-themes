# Base16 to YAML Theme Conversion

## Purpose

This document guides the conversion of base16 color schemes to the YAML theme format used in the `terminal-themes` project. For automated conversion from Base16 YAML files (single-mode or dual-mode with light/dark variants), use the provided script `tools/base16-to-yaml.py`.

## Base16 Standard

Base16 provides 16 colors: `base00` (background) to `base0F`.

The attached `eighties.txt` lists these for the Eighties theme.

## Mapping to Project Theme Format

The project uses a YAML structure with `name`, `source`, `dark` and/or `light` sections.

Each mode has `background`, `foreground`, `cursor`, and `colors` (normal and bright for 8 colors).

### Mapping Table

| Terminal Role | Base16 Color | Hex Code from Example |
|---------------|--------------|-----------------------|
| background    | base00       | #2D2D2D              |
| foreground    | base05       | #D3D0C8              |
| cursor        | base05       | #D3D0C8              |
| normal.black  | base01       | #393939              |
| normal.red    | base08       | #F2777A              |
| normal.green  | base0B       | #99CC99              |
| normal.yellow | base0F       | #D27B53              |
| normal.blue   | base0D       | #6699CC              |
| normal.magenta| base0E       | #CC99CC              |
| normal.cyan   | base0C       | #66CCCC              |
| normal.white  | base05       | #D3D0C8              |
| bright.black  | base03       | #747369              |
| bright.red    | base08       | #F2777A              |
| bright.green  | base0B       | #99CC99              |
| bright.yellow | base0A       | #FFCC66              |
| bright.blue   | base0D       | #6699CC              |
| bright.magenta| base0E       | #CC99CC              |
| bright.cyan   | base0C       | #66CCCC              |
| bright.white  | base07       | #F2F0EC              |

For bright colors, if not specified, they may be the same as normal.

In this example, bright.red is same as normal.red, bright.yellow uses base0A, and the notes indicate base0F for normal yellow.

## Generated YAML

The resulting YAML for Eighties is:

```yaml
name: Eighties
source: "Eighties (base16 conversion from eighties.txt)"
dark:
  background: "#2D2D2D"
  foreground: "#D3D0C8"
  cursor: "#D3D0C8"
  colors:
    normal:
      black: "#393939"
      red: "#F2777A"
      green: "#99CC99"
      yellow: "#D27B53"
      blue: "#6699CC"
      magenta: "#CC99CC"
      cyan: "#66CCCC"
      white: "#D3D0C8"
    bright:
      black: "#747369"
      red: "#F2777A"
      green: "#99CC99"
      yellow: "#FFCC66"
      blue: "#6699CC"
      magenta: "#CC99CC"
      cyan: "#66CCCC"
      white: "#F2F0EC"
```

## Steps to Convert

1. Obtain base16 colors base00 to base0F.
2. Assign as per the mapping table.
3. Create YAML with appropriate name and source.
4. Save in `themes/` directory.
5. Run the build script to generate files in `build/`.

## Automated Conversion

For Base16 themes in YAML format (as output by base16 builders):

- Single-mode: `python tools/base16-to-yaml.py <base16_file.yaml>`
- Dual-mode (light/dark): `python tools/base16-to-yaml.py <dark_file.yaml> <light_file.yaml>`

The script derives name and source from the Base16 file's metadata (e.g., `name`, `author`, `variant`), outputs YAML to stdout.
