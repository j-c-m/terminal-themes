"""Load themes from this repo's YAML files under themes/."""

from __future__ import annotations

import pathlib
from typing import Iterable

import yaml

from preview_theme.model import Color, Theme

REPO_PATH = pathlib.Path(__file__).resolve().parent.parent.parent
THEMES_PATH = REPO_PATH / "themes"

COLOR_NAMES = ("black", "red", "green", "yellow", "blue", "magenta", "cyan", "white")

_FALLBACKS = {
    "Cursor Color": "Foreground Color",
    "Cursor Text Color": "Background Color",
    "Selection Color": "Foreground Color",
    "Selected Text Color": "Background Color",
    "Bold Color": "Foreground Color",
}


def _read_yaml(path: pathlib.Path) -> dict:
    try:
        with path.open("r", encoding="utf-8") as handle:
            data = yaml.safe_load(handle)
    except OSError as exc:
        raise ValueError(f"{path}: failed to read YAML: {exc}") from exc
    except yaml.YAMLError as exc:
        raise ValueError(f"{path}: invalid YAML: {exc}") from exc
    if not isinstance(data, dict):
        raise ValueError(f"{path}: theme top-level must be a mapping")
    return data


def _hex_color(value: object, *, label: str) -> Color:
    if not isinstance(value, str):
        raise ValueError(f"{label}: expected hex string, got {value!r}")
    try:
        return Color.from_hex(value)
    except ValueError as exc:
        raise ValueError(f"{label}: {exc}") from exc


def _resolve_mode_map(theme_data: dict, theme_path: pathlib.Path, mode: str) -> dict:
    raw = theme_data[mode]
    if isinstance(raw, str):
        ref_path = theme_path.parent / raw
        if not ref_path.is_file():
            raise ValueError(
                f"{theme_path}: referenced file {raw!r} for {mode!r} does not exist"
            )
        ref_data = _read_yaml(ref_path)
        if mode not in ref_data:
            raise ValueError(
                f"{theme_path}: referenced file {raw!r} for {mode!r} "
                f"does not contain a {mode!r} mode"
            )
        raw = ref_data[mode]
    if not isinstance(raw, dict):
        raise ValueError(f"{theme_path}: mode {mode!r} must be a mapping")
    return raw


def _colors_from_mode(mode_map: dict, theme_path: pathlib.Path, mode: str) -> dict[str, Color]:
    missing: list[str] = []
    for primary in ("foreground", "background"):
        if primary not in mode_map:
            missing.append(primary)
    colors = mode_map.get("colors")
    if not isinstance(colors, dict):
        missing.append("colors")
        colors = {}
    normal = colors.get("normal")
    bright = colors.get("bright")
    if not isinstance(normal, dict):
        missing.append("colors.normal")
        normal = {}
    else:
        for name in COLOR_NAMES:
            if name not in normal:
                missing.append(f"colors.normal.{name}")
    if not isinstance(bright, dict):
        missing.append("colors.bright")
        bright = {}
    else:
        for name in COLOR_NAMES:
            if name not in bright:
                missing.append(f"colors.bright.{name}")
    if missing:
        raise ValueError(
            f"{theme_path} [{mode}]: missing required fields: {', '.join(missing)}"
        )

    label = f"{theme_path} [{mode}]"
    out: dict[str, Color] = {
        "Foreground Color": _hex_color(mode_map["foreground"], label=f"{label} foreground"),
        "Background Color": _hex_color(mode_map["background"], label=f"{label} background"),
    }
    for index, name in enumerate(COLOR_NAMES):
        out[f"Ansi {index} Color"] = _hex_color(
            normal[name], label=f"{label} colors.normal.{name}"
        )
        out[f"Ansi {index + 8} Color"] = _hex_color(
            bright[name], label=f"{label} colors.bright.{name}"
        )

    optional = {
        "Cursor Color": "cursor",
        "Cursor Text Color": "cursor-text",
        "Selection Color": "selection-background",
        "Selected Text Color": "selection-foreground",
    }
    for dest, key in optional.items():
        if key in mode_map and mode_map[key] is not None:
            out[dest] = _hex_color(mode_map[key], label=f"{label} {key}")

    for dest, src in _FALLBACKS.items():
        if dest not in out:
            out[dest] = out[src]
    return out


