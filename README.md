# Kappa Type

Kappa Type is an upstream-informed, UFO-first type foundry repository producing four active KM-X-oriented font families and one future in-house family:

- Kappa Text — long-form text for websites, documentation, manuals, and reports.
- Kappa Mark — corporate logo typography.
- Kappa Mono — code, terminals, snippets, and engineering documentation.
- Kappa Spin — venture and side-project logo typography.
- Kappa Hand — future handwriting-based family, not part of milestone 1 builds.

The first milestone is infrastructure only: license review, source import, renaming, build scripts, validation, and proof generation.

## Upstreams

- Kappa Text: Readerly
- Kappa Mark: ABeeZee
- Kappa Mono: Commit Mono
- Kappa Spin: Comfortaa

## Repository Layout

```txt
upstream/   read-only upstream clones for provenance and updates
families/   per-family metadata, notes, and wrapper config
sources/    KM-owned source layer
  */upstream-import/  imported upstream source assets used today
  */ufo/              canonical UFO source layer, including masters and instances where available
  */designspace/      tracked designspace files for families normalized beyond raw imports
fonts/      generated TTF/WOFF2/CSS outputs, plus optional extras when justified
proofs/     generated HTML proofs and validation reports
scripts/    repeatable bootstrap/import/build/rename/validation scripts
licenses/   copied upstream licenses, notices, and provenance notes
```

## Milestone 1 Commands

```bash
./scripts/bootstrap.sh
./scripts/sync-upstream-imports.sh
./scripts/build-upstream-reference.sh
./scripts/import-km-ufo.sh
./scripts/build-km.sh
./scripts/build.sh
```

`./scripts/build.sh` orchestrates the three explicit stages above.

## Stages

1. `build-upstream-reference.sh`
   - builds or prepares upstream-shaped reference outputs under `tmp/upstream-reference/`
2. `import-km-ufo.sh`
   - imports or refreshes KM UFO sources from upstream-informed inputs
3. `build-km.sh`
   - builds KM-named outputs, patches `Kappa Mono` with Nerd icons, then generates webfonts, proofs, and validation reports

## Current Scope

- No glyph redesign yet.
- `upstream/` remains the source-of-truth reference for the chosen upstream repos.
- `sources/*/ufo` is the intended long-term canonical source layer for KM-maintained derivatives.
- Milestone-1 builds still use the highest-fidelity upstream assets currently available per family.
- This repo is upstream-informed, not upstream-bound: over time each family can diverge into an independent KM source.
- Tracked UFO imports now exist for all four active families.
- `Kappa Mark` and `Kappa Spin` now also track master UFOs plus designspace files, not only flat instance imports.
- Primary desktop output format is `TTF`.
- Primary web output format is `WOFF2`.
- Other output formats are optional and should only exist when justified.

## Family Status

- `Kappa Text`: Readerly-informed; upstream reference TTFs are instantiated first, then imported into UFOs, then rebuilt as KM TTFs.
- `Kappa Mark`: ABeeZee-informed; Glyphs sources are normalized into master UFOs, instance UFOs, and designspace, then adopted as KM-owned canonical sources and rebuilt as KM TTFs.
- `Kappa Mono`: Commit Mono-informed; upstream OTF assets are imported to UFOs, rebuilt as KM TTFs, then Nerd-patched as the primary mono release.
- `Kappa Spin`: Comfortaa-informed; Glyphs sources are normalized into master UFOs, instance UFOs, and designspace, then rebuilt as KM TTFs.

## Current Outputs

- built fonts under `fonts/`
- proof HTML under `proofs/`
- validation reports under `proofs/validation/`

## Known Issues

- `Comfortaa` Glyphs-to-UFO conversion emits a large number of missing kerning-class warnings through `glyphsLib`.
- `Readerly` and `Commit Mono` currently depend on binary-to-UFO import, so their KM UFOs should still be treated as provisional engineering sources until manually reviewed.
- `fontbakery` is best-effort and time-bounded in milestone 1 so it does not stall the whole build.
