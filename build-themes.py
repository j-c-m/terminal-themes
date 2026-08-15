#!/usr/bin/env python3
# pyright: basic
"""
Generate script for terminal-themes

This version requires `templates/config.json` to include a `template` entry:
- For normal templates: "template": "filename"
- For dual-mode templates (when "dual_mode": true): "template": [ "single_template", "dual_template" ]

Behavior:
- For entries without "dual_mode" (or false): render the single template once per context (per-mode).
- For entries with "dual_mode": true:
  - If the theme file contains both `dark` and `light`, render ONLY the dual template once
    with a merged context that exposes `light` and `dark` (do NOT render per-context single templates).
  - If the theme file contains only one mode, render the single template once per-context as usual.

This refactor extracts several helpers to reduce cyclomatic complexity of `main()`.

Added behavior:
- Collects contexts across all themes and renders an `index.mustache` template once at the end,
  writing `build/index.html`. For themes that provide both dark and light modes the index
  will include a merged dual-mode context (`theme-mode` == "both"). For single-mode themes
  the individual per-mode contexts are included.

New behavior:
- When a theme's `normal` and corresponding `bright` color are identical, the bright color
  will be adjusted:
    - If the normal color's lightness is below `BRIGHTNESS_THRESHOLD`, the bright color is made
      `BRIGHTEN_FACTOR` times brighter (increase lightness).
    - If the normal color is already bright (>= threshold), the bright color is made
      `DARKEN_FACTOR` times darker and `SATURATION_INCREASE` times more saturated.
"""
from __future__ import annotations

import json
import yaml
import plistlib
import pystache
import os
import re
import glob
import sys
from pathlib import Path
from typing import Dict, List, Optional, Any, Tuple
from unidecode import unidecode
import colorsys

COLOR_NAMES = ['black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white']

# SPDX ids that allow free redistribution (permissive, public-domain, and copyleft).
ALLOWED_LICENSES = frozenset({
    '0BSD',
    'AGPL-3.0-only',
    'AGPL-3.0-or-later',
    'Apache-2.0',
    'BlueOak-1.0.0',
    'BSD-2-Clause',
    'BSD-3-Clause',
    'CC0-1.0',
    'GPL-2.0-only',
    'GPL-2.0-or-later',
    'GPL-3.0-only',
    'GPL-3.0-or-later',
    'ISC',
    'LGPL-2.1-only',
    'LGPL-2.1-or-later',
    'LGPL-3.0-only',
    'LGPL-3.0-or-later',
    'MIT',
    'MIT-0',
    'MPL-2.0',
    'PostgreSQL',
    'Unlicense',
    'Zlib',
})

# Simple in-module cache for template contents
_TEMPLATE_CACHE: dict[str, Optional[str]] = {}
_errors: List[str] = []


def record_error(message: str) -> None:
    print(message)
    _errors.append(message)


def exit_status() -> int:
    if not _errors:
        return 0
    print(f"Build failed with {len(_errors)} error(s).", file=sys.stderr)
    return 1

# Brightness/saturation adjustment constants
# If normal lightness >= BRIGHTNESS_THRESHOLD it's considered "already bright"
BRIGHTNESS_THRESHOLD: float = 0.8
# Multiplicative adjustments
BRIGHTEN_FACTOR: float = 1.10  # 10% brighter
DARKEN_FACTOR: float = 0.90    # 10% darker
SATURATION_INCREASE: float = 1.10  # 10% more saturated


def load_config(path: Path) -> Dict[str, Any]:
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)


def load_yaml(path: Path) -> Optional[Dict[str, Any]]:
    try:
        with open(path, 'r', encoding='utf-8') as f:
            return yaml.safe_load(f) or {}
    except Exception as e:
        record_error(f"Error loading YAML {path}: {e}")
        return None


def slugify(name: str) -> str:
    name = unidecode(name or '')
    name = name.lower()
    name = name.replace(' ', '-').replace('_', '-')
    name = re.sub(r'[^0-9a-z-]', '', name)
    name = re.sub(r'-{2,}', '-', name).strip('-')
    return name


