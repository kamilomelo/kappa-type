# Kappa Type

[![License: OFL 1.1](https://img.shields.io/badge/fonts-OFL%201.1-2d6a4f.svg)](./LICENSE)
[![Status: Baselines Frozen](https://img.shields.io/badge/status-baselines%20frozen-264653.svg)](#frozen-baselines)
[![Build Model: UFO First](https://img.shields.io/badge/build-UFO%20first-b56576.svg)](#repository-layout)

Kappa Type is an upstream-informed, UFO-first type foundry repository for four active KM-X font families and one future in-house handwriting family.

The current state is intentionally conservative:
- upstreams inspected and licensed
- build pipelines working
- KM-owned naming adopted
- approved baseline builds frozen
- redesign deferred until explicitly requested

Active families:

- Kappa Text — long-form text for websites, documentation, manuals, and reports.
- Kappa Mark — corporate logo typography.
- Kappa Mono — code, terminals, snippets, and engineering documentation.
- Kappa Spin — venture and side-project logo typography.
- Kappa Hand — future handwriting-based family, not part of milestone 1 builds.

The first milestone is infrastructure first: license review, source import, renaming, build scripts, validation, proof generation, and freezing approved baseline builds before intentional redesign.

## At A Glance

| Family | Upstream | Canonical Source Shape | Current Baseline |
| --- | --- | --- | --- |
| `Kappa Text` | Readerly | binary-informed UFOs | frozen |
| `Kappa Mark` | ABeeZee | master UFOs + instances + designspace | frozen |
| `Kappa Mono` | Commit Mono | binary-informed UFOs | frozen |
| `Kappa Spin` | Comfortaa | master UFOs + instances + designspace | frozen |

## Quick Start

```bash
./scripts/bootstrap.sh
./scripts/build.sh
```

Primary outputs:
- desktop fonts: `TTF`
- web fonts: `WOFF2`
- proofs: `proofs/*.html`
- validation: `proofs/validation/*`

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
references/ local private comparison notes and untracked design references
scripts/    repeatable bootstrap/import/build/rename/validation scripts
licenses/   copied upstream licenses, notices, and provenance notes
```

## Full Build Commands

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
- All four active families now have approved frozen baselines before redesign.

## Family Status

- `Kappa Text`: Readerly-informed; upstream Readerly reference TTFs are built first, then imported into UFOs, then rebuilt as KM TTFs. The current baseline is frozen and Readerly-faithful. Future redesign direction is broadly "more Bookerly, less Readerly" through legally clean original work.
- `Kappa Mark`: ABeeZee-informed; Glyphs sources are normalized into master UFOs, instance UFOs, and designspace, then adopted as KM-owned canonical sources and rebuilt as KM TTFs. The current baseline is frozen.
- `Kappa Mono`: Commit Mono-informed; upstream assets are imported to UFOs, rebuilt as KM static TTFs, then Nerd-patched as the primary mono release for terminal use. No upstream-derived variable font ships from this repo. The current baseline is frozen and approved in Starship use.
- `Kappa Spin`: Comfortaa-informed; Glyphs sources are normalized into master UFOs, instance UFOs, and designspace, then adopted as KM-owned canonical sources and rebuilt as KM TTFs. The current baseline is frozen.

## Frozen Baselines

- `Kappa Text`: frozen baseline approved
- `Kappa Mark`: frozen baseline approved
- `Kappa Mono`: frozen baseline approved
- `Kappa Spin`: frozen baseline approved

Deferred redesign targets now live in:
- `families/kappa-text/REDESIGN.md`
- `families/kappa-mark/REDESIGN.md`
- `families/kappa-mono/REDESIGN.md`
- `families/kappa-spin/REDESIGN.md`

## GitHub Push Notes

- `upstream/` is intentionally ignored and not part of the public repo payload
- `tmp/` is ignored
- private design references must remain untracked under `references/`
- proprietary sample fonts must not be committed
- current branch tip is safe to publish

## Current Outputs

- built fonts under `fonts/`
- proof HTML under `proofs/`
- validation reports under `proofs/validation/`

## Known Issues

- `Comfortaa` Glyphs-to-UFO conversion emits a large number of missing kerning-class warnings through `glyphsLib`.
- `Readerly` and `Commit Mono` currently depend on binary-to-UFO import, so their KM UFOs should still be treated as provisional engineering sources until manually reviewed.
- `fontbakery` is best-effort and time-bounded in milestone 1 so it does not stall the whole build.

## Notes

- Bookerly is not an upstream for `Kappa Text`; if used as a private visual reference, it must remain local and untracked.
- `Kappa MonoNoNe` remains documented in `AGENTS.md` as an older idea, but the current repo state treats Nerd-patched `Kappa Mono` as the primary mono release because that matches the approved terminal use case.
- Public contribution rules are summarized in [CONTRIBUTING.md](/home/kamilo/kDrive/KM-X%20Group/kappa-type/CONTRIBUTING.md).
