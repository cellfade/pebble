# Store submission checklist

Pass 3 · 29 October 2026. No account record, upload, agreement, price, or submission action was performed. This is a gate list, not a claim of Apple approval.

## Artifact and configuration

- [x] Source target has `APP_STORE`, minimum macOS 26, Apple-only visible engine, no Ollama installer/image UI, Store plist and sandbox entitlements.
- [x] Source entitlements omit network-client/server, automation, screen capture, and broad filesystem access.
- [x] Icon catalog has ten Mac slots with expected pixel sizes 16 through 1024; source catalog/reference are present.
- [x] Manifest declares UserDefaults CA92.1 and displayed disk-space 85F4.1; review data paths against both reasons.
- [x] Actual unsigned Store archive succeeded in clean-runner CI40976673954 for source5f7a043, pinned Xcode26.3/SDK26.2. Checker read `Products/Applications/Pebble.app`; logs and archive/JSON artifacts are available. This is not signed distribution or a result-bundle validation.
- [x] Actual unsigned archive checker reports minOS26.0, numeric version0.3.0/build4, arm64 executable, compiled Assets.car and packaged no-tracking/no-collection privacy manifest.
- [x] Downloaded source5f7a043 archive inspected: bundleID io.github.cellfade.pebble, application archive path/type, packaged PNG/PDF, CA92.1/85F4.1, arm64 Mach-O minOS26.0 and FoundationModels linkage. Enhanced checker JSON is stored alongside the downloaded archive.
- [ ] Inspect actual signed entitlements/provisioning and visually verify final icon renditions; unsigned artifact checks do not satisfy those gates.
- [x] Source removes Store beta/developer-preview copy, macOS14 setup copy, and image suggestion in the empty state. Store displays 0.3.0; plist is 0.3.0/build4. Runtime screenshots and archive matching remain separate gates.
- [x] Source includes Privacy Policy/Support links in Setup and More, independent of model availability.
- [x] Live public privacy text now reflects byte limits, Apple engine and diagnostic-sharing boundaries, as verified on29October.
- [ ] Verify link behavior in the actual Store app and replace the issues-only support destination with a page displaying the owner’s verified contact.
- [ ] Guard intended Apple-only runtime paths; validate no user flow reaches a loopback model request. A network entitlement omission alone is not runtime-path testing.
- [x] Both unsigned and signed archive scripts fail early without full Xcode or when selected Xcode major is below26. CI explicitly pins stable26.3/SDK26.2; unsigned validation remains separate from signed distribution. No automatic provisioning updates are enabled.

## Owner/account gate

- [ ] Owner confirms Apple Developer team/account standing, role, registered bundle ID/control, app name availability, copyright, pricing, countries, trader status, and applicable agreements. Zero local signing identities does not establish whether membership exists.
- [ ] Owner supplies review contact and a real support/privacy contact; approve correspondence retention/deletion text.
- [ ] Public stable privacy/support URLs work without authentication and contain no placeholders. Support URL includes actual required contact information. In-app links match.
- [ ] Owner completes age-rating/content questionnaire for generative text and browser navigation, export-encryption assessment, content rights, and regional disclosures. Do not fabricate answers or accept agreements by automation.
- [ ] Register or confirm App Store Connect record and matching bundle ID only under the owner's account workflow. None created in this pass.

## Signing and actual-device acceptance

- [ ] Distribution signing identity/profile/team configured. Signed App Store archive validates in Organizer; inspect actual signed sandbox and permitted entitlements.
- [ ] Test signed Store app on another compatible Mac, current shipping OS, minimum supported OS where feasible, and Apple Intelligence disabled/preparing/unsupported states.
- [ ] Verify typed first task without voice permission; mic/speech denial, recovery, unsupported on-device language, stop, timeout and window-close behavior.
- [ ] Repeat clipping/composer regression after mode changes, send/cancel/error, long text, approval sheet, resize/move, minimum viewport, light/dark, larger text, Reduce Transparency/Motion.
- [ ] Keyboard-only and VoiceOver task completion. Confirm approval destination is readable, Cancel has no effect, one approval triggers one reviewed action, no stale approval reuse, no unexpected Mac-summary sharing.
- [ ] Physical shortcut from Safari/another app, competing shortcut behavior, menu-bar fallback, close/reopen/quit.
- [ ] System clock authoritative within a stated tolerance; bounded context disclosed and Clear starts fresh; model errors do not lose drafts.

## Store media and metadata

- [ ] Use actual Store-build screenshots, with text-only Apple route and no developer-preview/Ollama/image controls. Current 990×758 direct-beta captures are evidence, not submission-sized Store assets.
- [ ] Prepare 16:10 Mac screenshots at 1280×800, 1440×900, 2560×1600, or 2880×1800. Capture/frame the actual Store app without distorting UI. Do not invent features or use the brandboard as a product screenshot.
- [ ] Metadata, review notes, privacy answers and URLs match the exact candidate; no placeholders, unsupported promises, or beta/trial Store positioning.
- [ ] Only claim accessibility features after their actual evaluation. No accessibility nutrition-label claim inferred from source labels or screenshots.
- [ ] Complete review access notes: no account needed, eligible model hardware/OS, optional permissions, exact bounded action behavior. Include reachable reviewer contact.

## Final human-controlled submission

- [ ] Owner reviews and confirms legal/commercial answers and final metadata.
- [ ] Upload signed validated build; wait for processing and resolve validation issues; choose correct version/build.
- [ ] Use TestFlight for further beta distribution; App Store release must be complete, not a labeled demo/trial.
- [ ] Final review of screenshot/description/permissions, then submit for App Review under the authorized account workflow. Record receipt/status, not an assumed outcome.
- [ ] Release only after approval under the chosen release control. Developer ID notarization for direct download is a distinct route; it does not substitute for Store signing/review.

Sources checked 27 October 2026: [Review Guidelines](https://developer.apple.com/app-store/review/guidelines/), [Mac screenshot specification](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications), [privacy labels](https://developer.apple.com/app-store/app-privacy-details/), [age rating](https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating/), [export assessment](https://developer.apple.com/help/app-store-connect/manage-app-information/overview-of-export-compliance/). Apple makes the final review decision.

Final candidate source must have its own successful CI/archive run. Run40976673954 establishes source5f7a043 only; the subsequent UI refactor requires matching verification before any release claim.

Final frozen source c6d1c42 now has its own successful archive/build/test CI: https://github.com/cellfade/pebble/actions/runs/40977818709 . Local inspection of that downloaded final archive also passed. The earlier source5f7a043 proof is retained as historical evidence, not substituted for the final run. Signing/account/manual gates above remain unchanged.
