`Kappa Text` is upstream-informed by Readerly.

Status:
- visually reviewed after correcting the Readerly reference build path
- accepted as the current Readerly-faithful KM baseline
- future Bookerly-inspired divergence is deferred

Current state:
- `upstream/readerly` is the read-only provenance source.
- `sources/kappa-text/upstream-import` contains the imported upstream build inputs used for milestone-1 alpha builds.
- `sources/kappa-text/ufo` now contains binary-derived KM UFO imports built from staged Readerly reference TTFs.

Upstream source format:
- variable TTF inputs
- upstream build entry point: `python3 build.py`

Current staged flow:
1. instantiate upstream variable TTFs into Readerly reference statics;
2. import those statics into UFO packages with `scripts/import-binary-ufo.py`;
3. adopt KM-owned source metadata with `scripts/adopt-kappa-text-sources.py`;
4. rebuild KM TTFs from the imported UFOs with `fontmake`.

Initial audit notes live in `families/kappa-text/AUDIT.md`.

Maintenance rule:
- current adoption work should remain non-visual
- preserve glyphs and feature behavior while normalizing source metadata
- future visual review should use `proofs/kappa-text.html`
- Readerly remains the approved baseline for current builds
- Bookerly is reference-only and should guide only future intentional redesign work

Manual review still needed:
- extracted feature text from compiled fonts;
- overlap handling and outline fidelity after binary-to-UFO import;
- whether these UFOs are acceptable as long-term canonical KM sources.

Reference samples:
- `references/kappa-text/bookerly`

Future redesign backlog:
- `families/kappa-text/REDESIGN.md`
