# Converting Alacritty TOML Themes to Terminal Themes YAML

## Overview

This guide provides a step-by-step process for converting color themes from Alacritty's TOML configuration format to the YAML schema used in the terminal-themes project. The YAML schema is designed for flexibility with terminal theme generators, supporting both dark and light modes, and focusing on core color elements like ANSI colors, foreground/background, and optional cursor/selection fields. For automated conversion, use the provided script `tools/alacritty-to-yaml.py`.

Alacritty themes are typically stored in `[colors]` sections within a TOML file, while the YAML schema organizes colors under `dark` or `light` modes, with mandatory `foreground`, `background`, and ANSI color mappings.

### Key Differences
- **Modes**: Alacritty often has a single color scheme; YAML requires at least one mode (`dark` or `light`), determined by background luminance (light if >0.5).
- **Structure**: YAML uses nested maps for `colors.normal` and `colors.bright`.
- **Hex Normalization**: Ensure colors are in lowercase `#rrggbb` format. The script assumes 6-digit hex; invalid formats may use defaults.
- **Omissions**: Some Alacritty fields (e.g., `dim`, `search`, `vi_mode_cursor`) aren't supported in YAML and can be skipped.

## Prerequisites

- Access to an Alacritty TOML theme file (e.g., from GitHub repositories or theme collections).
- Familiarity with the terminal-themes YAML schema (refer to `themes/THEME_FORMAT.md` or `AGENTS.md` in the project).
- A text editor for editing YAML files.

## Step-by-Step Conversion Guide

### 1. Prepare the Source TOML File
- Locate your Alacritty theme in TOML format. It should include `[colors]` sections like:
  ```
  [colors.primary]
  foreground = "#e0def4"
  background = "#232136"

  [colors.cursor]
  text = "#e0def4"
  cursor = "#56526e"

  [colors.selection]
  text = "#e0def4"
  background = "#44415a"

  [colors.normal]
  black = "#393552"
  red = "#eb6f92"
  # ... etc.

  [colors.bright]
  black = "#6e6a86"
  # ... etc.
  ```
- Identify the theme's mode (e.g., dark for "Moon" variants, light for daytime themes). Most Alacritty themes are dark.

### 2. Determine the Theme Name
- Choose a `name` string for the YAML (e.g., "Theme Name" – capitalize for readability).
- Typically derived from the TOML file name or theme description.

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
Use the following mappings to transfer values from TOML to YAML. Ensure hex colors are lowercase and 6-digits (e.g., `#rrggbb`).

#### Top-Level Fields
- `name`: Custom string (e.g., "Rose Pine Moon").

#### Mode Mapping (Dark or Light)
Choose `dark` or `light` based on the theme's intent.

| YAML Field                  | TOML Source                     | Example Value      |
|-----------------------------|---------------------------------|--------------------|
| `foreground`               | `[colors.primary].foreground`  | "#e0def4"         |
| `background`               | `[colors.primary].background`  | "#232136"         |
| `cursor`                   | `[colors.cursor].cursor`       | "#56526e"         |
| `cursor-text`              | `[colors.cursor].text`         | "#e0def4"         |
| `selection-background`     | `[colors.selection].background`| "#44415a"         |
| `selection-foreground`     | `[colors.selection].text`      | "#e0def4"         |

#### Colors Mapping
Directly copy the ANSI color arrays. If the theme has both normal and bright, map both.

##### Normal Colors (Mandatory)
| YAML Key   | TOML Source               | Example          |
|------------|---------------------------|------------------|
| `black`   | `[colors.normal].black`  | "#393552"       |
| `red`     | `[colors.normal].red`    | "#eb6f92"       |
| `green`   | `[colors.normal].green`  | "#3e8fb0"       |
| `yellow`  | `[colors.normal].yellow` | "#f6c177"       |
| `blue`    | `[colors.normal].blue`   | "#9ccfd8"       |
| `magenta` | `[colors.normal].magenta`| "#c4a7e7"       |
| `cyan`    | `[colors.normal].cyan`   | "#ea9a97"       |
| `white`   | `[colors.normal].white`  | "#e0def4"       |

