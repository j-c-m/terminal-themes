#!/usr/bin/env python3
# pyright: basic
"""
Standalone converter to transform Alacritty TOML themes into the project's YAML theme format.
Supports conversion of a single Alacritty theme to a single-mode theme (mode determined by background color).

Usage:
    python tools/alacritty-to-yaml.py <alacritty.toml>

The output YAML is printed to stdout.
"""

import sys
import os
import yaml
from collections import OrderedDict
import tomli

def represent_ordereddict(dumper, data):
    return dumper.represent_dict(data.items())

yaml.add_representer(OrderedDict, represent_ordereddict)

def is_light_background(bg_hex):
    """Determine if the background color is light based on luminance."""
    if not bg_hex or not bg_hex.startswith('#') or len(bg_hex) != 7:
        return False
    bg_hex = bg_hex[1:]  # Remove '#'
    try:
        r = int(bg_hex[0:2], 16) / 255.0
        g = int(bg_hex[2:4], 16) / 255.0
        b = int(bg_hex[4:6], 16) / 255.0
        luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return luminance > 0.5
    except ValueError:
        return False

def load_alacritty(file_path):
    """Load and parse an Alacritty TOML file."""
    try:
        with open(file_path, 'rb') as f:  # tomli requires binary mode
            return tomli.load(f)
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        sys.exit(1)

def main():
    if len(sys.argv) != 2:
        print("Usage: python tools/alacritty-to-yaml.py <alacritty.toml>")
        sys.exit(1)

    file = sys.argv[1]
    data = load_alacritty(file)
    colors = data.get('colors', {})

    primary = colors.get('primary', {})
    cursor = colors.get('cursor', {})
    selection = colors.get('selection', {})
    normal = colors.get('normal', {})
    bright = colors.get('bright', {})

    # Derive name and source
    basename = os.path.basename(file)
    name = basename.replace('.toml', '').replace('-', ' ').replace('_', ' ').title()
    source = f"Alacritty conversion from {basename}"

    # Determine mode based on background color luminance
    bg_color = primary.get('background')
    mode = 'light' if is_light_background(bg_color) else 'dark'

    # Build the mode dictionary with ordered keys
    mode_dict = OrderedDict()
    if 'foreground' in primary:
        mode_dict['foreground'] = primary['foreground']
    if 'background' in primary:
        mode_dict['background'] = primary['background']
    if 'cursor' in cursor:
        mode_dict['cursor'] = cursor['cursor']
    if 'text' in cursor:
        mode_dict['cursor-text'] = cursor['text']
    if 'background' in selection:
        mode_dict['selection-background'] = selection['background']
    if 'text' in selection:
        mode_dict['selection-foreground'] = selection['text']

    # Colors with normal and bright
    colors_dict = OrderedDict([
        ('normal', OrderedDict([
            ('black', normal.get('black', '#000000')),
            ('red', normal.get('red', '#ff0000')),
            ('green', normal.get('green', '#00ff00')),
            ('yellow', normal.get('yellow', '#ffff00')),
            ('blue', normal.get('blue', '#0000ff')),
            ('magenta', normal.get('magenta', '#ff00ff')),
            ('cyan', normal.get('cyan', '#00ffff')),
            ('white', normal.get('white', '#ffffff')),
        ])),
        ('bright', OrderedDict([
            ('black', bright.get('black', normal.get('black', '#000000'))),
            ('red', bright.get('red', normal.get('red', '#ff0000'))),
            ('green', bright.get('green', normal.get('green', '#00ff00'))),
            ('yellow', bright.get('yellow', normal.get('yellow', '#ffff00'))),
            ('blue', bright.get('blue', normal.get('blue', '#0000ff'))),
            ('magenta', bright.get('magenta', normal.get('magenta', '#ff00ff'))),
            ('cyan', bright.get('cyan', normal.get('cyan', '#00ffff'))),
            ('white', bright.get('white', normal.get('white', '#ffffff'))),
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
