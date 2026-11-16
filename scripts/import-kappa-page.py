#!/usr/bin/env python3
"""Import pinned CMU Sans Serif reference OTFs as KM-named UFO build inputs."""

from __future__ import annotations

import argparse
import importlib.util
import re
from pathlib import Path

from fontTools.ttLib import TTFont
from ufoLib2 import Font

ROOT = Path(__file__).resolve().parent.parent
BASE = ROOT / "sources/kappa-page"
IMPORTER = Path(__file__).with_name("import-binary-ufo.py")
STYLES = {
    "Regular": ("cmunss", 400, "regular"),
    "Italic": ("cmunsi", 400, "italic"),
    "Bold": ("cmunsx", 700, "bold"),
    "BoldItalic": ("cmunso", 700, "bold italic"),
}


def fix_aalt_syntax(features: str) -> str:
    """fontFeatures' binary unparser places forbidden script/language in aalt."""

    def rewrite(match: re.Match[str]) -> str:
        return re.sub(
            r"^[ \t]*(?:script|language) [^;\n]+;[ \t]*\n",
            "",
            match.group(),
            flags=re.MULTILINE,
        )

    return re.sub(r"feature aalt \{.*?\} aalt;", rewrite, features, flags=re.DOTALL)


def import_style(style: str, stem: str, weight: int, map_style: str) -> None:
    reference = BASE / "upstream-import" / f"{stem}.otf"
    sfd = reference.with_suffix(".sfd")
    if not reference.is_file() or not sfd.is_file():
        raise FileNotFoundError(f"Missing original SFD/OTF pair: {sfd}, {reference}")
    destination = BASE / "ufo" / f"KappaPage-{style}.ufo"
    spec = importlib.util.spec_from_file_location("kappa_binary_import", IMPORTER)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Cannot load {IMPORTER}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    module.import_binary_ufo(reference, destination)

    font = Font.open(destination)
    original = TTFont(reference)
    if font.features.text.startswith("# feature extraction failed:"):
        raise ValueError(f"OpenType feature extraction failed: {reference}")
    font.features.text = fix_aalt_syntax(font.features.text)
    info = font.info
    name = original["name"]
    info.familyName = "Kappa Page"
    info.styleName = "Bold Italic" if style == "BoldItalic" else style
    info.styleMapFamilyName = "Kappa Page"
    info.styleMapStyleName = map_style
    info.openTypeNamePreferredFamilyName = "Kappa Page"
    info.openTypeNamePreferredSubfamilyName = info.styleName
    info.postscriptFontName = f"KappaPage-{style}"
    info.openTypeOS2WeightClass = weight
    info.openTypeOS2VendorID = "KMXG"
    info.openTypeNameManufacturer = "KM-X Group"
    info.openTypeNameDesigner = "Donald E. Knuth; Computer Modern Unicode contributors"
    info.openTypeHeadCreated = None
    # Keep the upstream copyright block in the font metadata as well as OFL.txt.
    ofl = (ROOT / "licenses/kappa-page/OFL.txt").read_text(encoding="utf-8")
    info.copyright = ofl.split("This Font Software is licensed", 1)[0].strip()
    info.openTypeNameLicense = name.getDebugName(13)
    info.openTypeNameLicenseURL = name.getDebugName(14)
    font.save(overwrite=True)
    original.close()
    print(f"Imported {reference.relative_to(ROOT)} -> {destination.relative_to(ROOT)}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--force", action="store_true", help="replace existing Kappa Page UFOs")
    args = parser.parse_args()
    for style, (stem, weight, map_style) in STYLES.items():
        destination = BASE / "ufo" / f"KappaPage-{style}.ufo"
        required = ("metainfo.plist", "fontinfo.plist", "features.fea", "glyphs/contents.plist")
        if (
            destination.is_dir()
            and all((destination / name).is_file() for name in required)
            and not args.force
        ):
            print(f"Keeping existing {destination.relative_to(ROOT)}")
            continue
        import_style(style, stem, weight, map_style)


if __name__ == "__main__":
    main()
