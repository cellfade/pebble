# Installation and troubleshooting

## Requirements

- macOS 14 Sonoma or later. This preview binary is Apple silicon (arm64).
- Ollama installed and running on loopback port 11434.
- An installed local chat model. The tested text model is qwen3:8b; image questions use qwen3.5:9b.
- Internet for initial Ollama/model downloads. Local inference can then work offline.
- Optional microphone and Apple on-device speech support for your current language.

Ollama's [official Mac instructions](https://docs.ollama.com/macos) describe GUI installation and supported hardware. Model tags are available in the [official library](https://ollama.com/library). The app does not install Ollama or download weights automatically.

## Check setup

```sh
ollama --version
ollama list
curl --noproxy '*' http://127.0.0.1:11434/api/version
```

Use the app's More → Setup & installation to revisit the guide. The Check connection action reads the endpoint and installed model list; it does not start a model or download files.

## Common issues

**App is blocked by macOS.** The initial preview has only ad hoc signing. Until the maintainer provides a Developer ID-signed/notarized release, build from the published source on your Mac. Do not disable Gatekeeper or strip quarantine as a standard setup step. [Apple's app-opening guidance](https://support.apple.com/en-us/102445) explains macOS trust checks.

**Ollama unavailable.** Open Ollama, wait for startup, then Check connection. A CLI-only installation may need `ollama serve` in another Terminal. If something already owns port 11434, inspect it before starting another server. The Ollama endpoint is intentionally not configurable to a hosted/LAN server. Apple on-device is a separate engine available on compatible macOS 26+ Macs.

**No models installed.** Run `ollama pull qwen3:8b` in Terminal, wait for completion, then refresh. Inspect `ollama list` to confirm the exact tag. Do not select a remote/cloud tag.

**Microphone or speech access denied.** Open System Settings → Privacy & Security → Microphone or Speech Recognition, enable this app, and relaunch. The app's bundle identity changes only for the first branded preview; permission prompts may recur after moving from the earlier prototype or rebuilding with an ad hoc signature.

**On-device recognition unavailable.** The current language, installed speech assets, device, and OS determine support. Configure a supported dictation language in System Settings. Typing remains available. The app does not fall back to remote speech recognition.

**Control-Space does something else.** Check System Settings → Keyboard → Keyboard Shortcuts → Input Sources. A conflicting system/input-method shortcut can prevent the chord from reaching the app. Change the conflicting assignment yourself or use the menu bar icon and Command-Shift-D. The app never changes your system shortcuts. It displays a registration error if the hot-key API rejects registration. No global keyboard monitoring or Accessibility permission is used.

**Generation is slow.** The first request or switching models loads weights. Keep one model active on memory-limited Macs, close heavy applications, and use shorter prompts. Inspect `ollama ps` to see the loaded runner/GPU placement. Leave disk space for downloads and swap.

**Image request fails.** Choose an installed vision-capable model. The app auto-selects qwen3.5:9b if available, accepts one PNG/JPEG/HEIC/WebP file up to 20 MB, and downscales it to 1600 pixels. Attaching an image does not send it until you send the prompt.

**JSON constraint warning in Ollama logs.** Some MLX runtime packages can lack the constrained-output library. This app uses normal text responses. Do not infer schema guarantees from a successful chat.

**No web citations.** Browser search opens a search URL only. The app does not read results and cannot verify citations. Image generation/editing is also outside this preview.

**Uninstall.** Quit and remove the app. Ollama and downloaded models are separate installations and remain available to other clients. App setup preferences are stored in its UserDefaults domain; prompts and responses are not persisted by this app.

## Apple on-device setup

Choose Apple on-device in the sidebar. On a compatible Mac, enable Apple Intelligence in System Settings and allow the system model to finish preparing. Pebble reports model readiness and keeps unavailable states visible. The App Store configuration requires macOS 26 and exposes only this engine; it does not offer image questions or ask users to install Ollama.

## Movable workspace

Drag the standard title bar or empty window background. Resize from the edges, use Window → Minimize/Zoom, or close the window and reopen from the Dock/menu bar. Size and position are saved automatically. Microphone capture stops when the app loses focus or the window closes.
