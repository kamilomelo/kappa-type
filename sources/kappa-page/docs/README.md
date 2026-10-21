# Kappa Page source layers

- `upstream-import/`: unchanged CMU Sans Serif 0.7.0 SFD editable sources and
  matching OTF reference fonts.
- `ufo/`: KM-named, binary-informed build inputs produced by
  `scripts/import-kappa-page.py`. Do not treat these as a lossless SFD conversion.

Run `./scripts/import-kappa-page.py` to fill missing UFOs; use `--force` only
after reviewing local source edits, as it replaces the four UFO directories.