def normalize_hex(value: Any) -> Optional[str]:
    if not value or not isinstance(value, str):
        return None
    v = value.strip()
    if not v.startswith('#'):
        return None
    hex_part = v[1:]
    if re.fullmatch(r'[0-9a-fA-F]{3}', hex_part):
        return '#' + ''.join(ch * 2 for ch in hex_part).lower()
    if re.fullmatch(r'[0-9a-fA-F]{6}', hex_part):
        return '#' + hex_part.lower()
    return None


def hex_to_hexterm(hex_color: str) -> str:
    h = hex_color.lstrip('#')
    return f"{h[0:2]}/{h[2:4]}/{h[4:6]}"


def hex_to_rgb(hex_color: str):
    h = hex_color.lstrip('#')
    r = int(h[0:2], 16) / 255.0
    g = int(h[2:4], 16) / 255.0
    b = int(h[4:6], 16) / 255.0
    return r, g, b


def rgb_to_hex(r: float, g: float, b: float) -> str:
    """
    Convert floats in [0.0, 1.0] to a normalized '#rrggbb' hex string.
    """
    def clamp_byte(x: float) -> int:
        return max(0, min(255, int(round(x * 255))))
    return '#{0:02x}{1:02x}{2:02x}'.format(clamp_byte(r), clamp_byte(g), clamp_byte(b))


def adjust_bright_from_normal(normal_hex: str) -> str:
    """
    Given a normalized '#rrggbb' normal color, return an adjusted bright hex.
    If the normal color is not already bright (lightness < BRIGHTNESS_THRESHOLD),
    make it BRIGHTEN_FACTOR brighter (increase lightness).
    If it is already bright, make it DARKEN_FACTOR darker and increase saturation
    by SATURATION_INCREASE.
    """
    try:
        r, g, b = hex_to_rgb(normal_hex)
        # colorsys uses H, L, S (hue, lightness, saturation)
        h, l, s = colorsys.rgb_to_hls(r, g, b)
        if l >= BRIGHTNESS_THRESHOLD:
            # Already bright: make bright color slightly darker and more saturated
            new_l = max(0.0, min(1.0, l * DARKEN_FACTOR))
            new_s = max(0.0, min(1.0, s * SATURATION_INCREASE))
        else:
            # Not bright: make bright color slightly brighter (increase lightness)
            new_l = max(0.0, min(1.0, l * BRIGHTEN_FACTOR))
            new_s = s
        nr, ng, nb = colorsys.hls_to_rgb(h, new_l, new_s)
        return rgb_to_hex(nr, ng, nb)
    except Exception:
        # On any failure, fall back to returning the original normal color
        return normal_hex


def validate_theme_top_level(theme_data: dict, theme_path: Path):
    missing = []
    if not isinstance(theme_data, dict):
        raise ValueError(f"{theme_path}: theme top-level must be a mapping")
    if not theme_data.get('name'):
        missing.append('name')
    if not str(theme_data.get('source') or '').strip():
        missing.append('source')
    license_id = str(theme_data.get('license') or '').strip()
    if not license_id:
        missing.append('license')
    modes = [k for k in ('dark', 'light') if k in theme_data]
    if not modes:
        missing.append('dark|light (at least one required)')
    if missing:
        raise ValueError(f"{theme_path}: missing required top-level fields: {', '.join(missing)}")
    if license_id and license_id not in ALLOWED_LICENSES:
        allowed = ', '.join(sorted(ALLOWED_LICENSES))
        raise ValueError(
            f"{theme_path}: license {license_id!r} is not allowed; "
            f"must be an SPDX id that allows free redistribution: {allowed}"
        )


