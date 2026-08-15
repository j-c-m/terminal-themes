"""Load themes from generated JSON under build/json/."""

from __future__ import annotations

import json
import pathlib
from typing import Iterable

from preview_theme.model import Color, Theme

REPO_PATH = pathlib.Path(__file__).resolve().parent.parent.parent
JSON_PATH = REPO_PATH / "build" / "json"

COLOR_NAMES = ("black", "red", "green", "yellow", "blue", "magenta", "cyan", "white")

_FALLBACKS = {
    "Cursor Color": "Foreground Color",
    "Cursor Text Color": "Background Color",
    "Selection Color": "Foreground Color",
    "Selected Text Color": "Background Color",
    "Bold Color": "Foreground Color",
}

_OPTIONAL = {
    "Cursor Color": "cursor",
    "Cursor Text Color": "cursor-text",
    "Selection Color": "selection-background",
    "Selected Text Color": "selection-foreground",
}

_MISSING_JSON = (
    f"No generated themes in {JSON_PATH}/. Run ./do-build-themes.sh first."
)


def _read_json(path: pathlib.Path) -> dict:
    try:
        with path.open("r", encoding="utf-8") as handle:
            data = json.load(handle)
    except OSError as exc:
        raise ValueError(f"{path}: failed to read JSON: {exc}") from exc
    except json.JSONDecodeError as exc:
        raise ValueError(f"{path}: invalid JSON: {exc}") from exc
    if not isinstance(data, dict):
        raise ValueError(f"{path}: theme top-level must be a mapping")
    return data


def _hex_color(entry: object, *, label: str) -> Color:
    if isinstance(entry, dict):
        value = entry.get("hex")
    else:
        value = entry
    if not isinstance(value, str):
        raise ValueError(f"{label}: expected hex string, got {value!r}")
    try:
        return Color.from_hex(value)
    except ValueError as exc:
        raise ValueError(f"{label}: {exc}") from exc


def _strip_word(text: str, word: str) -> str:
    if not word:
        return text
    parts = text.split()
    try:
        idx = parts.index(word)
    except ValueError:
        return text
    return " ".join(parts[:idx] + parts[idx + 1 :]).strip()


def _family_slug(slug: str, mode: str) -> str:
    parts = slug.split("-")
    if mode not in parts:
        return slug
    idx = len(parts) - 1 - parts[::-1].index(mode)
    return "-".join(parts[:idx] + parts[idx + 1 :])


def _colors_from_json(data: dict, path: pathlib.Path) -> dict[str, Color]:
    missing: list[str] = []
    for primary in ("foreground", "background"):
        if primary not in data:
            missing.append(primary)
    normal = data.get("normal")
    bright = data.get("bright")
    if not isinstance(normal, dict):
        missing.append("normal")
        normal = {}
    else:
        for name in COLOR_NAMES:
            if name not in normal:
                missing.append(f"normal.{name}")
    if not isinstance(bright, dict):
        missing.append("bright")
        bright = {}
    else:
        for name in COLOR_NAMES:
            if name not in bright:
                missing.append(f"bright.{name}")
    if missing:
        raise ValueError(f"{path}: missing required fields: {', '.join(missing)}")

    label = str(path)
    out: dict[str, Color] = {
        "Foreground Color": _hex_color(data["foreground"], label=f"{label} foreground"),
        "Background Color": _hex_color(data["background"], label=f"{label} background"),
    }
    for index, name in enumerate(COLOR_NAMES):
        out[f"Ansi {index} Color"] = _hex_color(
            normal[name], label=f"{label} normal.{name}"
        )
        out[f"Ansi {index + 8} Color"] = _hex_color(
            bright[name], label=f"{label} bright.{name}"
        )

    for dest, key in _OPTIONAL.items():
        if key in data and data[key] is not None:
            out[dest] = _hex_color(data[key], label=f"{label} {key}")

    for dest, src in _FALLBACKS.items():
        if dest not in out:
            out[dest] = out[src]
    return out


def _theme_from_json(data: dict, path: pathlib.Path) -> Theme:
    mode = str(data.get("theme-mode") or "").strip()
    if mode not in {"dark", "light"}:
        raise ValueError(f"{path}: theme-mode must be 'dark' or 'light', got {mode!r}")
    theme_name = str(data.get("theme-name") or path.stem)
    modifier = str(data.get("theme-modifier") or "").strip()
    display = _strip_word(theme_name, mode.capitalize()) or theme_name
    base_name = _strip_word(display, modifier) if modifier else display
    return Theme(
        source_path=path,
        name=display,
        colors=_colors_from_json(data, path),
        variant=mode,
        base_name=base_name,
        modifier=modifier,
    )


def load_theme_file(path: pathlib.Path) -> list[Theme]:
    return [_theme_from_json(_read_json(path), path)]


def theme_files() -> list[pathlib.Path]:
    if not JSON_PATH.is_dir():
        return []
    return sorted(JSON_PATH.glob("*.json"))


def load_all_themes() -> list[Theme]:
    paths = theme_files()
    if not paths:
        raise FileNotFoundError(_MISSING_JSON)
    themes: list[Theme] = []
    for path in paths:
        themes.extend(load_theme_file(path))
    return themes


def load_theme_path(path: pathlib.Path) -> list[Theme]:
    resolved = path.expanduser().resolve()
    if resolved.is_dir():
        themes: list[Theme] = []
        for json_path in sorted(resolved.glob("*.json")):
            themes.extend(load_theme_file(json_path))
        if not themes:
            raise ValueError(
                f"No generated theme JSON files in {resolved}. "
                f"Preview reads build/json/. Run ./do-build-themes.sh first."
            )
        return themes
    if not resolved.is_file():
        raise FileNotFoundError(f"Theme file not found: {path}")
    suffix = resolved.suffix.lower()
    if suffix == ".json":
        return load_theme_file(resolved)
    if suffix in {".yaml", ".yml"}:
        return lookup_catalog(resolved.stem)
    raise ValueError(f"Unsupported theme file type: {path}")


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


def lookup_catalog(name: str) -> list[Theme]:
    key = name.strip()
    if not key:
        raise FileNotFoundError(f'Theme "{name}" not found in {JSON_PATH}/.')

    catalog = load_all_themes()
    lowered = key.lower()

    slug_hits = [
        theme for theme in catalog if theme.source_path.stem.lower() == lowered
    ]
    if slug_hits:
        return slug_hits

    name_hits = [
        theme
        for theme in catalog
        if theme.name.lower() == lowered or theme.base_name.lower() == lowered
    ]
    if name_hits:
        return name_hits

    family_hits = [
        theme
        for theme in catalog
        if _family_slug(theme.source_path.stem, theme.variant).lower() == lowered
    ]
    if family_hits:
        return family_hits

    composed_hits = [
        theme
        for theme in catalog
        if any(candidate.lower() == lowered for candidate in _composed_names(theme))
    ]
    if composed_hits:
        return composed_hits

    raise FileNotFoundError(f'Theme "{name}" not found in {JSON_PATH}/.')


def resolve_theme_name(name: str) -> list[Theme]:
    key = name.strip()
    if not key:
        raise FileNotFoundError(f'Theme "{name}" not found in {JSON_PATH}/.')

    as_path = pathlib.Path(key).expanduser()
    if as_path.exists():
        return load_theme_path(as_path)

    return lookup_catalog(key)


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
