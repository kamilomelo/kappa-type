# Kappa Type — Codex Instructions

This repository will produce four open-source derivative font families:

- Kappa Text: derived from Readerly.
- Kappa Mark: derived from ABeeZee.
- Kappa Mono: derived from Commit Mono.
- Kappa Spin: derived from Comfortaa.
- Kappa Hand: build from my own handwriting.

## Core rule

Do not start by creating a large structure blindly.

First inspect the upstream repositories, licenses, source formats, build systems, and reserved font name requirements. Then propose a structure and wait for confirmation before making large changes.

## Legal rules

Preserve all upstream copyright notices, OFL files, and license metadata.

Do not use upstream Reserved Font Names in modified fonts.

Final generated font family names must be:

- Kappa Text
- Kappa Mark
- Kappa Mono
- Kappa Spin
- Kappa Hand

Do not distribute modified fonts under the names Readerly, ABeeZee, Commit Mono, or Comfortaa.

Do not add non-OFL fonts.

All the new fonts should be OFL 1.1 lincensed

## Project goals

Create a repeatable public font engineering repo that can:

1. import upstream sources;
2. rename font metadata safely;
3. build TTF/OTF/WOFF2 where appropriate;
4. generate CSS @font-face files;
5. generate visual proof sheets;
6. validate outputs with fonttools and FontBakery where practical;
7. optionally produce a Nerd Font patched version of Kappa Mono;
8. document all build commands.

## First milestone

The first milestone is not glyph redesign.

The first milestone is:

- verify licenses;
- identify build systems;
- define repo structure;
- create scripts only after inspection;
- produce rename-only alpha builds;
- generate proof files;
- document remaining manual design work.

## Terminal font rule

Nerd Font support is needed for Kappa Mono, generate a separate optional build called:

- Kappa MonoNoNe

where the Kappa Mono remain clean. This in fact can be the base for the real Kappa Mono

Also document the fallback option:

- Kappa MonoNoNe + Symbols Nerd Font Mono

## Handwritten font rule
This we will reseve as eventually I will create a font right out of my own handwriting.

## Working style

Prefer small, reviewable commits.

Before editing many files, explain the plan.

After each major step, summarize:

- what changed;
- what command was run;
- what remains uncertain;
- what needs manual review.
