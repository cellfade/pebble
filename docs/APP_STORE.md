# Mac App Store readiness

Pebble now has an App Store-oriented configuration. It is **not yet submission-ready or approved**.

## Architecture

- Direct-download preview: macOS 14+, optional Apple on-device engine on macOS 26+, and optional local Ollama engine with images.
- `AppStore` configuration: macOS 26+, Apple `SystemLanguageModel.default` only. No Ollama download link, external runtime model picker, or image attachment surface. It requires a compatible Apple Intelligence Mac with the on-device model ready. No Private Cloud Compute model is instantiated.
- The direct preview is sandboxed: microphone/audio input, user-selected read/write files, and network-client access for loopback Ollama. The App Store entitlements omit network-client access. Neither build installs services, writes model weights into shared locations, runs installers, or changes system shortcuts.

Apple’s [Mac App Store requirements](https://developer.apple.com/app-store/review/guidelines/#hardware-compatibility) require sandboxed, self-contained apps packaged with Xcode technologies. A required third-party Ollama installation is a review risk; the standalone Apple engine is the store path. Apple makes the review decision. Review any model, platform, naming, intellectual-property, and app-availability requirements before submitting.

## Project and archive

Open `Pebble.xcodeproj` in **full Xcode 26+**, select the Pebble target, and choose your own Apple Developer team. The shared scheme archives using the AppStore configuration. Inspect the bundle identifier, capabilities, privacy manifest, version, and app icon. Register a bundle identifier and App Store Connect record that you control.

```sh
TEAM_ID=YOUR_TEAM_ID ./script/archive_store.sh
```

The script creates `dist/Pebble.xcarchive`. It does not upload or submit. Validate and distribute from Xcode Organizer after reviewing the generated archive. Resources/AppStore-ExportOptions.plist is provided for a future export workflow. No team IDs, signing identities, profiles, or App Store Connect credentials are committed.

## What was verified

- Apple on-device availability and a live APPLE_OK generation on the development Mac.
- Direct preview builds and launches with App Sandbox entitlements in the actual signature.
- On-device voice dictation and a resulting local response observed in the sandboxed app.
- Xcode project/plists parse; App Store conditional source path is compiled separately.
- Source preview CI builds, offline checks, and packaging are exercised on GitHub.

Full Xcode is absent on the development Mac, so an actual App Store archive/export, provisioning validation, upload, and App Review submission have not been performed. GitHub project validation is tracked separately; a plist parse alone is not an archive validation.

## Remaining submission gates

1. Apple Developer account, team, registered bundle ID, distribution signing certificate, provisioning, and App Store Connect record.
2. Archive with full Xcode 26+, inspect entitlements/resource/icon/privacy contents, validate in Organizer, and test a signed build on another eligible Mac.
3. Verify Apple Intelligence disabled/not-ready/ineligible states, microphone/speech permission denial and recovery, file picker/save/share, keyboard shortcuts, VoiceOver, Reduce Transparency/Reduce Motion, and light/dark/short-screen states.
4. Verify physical Control-Space dispatch in another app and conflict behavior; registration success alone is insufficient.
5. Prepare App Store-sized screenshots from the actual Store build, support/privacy URLs, age/content rating, accurate metadata, and reviewed privacy answers. Current developer preview media can show optional Ollama features and must not be uploaded as Store screenshots without checking the Store build.
6. Review app-name availability and final branding before claiming exclusivity; the owner chose Pebble as the product name, not a name-clearance conclusion.
7. Add review notes explaining that the Apple engine is on-device, how to enable/prepare it, and exactly which hardware/OS are needed. Do not give reviewers instructions to disable system security or install another executable.

## Draft review notes

Pebble is a native text assistant using Apple’s on-device Foundation Models API. It does not download executable code or require Ollama in this configuration. Launch, select Use Apple on-device on the setup screen, then type a short prompt and press Enter. Dictation is optional and asks for microphone/speech permission only when started. Text stays in process memory and is not collected by the developer. Share, save, and browser search require explicit user actions. AI output may be incorrect. Final metadata must match the signed archive actually submitted.
