#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path

from fontTools.designspaceLib import DesignSpaceDocument
from ufoLib2 import Font


ROOT_DIR = Path(__file__).resolve().parent.parent
FAMILY_NAME = "Kappa Mark"
TRIMMED_FAMILY = FAMILY_NAME.replace(" ", "")
TRADEMARK = "Kappa Mark is a trademark of KM-X Group."
MANUFACTURER = "KM-X Group"
VENDOR_ID = "KMXG"
SOURCE_BASE = ROOT_DIR / "sources" / "kappa-mark"
KEEP_LIB_KEYS = {
    "com.github.googlei18n.ufo2ft.featureWriters",
    "com.github.googlei18n.ufo2ft.filters",
    "designspace.location",
    "public.glyphOrder",
    "public.openTypeCategories",
    "public.postscriptNames",
    "public.skipExportGlyphs",
}


def ps_name(style: str) -> str:
    return f"{TRIMMED_FAMILY}-{style.replace(' ', '')}"


def ufo_style_name(path: Path) -> str:
    name = path.stem
    if name.endswith("-Italic"):
        return "Italic"
    return "Regular"


def rename_ufo(path: Path) -> Path:
    style = ufo_style_name(path)
    new_path = path.with_name(f"{TRIMMED_FAMILY}-{style}.ufo")
    if path != new_path:
        path.rename(new_path)
    return new_path


def normalize_ufo(path: Path) -> None:
    style = ufo_style_name(path)
    font = Font.open(path)
    info = font.info

    info.familyName = FAMILY_NAME
    info.styleName = style
    info.styleMapFamilyName = FAMILY_NAME
    info.styleMapStyleName = "italic" if style == "Italic" else "regular"
    info.openTypeNamePreferredFamilyName = FAMILY_NAME
    info.openTypeNamePreferredSubfamilyName = style
    info.openTypeNameManufacturer = MANUFACTURER
    info.openTypeNameManufacturerURL = ""
    info.openTypeNameDesigner = MANUFACTURER
    info.openTypeNameDesignerURL = ""
    info.openTypeOS2VendorID = VENDOR_ID
    info.openTypeHeadCreated = None
    info.postscriptFontName = ps_name(style)
    info.trademark = TRADEMARK
    info.guidelines = []

    for key in list(font.lib.keys()):
        if key not in KEEP_LIB_KEYS:
            del font.lib[key]

    font.save(overwrite=True)


def normalize_designspace(path: Path) -> Path:
    doc = DesignSpaceDocument.fromfile(path)

    for source in doc.sources:
        source.name = source.name.replace("ABeeZee", TRIMMED_FAMILY)
        source.familyName = FAMILY_NAME
        source.styleName = "Italic" if "Italic" in source.name else "Regular"
        if source.filename is not None:
            source.filename = str(source.filename).replace("ABeeZee", TRIMMED_FAMILY)
        source.path = None

    for instance in doc.instances:
        style = "Italic" if "Italic" in (instance.name or "") else "Regular"
        instance.name = f"{TRIMMED_FAMILY} {style}"
        instance.familyName = FAMILY_NAME
        instance.styleName = style
        instance.styleMapFamilyName = FAMILY_NAME
        instance.styleMapStyleName = "italic" if style == "Italic" else "regular"
        if instance.filename:
            instance.filename = str(instance.filename).replace("ABeeZee", TRIMMED_FAMILY)
        instance.path = None

    new_path = path.with_name(path.name.replace("ABeeZee", TRIMMED_FAMILY))
    if new_path != path and new_path.exists():
        new_path.unlink()
    doc.write(new_path)
    if new_path != path:
        path.unlink()
    return new_path


def main() -> None:
    ufo_roots = [
        SOURCE_BASE / "ufo" / "masters" / "regular",
        SOURCE_BASE / "ufo" / "masters" / "italic",
        SOURCE_BASE / "ufo" / "instances",
    ]

    for root in ufo_roots:
        if not root.exists():
            continue
        for path in sorted(root.glob("*.ufo")):
            renamed = rename_ufo(path)
            normalize_ufo(renamed)

    designspace_dir = SOURCE_BASE / "designspace"
    for path in sorted(designspace_dir.glob("*.designspace")):
        normalize_designspace(path)


if __name__ == "__main__":
    main()
