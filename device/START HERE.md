# YuE2 Session Bridge â€” 0.5.1 (experimental)

## Three generation modes

- **Vocals only**: requests a cappella with no instrumental accompaniment and sends your lyrics.
- **Instrumental only**: requests instruments without singing and omits lyrics from the request, while preserving your typed lyrics.
- **Vocals + instruments**: requests vocals with instrumental accompaniment and sends your lyrics.

Use **Sound / style description** for details: synth arpeggios, choir, backing vocals, drum patterns, genre, effects and performance. Avoid contradictory instructions in that field when changing modes. Modes provide guidance to YuE2, not guaranteed stem isolation.

The ABC editor holds the full source score with native `Vocal` and `Ins` voice IDs in every mode. These IDs describe the score format, not a guarantee of audible vocals. At submission, Instrumental only replaces Vocal notes with timed rests and omits lyrics; Vocals only replaces Ins notes with timed rests. Chord symbols and timing remain. Combined keeps both parts. Switching modes and generating do not overwrite your source notes or lyrics. The request JSON in renders contains the actual submitted score. Legacy Harmony IDs are converted to Vocal. Unsupported custom voices or music syntax produce an error rather than silently bypassing the mode filter.

All visible controls and labels now include Info View descriptions. Open Ableton's Info View and hover over a control to read its purpose and relevant behaviour.

Automatic Session audio import and live stage progress are retained. Replace the old device instance with this version. Extract the complete new bundle into its own folder before loading; do not copy only the AMXD. Copy any text you want to retain before removing the old instance.

A Max for Live MIDI device for Live Suite. Captures Session MIDI clips, converts their harmony and bass notes into ABC, and submits style + lyrics + ABC to your existing native YuE2 rendering chain in ComfyUI.

## Load it

1. Keep this entire folder together. `live.js`, `max-entry.js`, `bridge.js`, `progress.js`, and `core.js` must stay next to the device. If using the ZIP, extract it first.
2. Drag **YuE2 Session Bridge.amxd** onto a MIDI track in Live. A dedicated empty MIDI track is convenient. The device passes incoming MIDI through unchanged.
3. Start your existing ComfyUI server. Leave the address at `http://127.0.0.1:8188` unless your server uses another address. Press **Test connection**.

No custom ComfyUI nodes or additional Node packages are required. Requires Node for Max with Node.js 22 or later. The Windows Live 12.4 beta / bundled Max environment was used during development; other platforms have not been validated. The device is wide; expand the device view or scroll horizontally to reach the ABC preview and Generate button.

## Choose the musical material

Press **Refresh** in the device to list the Session MIDI clips. Choose a clip by track name and clip name from the dropdown, then press **Add chord** or **Add bass**. Repeat to combine several sources. You stay on the device's track throughout; selecting clips elsewhere in Live is unnecessary. Refresh the list after creating, deleting, moving, or renaming clips/tracks.

The source fields remain editable. Enter source clips as **track:scene**, using one-based numbers in Session View. For example:

- Chord clips: `1:1, 3:1` combines the notes from track 1 / scene 1 and track 3 / scene 1 into the harmony.
- Bass clips: `2:1` reads the actual bass notes from track 2 / scene 1.

These are examples, not defaults. Choose your actual clips. Audio clips and empty slots are rejected. Do not list the same clip in both roles.

Clip numbers refer to their current positions, so review the source fields after reordering tracks or scenes. Remove a source by deleting its entry from the field.

Set **Bars** to the desired passage length. Each looping clip starts at its own loop start and repeats to fill the passage; non-looping clips play their marker range once. This reads the stored clips, not the live playback phase. The first version supports one repeating passage, rather than a sequence of changing scenes.

**Key** defaults to `auto`, reading Live's current root and scale. You can enter `D minor`, `F# major`, etc. Tempo and meter come from Live at capture time. Existing chromatic notes are retained; the converter does not snap your music to a scale.

## Generate a take

