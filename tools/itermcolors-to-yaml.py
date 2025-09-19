#!/usr/bin/env python3
# pyright: basic
"""
Standalone converter to transform iTerm2 .itermcolors themes into the project's YAML theme format.
Supports sRGB and P3 colorspaces, converting P3 colors to sRGB for output.
Mode is determined by background color luminance.

Usage:
    python tools/itermcolors-to-yaml.py <itermcolors>

The output YAML is printed to stdout.
"""

import sys
import os
import yaml
import plistlib
from collections import OrderedDict

def represent_ordereddict(dumper, data):
    return dumper.represent_dict(data.items())

yaml.add_representer(OrderedDict, represent_ordereddict)

def gamma_decode(gc):
    """Decode gamma-encoded value to linear."""
    if gc <= 0.04045:
        return gc / 12.92
    return ((gc + 0.055) / 1.055) ** 2.4

def gamma_encode(lin):
    """Encode linear value to gamma."""
    if lin <= 0.0031308:
        return lin * 12.92
    return 1.055 * (lin ** (1/2.4)) - 0.055

def convert_p3_to_srgb(r, g, b):
    """Convert P3 gamma-corrected RGB to sRGB gamma-corrected RGB."""
    lr = gamma_decode(r)
    lg = gamma_decode(g)
    lb = gamma_decode(b)

    # Matrix from linear P3 to linear sRGB
    lrs = 1.2249 * lr - 0.2247 * lg + 0.0001 * lb
    lgs = -0.0420 * lr + 1.0419 * lg + 0.0 * lb
    lbs = -0.0197 * lr - 0.0786 * lg + 1.0983 * lb

    rs = gamma_encode(max(0, min(1, lrs)))
    gs = gamma_encode(max(0, min(1, lgs)))
    bs = gamma_encode(max(0, min(1, lbs)))

    return rs, gs, bs

def get_hex(color_dict):
    """Get hex string from iTerm2 color dict, converting P3 to sRGB."""
    if not color_dict:
        return '#000000'
    r = color_dict.get('Red Component', 0.0)
    g = color_dict.get('Green Component', 0.0)
    b = color_dict.get('Blue Component', 0.0)
    cs = color_dict.get('Color Space', 'sRGB')
    if cs == 'P3':
        r, g, b = convert_p3_to_srgb(r, g, b)
    # Now r,g,b are 0-1 sRGB
    return f"#{round(r*255):02x}{round(g*255):02x}{round(b*255):02x}".lower()

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

def load_itermcolors(file_path):
    """Load and parse an iTerm2 .itermcolors file."""
    try:
        with open(file_path, 'rb') as f:
            return plistlib.load(f)
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        sys.exit(1)

def main():
    if len(sys.argv) != 2:
        print("Usage: python tools/itermcolors-to-yaml.py <itermcolors>")
        sys.exit(1)

    file = sys.argv[1]
    data = load_itermcolors(file)

    # Derive name and source
    basename = os.path.basename(file).rsplit('.', 1)[0]  # Remove extension
    name = basename.replace('-', ' ').replace('_', ' ').title()
    source = f"iTerm2 conversion from {basename}"

    # Get color dicts
    color_dicts = {i: data.get(f'Ansi {i} Color') for i in range(16)}
    fg_dict = data.get('Foreground Color')
    bg_dict = data.get('Background Color')
    cursor_dict = data.get('Cursor Color')
    cursor_text_dict = data.get('Cursor Text Color')
    selection_bg_dict = data.get('Selection Color')
    selection_fg_dict = data.get('Selected Text Color')

    # Convert to hex
    fg_hex = get_hex(fg_dict)
    bg_hex = get_hex(bg_dict)
    cursor_hex = get_hex(cursor_dict)
    cursor_text_hex = get_hex(cursor_text_dict)
    selection_bg_hex = get_hex(selection_bg_dict)
    selection_fg_hex = get_hex(selection_fg_dict)

    ansi_hex = [get_hex(color_dicts[i]) for i in range(16)]

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
    if cursor_text_hex:
        mode_dict['cursor-text'] = cursor_text_hex
    if selection_bg_hex:
        mode_dict['selection-background'] = selection_bg_hex
    if selection_fg_hex:
        mode_dict['selection-foreground'] = selection_fg_hex

    # Normal colors
    normal = OrderedDict([
        ('black', ansi_hex[0]),
        ('red', ansi_hex[1]),
        ('green', ansi_hex[2]),
        ('yellow', ansi_hex[3]),
        ('blue', ansi_hex[4]),
        ('magenta', ansi_hex[5]),
        ('cyan', ansi_hex[6]),
        ('white', ansi_hex[7]),
    ])

    # Bright colors
    bright = OrderedDict([
        ('black', ansi_hex[8]),
        ('red', ansi_hex[9]),
        ('green', ansi_hex[10]),
        ('yellow', ansi_hex[11]),
        ('blue', ansi_hex[12]),
        ('magenta', ansi_hex[13]),
        ('cyan', ansi_hex[14]),
        ('white', ansi_hex[15]),
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
