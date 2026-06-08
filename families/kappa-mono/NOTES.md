`Kappa Mono` is upstream-informed by Commit Mono.

Current state:
- `upstream/commit-mono` is the read-only provenance source.
- `sources/kappa-mono/upstream-import` contains the imported upstream font assets used for milestone-1 alpha builds.
- `sources/kappa-mono/ufo` now contains binary-derived KM UFO imports built from staged Commit Mono OTF reference assets.

Observed upstream source situation:
- the inspected upstream repo exposes OTF/VF/WOFF2 assets
- no obvious editable `.glyphs` or `.ufo` sources were present in the inspected repo snapshot

Current staged flow:
1. copy upstream Commit Mono reference OTFs into `tmp/upstream-reference`;
2. import those OTFs into UFO packages with `scripts/import-binary-ufo.py`;
3. adopt KM-owned source metadata with `scripts/adopt-kappa-mono-sources.py`;
4. rebuild KM TTFs from the imported UFOs with `fontmake`.

Initial audit notes live in `families/kappa-mono/AUDIT.md`.
- future redesign backlog lives in `families/kappa-mono/REDESIGN.md`.

Maintenance rule:
- current adoption work should remain non-visual
- preserve glyphs and feature behavior while normalizing source metadata
- future visual review should use `proofs/kappa-mono.html` against Commit Mono
- current source/build state is visually approved against Commit Mono as the KM baseline
- current design layer is frozen: no spacing, feature-behavior, or outline changes should be made until explicitly approved
- no upstream-derived variable `VF` mono should ship from this repo
- `Kappa Mono` now means the Nerd-patched static TTF release, not a separate optional family

Manual review still needed:
- CFF-to-UFO feature fidelity;
- whether the imported UFOs should become the long-term KM source of truth;
- whether the imported UFOs should also justify optional non-TTF outputs later.