def validate_mode(mode_map: dict, theme_path: Path, mode_name: str):
    missing = []
    if not isinstance(mode_map, dict):
        raise ValueError(f"{theme_path}: mode '{mode_name}' must be a mapping")
    for primary in ('foreground', 'background'):
        if primary not in mode_map:
            missing.append(primary)
    colors = mode_map.get('colors')
    if not isinstance(colors, dict):
        missing.append('colors')
    else:
        normal = colors.get('normal')
        bright = colors.get('bright')
        if not isinstance(normal, dict):
            missing.append('colors.normal')
        else:
            for cn in COLOR_NAMES:
                if cn not in normal:
                    missing.append(f'colors.normal.{cn}')
        if not isinstance(bright, dict):
            missing.append('colors.bright')
        else:
            for cn in COLOR_NAMES:
                if cn not in bright:
                    missing.append(f'colors.bright.{cn}')
    if missing:
        raise ValueError(f"{theme_path} [{mode_name}]: missing required fields: {', '.join(missing)}")


def extract_theme_notice(theme_path: Path) -> str:
    """Return the leading # comment block from a theme YAML file."""
    try:
        text = theme_path.read_text(encoding='utf-8')
    except OSError:
        return ''
    lines: List[str] = []
    for raw in text.splitlines():
        if raw.startswith('#'):
            lines.append(raw[2:] if raw.startswith('# ') else raw[1:])
        elif raw.strip() == '':
            if lines:
                lines.append('')
        else:
            break
    while lines and lines[-1] == '':
        lines.pop()
    return '\n'.join(lines)


def notice_as_hash_comments(notice: str) -> str:
    """Format a notice as # comments, including a trailing newline when non-empty."""
    if not notice:
        return ''
    out: List[str] = []
    for line in notice.splitlines():
        out.append(f'# {line}' if line else '#')
    return '\n'.join(out) + '\n'


def wrap_plist_with_notice(xml: str, context: Dict[str, Any]) -> str:
    """Prepend an XML comment with the theme notice after the XML declaration."""
    notice = context.get('theme-notice') or ''
    license_id = context.get('theme-license') or ''
    source = context.get('theme-source') or ''
    body_lines: List[str] = []
    if notice:
        body_lines.extend(notice.splitlines())
    if license_id:
        body_lines.append(f'SPDX-License-Identifier: {license_id}')
    if source:
        body_lines.append(f'Source: {source}')
    if not body_lines:
        return xml
    body = '\n'.join(body_lines).replace('--', '- -')
    comment = f'<!--\n{body}\n-->\n'
    if xml.startswith('<?xml'):
        nl = xml.find('\n')
        if nl != -1:
            return xml[:nl + 1] + comment + xml[nl + 1:]
    return comment + xml


def build_context_for_mode(base_name: str, modifier: str, source: str, mode_name: str, mode_map: dict,
                           theme_path: Path, include_mode: bool = True, license_id: str = '',
                           notice: str = '') -> Dict[str, Any]:
    validate_mode(mode_map, theme_path, mode_name)

    normal: Dict[str, Dict[str, str]] = {}
    bright: Dict[str, Dict[str, str]] = {}
    for cn in COLOR_NAMES:
        raw_n = mode_map.get('colors', {}).get('normal', {}).get(cn)
        raw_b = mode_map.get('colors', {}).get('bright', {}).get(cn)
        if raw_n is None or raw_b is None:
            raise ValueError(f"{theme_path} [{mode_name}]: missing color '{cn}' in normal/bright")
        hn = normalize_hex(raw_n)
        hb = normalize_hex(raw_b)
        if not hn or not hb:
            raise ValueError(f"{theme_path} [{mode_name}]: invalid hex for color '{cn}' in normal/bright; must be '#rgb' or '#rrggbb'")

        # If normal and bright are identical after normalization, adjust the bright variant
        if hn == hb and cn != 'white':
            hb = adjust_bright_from_normal(hn)

        normal[cn] = {'hex': hn, 'hexterm': hex_to_hexterm(hn)}
        bright[cn] = {'hex': hb, 'hexterm': hex_to_hexterm(hb)}

    def normp(key: str, fallback: Optional[str] = None) -> Optional[Dict[str, str]]:
        v = mode_map.get(key, fallback)
        h = normalize_hex(v)
        if not h:
            return None
        return {'hex': h, 'hexterm': hex_to_hexterm(h)}

    foreground = normp('foreground')
    background = normp('background')
    cursor = normp('cursor', fallback=(foreground['hex'] if foreground else None)) or foreground
    cursor_text = normp('cursor-text', fallback=(background['hex'] if background else None)) or background
    selection_background = normp('selection-background', fallback=(foreground['hex'] if foreground else None)) or foreground
    selection_foreground = normp('selection-foreground', fallback=(background['hex'] if background else None)) or background

    mode_label = mode_name.capitalize()
    parts = [base_name]
    if include_mode:
        parts.append(mode_label)
    if modifier:
        parts.append(modifier)
    theme_name = ' '.join(parts).strip()

    slug_parts = [slugify(base_name)]
    if include_mode:
        slug_parts.append(mode_name)
    if modifier:
        slug_parts.append(slugify(modifier))
    theme_slug = '-'.join(slug_parts)

    context = {
        'theme-source': source or '',
        'theme-license': license_id or '',
        'theme-notice': notice or '',
        'theme-notice-hash': notice_as_hash_comments(notice),
        'theme-slug': theme_slug,
        'theme-name': theme_name,
        'theme-mode': mode_name,
        'theme-modifier': modifier or '',
        'normal': normal,
        'bright': bright,
        'foreground': foreground,
        'background': background,
        'cursor': cursor,
        'cursor-text': cursor_text,
        'selection-background': selection_background,
        'selection-foreground': selection_foreground
    }
    return context


