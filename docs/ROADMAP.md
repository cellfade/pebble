# Release board

## Sprint 1 · Foundation
- [x] Local text, rewrite, image understanding, and dictation
- [x] Global Control-Space registration, clipboard controls, native sharing
- [x] Keyboard composition handling and accessibility labels

## Sprint 2 · Product preview
- [ ] Name/icon direction selected by the owner
- [ ] SVG logo, app icon, menu bar mark, and brand kit
- [x] In-app setup guide and explicit model installation instructions
- [x] Repeatable app/ZIP packaging and build CI
- [ ] Public GitHub source and preview release
- [ ] Real application screenshots and demo video

## Sprint 3 · Public distribution
- [ ] Developer ID signing identity and Apple notarization credentials
- [ ] Signed, notarized, stapled public artifact
- [ ] Fresh-Mac setup/permission testing
- [ ] Physical global shortcut check outside the app
- [ ] VoiceOver and high-contrast/reduced-motion acceptance
- [ ] Image generation backend (deliberately deferred)

Definition of done: observable behavior checked, build and relevant tests pass, sources and media match the release, known limitations are visible, and no secrets or personal audit data are published. Model weights are never bundled. Preview and notarized release labels must remain distinct.