1. Choose one of the three generation modes and enter your **Sound / style description**. Lyrics are sent in both vocal modes and omitted in Instrumental only mode.
2. Press **1 Build ABC**. This captures all configured clips over the requested number of bars.
3. Review the ABC preview. Chord symbols appear in quotes. The status line reports duration, key, and any chord ambiguity. You can edit the ABC directly.
4. In **Send audio to track**, choose an existing audio track, or leave **Save only** selected. Press Refresh if you just added a track. Then press **2 Generate**. The edited ABC goes directly into **YuE2GenerateMusic**, together with the text fields. The separate ABC generator is not used.
5. Watch the progress bar and stage label. On completion, the FLAC is saved in **renders** beside the device and loaded into the selected track's first empty Session slot. The clip is not automatically launched. ComfyUI also retains its normal saved output.

The destination is captured when Generate is pressed; changing the dropdown during rendering affects the next request. Track identity is retained across reordering within the current Live Set. Destinations are deliberately not restored across Set loads; choose the track again. Existing clips are never replaced. Frozen/deleted tracks or a full destination are reported; the file is still retained. Add an empty scene or choose another destination, then press **Import latest take** to retry or copy the latest completed take elsewhere. This button remembers takes completed in the current device session only.

Imported clips reference the file in renders. Use Live's **Collect All and Save** before relocating/removing the device folder if you want the Set to be self-contained. Import uses Live's normal audio clip defaults, including any automatic warping preferences; no extra alignment or warping is applied by the device.

Progress comes from ComfyUI's WebSocket events for this request only. The percentage describes the current stage, not total time remaining, and may reset between stages or internal passes. Stages without step updates display their name. If the progress connection fails, completion polling and audio download continue normally.

Press Build ABC again after changing MIDI, sources, bars, key, or tempo. Generate uses the last built capture's duration and tonal context, and the current text fields. Building again replaces manual ABC edits. If you manually change the ABC's overall duration, rebuild with matching Bars before generating.

The stored text fields are configured as Live parameters for saving with the Set. A new load still requires Build ABC before generating, so duration is recaptured from Live.

## How the first converter behaves

- Combines chord-role notes across tracks at every note boundary, including chord changes within a bar.
- Recognizes common triads, sevenths, suspensions, sixths, and selected ninths. Inversions use slash chords. Ambiguous matches are reported.
- Keeps unrecognized voicings as simultaneous notes in the instrumental lane instead of inventing a chord name.
- Writes bass-role notes into the instrumental lane. If bass notes overlap, the lowest active note wins.
- Writes chord annotations over rests in the native Vocal lane, leaving musical invention to YuE2. No separately composed vocal melody is inserted.
- Rounds MIDI timing to a 1/32-note grid. Muted/zero-probability notes are excluded; other probabilistic notes are included as fixed notes. Groove, MIDI effects, MPE, audio transcription, and microtonal tuning are not captured.
- Uses correct bar durations, explicit pitch accidentals, and a supported ABC key signature. Other scale names are included as textual tonal context.

The chord-only/rest score is experimental; musical results depend on the model and prompt. A model may interpret vocal rests literally or introduce instruments despite an a cappella prompt. If that happens, retain this device and adjust the score representation based on the render; the connection does not need rebuilding.

The requested loop duration is a generation ceiling, not a guarantee of exact audio length or beat alignment. YuE2 can stop early. Automatic Session placement is supported; automatic beat alignment is not.

## Workflow settings

The built-in ComfyUI workflow uses: `yue2_3b_bf16.safetensors`, YuE2 full mode, temperature 1, top-p 0.95, top-k 100, repetition penalty 1.2, 32 sampler steps, CFG 1, dpm_2 / sgm_uniform, full audio decode, FLAC output. Each request gets a new YuE2 seed, recorded in the saved request; sampler seed remains 7. The device does not watch later changes to your workflow JSON.

If connection fails, check that ComfyUI is running and that the address is correct. If generation loses connection after being queued, check ComfyUI before retrying: the queued job may still be running. Removing the device does not cancel a ComfyUI job. Use ComfyUI's queue controls to manage it.

## Validation status

Automated tests cover conversion, source selection, all three generation modes, button routing, simulated Live import, progress events and mock ComfyUI completion/download. Earlier device versions have been used in Live on Windows. The public package still needs a clean-machine loading test, particularly script resolution after moving folders. No broad platform compatibility claim is made.