def _display_name(base_name: str, modifier: str) -> str:
    if modifier:
        return f"{base_name} {modifier}"
    return base_name


def _theme_from_mode(
    theme_data: dict,
    theme_path: pathlib.Path,
    mode: str,
) -> Theme:
    base_name = str(theme_data.get("name") or theme_path.stem)
    modifier = str(theme_data.get("modifier") or "").strip()
    return Theme(
        source_path=theme_path,
        name=_display_name(base_name, modifier),
        colors=_colors_from_mode(_resolve_mode_map(theme_data, theme_path, mode), theme_path, mode),
        variant=mode,
        base_name=base_name,
        modifier=modifier,
    )


def load_theme_file(path: pathlib.Path) -> list[Theme]:
    data = _read_yaml(path)
    modes = [mode for mode in ("dark", "light") if mode in data]
    if not modes:
        raise ValueError(f"{path}: no modes found (expected 'dark' and/or 'light')")
    return [_theme_from_mode(data, path, mode) for mode in modes]


def load_theme_path(path: pathlib.Path) -> list[Theme]:
    resolved = path.expanduser().resolve()
    if resolved.is_dir():
        themes: list[Theme] = []
        for yaml_path in sorted(resolved.glob("*.yaml")):
            themes.extend(load_theme_file(yaml_path))
        if not themes:
            raise ValueError(f"No theme YAML files in {resolved}")
        return themes
    if not resolved.is_file():
        raise FileNotFoundError(f"Theme file not found: {path}")
    suffix = resolved.suffix.lower()
    if suffix not in {".yaml", ".yml"}:
        raise ValueError(f"Unsupported theme file type: {path}")
    return load_theme_file(resolved)


def theme_files() -> list[pathlib.Path]:
    return sorted(THEMES_PATH.glob("*.yaml"))


def load_all_themes() -> list[Theme]:
    themes: list[Theme] = []
    for path in theme_files():
        themes.extend(load_theme_file(path))
    return themes


def _composed_names(theme: Theme) -> Iterable[str]:
    yield theme.name
    yield theme.base_name
    yield f"{theme.name} {theme.variant}"
    yield f"{theme.base_name} {theme.variant}"
    if theme.variant:
        yield f"{theme.base_name} {theme.variant.capitalize()}"
        if theme.modifier:
            yield f"{theme.base_name} {theme.variant.capitalize()} {theme.modifier}"
            yield f"{theme.name} {theme.variant.capitalize()}"


def resolve_theme_name(name: str) -> list[Theme]:
    key = name.strip()
    if not key:
        raise FileNotFoundError(f'Theme "{name}" not found in {THEMES_PATH}/.')

    as_path = pathlib.Path(key).expanduser()
    if as_path.exists():
        return load_theme_path(as_path)

    catalog = load_all_themes()
    lowered = key.lower()

    stem_hits = [theme for theme in catalog if theme.source_path.stem.lower() == lowered]
    if stem_hits:
        return stem_hits

    name_hits = [
        theme
        for theme in catalog
        if theme.name.lower() == lowered or theme.base_name.lower() == lowered
    ]
    if name_hits:
        return name_hits

    composed_hits = [
        theme
        for theme in catalog
        if any(candidate.lower() == lowered for candidate in _composed_names(theme))
    ]
    if composed_hits:
        return composed_hits

    raise FileNotFoundError(f'Theme "{name}" not found in {THEMES_PATH}/.')


def _dedupe(themes: list[Theme]) -> list[Theme]:
    seen: set[str] = set()
    out: list[Theme] = []
    for theme in themes:
        if theme.identity not in seen:
            out.append(theme)
            seen.add(theme.identity)
    return out


def resolve_themes(
    scheme_names: list[str] | None,
    paths: list[pathlib.Path],
) -> list[Theme]:
    themes: list[Theme] = []

    for path in paths:
        themes.extend(load_theme_path(path))

    if scheme_names:
        for name in scheme_names:
            themes.extend(resolve_theme_name(name))

    if not themes and not scheme_names and not paths:
        themes = load_all_themes()

    themes = _dedupe(themes)
    if not themes:
        raise ValueError("No themes to preview.")
    return themes
