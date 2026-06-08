#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path

from ufoLib2 import Font


ROOT_DIR = Path(__file__).resolve().parent.parent
SOURCE_DIR = ROOT_DIR / "sources" / "kappa-mono" / "ufo"
FAMILY_NAME = "Kappa Mono"
TRIMMED_FAMILY = FAMILY_NAME.replace(" ", "")
MANUFACTURER = "KM-X Group"
VENDOR_ID = "KMXG"
TRADEMARK = "Kappa Mono is a trademark of KM-X Group."
COPYRIGHT = "Copyright 2023 Commit Mono authors (https://github.com/eigilnikolajsen/commit-mono)"
LICENSE = "This Font Software is licensed under the SIL Open Font License, Version 1.1. This license is available with a FAQ at: https://scripts.sil.org/OFL"
LICENSE_URL = "https://scripts.sil.org/OFL"
UPSTREAM_DESCRIPTION = "Commit Mono is an anonymous and neutral programming typeface focused on creating a better reading experience."
KEEP_LIB_KEYS = {"public.glyphOrder"}


def style_from_filename(path: Path) -> str:
    stem = path.stem
    if stem.endswith("-BoldItalic"):
        return "Bold Italic"
    if stem.endswith("-Bold"):
        return "Bold"
    if stem.endswith("-Italic"):
        return "Italic"
    return "Regular"


def postscript_name(style: str) -> str:
    return f"{TRIMMED_FAMILY}-{style.replace(' ', '')}"


def style_map_name(style: str) -> str:
    mapping = {
        "Regular": "regular",
        "Italic": "italic",
        "Bold": "bold",
        "Bold Italic": "bold italic",
    }
    return mapping[style]


def normalize_ufo(path: Path) -> None:
    style = style_from_filename(path)
    font = Font.open(path)
    info = font.info

    info.familyName = FAMILY_NAME
    info.styleName = style
    info.styleMapFamilyName = FAMILY_NAME
    info.styleMapStyleName = style_map_name(style)
    info.openTypeNamePreferredFamilyName = FAMILY_NAME
    info.openTypeNamePreferredSubfamilyName = style
    info.postscriptFontName = postscript_name(style)
    info.openTypeNameManufacturer = MANUFACTURER
    info.openTypeNameManufacturerURL = ""
    info.openTypeNameDesigner = MANUFACTURER
    info.openTypeNameDesignerURL = ""
    info.openTypeOS2VendorID = VENDOR_ID
    info.openTypeHeadCreated = None
    info.postscriptIsFixedPitch = True
    info.copyright = COPYRIGHT
    info.openTypeNameLicense = LICENSE
    info.openTypeNameLicenseURL = LICENSE_URL
    info.openTypeNameDescription = UPSTREAM_DESCRIPTION
    info.trademark = TRADEMARK

    for key in list(font.lib.keys()):
        if key not in KEEP_LIB_KEYS:
            del font.lib[key]

    font.save(overwrite=True)


def main() -> None:
    for path in sorted(SOURCE_DIR.glob("*.ufo")):
        normalize_ufo(path)


if __name__ == "__main__":
    main()
