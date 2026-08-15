"""sRGB Color and Theme types for display-only preview."""

from __future__ import annotations

import dataclasses
import pathlib
import re


_HEX3 = re.compile(r"[0-9a-fA-F]{3}")
_HEX6 = re.compile(r"[0-9a-fA-F]{6}")


@dataclasses.dataclass(frozen=True)
class Color:
    """sRGB color as 8-bit components."""

    r: int
    g: int
    b: int

    @classmethod
    def from_hex(cls, value: str) -> Color:
        raw = value.strip()
        if not raw.startswith("#"):
            raise ValueError(f"invalid hex color {value!r}: must start with '#'")
        hex_part = raw[1:]
        if _HEX3.fullmatch(hex_part):
            hex_part = "".join(ch * 2 for ch in hex_part)
        elif not _HEX6.fullmatch(hex_part):
            raise ValueError(f"invalid hex color {value!r}: must be '#rgb' or '#rrggbb'")
        return cls(int(hex_part[0:2], 16), int(hex_part[2:4], 16), int(hex_part[4:6], 16))

    @property
    def hex(self) -> str:
        return f"{self.r:02x}{self.g:02x}{self.b:02x}"


@dataclasses.dataclass(frozen=True)
class Theme:
    source_path: pathlib.Path
    name: str
    colors: dict[str, Color]
    variant: str = ""
    author: str = ""
    base_name: str = ""
    modifier: str = ""

    @property
    def identity(self) -> str:
        return f"{self.name}\0{self.variant}"