def build_contexts_from_yaml(theme_data: dict, source_name: str, theme_path: Path) -> Tuple[List[Dict[str, Any]], bool]:
    validate_theme_top_level(theme_data, theme_path)
    base_name = str(theme_data.get('name') or '')
    if not base_name:
        raise ValueError(f"{theme_path}: invalid theme 'name' value")
    modifier = (theme_data.get('modifier') or '').strip()
    source = theme_data.get('source') or source_name or ''
    license_id = str(theme_data.get('license') or '').strip()
    notice = extract_theme_notice(theme_path)

    is_combined = False  # Flag to detect if theme references external files
    # NEW: Resolve any string references to external YAML files for modes
    for mode in ('dark', 'light'):
        if mode in theme_data and isinstance(theme_data[mode], str):
            is_combined = True  # Set flag if any reference is found
            ref_filename = theme_data[mode]
            ref_path = theme_path.parent / ref_filename
            ref_data = load_yaml(ref_path)
            if not ref_data or mode not in ref_data:
                raise ValueError(f"{theme_path}: Referenced file '{ref_filename}' for '{mode}' does not contain '{mode}' mode or failed to load")
            # Replace the string reference with the actual mode dict from the referenced file
            theme_data[mode] = ref_data[mode]

    contexts: List[Dict[str, Any]] = []
    modes_present = [k for k in ('dark', 'light') if k in theme_data]
    include_mode = len(modes_present) > 1
    for mode in ('dark', 'light'):
        if mode not in theme_data:
            continue
        mode_map = theme_data[mode]
        ctx = build_context_for_mode(base_name, modifier, source, mode, mode_map, theme_path,
                                     include_mode=include_mode, license_id=license_id, notice=notice)
        contexts.append(ctx)

    if not contexts:
        raise ValueError(f"{theme_path}: no modes found (expected 'dark' and/or 'light')")
    return contexts, is_combined


