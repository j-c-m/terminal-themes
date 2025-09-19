# Converting VSCode Theme JSON to Terminal Themes YAML

This guide provides a step-by-step process for converting color themes from VSCode's JSON format to the YAML schema used in the terminal-themes project. VSCode themes often include terminal colors under keys like `"terminal.ansiXxx"`, which map directly to the YAML's ANSI color arrays. This process allows you to adapt editor themes for use in terminal emulators or other tools supporting the YAML schema. For automated conversion, use the provided script `tools/vscode-to-yaml.py`.

## Overview

VSCode theme JSON files typically define colors for various UI elements, including terminal-specific colors. The terminal-themes YAML schema focuses on core elements: foreground, background, ANSI colors (normal and bright), and optional cursor/selection fields. The conversion involves extracting relevant keys and mapping them to the YAML structure, normalizing hex values, and handling any unsupported formats (e.g., RGBA).

- **Key Differences**: VSCode may include UI colors not used in terminals; YAML requires at least one mode (`dark` or `light`) with mandatory foreground, background, and ANSI mappings.
- **Supported VSCode Keys**: Focus on `terminal.*` keys for colors, plus some editor keys for cursor/selection, with fallbacks from `editor.*` if terminal keys are absent.
- **Normalization**: Ensure hex colors are lowercase, 6-digit (#rrggbb). Remove alpha channels if present.
- **Modes**: Determine if the theme is dark or light based on background luminance (light if >0.5).

## Prerequisites

- A VSCode theme JSON file (downloadable from VSCode Marketplace or theme repositories).
- Familiarity with JSON structure (e.g., `{ "key": "value" }`).
- Access to the terminal-themes project structure (refer to `AGENTS.md` for schema details).

## Step-by-Step Conversion Guide

### 1. Locate and Examine the VSCode JSON
- Find the theme's JSON file (often in a repository or extracted from VSCode extensions).
- Look for sections like:
  ```
  {
    "terminal.background": "#1f2430",
    "terminal.foreground": "#cccac2",
    "terminal.ansiBlack": "#171b24",
    "terminal.ansiBrightBlack": "#686868",
    "editorCursor.foreground": "#ffcc66",
    "selection.background": "#409fff40",
    // ... more keys
  }
  ```
- Identify the mode: Dark if background is dark (e.g., #000000+), light otherwise.

### 2. Extract Relevant Color Keys
- Prioritize `terminal.*` keys for ANSI and primary colors, with fallbacks to `editor.*` (e.g., `terminal.background` or `editor.background`).
- Include `terminalCursor.foreground` or `editorCursor.foreground`, and `selection.background` for optional fields.
- Note: Some themes may lack bright colors; if so, the script duplicates normal colors as bright.

### 3. Normalize Values
- Convert to lowercase hex: e.g., `#1F2430` → `#1f2430`.
- Remove alpha: e.g., `#409fff40` → `#409fff`.
- Expand 3-digit hex if needed: e.g., `#fff` → `#ffffff`.

### 4. Map to YAML Structure
Create a new YAML file in `themes/your-theme-name.yaml`. Use the following mappings.

#### Top-Level and Mode Fields
- `name`: Choose a string, e.g., "Theme Name".
- Mode: Use `dark` or `light` based on theme.

| YAML Field              | VSCode Key                    | Description                                      |
|-------------------------|-------------------------------|--------------------------------------------------|
| `foreground`           | `terminal.foreground`        | Default text color.                              |
| `background`           | `terminal.background`        | Background color.                                |
| `cursor`               | `terminalCursor.foreground` or `editorCursor.foreground` | Cursor color (optional).                         |
| `cursor-text`          | (Inferred as background)     | Text under cursor. |
| `selection-background` | `selection.background`       | Selected text background (optional).             |
| `selection-foreground`| (Inferred as background)     | Selected text color. |

#### ANSI Colors
Directly map to `colors.normal` and `colors.bright`.

##### Normal Colors
| YAML Key | VSCode Key          | Example       |
|----------|---------------------|---------------|
| `black`  | `terminal.ansiBlack`  | `#171b24`   |
| `red`    | `terminal.ansiRed`    | `#ed8274`   |
| `green`  | `terminal.ansiGreen`  | `#87d96c`   |
| `yellow` | `terminal.ansiYellow` | `#facc6e`   |
| `blue`   | `terminal.ansiBlue`   | `#6dcbfa`   |
| `magenta`| `terminal.ansiMagenta`| `#dabafa`   |
| `cyan`   | `terminal.ansiCyan`   | `#90e1c6`   |
| `white`  | `terminal.ansiWhite`  | `#c7c7c7`   |

##### Bright Colors
| YAML Key | VSCode Key                | Example       |
|----------|---------------------------|---------------|
| `black`  | `terminal.ansiBrightBlack`  | `#686868`   |
| `red`    | `terminal.ansiBrightRed`    | `#f28779`   |
| `green`  | `terminal.ansiBrightGreen`  | `#d5ff80`   |
| `yellow` | `terminal.ansiBrightYellow` | `#ffd173`   |
| `blue`   | `terminal.ansiBrightBlue`   | `#73d0ff`   |
| `magenta`| `terminal.ansiBrightMagenta`| `#dfbfff`   |
| `cyan`   | `terminal.ansiBrightCyan`   | `#95e6cb`   |
| `white`  | `terminal.ansiBrightWhite`  | `#ffffff`   |

### 5. Handle Missing or Optional Fields
- For missing optional fields (e.g., `cursor-text`), infer from `background` (for dark themes) or `foreground`.
- If bright colors are absent, use normal colors as bright.
- Omit unsupported keys (e.g., non-terminal colors).

### 6. Build and Validate the YAML
- Assemble the YAML:
  ```yaml
  name: "Theme Name"
  source: "VSCode conversion from theme-name.json"
  dark:  # or light
    foreground: "#rrggbb"
    background: "#rrggbb"
    cursor: "#rrggbb"  # optional
    cursor-text: "#rrggbb"  # inferred as background
    selection-background: "#rrggbb"  # optional
    selection-foreground: "#rrggbb"  # inferred as background
    colors:
      normal:
        black: "#rrggbb"
        red: "#rrggbb"
        # ... etc.
      bright:
        black: "#rrggbb"
        # ... etc.
  ```
- Run `python tools/vscode-to-yaml.py path/to/theme.json` for automated conversion, or `python build-themes.py` to test and build outputs.

## Example Conversion: Ayu Mirage

Using the Ayu Mirage theme as an example:

**Source VSCode JSON Snippet:**
```json
{
  "terminal.background": "#1f2430",
  "terminal.foreground": "#cccac2",
  "terminal.ansiBlack": "#171b24",
  "terminal.ansiRed": "#ed8274",
  "terminal.ansiGreen": "#87d96c",
  "terminal.ansiYellow": "#facc6e",
  "terminal.ansiBlue": "#6dcbfa",
  "terminal.ansiMagenta": "#dabafa",
  "terminal.ansiCyan": "#90e1c6",
  "terminal.ansiWhite": "#c7c7c7",
  "terminal.ansiBrightBlack": "#686868",
  "terminal.ansiBrightRed": "#f28779",
  "terminal.ansiBrightGreen": "#d5ff80",
  "terminal.ansiBrightYellow": "#ffd173",
  "terminal.ansiBrightBlue": "#73d0ff",
  "terminal.ansiBrightMagenta": "#dfbfff",
  "terminal.ansiBrightCyan": "#95e6cb",
  "terminal.ansiBrightWhite": "#ffffff",
  "editorCursor.foreground": "#ffcc66",
  "selection.background": "#409fff40"
}
```

**Resulting YAML:**
```yaml
name: "Ayu Mirage"
dark:
  foreground: "#cccac2"
  background: "#1f2430"
  cursor: "#ffcc66"
  cursor-text: "#1f2430"  # Inferred from background
  selection-background: "#409fff"  # Alpha removed
  selection-foreground: "#1f2430"  # Inferred from background
  colors:
    normal:
      black: "#171b24"
      red: "#ed8274"
      green: "#87d96c"
      yellow: "#facc6e"
      blue: "#6dcbfa"
      magenta: "#dabafa"
      cyan: "#90e1c6"
      white: "#c7c7c7"
    bright:
      black: "#686868"
      red: "#f28779"
      green: "#d5ff80"
      yellow: "#ffd173"
      blue: "#73d0ff"
      magenta: "#dfbfff"
      cyan: "#95e6cb"
      white: "#ffffff"
```

## Tips and Troubleshooting

- **Mode Detection**: Check `terminal.background`; dark themes often have #000000+.
- **Alpha Handling**: VSCode uses RGBA; strip the alpha for YAML (last 2 chars).
- **Missing Brights**: Replicate normal colors or search for extended palettes.
- **Errors**: If `build-themes.py` fails, check indentation and hex formats.
- **Resources**: Explore VSCode Marketplace for more themes or use online converters as references.
- **Automation**: Use the provided script `python tools/vscode-to-yaml.py path/to/theme.json` to automate conversion from a single VSCode JSON file to YAML. It outputs to stdout for easy piping to a file.

This guide enables seamless conversions. Refer to `AGENTS.md` for schema details.```
