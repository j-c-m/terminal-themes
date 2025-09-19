# Dual-Mode Behavior

Dual-mode handling is designed for themes that define both `dark` and `light` modes, allowing efficient rendering into a single output file where possible. This ensures combined themes are processed as a unified entity, especially when templates support both variants.

## Key Concepts

Dual-mode affects how templates are rendered based on:
- The theme's available modes (`dark`, `light`, or both).
- The `dual_mode` flag in `templates/config.json` for each entry.

## Behavior Rules

- **For dual-mode config entries** (`"dual_mode": true`):
  - **Both modes present**: Renders only the dual template once. Uses a merged context with `theme-mode` set to `"both"`. The merged context exposes `light` and `dark` subcontexts for template access.
  - **One mode present**: Falls back to rendering the single template once per available mode (standard behavior for single-mode themes).

- **For non-dual config entries** (no `dual_mode` or `false`):
  - Always renders per mode: Single template per context, even for themes with both modes.

- **Combined themes**: If a theme uses external file references for modes (marked as "combined"), non-dual entries skip per-mode rendering to prevent duplicate outputs for dual-mode themes.

## Merged Context Details

When generating a merged context for dual-mode:
- Base is the `light` context (for defaults).
- Added fields: `theme-mode: "both"`, `light` (full light context), `dark` (full dark context).
- Slug and name are adjusted to reflect both modes (e.g., no "Light" suffix if include_mode was true).

## Processing Flow

1. **Regular themes**: Processed first, building contexts normally.
2. **Combined themes**: Processed last, to allow external loading.
3. **Index inclusion**: For dual-mode themes, the merged context is added to the index list. For single-mode, each per-mode context is added.

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

Note: Errors (e.g., missing dark/light contexts) are logged, and rendering is skipped for that entry.