def generate_iterm_plist(context: dict) -> str:
    plist: Dict[str, Any] = {}
    for i, name in enumerate(COLOR_NAMES):
        h = context['normal'][name]['hex']
        r, g, b = hex_to_rgb(h)
        plist[f'Ansi {i} Color'] = {
            'Red Component': r,
            'Green Component': g,
            'Blue Component': b,
            'Alpha Component': 1.0,
            'Color Space': 'sRGB'
        }
    for i, name in enumerate(COLOR_NAMES):
        h = context['bright'][name]['hex']
        r, g, b = hex_to_rgb(h)
        plist[f'Ansi {8 + i} Color'] = {
            'Red Component': r,
            'Green Component': g,
            'Blue Component': b,
            'Alpha Component': 1.0,
            'Color Space': 'sRGB'
        }
    for key, label in [
        ('foreground', 'Foreground Color'),
        ('background', 'Background Color'),
        ('cursor', 'Cursor Color'),
        ('selection-background', 'Selection Color'),
        ('selection-foreground', 'Selected Text Color'),
    ]:
        val = context.get(key)
        if not val:
            continue
        r, g, b = hex_to_rgb(val['hex'])
        plist[label] = {
            'Red Component': r,
            'Green Component': g,
            'Blue Component': b,
            'Alpha Component': 1.0,
            'Color Space': 'sRGB'
        }
    return wrap_plist_with_notice(
        plistlib.dumps(plist, fmt=plistlib.FMT_XML).decode('utf-8'),
        context,
    )


def prepare_iterm_plists(contexts: List[Dict[str, Any]], dark_ctx: Optional[Dict[str, Any]] = None,
                         light_ctx: Optional[Dict[str, Any]] = None) -> Optional[str]:
    combined = None
    for c in contexts:
        try:
            c['theme-itermcolors-plist'] = generate_iterm_plist(c)
        except Exception as e:
            record_error(f"Error generating iTerm plist for {c.get('theme-slug')}: {e}")
            c['theme-itermcolors-plist'] = ''
    if dark_ctx and light_ctx:
        try:
            combined = generate_dual_iterm_plist(dark_ctx, light_ctx)
        except Exception as e:
            record_error(f"Error generating combined iTerm plist: {e}")
            combined = ''
    return combined


def generate_dual_iterm_plist(dark_context: dict, light_context: dict) -> str:
    if not dark_context or not light_context:
        raise ValueError("Both dark and light contexts are required for dual plist generation")
    plist: Dict[str, Any] = {}

    def set_color(d: Dict[str, Any], key: str, hexcolor: str):
        r, g, b = hex_to_rgb(hexcolor)
        d[key] = {
            'Red Component': r,
            'Green Component': g,
            'Blue Component': b,
            'Alpha Component': 1.0,
            'Color Space': 'sRGB'
        }

    for i in range(0, 16):
        if i < 8:
            name = COLOR_NAMES[i]
            light_hex = light_context['normal'][name]['hex']
            dark_hex = dark_context['normal'][name]['hex']
        else:
            name = COLOR_NAMES[i - 8]
            light_hex = light_context['bright'][name]['hex']
            dark_hex = dark_context['bright'][name]['hex']

        base_key = f'Ansi {i} Color'
        dark_key = f'{base_key} (Dark)'
        light_key = f'{base_key} (Light)'

        set_color(plist, base_key, light_hex)
        set_color(plist, dark_key, dark_hex)
        set_color(plist, light_key, light_hex)

    primaries = [
        ('foreground', 'Foreground Color'),
        ('background', 'Background Color'),
        ('cursor', 'Cursor Color'),
        ('selection-background', 'Selection Color'),
        ('selection-foreground', 'Selected Text Color'),
    ]

    for key, label in primaries:
        light_val = light_context.get(key)
        dark_val = dark_context.get(key)
        if light_val:
            set_color(plist, label, light_val['hex'])
            set_color(plist, f'{label} (Light)', light_val['hex'])
        if dark_val:
            set_color(plist, f'{label} (Dark)', dark_val['hex'])

    return wrap_plist_with_notice(
        plistlib.dumps(plist, fmt=plistlib.FMT_XML).decode('utf-8'),
        light_context,
    )


def find_theme_files(themes_base: Path) -> List[str]:
    patterns = [
        str(themes_base / '*.yaml'),
        str(themes_base / '*.yml'),
        str(themes_base / '*' / '*.yaml'),
        str(themes_base / '*' / '*.yml'),
    ]
    files: List[str] = []
    for p in patterns:
        files.extend(glob.glob(p))
    return sorted(set(files))


