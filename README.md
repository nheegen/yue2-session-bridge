# YuE2 Session Bridge

An experimental Max for Live MIDI device that uses your Session clips as harmonic guidance for music generation in ComfyUI.

**Session MIDI Ã¢â€ â€™ chord/bass ABC Ã¢â€ â€™ YuE2 Ã¢â€ â€™ audio in a Session track**

## Features

- Select and combine chord and bass clips inside the device.
- Capture loop boundaries, tempo, meter and Live's scale; edit the resulting ABC.
- Choose Vocals only, Instrumental only, or Vocals + instruments.
- Send a sound description and optional lyrics to a local ComfyUI server.
- See per-stage generation progress.
- Import completed takes into a selected audio track's first empty Session slot.
- Hover over controls for Ableton Info View help.

## Install

1. Extract the device ZIP from a release, keeping all files together in a writable folder.
2. Drag `YuE2 Session Bridge.amxd` onto a MIDI track in Ableton Live Suite.
3. Run ComfyUI with native YuE2 nodes and the `yue2_3b_bf16.safetensors` checkpoint installed.
4. Press **Test connection**. The default server address is `http://127.0.0.1:8188`.
5. Press **Refresh**, choose source MIDI clips, and add them as chord or bass sources.
6. Enter style/lyrics, select a generation mode, and press **Build ABC**, then **Generate**.

When using the source ZIP, the complete installable device is in `device/`.

Read [the device guide](device/START%20HERE.md) for source numbering, destination tracks and troubleshooting.

## Requirements and support

- Ableton Live Suite with Max for Live. Development and user testing used Windows and Live 12.4 beta; compatibility with other releases and macOS is unverified.
- Node for Max with Node.js 22 or later, used for its built-in WebSocket client.
- ComfyUI exposing `CheckpointLoaderSimple`, `YuE2GenerateMusic`, `EmptyYuE2LatentAudio`, `KSampler`, `VAEDecodeAudio`, and `SaveAudioAdvanced`.
- A working YuE2 installation and hardware capable of running it. Models and ComfyUI are not included.

The ComfyUI workflow settings are currently fixed in `device/core.js`; server address is editable in the device. This package is not a general-purpose workflow importer. Other checkpoint names or sampler settings require editing that file.

The ABC editor preserves the full source score. Requests use native `Vocal`/`Ins` voice IDs: Vocals only rests instrumental notes; Instrumental only rests vocal notes and omits lyrics; Combined keeps both. Chord symbols and timing are preserved. See the device guide for supported editing and saved request scores.

## Limitations

This is a harmony/bass bridge, not exact MIDI-to-audio synthesis. It does not preserve a chord instrument's arpeggio pattern as a performance. It rounds timing to a 1/32-note grid and does not capture audio, MIDI effects, groove, MPE or microtonal tuning.

YuE2 may interpret score conditioning loosely or introduce vocals/instruments contrary to the requested mode. Generated audio may require timing adjustment. The progress percentage is for the current stage, not the whole job. These are not guarantees of isolated stems or loop-perfect output.

Generated FLACs and request JSONs are saved in `device/renders/`. Requests include prompts, lyrics and scores. These files are ignored by Git and excluded from release packaging. Imported clips reference those audio files: use Live's Collect All and Save before moving or removing the device folder.

## Development

From the repository root, with Python 3.10+ and Node.js 22+:

```sh
python scripts/build_device.py
node tests/test_bridge.js
node tests/test_modes.js
python scripts/release.py
```

No third-party build dependencies are required. The Python builder generates the Max patch and AMXD container without reading an installed Ableton template. It does not embed the builder's filesystem path. The test suite uses mock Live objects and a temporary local HTTP server; it does not queue a real model generation.

`VERSION` is the single source for the device version and archive filenames. See [RELEASING.md](RELEASING.md) for the commit/tag/release process.

## Licence and attribution

The bridge code and documentation use the [MIT License](LICENSE); see [LICENSING.md](LICENSING.md) for scope. No Ableton, Max, ComfyUI or model binaries are bundled. Their own terms apply separately. This is an independent project, not an official Ableton or YuE2 product.

