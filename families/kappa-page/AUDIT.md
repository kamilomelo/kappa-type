# Kappa Page alpha audit

Source: CMU Sans Serif 0.7.0, SFD and OTF pairs. `licenses/kappa-page/OFL.txt`
preserves all upstream copyright holders and the Reserved Font Family Name.
Only four proportional Sans Serif styles were imported; Demi Condensed was not.

## Build and engineering checks

```bash
.venv/bin/python scripts/import-kappa-page.py
bash scripts/build-kappa-page.sh
.venv/bin/python scripts/check-kappa-page.py
```

The four TTFs and four WOFF2s pass family/style/PostScript name checks,
OFL/copyright metadata checks, and exact upstream cmap and GSUB/GPOS feature
tag/lookup-count comparisons. These checks do **not** prove identical outlines,
shaping, positioning, or printed appearance. Binary-derived UFOs are provisional;
the SFD sources are retained for a future source-fidelity review.

`fontbakery check-universal fonts/kappa-page/ttf/*.ttf` completed for the alpha:
0 errors, 0 fatals, **30 fails**, 44 warnings, 138 skips, 12 infos, 248 passes.
Do not present this as a passing FontBakery build. Findings include missing
STAT tables, legacy metrics disagreements (including a different Bold Oblique
vertical extent), zero-width Cyrillic bases, a glyph with ink at U+2029,
Mac name records, and TrueType hinting/dropout issues. At least some issues
(missing STAT, legacy ascender mismatch, zero-width U+0488) are present in
the original OTFs; others need separate classification. Do not make blind
glyph or metric changes to suppress failures during this rename-only alpha.

## Manual acceptance still needed

- Compare upstream OTF vs KM print/PDF proofs at document sizes and across
  Regular, Italic, Bold, and Bold Italic; check accents and figure alignment.
- Inspect shaping and positioning across Latin, Greek, and Cyrillic, not just
  feature counts; audit the `aalt` unparser correction.
- Evaluate whether native SFD conversion with FontForge improves source fidelity
  and whether the baseline should use Regular weight 400 vs original Medium 500.
- Triage FontBakery findings before freezing or recommending for release.
