# Local Light Chat

**Your Mac. Your words.**

A small native macOS menu bar companion for local Ollama models. Ask a question, rewrite a sentence, dictate a prompt, or attach an image—without a hosted inference account.

> 0.1.0 developer preview. The downloadable build is Apple silicon and ad hoc signed, not Apple-notarized. Build from source if macOS refuses the downloaded preview. No model weights are included.

## Get running

1. **Install Ollama.** Download the [official Mac app](https://ollama.com/download/mac), move it to Applications, and open it. Ollama requires macOS 14 or newer. Apple silicon is recommended for this app; the preview is tested on Apple silicon only.
2. **Download a model.** In Terminal, run:

   ```sh
   ollama pull qwen3:8b
   ```

   For image understanding, optionally add `ollama pull qwen3.5:9b`. Models are separate multi-GB downloads. This app uses a 4096-token context; model download size and useful memory needs vary. A Mac with 16 GB RAM is a practical starting point for the tested 8B/9B models, not a minimum guaranteed for every workload. Keep substantial disk headroom beyond the model files.
3. **Install this app.** Download a preview from Releases, extract it, and move the app to Applications. See the preview trust limitation above. For the supported source-build path below, run the build command and copy the resulting `.app` from `dist/` to Applications.
4. **Open the app.** Follow the in-app setup guide and press Check connection. It connects only to `127.0.0.1:11434`.
5. **Press Control-Space.** The panel opens and starts dictation. Allow microphone and speech recognition only if you want voice input. You can always type instead. Review the text, then press Enter to send.

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

Inference uses installed local models only. Voice transcription requires on-device speech support for the current language. Unsupported recognizers show guidance instead of switching to network recognition. No chat history is saved by the app.

Paste reads the clipboard only when clicked. Search in browser opens an explicit browser search; the app does not fetch pages or generate verified citations. Share and Save are explicit user actions. Ollama's own networking and logs are controlled separately. Read [data flow and privacy](docs/PRIVACY.md).

Image attachments are for **understanding**, not image generation/editing. Generation is deferred. Model answers can be wrong, including time conversions, facts, and source claims. Each request is independent; conversation memory and live token streaming are not implemented.

## Build from source

Use macOS 14+ with Xcode Command Line Tools and Swift 6 or newer. Install the tools with `xcode-select --install` if needed. No third-party Swift dependencies are required.

```sh
git clone https://github.com/cellfade/local-light-chat.git
cd local-light-chat
./script/build_and_run.sh
```

The result is `dist/Local Light Chat.app`. The app intentionally lives in the menu bar and has no Dock icon. The build script uses your current architecture. Intel source builds are not yet validated.

```sh
./script/test_offline.sh     # no Ollama or model downloads
./script/test.sh             # live Ollama, qwen3:8b and qwen3.5:9b required
./script/doctor.sh           # read-only local connection diagnostics
./script/package.sh          # release-mode ZIP + SHA-256 checksum
```

See [installation and troubleshooting](docs/INSTALL.md), [distribution](docs/DISTRIBUTION.md), [release board](docs/ROADMAP.md), and [contributing](CONTRIBUTING.md). Ollama and model licenses remain separate from this repository's MIT license.

## Status

Built and tested as a macOS developer preview. Control-Space registration succeeds, but physical dispatch from another app still needs acceptance testing on additional machines. First-launch privacy permissions, unsupported speech languages, VoiceOver, high contrast, and Intel builds need broader coverage. A Developer ID/notarized distribution requires the maintainer's Apple credentials; they are never included here.
