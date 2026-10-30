# Pass 3 — final Store submission gate

Reviewed 29 October 2026, America/Denver. This is the **third and final review pass** in the requested cycle. It evaluates Store submission readiness separately from product UX/code quality. No Apple account record, agreement, pricing choice, upload, or submission was performed.

## Result and scores

Actual unsigned Store archiving and artifact inspection now pass. **App Store submission remains blocked**, because the archive is unsigned and owner/account, support contact and signed-device acceptance gates remain open.

| Area | Weight | Pass 2 | Final pass / 10 | New evidence / remaining limit |
| --- | ---: | ---: | ---: | --- |
| Store source/configuration | 30% | 8.5 | 8.5 | Edition copy, Apple-only controls, policy links and entitlements retain source evidence; signed archive script now rejects old Xcode. No unsupported completion credit. |
| Artifact/distribution validation | 25% | 3.0 | 8.0 | Actual clean-runner Xcode26.3 archive plus downloaded artifact inspection passes. Still unsigned: no provisioning, Organizer/export validation or Connect processing. |
| Metadata/privacy/support | 20% | 5.5 | 6.0 | Corrected policy is publicly readable; drafts match current byte budgets/build4. Verified owner contact, retention, rights/commercial answers and final metadata approval remain missing. |
| Owner/account prerequisites | 15% | 0.0 | 0.0 | Team/account role, bundle registration and distribution signing have not been verified. Zero local identities is observed, not a finding about membership. |
| Signed-device/manual Store acceptance | 10% | 3.5 | 3.5 | No signed Store device test or complete VoiceOver/permission matrix supplied to this reviewer. Other agents’ product UAT is tracked separately. |
| **Weighted Store readiness** | **100%** | **4.8** | **6.1** | Improved by real artifact and published-policy evidence. Submission hard gates still fail; an 8/10 product score cannot override them. |

Weights are unchanged from pass2. Final score is 2.55+2.00+1.20+0+0.35 = **6.10**. No fourth pass is recommended merely to re-score unchanged external prerequisites.

## Independently verified CI and downloaded archive

[CI40976673954](https://github.com/cellfade/pebble/actions/runs/40976673954) reports success for both `build` and `store-archive`, head **5f7a043ffdca377dd669428961db2a4c7fa07ee6**. The direct job passed build, offline tests, beta tests and packaging. The Store log reports Xcode26.3, SDK26.2, `-DAPP_STORE`, arm64 macOS26.0 and **ARCHIVE SUCCEEDED**. The actual project’s `actool` compilation and resource-copy steps ran; this is materially stronger than the previous standalone conditional compile.

Downloaded artifact: `dist/ci-store-5f7a043/Pebble-Unsigned.xcarchive`. This reviewer read its archive Info.plist, app Info.plist, sibling enhanced validation JSON and binary linkage:

- Application archive path is `Applications/Pebble.app`; archive version2 and scheme Pebble.
- BundleID `io.github.cellfade.pebble`, numeric version0.3.0, build4; SDK26.2 / Xcode2630 metadata.
- Actual executable architecture arm64 and Mach-O minimum macOS26.0 verified by the enhanced checker.
- `Assets.car`, nonempty AppIcon.png/MenuBarMark.pdf and packaged privacy manifest verified. The manifest includes UserDefaults CA92.1 and DiskSpace85F4.1, with no tracking or collected data types.
- `otool -L` independently confirms FoundationModels, SwiftUI and AppKit linkage.
- Archive `SigningIdentity` and `Team` are empty. JSON status is **unsigned_not_submittable**. Declared sandbox/no-network entitlements are source checks; there is no actual distribution signature to inspect.

The enhanced post-download check is distinct from the narrower original CI checker. Asset presence does not establish visual icon quality, signed runtime behavior or App Review acceptance.

## Public policy and drafts

The [published policy](https://raw.githubusercontent.com/cellfade/pebble/main/docs/PRIVACY.md) now states redirect refusal, current 2,048/2,304-byte request/context limits, Apple engine and Apple-only Store configuration, no developer analytics, and separation of Mac diagnostics from chat model/sharing paths. The old context description has been removed. It was retrieved publicly without authentication on29October.

The in-app Support destination is still the public GitHub issues list. No verified owner contact/retention policy has been supplied; draft placeholders must not be published as final Store metadata. Apple’s [platform version reference](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information/) requires actual contact information at the support destination. The owner must approve a real public support/privacy contact and correspondence policy, together with review contact, rights-holder, name availability and legal/commercial answers.

Store metadata, privacy answers, review notes, support structure and submission checklist remain concrete editable drafts. They are not submitted Connect records. No app screenshot or app-preview upload has occurred in this audit.

## Final candidate boundary

The verified archive above belongs to **source5f7a043**. A later compact-UI/accessibility-announcement refactor was reported by the release owner; it requires its own successful matching CI/archive before final-source claims. This follow-up verification belongs to this final pass, not an extra design/review iteration. Do not attach the old green badge to changed source.

## What remains before submission

1. Owner-selected Apple Developer team/role, registered bundle ID, signing identity/profile and matching Store record; review/support contact, rights, pricing/territories and required questionnaires/agreements.
2. Signed AppStore archive, actual signed-entitlement/provisioning inspection, Organizer/export validation and successful Connect processing for the exact final candidate.
3. Signed Store testing on another eligible Mac, unavailable/disabled/preparing Apple model states, fresh speech permission denial/recovery, physical global shortcut/conflicts, keyboard-only/VoiceOver and accessibility settings. Preserve the existing clipping/draft/approval regressions.
4. Actual final Store UI screenshots at accepted Mac dimensions; accurate metadata and policy/support URLs with no placeholders; owner’s final review before submission.

The local lack of full Xcode is no longer a blocker to **unsigned CI archiving**. It remains a local signed-distribution workflow prerequisite unless the owner configures an appropriate controlled signing environment. No credentials should be pasted into the repository or report.

Apple’s [Review Guidelines](https://developer.apple.com/app-store/review/guidelines/) remain the governing review source; the GitHub developer prerelease is not Store approval. At this third-pass stop, report preparation complete to the available evidence and name the remaining gates, rather than claim a submitted or accepted app.

## Reviewer actions

Read-only source, CI logs, downloaded artifact metadata and public-policy checks. Updated this report and `docs/store/*` only. No CUA, source/CI/project edits, external mutation or Apple account/submission action.

## Final artifact provenance

Final app source is `c6d1c4277a637c82b02e3016c05c40df95ea5320`. [CI40977818709](https://github.com/cellfade/pebble/actions/runs/40977818709) passed both the direct build/tests/package job and the unsigned Store archive job. The downloaded final archive at `dist/ci-store-final-c6d1c42/Pebble-Unsigned.xcarchive` passed the actual-archive/resource/privacy/deployment checker locally as well. It remains unsigned and not submittable.

[Beta2](https://github.com/cellfade/pebble/releases/tag/v0.3.0-beta.2) ships the reviewed fixes as an explicitly unnotarized developer preview. ZIP integrity, extracted strict/deep signature and checksum passed; SHA-256 `6ad8336262f5ebf7c3b88bd68bbb72912da4490c62c782e8972a43228192b72b`. Publication does not override the failed full-product quality gate or Store blockers. No fourth review pass or Apple submission occurred.
