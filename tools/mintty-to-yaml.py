#!/usr/bin/env python3
# pyright: basic
"""
Standalone converter to transform Mintty .minttyrc themes into the project's YAML theme format.
Supports conversion of a single Mintty theme to a single-mode theme (mode determined by background color luminance).

Usage:
    python tools/mintty-to-yaml.py <minttyrc>

The output YAML is printed to stdout.
"""

import sys
import os
import yaml
from collections import OrderedDict

def represent_ordereddict(dumper, data):
    return dumper.represent_dict(data.items())

yaml.add_representer(OrderedDict, represent_ordereddict)

def rgb_to_hex(rgb_str):
    """Convert RGB string like '255,0,0' to hex '#ff0000'."""
    if not rgb_str or ',' not in rgb_str:
        return None
    parts = rgb_str.split(',')
    if len(parts) != 3:
        return None
    try:
        r = int(parts[0].strip())
        g = int(parts[1].strip())
        b = int(parts[2].strip())
        return f"#{r:02x}{g:02x}{b:02x}".lower()
    except ValueError:
        return None

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

def load_mintty(file_path):
    """Load and parse a Mintty .minttyrc file into a dict."""
    data = {}
    try:
        with open(file_path, 'r') as f:
            for line in f:
                line = line.strip()
                if '=' in line and not line.startswith('#'):
                    key, value = line.split('=', 1)
                    data[key.strip()] = value.strip()
        return data
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        sys.exit(1)

def main():
    if len(sys.argv) != 2:
        print("Usage: python tools/mintty-to-yaml.py <minttyrc>")
        sys.exit(1)

    file = sys.argv[1]
    data = load_mintty(file)

    # Derive name and source
    basename = os.path.basename(file).rsplit('.', 1)[0]  # Remove extension
    name = basename.replace('-', ' ').replace('_', ' ').title()
    source = f"Mintty conversion from {basename}"

    # Get colors
    fg_hex = rgb_to_hex(data.get('ForegroundColour'))
    bg_hex = rgb_to_hex(data.get('BackgroundColour'))
    cursor_hex = rgb_to_hex(data.get('CursorColour'))

    # Determine mode based on background color luminance
    mode = 'light' if bg_hex and is_light_background(bg_hex) else 'dark'

    # Build the mode dictionary with ordered keys
    mode_dict = OrderedDict()
    if fg_hex:
        mode_dict['foreground'] = fg_hex
    if bg_hex:
        mode_dict['background'] = bg_hex
    if cursor_hex:
        mode_dict['cursor'] = cursor_hex
    # Selection not present in Mintty format, omit

    # Normal colors
    normal = OrderedDict([
        ('black', rgb_to_hex(data.get('Black', '0,0,0'))),
        ('red', rgb_to_hex(data.get('Red', '255,0,0'))),
        ('green', rgb_to_hex(data.get('Green', '0,255,0'))),
        ('yellow', rgb_to_hex(data.get('Yellow', '255,255,0'))),
        ('blue', rgb_to_hex(data.get('Blue', '0,0,255'))),
        ('magenta', rgb_to_hex(data.get('Magenta', '255,0,255'))),
        ('cyan', rgb_to_hex(data.get('Cyan', '0,255,255'))),
        ('white', rgb_to_hex(data.get('White', '255,255,255'))),
    ])

    # Bright colors (use Bold variants if available, else normal)
    bright = OrderedDict([
        ('black', rgb_to_hex(data.get('BoldBlack', data.get('Black', '0,0,0')))),
        ('red', rgb_to_hex(data.get('BoldRed', data.get('Red', '255,0,0')))),
        ('green', rgb_to_hex(data.get('BoldGreen', data.get('Green', '0,255,0')))),
        ('yellow', rgb_to_hex(data.get('BoldYellow', data.get('Yellow', '255,255,0')))),
        ('blue', rgb_to_hex(data.get('BoldBlue', data.get('Blue', '0,0,255')))),
        ('magenta', rgb_to_hex(data.get('BoldMagenta', data.get('Magenta', '255,0,255')))),
        ('cyan', rgb_to_hex(data.get('BoldCyan', data.get('Cyan', '0,255,255')))),
        ('white', rgb_to_hex(data.get('BoldWhite', data.get('White', '255,255,255')))),
    ])

    colors_dict = OrderedDict([
        ('normal', normal),
        ('bright', bright)
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