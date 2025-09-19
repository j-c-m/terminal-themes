# Converting iTerm2 .itermcolors Themes to Terminal Themes YAML

## Overview

This guide provides a step-by-step process for converting color themes from iTerm2's .itermcolors configuration format to the YAML schema used in the terminal-themes project. iTerm2 themes are stored in XML-based plist files with color components (Red/Green/Blue) in gamma-corrected 0-1 values, supporting sRGB and P3 colorspaces. The YAML schema organizes colors under `dark` or `light` modes, with mandatory `foreground`, `background`, and ANSI color mappings in hex format.

The conversion tool handles both sRGB (default) and P3 colorspaces, converting P3 colors to sRGB for consistent output in the project's YAML format.

### Key Differences
- **Color Format**: iTerm2 uses gamma-corrected RGB floats (0-1); YAML uses hex (#rrggbb).
- **Colorspace**: Supports sRGB and P3; P3 is converted to sRGB.
- **Structure**: YAML nests colors under `colors.normal` and `colors.bright`.
- **Sources**: iTerm2 has dedicated keys for foreground, background, cursor, selection, and ANSI 0-15 colors.

## Prerequisites

- Access to an iTerm2 .itermcolors theme file (e.g., from the iTerm2 repository or custom themes).
- Familiarity with the terminal-themes YAML schema (refer to `docs/themes.md` or `AGENTS.md`).
- A text editor for editing YAML files.
- Python 3 with PyYAML and standard library (plistlib) for automated conversion.

## Step-by-Step Conversion Guide

### 1. Prepare the Source .itermcolors File
- Locate your iTerm2 theme in .itermcolors format. It should be a plist XML file with color dictionaries like:
  ```
  <key>Ansi 0 Color</key>
  <dict>
    <key>Red Component</key><real>0.0</real>
    <key>Green Component</key><real>0.0</real>
    <key>Blue Component</key><real>0.0</real>
    <key>Color Space</key><string>sRGB</string>
  </dict>
  <!-- ... etc. -->
  ```
- Note the colorspace; if P3, it will be converted automatically.

### 2. Determine the Theme Name
- Choose a `name` string for the YAML (e.g., "Cobalt 2" – capitalize for readability).
- Typically derived from the .itermcolors file name.

### 3. Set Up the YAML Structure
- Create a new YAML file in `themes/your-theme-name.yaml`.
- Start with the basic structure:
  ```yaml
  name: "Theme Name"
  dark:  # or light
    foreground: "#rrggbb"
    background: "#rrggbb"
    colors:
      normal:
        black: "#rrggbb"
        red: "#rrggbb"
        # ... (7 more)
      bright:
        black: "#rrggbb"
        # ... (7 more)
  ```

### 4. Map the Color Values
Convert float components to hex. The tool handles sRGB and P3 conversion.

#### Top-Level Fields
- `name`: Custom string (e.g., "Cobalt 2").

#### Mode Mapping (Dark or Light)
Determined by background luminance (luminance > 0.5 is light).

| YAML Field                  | iTerm2 Source                      | Example Value      |
|-----------------------------|------------------------------------|--------------------|
| `foreground`               | `<key>Foreground Color</key>`     | "#fffefe"         |
| `background`               | `<key>Background Color</key>`     | "#173347"         |
| `cursor`                   | `<key>Cursor Color</key>`         | "#f4d200"         |
| `cursor-text`              | `<key>Cursor Text Color</key>`    | "#fefef4"         |
| `selection-background`     | `<key>Selection Color</key>`      | "#1f4461"         |
| `selection-foreground`     | `<key>Selected Text Color</key>`  | "#c1c1c1"         |

#### Colors Mapping
ANSI colors from Ansi 0 to Ansi 15 (0-7 normal, 8-15 bright).

##### Normal Colors (Mandatory)
| YAML Key   | iTerm2 Key         | Example          |
|------------|--------------------|------------------|
| `black`   | `Ansi 0 Color`    | "#000000"       |
| `red`     | `Ansi 1 Color`    | "#ff2600"       |
| `green`   | `Ansi 2 Color`    | "#3cdf2b"       |
| `yellow`  | `Ansi 3 Color`    | "#f4d300"       |
| `blue`    | `Ansi 4 Color`    | "#1477da"       |
| `magenta` | `Ansi 5 Color`    | "#ff2b6f"       |
| `cyan`    | `Ansi 6 Color`    | "#00c5c7"       |
| `white`   | `Ansi 7 Color`    | "#c7c7c7"       |

##### Bright Colors (Mandatory)
| YAML Key   | iTerm2 Key         | Example          |
|------------|--------------------|------------------|
| `black`   | `Ansi 8 Color`    | "#676767"       |
| `red`     | `Ansi 9 Color`    | "#f8291c"       |
| `green`   | `Ansi 10 Color`   | "#43d326"       |
| `yellow`  | `Ansi 11 Color`   | "#f1cf00"       |
| `blue`    | `Ansi 12 Color`   | "#6871ff"       |
| `magenta` | `Ansi 13 Color`   | "#ff76ff"       |
| `cyan`    | `Ansi 14 Color`   | "#79e7fa"       |
| `white`   | `Ansi 15 Color`   | "#fffefe"       |

### 5. Handle Unsupported Fields
- Ignore extra fields like `Badge Color`, `Link Color`, etc.
- Ensure colors are converted to sRGB if P3.

### 6. Validate and Test
- Run `python build-themes.py` to build outputs.
- Ensure hex values are lowercase and valid.

## Example Conversion

Using the cobalt2.itermcolors theme:

**Source .itermcolors snippet:**
```xml
<key>Ansi 0 Color</key>
<dict>
  <key>Red Component</key><real>0.0</real>
  <key>Green Component</key><real>0.0</real>
  <key>Blue Component</key><real>0.0</real>
  <key>Color Space</key><string>sRGB</string>
</dict>
<!-- ... -->
<key>Foreground Color</key>
<dict>
  <key>Red Component</key><real>1</real>
  <key>Green Component</key><real>1</real>
  <key>Blue Component</key><real>0.99999994039535522</real>
  <key>Color Space</key><string>sRGB</string>
</dict>
```

**Resulting YAML:**
```yaml
name: "Cobalt2"
source: "iTerm2 conversion from cobalt2"
dark:
  foreground: "#fffefe"
  background: "#173347"
  cursor: "#f4d200"
  cursor-text: "#fefef4"
  selection-background: "#1f4461"
  selection-foreground: "#c1c1c1"
  colors:
    normal:
      black: "#000000"
      red: "#ff2600"
      green: "#3cdf2b"
      yellow: "#f4d300"
      blue: "#1477da"
      magenta: "#ff2b6f"
      cyan: "#00c5c7"
      white: "#c7c7c7"
    bright:
      black: "#676767"
      red: "#f8291c"
      green: "#43d326"
      yellow: "#f1cf00"
      blue: "#6871ff"
      magenta: "#ff76ff"
      cyan: "#79e7fa"
      white: "#fffefe"
```

## Tips and Troubleshooting
- **Colorspace Conversion**: P3 colors are automatically converted to sRGB using linear transformation.
- **Missing Colors**: Use defaults if keys are missing.
- **Automation**: Use `python3 tools/itermcolors-to-yaml.py path/to/theme.itermcolors > themes/theme.yaml`.
- **Resources**: iTerm2 themes available at https://iterm2colorschemes.com/.

This guide enables easy conversions. Refer to `AGENTS.md` for schema details.