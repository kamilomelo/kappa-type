# Kappa Mark Future Redesign Backlog

Status: deferred

Current rule:
- do not change the visual behavior of `Kappa Mark` during source-cleanup work
- treat the current KM source state as the approved visual baseline

Future redesign targets already identified:
- lowercase: `q`, `y`, `z`
- uppercase: `G`, `I`, `Z`
- numerals: `3`, `7`

Suggested redesign workflow when the time comes:
1. clone the current approved baseline into a review branch or milestone snapshot
2. change only one target area at a time
3. regenerate proofs after each step
4. compare against the approved baseline before accepting the change
5. update proof watch strings if new weak spots are found

Current proof watch strings live in:
- `proofs/kappa-mark.html`

Current non-goals:
- no kerning redesign yet
- no spacing redesign yet
- no feature behavior redesign yet
