# Pebble — three-pass quality gate

Reviewed 29 October 2026 (America/Denver). User limit: stop when the quality gate reaches at least 8/10, or after three passes. **Three passes completed; gate not met. Further review iterations stopped.**

## Decision

| Review | Final score | Decision |
|---|---:|---|
| Source reliability / safety / code / test coverage | 8.0/10 | Scoped source gate met |
| Observed native UX and UAT | 7.9/10 | Below target; not rounded up |
| App Store submission readiness | 6.1/10 | Hard gates remain blocked |

A source score does not establish the complete product or Store gate. We do not average away a failing UX score, untested accessibility paths, or missing signing/account prerequisites. These are agent review scores based on the evidence below, not independent certification.

## Pass record

1. [Pass1 code](quality/PASS-1-CODE.md): 7.3/10. Fixed inference redirects, oversized input/context, cross-surface dictation lifecycle, and mutable Save response content. Store-specific copy and privacy/support access were corrected.
2. [Pass2 code](quality/PASS-2-CODE.md): 8.0/10. [Pass2 UX](quality/PASS-2-UX.md): 7.1/10. Reproduced compact-window overflow when an input error and expanded receipt coexisted. [Store](quality/PASS-2-STORE.md): 4.8/10.
3. [Final code](quality/PASS-3-CODE.md): 8.0/10. [Final UX](quality/PASS-3-UX.md): 7.9/10. Fixed variable response content scrolling, feedback visibility and dark-mode control contrast; actual Send and Approve states inspected. [Final Store review](quality/PASS-3-STORE.md): 6.1/10 after actual unsigned Xcode archive validation. This final pass included focused repair checks; no fourth review pass was started.

## Accepted evidence

- [Compact error and expanded receipt](media/quality/pass3-01-compact-error-fixed.png): header/composer/footer remain visible.
- [Dark Send controls](media/quality/pass3-12-accepted-dark-send.png), [dark approval](media/quality/pass3-13-accepted-dark-approval.png), [light Send](media/quality/pass3-14-accepted-light-send.png): repaired contrast states.
- [1280×800 Store-configuration response](media/quality/pass3-16-store-response-1280x800.png): genuine app capture; short rewrite completed. This is an ad hoc Store-conditional test app, not the signed submission binary. Recapture/confirm against the signed build before upload.
- Final frozen-source backend/input suites passed from a temporary source copy outside FileProvider-managed Documents. This avoided the observed input-file-modified build interruptions without changing source content.

## Remaining gates

- Keyboard-only/VoiceOver task completion; speech permission denial/recovery and unsupported locale; physical Control-Space dispatch and conflicts; fresh-Mac/minimum-OS acceptance.
- Broader Apple-model task quality. Longer general/creative requests produced refusals; short welcome/rewrite tasks succeeded. Do not promise unrestricted knowledge or creative ability. Live cancellation coverage remains incomplete; deterministic cancellation fixtures pass.
- Verified owner team/bundle/account role, actual support contact and legal/commercial metadata; distribution signing/provisioning; Organizer validation and signed-device tests; App Store Connect processing and submission.
- Local toolchain check still reports Command Line Tools, no full Xcode app and zero valid signing identities. This does not establish whether the owner has Apple Developer membership.

## Submission handoff

[Store checklist](store/SUBMISSION-CHECKLIST.md), [metadata](store/METADATA.md), [privacy-answer draft](store/PRIVACY-ANSWERS.md), [review notes](store/REVIEW-NOTES.md), and [support-page draft](store/SUPPORT-PAGE.md) are prepared. Placeholder owner/contact/legal fields must not be published as final answers.

CI validates an unsigned `AppStore` archive using Xcode26.3 and checks the actual application archive, arm64/macOS26 deployment, compiled assets, avatar/menu mark, privacy reasons and declared entitlements. Unsigned validation is not distribution signing, Organizer validation or Apple acceptance. Final source/artifact provenance is appended after CI completes.

## Final artifact provenance

Final app source is `c6d1c4277a637c82b02e3016c05c40df95ea5320`. [CI40977818709](https://github.com/cellfade/pebble/actions/runs/40977818709) passed both the direct build/tests/package job and the unsigned Store archive job. The downloaded final archive at `dist/ci-store-final-c6d1c42/Pebble-Unsigned.xcarchive` passed the actual-archive/resource/privacy/deployment checker locally as well. It remains unsigned and not submittable.

[Beta2](https://github.com/cellfade/pebble/releases/tag/v0.3.0-beta.2) ships the reviewed fixes as an explicitly unnotarized developer preview. ZIP integrity, extracted strict/deep signature and checksum passed; SHA-256 `6ad8336262f5ebf7c3b88bd68bbb72912da4490c62c782e8972a43228192b72b`. Publication does not override the failed full-product quality gate or Store blockers. No fourth review pass or Apple submission occurred.
