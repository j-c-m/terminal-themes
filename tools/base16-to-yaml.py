#!/usr/bin/env python3
# pyright: basic
"""
Standalone converter to transform Base16 YAML themes into the project's YAML theme format.
Supports conversion of a single Base16 theme (to a single-mode theme) or two themes (to a dual-mode theme).

Usage:
    python tools/base16-to-yaml.py <base16_file1.yaml> [base16_file2.yaml]

The output YAML is printed to stdout.
"""

import sys
import os
import yaml
from collections import OrderedDict

def represent_ordereddict(dumper, data):
    return dumper.represent_dict(data.items())

yaml.add_representer(OrderedDict, represent_ordereddict)

def map_colors(palette):
    """Map Base16 palette to the project's color structure."""
    return OrderedDict([
        ('foreground', palette['base05']),
        ('background', palette['base00']),
        ('cursor', palette['base05']),  # Typically same as foreground
        ('colors', OrderedDict([
            ('normal', OrderedDict([
                ('black', palette['base01']),
                ('red', palette['base08']),
                ('green', palette['base0B']),
                ('yellow', palette['base0F']),  # Per mapping in base16-conversion.md
                ('blue', palette['base0D']),
                ('magenta', palette['base0E']),
                ('cyan', palette['base0C']),
                ('white', palette['base05']),
            ])),
            ('bright', OrderedDict([
                ('black', palette['base03']),
                ('red', palette['base08']), # Same as normal
                ('green', palette['base0B']),  # Same as normal
                ('yellow', palette['base0A']),
                ('blue', palette['base0D']),   # Same as normal
                ('magenta', palette['base0E']), # Same as normal
                ('cyan', palette['base0C']),   # Same as normal
                ('white', palette['base07']),
            ]))
        ]))
    ])

def load_base16(file_path):
    """Load and parse a Base16 YAML file."""
    try:
        with open(file_path, 'r') as f:
            return yaml.safe_load(f)
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        sys.exit(1)

def main():
    if len(sys.argv) not in [2, 3]:
        print("Usage: python tools/base16-to-yaml.py <base16_file1.yaml> [base16_file2.yaml]")
        sys.exit(1)

    file1 = sys.argv[1]
    data1 = load_base16(file1)

    if len(sys.argv) == 2:
        # Single-mode theme
        name = data1.get('name', 'Unnamed Theme')
        source = data1.get('author', f"{name} (base16 conversion from {os.path.basename(file1)})")
        mode = data1.get('variant', 'dark')  # Default to 'dark' if not specified
        output = OrderedDict([
            ('name', name),
            ('source', source),
            (mode, map_colors(data1['palette']))
        ])
    else:
        # Dual-mode theme
        file2 = sys.argv[2]
        data2 = load_base16(file2)
        name1 = data1.get('name', 'Unnamed1')
        name2 = data2.get('name', 'Unnamed2')
        if name1 == name2:
            name = name1
        else:
            # Attempt to extract common base name by removing 'Light'/'Dark' suffixes
            base_name1 = name1.replace(' Light', '').replace(' Dark', '').replace(' light', '').replace(' dark', '')
            base_name2 = name2.replace(' Light', '').replace(' Dark', '').replace(' light', '').replace(' dark', '')
            if base_name1 == base_name2:
                name = base_name1
            else:
                name = f"{base_name1}/{base_name2}"  # Fallback to combined name
        author1 = data1.get('author', '')
        author2 = data2.get('author', '')
        if author1 == author2 and author1:
            source = author1
        elif author1 and author2:
            source = f"{author1} / {author2}"
        else:
            source = author1 or author2 or f"{name} (base16 conversion from {os.path.basename(file1)} and {os.path.basename(file2)})"
        # Determine which is dark/light based on 'variant'
        dark_data = data1 if data1.get('variant') == 'dark' else data2
        light_data = data1 if data1.get('variant') == 'light' else data2
        output = OrderedDict([
            ('name', name),
            ('source', source),
            ('dark', map_colors(dark_data['palette'])),
            ('light', map_colors(light_data['palette']))
        ])

    # Output the YAML
    print(yaml.dump(output, default_flow_style=False))

if __name__ == "__main__":
    main()
