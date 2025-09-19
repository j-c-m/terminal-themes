#!/usr/bin/env python3
# pyright: basic
"""
Standalone converter to transform VSCode JSON themes into the project's YAML theme format.
Supports conversion of a single VSCode theme to a single-mode theme (mode determined by background color).

Usage:
    python tools/vscode-to-yaml.py <vscode-theme.json>

The output YAML is printed to stdout.
"""

import sys
import os
import json5 as json
import yaml
from collections import OrderedDict

def represent_ordereddict(dumper, data):
    return dumper.represent_dict(data.items())

yaml.add_representer(OrderedDict, represent_ordereddict)

def is_light_background(bg_hex):
    """Determine if the background color is light based on luminance."""
    if not bg_hex or not bg_hex.startswith('#') or len(bg_hex) < 7:
        return False
    bg_hex = bg_hex.lower()[:7]  # Normalize to RGB
    try:
        r = int(bg_hex[1:3], 16) / 255.0
        g = int(bg_hex[3:5], 16) / 255.0
        b = int(bg_hex[5:7], 16) / 255.0
        luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return luminance > 0.5
    except ValueError:
        return False

def normalize_hex(color):
    """Normalize hex color: lowercase, strip alpha if present."""
    if not color or not color.startswith('#'):
        return '#000000'
    color = color.lower()
    if len(color) > 7:
        color = color[:7]  # Strip alpha
    return color

def load_vscode(file_path):
    """Load and parse a VSCode JSON theme file."""
    try:
        with open(file_path, 'r') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        sys.exit(1)

def main():
    if len(sys.argv) != 2:
        print("Usage: python tools/vscode-to-yaml.py <vscode-theme.json>")
        sys.exit(1)

    file = sys.argv[1]
    data = load_vscode(file)
    colors = data.get('colors', {})

    # Extract values
    background = colors.get('terminal.background') or colors.get('editor.background')
    foreground = colors.get('terminal.foreground') or colors.get('editor.foreground')
    cursor = colors.get('terminalCursor.foreground') or colors.get('editorCursor.foreground')
    selection_background = colors.get('terminal.selectionBackground') or colors.get('selection.background')

    # ANSI colors
    ansi_mapping = {
        'black': colors.get('terminal.ansiBlack'),
        'red': colors.get('terminal.ansiRed'),
        'green': colors.get('terminal.ansiGreen'),
        'yellow': colors.get('terminal.ansiYellow'),
        'blue': colors.get('terminal.ansiBlue'),
        'magenta': colors.get('terminal.ansiMagenta'),
        'cyan': colors.get('terminal.ansiCyan'),
        'white': colors.get('terminal.ansiWhite'),
    }

    bright_mapping = {
        'black': colors.get('terminal.ansiBrightBlack'),
        'red': colors.get('terminal.ansiBrightRed'),
        'green': colors.get('terminal.ansiBrightGreen'),
        'yellow': colors.get('terminal.ansiBrightYellow'),
        'blue': colors.get('terminal.ansiBrightBlue'),
        'magenta': colors.get('terminal.ansiBrightMagenta'),
        'cyan': colors.get('terminal.ansiBrightCyan'),
        'white': colors.get('terminal.ansiBrightWhite'),
    }

    # Normalize hex colors
    background = normalize_hex(background)
    foreground = normalize_hex(foreground)
    cursor = normalize_hex(cursor) if cursor else None
    selection_background = normalize_hex(selection_background) if selection_background else None

    for key in ansi_mapping:
        ansi_mapping[key] = normalize_hex(ansi_mapping[key])
    for key in bright_mapping:
        bright_mapping[key] = normalize_hex(bright_mapping[key]) if bright_mapping[key] else ansi_mapping[key]

    # Determine mode based on background
    mode = 'light' if is_light_background(background) else 'dark'

    # Derive name and source
    basename = os.path.basename(file)
    name = basename.replace('.json', '').replace('-', ' ').replace('_', ' ').title()
    source = f"VSCode conversion from {basename}"

    # Build the mode dictionary with ordered keys
    mode_dict = OrderedDict()
    if foreground:
        mode_dict['foreground'] = foreground
    if background:
        mode_dict['background'] = background
    if cursor:
        mode_dict['cursor'] = cursor
    if background:
        mode_dict['cursor-text'] = background  # Inferred as per doc example
    if selection_background:
        mode_dict['selection-background'] = selection_background
    if background:
        mode_dict['selection-foreground'] = background  # Inferred as per doc example

    # Colors with normal and bright
    colors_dict = OrderedDict([
        ('normal', OrderedDict([
            ('black', ansi_mapping['black']),
            ('red', ansi_mapping['red']),
            ('green', ansi_mapping['green']),
            ('yellow', ansi_mapping['yellow']),
            ('blue', ansi_mapping['blue']),
            ('magenta', ansi_mapping['magenta']),
            ('cyan', ansi_mapping['cyan']),
            ('white', ansi_mapping['white']),
        ])),
        ('bright', OrderedDict([
            ('black', bright_mapping['black']),
            ('red', bright_mapping['red']),
            ('green', bright_mapping['green']),
            ('yellow', bright_mapping['yellow']),
            ('blue', bright_mapping['blue']),
            ('magenta', bright_mapping['magenta']),
            ('cyan', bright_mapping['cyan']),
            ('white', bright_mapping['white']),
        ]))
    ])
    mode_dict['colors'] = colors_dict

    # Output
    output = OrderedDict([
        ('name', name),
        ('source', source),
        (mode, mode_dict)
    ])

    print(yaml.dump(output, default_flow_style=False))

if __name__ == "__main__":
    main()
