# Kappa Page

Kappa Page is for printed documents: correspondence, invoices, CVs, and forms.
Kappa Text remains for long-form reading; Kappa Form remains for screen-based text.

The rename-only alpha uses the four CMU Sans Serif styles from Computer Modern
Unicode 0.7.0. The original FontForge SFDs and OTFs are preserved in
`sources/kappa-page/upstream-import/`; the KM-named UFOs are **binary-derived**
build inputs, not a faithful conversion of the editable SFD source. The OTF
feature extraction needs one technical correction: language/script declarations
are removed *only inside* the `aalt` feature, where they are invalid in Adobe
feature syntax. No glyph redesign is intended.

Upstream Medium is mapped to Kappa Page Regular (CSS 400); Oblique is mapped to
Italic for normal desktop and web style selection. Bold and Bold Oblique map to
Bold and Bold Italic. These are naming/style decisions, not outline changes.

This alpha is **not frozen or visually approved**. Check proof rendering,
metrics, kerning, language features, and PDF/print output against the upstream
OTFs before accepting the baseline. A future SFD-to-UFO conversion should be
evaluated against the current binary-informed import rather than silently
replacing it.
