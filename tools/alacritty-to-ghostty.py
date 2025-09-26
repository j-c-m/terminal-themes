#!/usr/bin/env python3
# pyright: basic

import tomli
import sys

def parse_alacritty_theme(file_path):
    """Parse the Alacritty TOML configuration file."""
    try:
        with open(file_path, 'rb') as f:  # tomli requires binary mode
            config = tomli.load(f)
        return config.get('colors', {})
    except FileNotFoundError:
        print(f"Error: File {file_path} not found.")
        sys.exit(1)
    except tomli.TOMLDecodeError:
        print(f"Error: Invalid TOML format in {file_path}.")
        sys.exit(1)

def convert_to_ghostty(colors):
    """Convert Alacritty colors to Ghostty palette format."""
    output = []

    # Normal colors (palette 0-7)
    if 'normal' in colors:
        normal = colors['normal']
        output.extend([
            f"palette = 0={normal.get('black', '#000000')}",
            f"palette = 1={normal.get('red', '#FF0000')}",
            f"palette = 2={normal.get('green', '#00FF00')}",
            f"palette = 3={normal.get('yellow', '#FFFF00')}",
            f"palette = 4={normal.get('blue', '#0000FF')}",
            f"palette = 5={normal.get('magenta', '#FF00FF')}",
            f"palette = 6={normal.get('cyan', '#00FFFF')}",
            f"palette = 7={normal.get('white', '#FFFFFF')}",
        ])

    # Bright colors (palette 8-15)
    if 'bright' in colors:
        bright = colors['bright']
        output.extend([
            f"palette = 8={bright.get('black', '#666666')}",
            f"palette = 9={bright.get('red', '#FF6666')}",
            f"palette = 10={bright.get('green', '#66FF66')}",
            f"palette = 11={bright.get('yellow', '#FFFF66')}",
            f"palette = 12={bright.get('blue', '#6666FF')}",
            f"palette = 13={bright.get('magenta', '#FF66FF')}",
            f"palette = 14={bright.get('cyan', '#66FFFF')}",
            f"palette = 15={bright.get('white', '#FFFFFF')}",
        ])

    # Indexed colors (palette 0-255)
    if 'indexed_colors' in colors:
        for idx_color in colors.get('indexed_colors', []):
            index = idx_color.get('index')
            color = idx_color.get('color')
            if isinstance(index, int) and 16 <= index <= 255:
                output.append(f"palette = {index}={color}")

    # Primary colors (background, foreground)
    if 'primary' in colors:
        primary = colors['primary']
        output.extend([
            f"background = {primary.get('background', '#000000')}",
            f"foreground = {primary.get('foreground', '#FFFFFF')}",
        ])

    # Cursor colors (always set to cell-foreground/cell-background)
    output.extend([
        "cursor-color = cell-foreground",
        "cursor-text = cell-background",
    ])

    # Selection colors (always set to cell-background/cell-foreground)
    output.extend([
        "selection-foreground = cell-background",
        "selection-background = cell-foreground",
    ])

    return "\n".join(output)

def main():
    if len(sys.argv) != 2:
        print("Usage: python convert_alacritty_to_ghostty.py <input_alacritty.toml>")
        sys.exit(1)

    input_file = sys.argv[1]
    # Parse Alacritty theme
    colors = parse_alacritty_theme(input_file)

    # Convert to Ghostty format
    ghostty_config = convert_to_ghostty(colors)

    # Output to stdout
    print("# Ghostty theme generated from Alacritty")
    print(ghostty_config)

if __name__ == "__main__":
    main()