def read_template_file(template_filename: str) -> Optional[str]:
    template_path = Path('templates') / template_filename
    if not template_path.exists():
        record_error(f"Template {template_path} not found.")
        return None
    try:
        with open(template_path, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception as e:
        record_error(f"Error reading template {template_path}: {e}")
        return None


#
# New helper functions to reduce duplication and complexity in `main()`
#
def read_template_cached(template_filename: str) -> Optional[str]:
    if template_filename in _TEMPLATE_CACHE:
        return _TEMPLATE_CACHE[template_filename]
    content = read_template_file(template_filename)
    _TEMPLATE_CACHE[template_filename] = content
    return content


def ensure_dir(path: Path) -> bool:
    try:
        os.makedirs(path, exist_ok=True)
        return True
    except Exception as e:
        record_error(f"Error creating directory {path}: {e}")
        return False


def prepare_context_json(context: Dict[str, Any]) -> None:
    context_for_json = {k: v for k, v in context.items() if k not in ['theme-itermcolors-plist', 'theme-json', 'theme-notice-hash']}
    context['theme-json'] = json.dumps(context_for_json, sort_keys=True, ensure_ascii=False, indent=4)


def safe_write_rendered(out_dir: Path, out_name: str, rendered: str, log_label: Optional[str] = None) -> bool:
    out_path = out_dir / out_name
    if not ensure_dir(out_dir):
        return False
    try:
        with open(out_path, 'w', encoding='utf-8') as f:
            f.write(rendered)
        label = f" [{log_label}]" if log_label else ""
        print(f"Generated{label} -> {out_path}")
        return True
    except Exception as e:
        record_error(f"Error writing file {out_path}: {e}")
        return False


def render_single_context_to_template(context: Dict[str, Any], template_text: str, filename_tmpl: str,
                                      directory: str, template_key: Optional[str] = None) -> bool:
    prepare_context_json(context)
    out_dir = Path('build') / Path(directory)
    out_name = pystache.render(filename_tmpl, context)
    try:
        rendered = pystache.render(template_text, context)
    except Exception as e:
        record_error(f"Error rendering template for {context.get('theme-name')}: {e}")
        return False
    return safe_write_rendered(out_dir, out_name, rendered, log_label=template_key)


def render_contexts_to_template(contexts: List[Dict[str, Any]], template_text: str, filename_tmpl: str,
                                directory: str, template_key: Optional[str] = None) -> bool:
    ok = True
    for context in contexts:
        if not render_single_context_to_template(context, template_text, filename_tmpl, directory, template_key=template_key):
            ok = False
    return ok


def build_merged_context(base_name: str, base_modifier: str, base_slug: str, theme_data: dict,
                         source_name: str, light_ctx: Dict[str, Any], dark_ctx: Dict[str, Any],
                         combined_iterm_plist: Optional[str]) -> Dict[str, Any]:
    merged = dict(light_ctx)  # shallow copy of light for defaults
    merged['light'] = light_ctx
    merged['dark'] = dark_ctx

    parts = [base_name]
    if base_modifier:
        parts.append(base_modifier)
    merged['theme-name'] = ' '.join(parts).strip()
    merged['theme-slug'] = base_slug
    merged['theme-mode'] = 'both'
    merged['theme-modifier'] = base_modifier or ''
    merged['theme-source'] = theme_data.get('source') or source_name or ''
    merged['theme-license'] = str(theme_data.get('license') or '').strip()
    notice = light_ctx.get('theme-notice') or dark_ctx.get('theme-notice') or ''
    merged['theme-notice'] = notice
    merged['theme-notice-hash'] = notice_as_hash_comments(notice)
    context_for_json = {k: v for k, v in merged.items() if k not in ['theme-itermcolors-plist', 'theme-json', 'theme-notice-hash']}
    merged['theme-json'] = json.dumps(context_for_json, sort_keys=True, ensure_ascii=False, indent=4)
    merged['theme-itermcolors-plist'] = combined_iterm_plist or ''
    return merged


def render_merged_dual_template(merged: Dict[str, Any], dual_template_text: str, filename_tmpl: str,
                                directory: str, template_key: Optional[str] = None) -> bool:
    out_dir = Path('build') / Path(directory)
    out_name = pystache.render(filename_tmpl, merged)
    try:
        rendered = pystache.render(dual_template_text, merged)
    except Exception as e:
        record_error(f"Error rendering dual template for {merged.get('theme-name')}: {e}")
        return False
    success = safe_write_rendered(out_dir, out_name, rendered, log_label=f"dual:{template_key}")
    if success:
        print(f"Generated [dual:{template_key}] combined for {merged.get('theme-name')} -> {out_dir / out_name}")
    return success


def process_template_entry(template_key: str, template_conf: Dict[str, Any], contexts: List[Dict[str, Any]],
                           theme_data: dict, tf_path: Path, source_name: str, has_both_modes: bool,
                           dark_ctx: Optional[Dict[str, Any]], light_ctx: Optional[Dict[str, Any]],
                           combined_iterm_plist: Optional[str], base_name: str, base_modifier: str, base_slug: str,
                           is_combined: bool) -> None:
    if 'template' not in template_conf:
        return

    tpl_field = template_conf['template']
    dual_mode = bool(template_conf.get('dual_mode'))

    # For combined themes with both modes, skip non-dual templates to avoid per-mode outputs
    if has_both_modes and is_combined and not dual_mode:
        return

    if dual_mode:
        if not isinstance(tpl_field, (list, tuple)) or len(tpl_field) < 2:
            return
        single_template_name = str(tpl_field[0])
        dual_template_name = str(tpl_field[1])

        if has_both_modes:
            dual_template = read_template_cached(dual_template_name)
            if dual_template is None:
                return
            if dark_ctx is None or light_ctx is None:
                record_error(
                    f"Skipping dual-mode output for {template_key} in {tf_path}: missing dark or light context"
                )
                return
            merged = build_merged_context(base_name, base_modifier, base_slug, theme_data, source_name,
                                          light_ctx, dark_ctx, combined_iterm_plist)
            render_merged_dual_template(merged, dual_template, template_conf['filename'], template_conf['directory'], template_key=template_key)
        else:
            single_template = read_template_cached(single_template_name)
            if single_template is None:
                return
            render_contexts_to_template(contexts, single_template, template_conf['filename'], template_conf['directory'], template_key=template_key)
    else:
        if not isinstance(tpl_field, str):
            return
        # Skip per-mode rendering for combined dual themes (they only use dual-mode)
        if has_both_modes and is_combined:
            return
        template_name = str(tpl_field)
        template_text = read_template_cached(template_name)
        if template_text is None:
            return
        render_contexts_to_template(contexts, template_text, template_conf['filename'], template_conf['directory'], template_key=template_key)


def validate_config(config: Any) -> bool:
    if not isinstance(config, dict):
        record_error("templates/config.json must be a mapping of template entries.")
        return False
    ok = True
    for template_key, template_conf in config.items():
        if not isinstance(template_conf, dict):
            record_error(f"Config entry '{template_key}' must be an object.")
            ok = False
            continue
        if 'template' not in template_conf:
            record_error(f"Config entry '{template_key}' missing required 'template' field.")
            ok = False
            continue
        if 'filename' not in template_conf:
            record_error(f"Config entry '{template_key}' missing required 'filename' field.")
            ok = False
        if 'directory' not in template_conf:
            record_error(f"Config entry '{template_key}' missing required 'directory' field.")
            ok = False
        dual_mode = bool(template_conf.get('dual_mode'))
        tpl_field = template_conf['template']
        if dual_mode:
            if not isinstance(tpl_field, (list, tuple)) or len(tpl_field) < 2:
                record_error(
                    f"Config entry '{template_key}' is 'dual_mode': true but "
                    f"'template' is not an array of two filenames."
                )
                ok = False
        elif not isinstance(tpl_field, str):
            record_error(
                f"Config entry '{template_key}' expected 'template' to be a string "
                f"for non-dual templates."
            )
            ok = False
    return ok


#
# Refactored main that delegates work to helpers above
#
def main() -> int:
    _errors.clear()
    config_path = Path('templates') / 'config.json'
    try:
        config = load_config(config_path)
    except Exception as e:
        record_error(f"Error loading config {config_path}: {e}")
        return exit_status()

    if not validate_config(config):
        return exit_status()

    themes_base = Path('themes')
    if not themes_base.exists():
        record_error("No themes/ directory found.")
        return exit_status()

    theme_files = find_theme_files(themes_base)
    if not theme_files:
        record_error("No YAML theme files found in themes/ directory.")
        return exit_status()

    # Separate regular and combined themes to process combined last
    regular_themes: List[str] = []
    combined_themes: List[str] = []
    for tf in theme_files:
        tf_path = Path(tf)
        source_name = tf_path.parent.name if tf_path.parent != themes_base else tf_path.stem
        theme_data = load_yaml(tf_path)
        if theme_data is None:
            continue
        if isinstance(theme_data.get('dark'), str) or isinstance(theme_data.get('light'), str):
            combined_themes.append(tf)
        else:
            regular_themes.append(tf)

    # Collect contexts for the index page
    index_entries: List[Dict[str, Any]] = []

    for tf in regular_themes + combined_themes:
        tf_path = Path(tf)
        source_name = tf_path.parent.name if tf_path.parent != themes_base else tf_path.stem

        theme_data = load_yaml(tf_path)
        # Note: theme_data was checked None earlier, but if it changed, skip
        if theme_data is None:
            continue

        try:
            contexts, is_combined = build_contexts_from_yaml(theme_data, source_name, tf_path)
        except ValueError as e:
            record_error(str(e))
            continue
        except Exception as e:
            record_error(f"Schema validation error for {tf_path}: {e}")
            continue

        has_both_modes = 'dark' in theme_data and 'light' in theme_data
        dark_ctx: Optional[Dict[str, Any]] = None
        light_ctx: Optional[Dict[str, Any]] = None
        if has_both_modes:
            for c in contexts:
                if c.get('theme-mode') == 'dark':
                    dark_ctx = c
                elif c.get('theme-mode') == 'light':
                    light_ctx = c

        combined_iterm_plist = prepare_iterm_plists(contexts, dark_ctx, light_ctx)

        base_name = str(theme_data.get('name') or tf_path.stem)
        base_modifier = (theme_data.get('modifier') or '').strip()
        base_slug = slugify(base_name)
        if base_modifier:
            base_slug = '-'.join([base_slug, slugify(base_modifier)])

        # Process templates strictly according to new config schema
        for template_key, template_conf in config.items():
            process_template_entry(template_key, template_conf, contexts, theme_data, tf_path, source_name, has_both_modes, dark_ctx, light_ctx, combined_iterm_plist, base_name, base_modifier, base_slug, is_combined)

        # Prepare entries for the index:
        # Skip combined meta themes, show each mode as separate for others
        if not is_combined:
            for c in contexts:
                prepare_context_json(c)
                index_entries.append(c)

    # After processing all themes, render the aggregated index page
    index_template = read_template_cached('index.mustache')
    if index_template:
        # Prepare a wrapper context with a list of themes sorted by theme-name
        try:
            # sort entries by display name (theme-name)
            sorted_entries = sorted(index_entries, key=lambda x: (x.get('theme-name') or '').lower())
        except Exception:
            sorted_entries = index_entries

        # For safety, ensure each entry has theme-json
        for entry in sorted_entries:
            if 'theme-json' not in entry:
                prepare_context_json(entry)

        index_context = {'themes': sorted_entries}
        try:
            rendered_index = pystache.render(index_template, index_context)
            # write to build/index.html
            out_dir = Path('build')
            safe_write_rendered(out_dir, 'index.html', rendered_index, log_label='index')
        except Exception as e:
            record_error(f"Error rendering index.mustache: {e}")

    return exit_status()


if __name__ == "__main__":
    sys.exit(main())
