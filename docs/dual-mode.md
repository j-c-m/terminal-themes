# Dual-Mode Behavior

Dual-mode templates can write one file for a theme that has both `dark` and `light`. Combined (pointer) theme files exist to feed those templates. The HTML index is separate: it never uses a merged context.

## Key Concepts

Rendering depends on:
- Whether the theme YAML defines `dark`, `light`, or both.
- Whether the config entry sets `"dual_mode": true`.
- Whether the theme is **combined**: `dark` and/or `light` is a filename string that loads another YAML file.

A `-meta` suffix on a combined file is only used when the family name already exists as a standalone theme (`rose-pine.yaml` vs `rose-pine-meta.yaml`). `catppuccin.yaml` needs no suffix.

## Behavior Rules

- **For dual-mode config entries** (`"dual_mode": true`):
  - **Both modes present**: Renders only the dual template once. Uses a merged context with `theme-mode` set to `"both"`. The merged context exposes `light` and `dark` subcontexts for template access.
  - **One mode present**: Falls back to rendering the single template once per available mode.

- **For non-dual config entries** (no `dual_mode` or `false`):
  - Regular themes: one file per mode, even when both modes are in the same YAML.
  - Combined themes: skip non-dual entries so mocha/latte (and similar) are not emitted again from the pointer file.

## Merged Context Details

When generating a merged context for dual-mode templates:
- Base is the `light` context (for defaults).
- Added fields: `theme-mode: "both"`, `light` (full light context), `dark` (full dark context).
- Slug and name omit the per-mode suffix (e.g. `catppuccin`, not `catppuccin-dark`).

This merged context is for dual templates only (iTerm, debug). It is not added to the index.

## Index

`build/index.html` is one card per mode from **non-combined** theme files, sorted by `theme-name`.

- Inline dual YAML (`solarized.yaml`) produces two cards (Solarized Dark, Solarized Light).
- Combined / `-meta` files produce no cards. Their members still appear from their own YAML (`catppuccin-mocha.yaml`, `rose-pine.yaml`, `rose-pine-dawn.yaml`).
- There is no card with `theme-mode == "both"`. `index.mustache` is a single-pane preview.

## Processing Flow

1. **Regular themes**: Processed first, building contexts normally.
2. **Combined themes**: Processed last, so referenced mode files are already loaded.
3. **Index**: Each per-mode context from non-combined files is appended. Combined files are skipped.

## Examples

### Scenario 1: Theme with Both Modes, Dual-Mode Config
- **Input**: YAML with `dark` and `light` objects, config has `dual_mode: true`.
- **Output**: One file rendered from the dual template, with merged context allowing `{{light.foreground.hex}}` and `{{dark.background.hex}}`.

### Scenario 2: Theme with One Mode, Dual-Mode Config
- **Input**: YAML with only `dark`.
- **Output**: One file per mode using the single template.

### Scenario 3: Theme with Both Modes, Non-Dual Config
- **Input**: Same as Scenario 1, but `dual_mode: false`.
- **Output**: Two separate files (one for dark, one for light) using the single template.

### Scenario 4: Combined / `-meta` file
- **Input**: `dark` / `light` are filenames; config has both dual and non-dual entries.
- **Output**: Dual templates only (one merged iTerm/debug file). No per-mode Alacritty/Ghostty/JSON from this file. No index card from this file.

Note: Errors (e.g., missing dark/light contexts) are logged, and rendering is skipped for that entry.