##### Bright Colors (Mandatory)
| YAML Key   | TOML Source               | Example          |
|------------|---------------------------|------------------|
| `black`   | `[colors.bright].black`  | "#6e6a86"       |
| `red`     | `[colors.bright].red`    | "#eb6f92"       |
| `green`   | `[colors.bright].green`  | "#3e8fb0"       |
| `yellow`  | `[colors.bright].yellow` | "#f6c177"       |
| `blue`    | `[colors.bright].blue`   | "#9ccfd8"       |
| `magenta` | `[colors.bright].magenta`| "#c4a7e7"       |
| `cyan`    | `[colors.bright].cyan`   | "#ea9a97"       |
| `white`   | `[colors.bright].white`  | "#e0def4"       |

### 5. Handle Unsupported Fields
- Ignore `[colors.dim]`, `[colors.search]`, `[colors.hints]`, etc., as they aren't in the YAML schema.
- If the theme lacks bright colors, the script duplicates normal colors as bright defaults.
- For themes with both modes, add both `dark:` and `light:` mappings.

### 6. Validate and Test
- Run `python tools/alacritty-to-yaml.py path/to/theme.toml` for automated conversion, or `python build-themes.py` to test and build outputs.
- Ensure hex values are lowercase and exactly 7 characters (# + 6 digits); the script outputs YAML directly.
- Test the generated themes in a terminal to verify colors.

## Example Conversion

Using the Rose Pine Moon theme as an example:

**Source TOML Snippet:**
```toml
[colors.primary]
foreground = "#e0def4"
background = "#232136"

[colors.cursor]
text = "#e0def4"
cursor = "#56526e"

[colors.selection]
text = "#e0def4"
background = "#44415a"

[colors.normal]
black = "#393552"
red = "#eb6f92"
green = "#3e8fb0"
yellow = "#f6c177"
blue = "#9ccfd8"
magenta = "#c4a7e7"
cyan = "#ea9a97"
white = "#e0def4"

[colors.bright]
black = "#6e6a86"
red = "#eb6f92"
green = "#3e8fb0"
yellow = "#f6c177"
blue = "#9ccfd8"
magenta = "#c4a7e7"
cyan = "#ea9a97"
white = "#e0def4"
```

**Resulting YAML:**
```yaml
name: "Rose Pine Moon"
source: "Alacritty conversion from rose-pine-moon.toml"
dark:
  foreground: "#e0def4"
  background: "#232136"
  cursor: "#56526e"
  cursor-text: "#e0def4"
  selection-background: "#44415a"
  selection-foreground: "#e0def4"
  colors:
    normal:
      black: "#393552"
      red: "#eb6f92"
      green: "#3e8fb0"
      yellow: "#f6c177"
      blue: "#9ccfd8"
      magenta: "#c4a7e7"
      cyan: "#ea9a97"
      white: "#e0def4"
    bright:
      black: "#6e6a86"
      red: "#eb6f92"
      green: "#3e8fb0"
      yellow: "#f6c177"
      blue: "#9ccfd8"
      magenta: "#c4a7e7"
      cyan: "#ea9a97"
      white: "#e0def4"
```

## Tips and Troubleshooting
- **Mode Selection**: Use `dark` for night themes, `light` for day themes. If unsure, check the background color (#000000+ is dark, lighter is light).
- **Hex Formats**: The script expects 6-digit hex (#rrggbb); invalid formats may not be handled correctly.
- **Missing Fields**: Optional YAML fields can be omitted if not in the TOML.
- **Errors**: If `build-themes.py` fails, check for syntax errors in YAML (e.g., indentation).
- **Resources**: Browse Alacritty themes on GitHub for more examples.
- **Automation**: Use the provided script `python tools/alacritty-to-yaml.py path/to/theme.toml` to automate conversion from a single Alacritty TOML file to YAML. It outputs to stdout for easy piping to a file.

This guide should enable smooth conversions. Refer to `AGENTS.md` for advanced schema details.
