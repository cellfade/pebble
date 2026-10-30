# Pass 2 — independent App Store submission review

Reviewed 29 October 2026, America/Denver, against the current working tree: Store display version **0.3.0**, bundle build **4**, Apple-only configuration. This is a submission-readiness assessment, **not the product design score**, an Apple approval prediction, or proof of a signed archive. No Apple account records were created or inspected, agreements accepted, builds uploaded, or submission made.

## Scored gate

| Area | Weight | Score / 10 | Evidence and limit |
| --- | ---: | ---: | --- |
| Store source/configuration | 30% | 8.5 | Corrected edition copy, text-only surface, availability messages, sandbox entitlements and visible policy/support controls. Actual archived settings and Apple-only runtime acceptance remain open. |
| Artifact/distribution validation | 25% | 3.0 | Xcode project and conditional source compile have prior evidence; actual full-Xcode unsigned Store archive is being prepared by release owner. No signed archive, provisioning, Organizer validation or Connect processing evidence supplied in this review. |
| Metadata/privacy/support | 20% | 5.5 | Concrete drafts prepared and source reconciled. Owner contact/retention/copyright and legal/commercial decisions remain placeholders. Public policy link needs the local corrections published; issues-only support destination does not establish the required contact page. |
| Owner/account prerequisites | 15% | 0.0 | No verified account/team, bundle registration, signing/profile or review contact provided to this reviewer. Zero local signing identities is observed; it does not prove the owner lacks membership. Unknown gates receive no completion credit. |
| Signed-device/manual Store acceptance | 10% | 3.5 | Existing direct-beta interaction evidence is useful but does not cover signed Store install, Apple model unavailable states, fresh speech permissions, VoiceOver or the full accessibility matrix. |
| **Weighted Store readiness** | **100%** | **4.8** | Submission hard gate remains **blocked**. A product UX/code score above 8 cannot override these missing prerequisites. |

The score is rounded from 4.75. Re-score only when new artifact, account or manual acceptance evidence exists; do not inflate it merely because source looks sound.

## Repairs verified in source

- Store `Product.version` is numeric 0.3.0 and edition label is “On-device edition”; the direct edition retains separate developer-preview wording.
- Store Setup says macOS 26+ / Apple Intelligence required, hides the optional Ollama installer path, and has Privacy Policy and Support links independent of model readiness.
- Store navigation hides Image questions, the attachment button is gated, the empty state suggests questions/drafts rather than images, and Actions no longer introduces itself as a beta.
- Store entitlements contain app sandbox, audio input and user-selected read/write files. They omit network-client/server, automation, broad file access and screen capture.
- Privacy manifest declares UserDefaults CA92.1 and displayed disk-space 85F4.1, with no tracking or collected data types. The diagnostic action result remains separate from chat history and generic response sharing; no new off-device diagnostic workflow should be added under that reason without reassessment.
- New conservative model-input limits are 2,048 UTF-8 bytes per current request and 2,304 combined current/context bytes. Up to four recent turns are shortened to 192 user / 320 assistant bytes; eight session turns remain in memory. The Store draft copy now matches this behavior. This is a byte budget, not an exact token count.

These are read-only source findings. They do not establish that the intended entitlements/resources are present in a signed export.

## Remaining actionable gates

| Priority | Gate | Concrete next evidence |
| --- | --- | --- |
| P1 | Real Store archive | Select stable full Xcode 26+ explicitly; archive the AppStore scheme with actual `actool` resources. Validate minimum OS, architecture, bundle/version/build, executable, Assets.car/icon, PNG/PDF, privacy manifest, FoundationModels linkage and archive type. Source compile or `xcodebuild -list` is insufficient. |
| P1 | Apple-silicon distribution | The reviewed project had no explicit Store ARCHS restriction. Inspect effective build settings and binary; prefer an arm64 Store artifact consistent with eligible Apple Intelligence hardware. A host-default x86_64-only artifact would not deliver the promised model experience. This is an identified validation risk, not a proven shipped failure. |
| P1 | Support contact | Current `Product.supportURL` is the public GitHub issues list. It loads unauthenticated, but no actual owner contact information was established there. Owner supplies a verified contact and public support page; do not invent an email or publish draft placeholders. |
| P1 | Public policy reconciliation | Live public policy still showed old context limits during this review. Release owner subsequently reported local byte-budget and diagnostic-sharing corrections. Publish and verify the actual linked page; lead with the Apple Store edition for clarity. Owner-defined support correspondence retention/deletion and privacy contact still need confirmation. |
| P1 | Signed acceptance | Test the signed Store candidate on another eligible Mac, including model unavailable/preparing/disabled, typed use without mic permission, speech denial/recovery, keyboard-only/VoiceOver, reduced transparency/motion, minimum-window post-interaction layout and exact approval denial/dispatch. |
| P1 | Account and final submission | Owner verifies team/role, registered bundle ID, signing/profile, Store record, review contact, name rights/availability, copyright, price/territories, content age/export assessments and applicable agreements. No credential or legal answer is fabricated here. |
| P2 | Store media | Capture the actual Store UI at an accepted 16:10 Mac size. Direct-beta screenshots and the sampled screenshot video are audit/demo evidence, not automatically Store-ready media. No screenshot or app-preview upload has occurred. |

No source/configuration P0 was established in this scoped audit. Missing submission prerequisites remain hard blockers rather than downgraded product defects.

## Current primary-source checks

Checked 29 October 2026:

- [Apple Review Guidelines](https://developer.apple.com/app-store/review/guidelines/): Store releases must be complete; beta testing uses TestFlight. Privacy policy access must exist in-app and in metadata. This supports keeping preview distribution and Store release separate.
- [Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information/): the support URL must expose actual contact information. The current issues link is therefore a preparation channel, not a completed support gate.
- [Mac screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/): Mac uses 16:10, with 1280×800, 1440×900, 2560×1600 or 2880×1800 options.
- [App Privacy Details](https://developer.apple.com/app-store/app-privacy-details/): processing solely on-device is not collection; off-device derived information requires separate assessment. The proposed no-collection answer remains conditional on the exact final artifact/services and owner review.
- [Official macOS 15 runner inventory](https://github.com/actions/runner-images/blob/main/images/macos/macos-15-Readme.md): lists Xcode 26.3 at `/Applications/Xcode_26.3.app`, macOS SDK 26.2, while default Xcode is 16.4. The owner’s CI must select the supported toolchain and fail if absent rather than silently skip the Store gate. Hosted archive validation cannot establish model readiness or signed-device behavior.

No unmodified long source excerpt is used. Apple makes the final review decision. The default Foundation Models guardrails and absence of public social accounts/feed should be explained accurately; owner must still assess content/age safeguards against the final experience rather than assume a blanket exemption.

## Prepared handoff

Updated `docs/store/METADATA.md`, `PRIVACY-ANSWERS.md`, `REVIEW-NOTES.md`, `SUBMISSION-CHECKLIST.md` and `SUPPORT-PAGE.md` to reconcile build4, conservative context budgets, visible links and remaining owner gates. Corrected the keywords byte count to 72. `CI-VALIDATION.md` remains a proposed full-Xcode route until the release owner provides an actual run result.

No source/project/CI edits, CUA actions, external mutations or App Store account actions were performed by this reviewer.
