#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
from pathlib import Path

from fontTools.ttLib import TTFont
from fontTools.ttLib.tables._n_a_m_e import NameRecord


NAME_IDS = {
    "family": 1,
    "subfamily": 2,
    "unique_id": 3,
    "full_name": 4,
    "version": 5,
    "postscript": 6,
    "trademark": 7,
    "manufacturer": 8,
    "designer": 9,
    "description": 10,
    "vendor_url": 11,
    "designer_url": 12,
    "license": 13,
    "license_url": 14,
    "typographic_family": 16,
    "typographic_subfamily": 17,
    "compatible_full": 18,
    "sample_text": 19,
    "wws_family": 21,
    "wws_subfamily": 22,
    "variations_postscript_prefix": 25,
}


def sanitize_postscript_name(value: str) -> str:
    value = re.sub(r"[^A-Za-z0-9-]", "", value.replace(" ", ""))
    return value[:63]


def set_name(name_table, name_id: int, value: str) -> None:
    if not value:
        return

    existing: list[NameRecord] = [record for record in name_table.names if record.nameID == name_id]
    if existing:
        for record in existing:
            record.string = value.encode("utf-16-be") if record.isUnicode() else value.encode("latin-1", errors="ignore")
    else:
        name_table.setName(value, name_id, 3, 1, 0x409)
        name_table.setName(value, name_id, 1, 0, 0)


def main() -> None:
    parser = argparse.ArgumentParser(description="Rename font metadata safely for derivative builds.")
    parser.add_argument("--input", required=True, help="Input font path")
    parser.add_argument("--output", required=True, help="Output font path")
    parser.add_argument("--family", required=True, help="Preferred family name")
    parser.add_argument("--style", required=True, help="Preferred style/subfamily name")
    parser.add_argument("--version-prefix", default="Version", help="Version string prefix")
    parser.add_argument("--manufacturer", default="KM-X Group")
    parser.add_argument("--vendor-url", default="https://github.com/km-x-group/kappa-type")
    parser.add_argument("--designer", default="")
    parser.add_argument("--designer-url", default="")
    parser.add_argument("--license-url", default="https://openfontlicense.org")
    parser.add_argument("--postscript-name", default="")
    parser.add_argument("--typographic-family", default="")
    parser.add_argument("--typographic-style", default="")
    args = parser.parse_args()

    input_path = Path(args.input)
    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    font = TTFont(str(input_path))
    name_table = font["name"]

    version = name_table.getDebugName(NAME_IDS["version"]) or f"{args.version_prefix} 0.001"
    family = args.family
    style = args.style
    full_name = f"{family} {style}".strip()
    compatible_full = full_name
    unique_id = f"{family}; {style}; {version}"
    typographic_family = args.typographic_family or family
    typographic_style = args.typographic_style or style
    postscript_name = args.postscript_name or sanitize_postscript_name(f"{family}-{style}")
    variations_prefix = sanitize_postscript_name(family)

    set_name(name_table, NAME_IDS["family"], family)
    set_name(name_table, NAME_IDS["subfamily"], style)
    set_name(name_table, NAME_IDS["unique_id"], unique_id)
    set_name(name_table, NAME_IDS["full_name"], full_name)
    set_name(name_table, NAME_IDS["postscript"], postscript_name)
    set_name(name_table, NAME_IDS["typographic_family"], typographic_family)
    set_name(name_table, NAME_IDS["typographic_subfamily"], typographic_style)
    set_name(name_table, NAME_IDS["compatible_full"], compatible_full)
    set_name(name_table, NAME_IDS["wws_family"], family)
    set_name(name_table, NAME_IDS["wws_subfamily"], style)
    set_name(name_table, NAME_IDS["variations_postscript_prefix"], variations_prefix)

    if args.manufacturer:
        set_name(name_table, NAME_IDS["manufacturer"], args.manufacturer)
    if args.vendor_url:
        set_name(name_table, NAME_IDS["vendor_url"], args.vendor_url)
    if args.designer:
        set_name(name_table, NAME_IDS["designer"], args.designer)
    if args.designer_url:
        set_name(name_table, NAME_IDS["designer_url"], args.designer_url)
    if args.license_url:
        set_name(name_table, NAME_IDS["license_url"], args.license_url)

    if "CFF " in font:
        cff = font["CFF "].cff.topDictIndex[0]
        cff.FamilyName = family
        cff.FullName = full_name
        cff.FontName = postscript_name
        if hasattr(cff, "Weight"):
            cff.Weight = style
    if "CFF2" in font:
        top_dict = font["CFF2"].cff.topDictIndex[0]
        top_dict.FontName = postscript_name

    font.save(str(output_path))


if __name__ == "__main__":
    main()
