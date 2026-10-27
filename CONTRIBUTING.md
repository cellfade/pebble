# Contributing

Keep the assistant small and local. Use a focused issue or PR with the trigger, resulting behavior, and relevant verification. Never attach credentials, personal prompts, clipboard contents, private images, or full system logs without review.

- Build: `./script/build_app.sh debug`
- Offline checks: `./script/test_offline.sh`
- Live checks: `./script/test.sh` (requires the documented Ollama models)
- UI: inspect light/dark states, keyboard composition, narrow/short screens, permissions, cancellation, and first launch.

SwiftUI owns visible state. AppKit bridges own status-item/popover and native text behavior. No networking outside loopback inference without an explicit product decision and clear user action. Public downloads must disclose their signing/notarization state. See docs/ROADMAP.md for the release board and docs/agent/ for design intent.
