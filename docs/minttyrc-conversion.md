<file_path>
terminal-themes/docs/minttyrc-conversion.md
</file_path>

<edit_description>
Creating documentation for Mintty to YAML conversion
</edit_description>
# Converting Mintty .minttyrc Themes to Terminal Themes YAML

## Overview

This guide provides a step-by-step process for converting color themes from Mintty's .minttyrc configuration format to the YAML schema used in the terminal-themes project. The YAML schema is designed for flexibility with terminal theme generators, supporting both dark and light modes, and focusing on core color elements like ANSI colors, foreground/background, and optional cursor/selection fields.

Mintty themes are stored in plain text files with key-value pairs, where colors are specified as RGB values (e.g., `Red=255,0,0`), while the YAML schema organizes colors under `dark` or `light` modes, with mandatory `foreground`, `background`, and ANSI color mappings in hex format.

### Key Differences
- **Modes**: Mintty themes typically have a single color scheme; YAML requires at least one mode (`dark` or `light`), determined by background luminance.
- **Structure**: YAML uses nested maps for `colors.normal` and `colors.bright`.
- **Color Format**: Mintty uses RGB (comma-separated values), YAML uses hex (#rrggbb).
- **Omissions**: Some Mintty fields (e.g., `Font`, `Term`, `Locale`) aren't relevant for color themes and can be skipped.

## Prerequisites

- Access to a Mintty .minttyrc theme file (e.g., from theme collections or exported from a Mintty session).
- Familiarity with the terminal-themes YAML schema (refer to `docs/themes.md` or `AGENTS.md` in the project).
- A text editor for editing YAML files.
- Python 3 with PyYAML for automated conversion (optional, see automation below).

## Step-by-Step Conversion Guide

### 1. Prepare the Source .minttyrc File
- Locate your Mintty theme in .minttyrc format. It should include color definitions like:
  ```
  ForegroundColour=255,255,255
  BackgroundColour=18,39,56
  CursorColour=240,204,9
  Black=0,0,0
  Red=255,0,0
  # ... etc.
  BoldBlack=56,222,33
  # ... etc.
  ```
- Note the theme's appearance to determine mode (e.g., dark if background is dark).

### 2. Determine the Theme Name
- Choose a `name` string for the YAML (e.g., "Theme Name" – capitalize for readability).
- Typically derived from the .minttyrc file name or theme description.

### 3. Set Up the YAML Structure
- Create a new YAML file in `themes/your-theme-name.yaml`.
- Start with the basic structure:
  ```yaml
  name: "Theme Name"
  dark:  # or light, or both
    foreground: "#rrggbb"
    background: "#rrggbb"
    colors:
      normal:
        black: "#rrggbb"
        red: "#rrggbb"
        # ... (7 more colors)
      bright:
        black: "#rrggbb"
        # ... (7 more colors)
  ```

### 4. Map the Color Values
Use the following mappings to transfer values from .minttyrc to YAML. Convert RGB to lowercase hex format.

#### Top-Level Fields
- `name`: Custom string (e.g., "Custom Dark Theme").
- `source`: Optional, e.g., "Mintty conversion from custom".

#### Mode Mapping (Dark or Light)
Choose `dark` or `light` based on the theme's background color luminance (calculated using the standard formula).

| YAML Field                  | .minttyrc Source                | Example Value      |
|-----------------------------|---------------------------------|--------------------|
| `foreground`               | `ForegroundColour=255,255,255` | "#ffffff"         |
| `background`               | `BackgroundColour=18,39,56`     | "#122738"         |
| `cursor`                   | `CursorColour=240,204,9`        | "#f0cc09"         |
| `cursor-text`              | Not in Mintty (optional)        | Omitted            |
| `selection-background`     | Not in Mintty (optional)        | Omitted            |
| `selection-foreground`     | Not in Mintty (optional)        | Omitted            |

#### Colors Mapping
Map ANSI colors. Bright colors use `Bold*` variants if present, else fall back to normal.

##### Normal Colors (Mandatory)
| YAML Key   | .minttyrc Source     | Example          |
|------------|----------------------|------------------|
| `black`   | `Black=0,0,0`       | "#000000"       |
| `red`     | `Red=255,0,0`       | "#ff0000"       |
| `green`   | `Green=29,208,59`   | "#1dd03b"       |
| `yellow`  | `Yellow=237,200,9`  | "#edc809"       |
| `blue`    | `Blue=85,85,255`    | "#5555ff"       |
| `magenta` | `Magenta=255,85,255`| "#ff55ff"       |
| `cyan`    | `Cyan=106,227,250`  | "#6ae3fa"       |
| `white`   | `White=255,255,255` | "#ffffff"       |

##### Bright Colors (Mandatory)
| YAML Key   | .minttyrc Source     | Example          |
|------------|----------------------|------------------|
| `black`   | `BoldBlack=56,222,33`| "#38de21"       |
| `red`     | `BoldRed=255,229,10` | "#ffe50a"       |
| `green`   | `BoldGreen=20,96,210`| "#1460d2"       |
| `yellow`  | `BoldYellow=255,0,93`| "#ff005d"       |
| `blue`    | `BoldBlue=0,187,187` | "#00bbbb"       |
| `magenta` | `BoldMagenta=187,187,187`| "#bbbbbb"     |
| `cyan`    | `BoldCyan=85,85,85`  | "#555555"       |
| `white`   | `BoldWhite=244,14,23`| "#f40e17"       |

### 5. Handle Unsupported Fields
- Ignore non-color fields like `Font`, `Term`, `Locale`, `Charset`, etc.
- If bright colors are missing, duplicate normal colors or research variants.
- For themes with both modes, add both `dark:` and `light:` mappings.

### 6. Validate and Test
- Run `python build-themes.py` to build outputs and check for errors.
- Ensure hex values are lowercase and exactly 7 characters (# + 6 digits).
- Test the generated themes in a terminal to verify colors.

## Example Conversion

Using the provided sample `minttyrc.txt`:

**Source .minttyrc:**
```
Font=Inconsolata for Powerline
BoldAsFont=yes
Term=xterm-256color
Locale=en_GB
Charset=utf-8
BoldAsColour=yes
Black=0,0,0
Red=255,0,0
Green=29,208,59
Yellow=237,200,9
Blue=85,85,255
Magenta=255,85,255
Cyan=106,227,250
White=255,255,255
BoldBlack=56,222,33
BoldRed=255,229,10
BoldGreen=20,96,210
BoldYellow=255,0,93
BoldBlue=0,187,187
BoldMagenta=187,187,187
BoldCyan=85,85,85
BoldWhite=244,14,23
ForegroundColour=255,255,255
BackgroundColour=18,39,56
CursorColour=240,204,9
```

**Resulting YAML:**
```yaml
name: "Minttyrc"
source: "Mintty conversion from minttyrc"
dark:
  foreground: "#ffffff"
  background: "#122738"
  cursor: "#f0cc09"
  colors:
    normal:
      black: "#000000"
      red: "#ff0000"
      green: "#1dd03b"
      yellow: "#edc809"
      blue: "#5555ff"
      magenta: "#ff55ff"
      cyan: "#6ae3fa"
      white: "#ffffff"
    bright:
      black: "#38de21"
      red: "#ffe50a"
      green: "#1460d2"
      yellow: "#ff005d"
      blue: "#00bbbb"
      magenta: "#bbbbbb"
      cyan: "#555555"
      white: "#f40e17"
```

## Tips and Troubleshooting
- **Mode Selection**: Use `dark` for night themes, `light` for day themes. The background luminance determines the mode (lighter than 50% luminance is light).
- **Hex Conversion**: Ensure RGB values are integers 0-255; convert to lowercase hex.
- **Missing Fields**: Optional YAML fields can be omitted if not in .minttyrc.
- **Errors**: If `build-themes.py` fails, check for syntax errors in YAML.
- **Automation**: Use the provided `tools/mintty-to-yaml.py` script for automatic conversion: `python3 tools/mintty-to-yaml.py path/to/minttyrc.txt > themes/theme.yaml`.
- **Resources**: Look for Mintty themes on GitHub or theme sharing sites.

This guide should enable smooth conversions. Refer to `AGENTS.md` for advanced schema details.