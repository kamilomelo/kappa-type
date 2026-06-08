`Kappa Mark` is upstream-informed by ABeeZee.

Current state:
- `upstream/abeezee` is the read-only provenance source.
- `sources/kappa-mark/upstream-import` contains the imported `.glyphs` sources and build config used for milestone-1 alpha builds.
- `sources/kappa-mark/ufo/masters` contains the adopted canonical KM master UFOs.
- `sources/kappa-mark/ufo/instances` contains build-oriented KM instance UFOs generated from the designspace.
- `sources/kappa-mark/designspace` contains tracked KM designspace files for the regular and italic source sets.

Upstream source format:
- `ABeeZee.glyphs`
- `ABeeZee-Italic.glyphs`
- `config.yaml`

UFO-first plan:
1. keep the imported Glyphs files only as the upstream reference baseline;
2. maintain master UFOs and designspace as the canonical KM-editable source layer;
3. generate instance UFOs from that designspace for release builds.

Current progress:
- master UFOs now exist in `sources/kappa-mark/ufo/masters`
- instance UFOs now exist in `sources/kappa-mark/ufo/instances`
- tracked designspace files now exist in `sources/kappa-mark/designspace`
- builds now run from the KM instance UFOs, not from ABeeZee Glyphs files
- automatic upstream reimport is disabled once the canonical KM source has been adopted
- source audit notes live in `families/kappa-mark/AUDIT.md`
- kerning structure notes live in `families/kappa-mark/KERNING.md`
- future redesign backlog lives in `families/kappa-mark/REDESIGN.md`

Maintenance rule:
- normal builds should not refresh `Kappa Mark` from upstream
- to force a fresh upstream reimport, run `KAPPA_MARK_REIMPORT_FROM_UPSTREAM=1 ./scripts/import-ufo-sources.sh`
- copyright and OFL provenance remain upstream-derived by design; family naming, PostScript naming, and tracked source filenames are KM-owned
- current design layer is frozen: no kerning, spacing, feature-behavior, or outline changes should be made until explicitly approved
- current source/build state is visually approved against ABeeZee as the KM baseline
