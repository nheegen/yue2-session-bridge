# Changelog

## 0.5.2 — Consistent generation modes

- Keep native Vocal/Ins ABC identifiers, including in instrumental mode.
- Replace unwanted-part notes with timed rests on submission; retain harmony annotations.
- Preserve the editable source score and lyrics across mode changes and generation.
- Reject unsupported voice IDs and music syntax instead of silently skipping part suppression.
- Put the selected mode instruction first in the style prompt.
- Add regression coverage for mode-specific requests, ties, rests and source preservation.

## 0.5.1 â€” Public packaging preparation

- Removed absolute developer filesystem paths from patch metadata.
- Made device builds portable and independent of an installed Live template.
- Added public documentation, version tracking, tests, release packaging and Git exclusions.
- Excluded personal content, generated audio, private request records and old bundles.
- Kept audio-generation behaviour unchanged from 0.5.

## 0.5

- Added Vocals only, Instrumental only, and Vocals + instruments.
- Made generated ABC voice labels follow the selected mode.

## Earlier prototypes

- 0.4.1: Info View descriptions.
- 0.4: sound/style label and instrumental mode.
- 0.3: destination audio-track import and generation progress.
- 0.2: fixed button routing and Max startup; added in-device source selection.
- 0.1: initial Session MIDI-to-ABC bridge.

