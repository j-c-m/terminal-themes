#!/usr/bin/env python3
# pyright: basic
"""
Standalone converter to transform iTerm2 .itermcolors themes into the project's YAML theme format.

YAML hex values are sRGB. iTerm2 color dicts are converted when their Color Space
is not already sRGB, matching iTerm2's own decoder (NSDictionary+iTerm colorValue):

- sRGB: leave components unchanged
- P3: Display P3 (sRGB transfer, P3 primaries) to sRGB
- Calibrated, or missing Color Space: Apple Generic RGB (gamma 1.80078125) to sRGB
- any other tag: treated as Calibrated, with a warning

Mode is determined by background luminance after conversion.

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

# Display P3 linear → sRGB linear (D65, CSS Color 4 / Apple Display P3).
_P3_TO_SRGB = (
    (1.224940176281, -0.224940176281, 0.0),
    (-0.042056954710, 1.042056954710, 0.0),
    (-0.019637554590, -0.078636045551, 1.098273600141),
)

# Apple Generic RGB linear → sRGB linear, from Generic RGB Profile.icc
# (gamma 1.80078125 TRC, Bradford chad D50→D65, then XYZ→sRGB).
_GENERIC_RGB_TO_SRGB = (
    (1.0251724346, -0.0264023654, 0.0012584940),
    (0.0193907827, 0.9479650235, 0.0325523444),
    (-0.0017811437, -0.0014217819, 1.0037550832),
)

_GENERIC_RGB_GAMMA = 1.80078125

_warned_spaces = set()


def _clamp01(value):
    if value < 0.0:
        return 0.0
    if value > 1.0:
        return 1.0
    return value


def _mul3(matrix, vec):
    return (
        matrix[0][0] * vec[0] + matrix[0][1] * vec[1] + matrix[0][2] * vec[2],
        matrix[1][0] * vec[0] + matrix[1][1] * vec[1] + matrix[1][2] * vec[2],
        matrix[2][0] * vec[0] + matrix[2][1] * vec[1] + matrix[2][2] * vec[2],
    )


def srgb_decode(encoded):
    """Decode an sRGB (and Display P3) component to linear light."""
    if encoded <= 0.04045:
        return encoded / 12.92
    return ((encoded + 0.055) / 1.055) ** 2.4


def srgb_encode(linear):
    """Encode linear light to an sRGB component."""
    if linear <= 0.0031308:
        return linear * 12.92
    return 1.055 * (linear ** (1 / 2.4)) - 0.055


def generic_rgb_decode(encoded):
    """Decode an Apple Generic RGB / NSCalibratedRGB component to linear light."""
    if encoded <= 0.0:
        return 0.0
    return encoded ** _GENERIC_RGB_GAMMA


def _apply_matrix_to_srgb(r, g, b, decode, matrix):
    linear = _mul3(matrix, (decode(r), decode(g), decode(b)))
    return (
        srgb_encode(_clamp01(linear[0])),
        srgb_encode(_clamp01(linear[1])),
        srgb_encode(_clamp01(linear[2])),
    )


def convert_p3_to_srgb(r, g, b):
    """Convert Display P3 components to sRGB components."""
    return _apply_matrix_to_srgb(r, g, b, srgb_decode, _P3_TO_SRGB)


def convert_generic_rgb_to_srgb(r, g, b):
    """Convert Apple Generic RGB / Calibrated components to sRGB components."""
    return _apply_matrix_to_srgb(r, g, b, generic_rgb_decode, _GENERIC_RGB_TO_SRGB)


def _normalize_color_space(color_space):
    """Return (canonical_name, converter_or_None). Missing space is Calibrated."""
    if color_space is None or str(color_space).strip() == '':
        return 'Calibrated', convert_generic_rgb_to_srgb
    raw = str(color_space).strip()
    key = raw.lower().replace(' ', '').replace('_', '').replace('-', '')
    if key == 'srgb':
        return 'sRGB', None
    if key in ('p3', 'displayp3'):
        return 'P3', convert_p3_to_srgb
    if key in ('calibrated', 'genericrgb', 'nscalibratedrgbcolorspace'):
        return 'Calibrated', convert_generic_rgb_to_srgb
    return raw, convert_generic_rgb_to_srgb


def _warn_unknown_color_space(original):
    if original in _warned_spaces:
        return
    _warned_spaces.add(original)
    print(
        f"warning: treating Color Space {original!r} as Calibrated (Generic RGB) → sRGB",
        file=sys.stderr,
    )


def to_srgb(r, g, b, color_space):
    """Return sRGB components for an iTerm2 color dict's RGB and Color Space."""
    name, convert = _normalize_color_space(color_space)
    if convert is None:
        return r, g, b
    if name not in ('P3', 'Calibrated'):
        _warn_unknown_color_space(color_space)
    return convert(r, g, b)


def get_hex(color_dict):
    """Get sRGB hex string from an iTerm2 color dict."""
    if not color_dict:
        return '#000000'
    r = float(color_dict.get('Red Component', 0.0))
    g = float(color_dict.get('Green Component', 0.0))
    b = float(color_dict.get('Blue Component', 0.0))
    r, g, b = to_srgb(r, g, b, color_dict.get('Color Space'))
    return f"#{round(r*255):02x}{round(g*255):02x}{round(b*255):02x}"

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
