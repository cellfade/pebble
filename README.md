# Pebble

**A little help. Close to home.**

A native macOS workspace for Apple’s on-device model and local Ollama models, with a draggable window, cobalt accents, and a neutral stone companion with floating ink eyes and a smile. Ask a question, rewrite a sentence, dictate a prompt, or attach an image—without a hosted inference account.

> 0.3.0-beta.1 developer preview. The downloadable build is Apple silicon and ad hoc signed, not Apple-notarized. Build from source if macOS refuses the downloaded preview. No model weights are included.

## Choose your local engine

**Apple on-device** works on a compatible Apple Intelligence Mac running macOS 26+ with Apple Intelligence enabled and the model ready. It needs no separate runtime or API key. Pebble checks availability and explains unavailable states. This engine handles text/chat/rewriting; it does not analyze attachments.

**Ollama** gives the direct-download edition configurable models and image understanding. It works on macOS 14+; Apple silicon is recommended and the preview binary is arm64. The instructions below set it up explicitly.

A separate `AppStore` Xcode configuration uses only Apple’s on-device engine, removes the Ollama installer guidance/model picker/image attachment surface, targets macOS 26+, and uses sandbox entitlements without a network-client permission. It is a submission candidate, not an accepted App Store release. See [App Store readiness](docs/APP_STORE.md).

## Get running with Ollama

1. **Install Ollama.** Download the [official Mac app](https://ollama.com/download/mac), move it to Applications, and open it. Ollama requires macOS 14 or newer. Apple silicon is recommended for this app; the preview is tested on Apple silicon only.
2. **Download a model.** In Terminal, run:

   ```sh
   ollama pull qwen3:8b
   ```

   For image understanding, optionally add `ollama pull qwen3.5:9b`. Models are separate multi-GB downloads. This app uses a 4096-token context; model download size and useful memory needs vary. A Mac with 16 GB RAM is a practical starting point for the tested 8B/9B models, not a minimum guaranteed for every workload. Keep substantial disk headroom beyond the model files.
3. **Install this app.** Download a preview from Releases, extract it, and move the app to Applications. See the preview trust limitation above. For the supported source-build path below, run the build command and copy the resulting `.app` from `dist/` to Applications.
4. **Open the app.** Follow the in-app setup guide and press Check connection. It connects only to `127.0.0.1:11434`.
5. **Use the workspace.** You can choose Apple on-device when available. Drag the native title bar to move the window or resize it from its edges. **Press Control-Space.** The panel opens and starts dictation. Allow microphone and speech recognition only if you want voice input. You can always type instead. Review the text, then press Enter to send.

If you use the Ollama GUI, keep it running. If you installed the command-line runtime without the GUI or a service, run `ollama serve` in a separate Terminal. Do not start a second server if the endpoint is already available.

## A small set of useful controls

| Action | Control |
|---|---|
| Open panel and start/stop dictation | Control-Space while the app is running |
| Start/stop dictation in the panel | Command-Shift-D |
| Send | Enter or Command-Enter |
| Insert a newline | Shift-Enter |
| Cancel generation | Escape while the panel is active |
| Copy response | Command-Shift-C or Copy response |
| Paste at the cursor | Command-V in the editor |
| Append clipboard text | Paste button |
| Share or save a response | Share or More → Save response |
| Reopen setup | More → Setup & installation |

The app does not register itself to start at login. Add it in System Settings → General → Login Items if you want it available after each login.

## What stays local

Inference uses installed local models only. Text chat retains a bounded recent context in process memory: the last four turns, with each user message capped at 1,200 characters and each answer at 1,800. The session stores at most eight turns. Rewrite and image requests exclude recent chat context; Clear starts a fresh conversation. Voice transcription requires on-device speech support for the current language. Unsupported recognizers show guidance instead of switching to network recognition. No chat history is persisted to disk by the app.

Paste reads the clipboard only when clicked. The Actions workspace proposes an exact Safari search, explicit HTTPS link, or basic Mac summary for your approval. Search sends the approved query to DuckDuckGo in Safari. The app does not fetch pages or generate verified citations. Share and Save are explicit user actions. Ollama's own networking and logs are controlled separately. Read [data flow and privacy](docs/PRIVACY.md).

Image attachments are for **understanding**, not image generation/editing. Generation is deferred. Model answers can be wrong, including facts and source claims. Recognized clock/date requests use this Mac’s system clock and time-zone database rather than a model estimate; supported named zones are bounded. The basic Mac summary reports OS version, logical processor count, physical RAM, free volume storage, and clock data after approval. It does not inspect files, screens, app contents, or processes. Durable memory, a full context tray, and live token streaming are not implemented.

## Build from source

Use macOS 14+ with Xcode Command Line Tools and Swift 6 or newer. Install the tools with `xcode-select --install` if needed. No third-party Swift dependencies are required. Full native Liquid Glass and Foundation Models are compiled when building with Xcode 26+/Swift 6.2+ and the macOS 26 SDK; builds with older SDKs use standard macOS materials and the Ollama engine. Full Xcode 26+ is needed for the App Store archive configuration.

```sh
git clone https://github.com/cellfade/pebble.git
cd pebble
./script/build_and_run.sh
```

The result is `dist/Pebble.app`. The app has a normal movable/resizable window and Dock icon, plus a menu bar shortcut. It remembers window position and size; closing the window leaves the menu bar companion running. The build script uses your current architecture. Intel source builds are not yet validated.

```sh
./script/test_offline.sh     # no Ollama or model downloads
./script/test_beta.sh        # clock/context/composer/approval regressions; fake executor
./script/test.sh             # live Ollama, qwen3:8b and qwen3.5:9b required
./script/doctor.sh           # read-only local connection diagnostics
./script/package.sh          # release-mode ZIP + SHA-256 checksum
```

See [installation and troubleshooting](docs/INSTALL.md), [distribution](docs/DISTRIBUTION.md), [release board](docs/ROADMAP.md), and [contributing](CONTRIBUTING.md). Ollama and model licenses remain separate from this repository's MIT license.

## Product and release

- [Screenshots and interaction demo](docs/MEDIA.md)
- [Beta release destination](https://github.com/cellfade/pebble/releases/tag/v0.3.0-beta.1) — published developer preview; CI passed, not notarized
- [Brand assets: SVG, monochrome mark, icon](docs/brand/README.md)
- [App Store submission path and remaining gates](docs/APP_STORE.md)

## Status

Built and tested as a macOS developer preview. Control-Space registration succeeds, but physical dispatch from another app still needs acceptance testing on additional machines. First-launch privacy permissions, unsupported speech languages, VoiceOver, high contrast, and Intel builds need broader coverage. A Developer ID/notarized distribution requires the maintainer's Apple credentials; they are never included here.
