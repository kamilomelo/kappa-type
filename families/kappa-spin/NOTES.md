`Kappa Spin` is upstream-informed by Comfortaa.

Current state:
- `upstream/comfortaa` is the read-only provenance source.
- `sources/kappa-spin/upstream-import` contains the imported `.glyphs` sources and build config used for milestone-1 alpha builds.
- `sources/kappa-spin/ufo/masters` contains the current canonical master UFOs.
- `sources/kappa-spin/ufo/instances` contains build-oriented instance UFOs generated from the designspace.
- `sources/kappa-spin/designspace` contains the tracked designspace file for the family.

Upstream source format:
- `Comfortaa.glyphs`
- `config.yaml`

UFO-first plan:
1. keep the imported Glyphs file only as the upstream reference baseline;
2. maintain master UFOs and designspace as the canonical KM-editable source layer;
3. generate instance UFOs from that designspace for release builds.

Current progress:
- master UFOs now exist in `sources/kappa-spin/ufo/masters`
- instance UFOs now exist in `sources/kappa-spin/ufo/instances`
- a tracked designspace file now exists in `sources/kappa-spin/designspace`
- conversion succeeds, but `glyphsLib` emits many missing kerning-class warnings from the upstream source
- initial source audit notes live in `families/kappa-spin/AUDIT.md`
