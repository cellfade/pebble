# Beta verification report

Verified October 28, 2026 at approximately 04:21 UTC (October 27, America/Denver), against working-tree sources based on commit `a0c6240`. This report records backend checks and source review; it does not independently certify the release ZIP or all manual UAT.

## Fresh automated evidence

The following scripts ran sequentially from the repository and each completed with exit code **0**:

| Check | Verified result |
| --- | --- |
| `./script/test_beta.sh` | Authoritative clock/time-zone fixtures and intent boundaries; bounded recent context; action-kind/URL/credential/control-character validation; transactional drafts, follow-up context, clear, failure and cancellation; approval identity, denial, expiry, exactly-once dispatch and action failure. |
| `./script/test_offline.sh` | Enter/newline/input-composition behavior; remote-model metadata rejection; loopback-only model destination; local chat request handling; HTTP failure; refusal of images on a nonvision model. |

The beta tests use fake model/executor fixtures. The offline suite uses local test fixtures. Neither result establishes live Safari behavior, real Mac diagnostics, microphone permissions, global keyboard dispatch, or hardware model availability.

Each script’s first attempt reported an input-file-modified-during-build error from Swift; immediate reruns succeeded. No review-agent edits occurred during either build. File-provider metadata churn is a suspected explanation, not a proven diagnosis. The successful runs compiled directly from this repository; no temporary source copy was used.

## Final bounded-action source review

The current `planAction()` clears pending approval before validating a replacement request, closing the stale-plan issue recorded earlier in `ACTION-REVIEW.md`. Typed action parsing restricts dispatch to browser search, an explicit HTTPS URL, or a limited read-only Mac capacity summary. Explicit destinations proposed by a model must occur in the user’s request. Matching approval consumes the immutable proposal; expiry and execution checks precede dispatch. Model output does not grant execution permission.

Action results stay separate from chat answers. Regression checks confirm success and failure preserve the prior chat answer/prompt association, failure preserves the prior action result, and Clear removes diagnostic output. Approval commits an external effect; Cancel does not promise to reverse an already approved browser launch.

No additional P0 backend regression surfaced in these checks. This is a scoped finding, not a blanket security or release-readiness claim. Four-turn character limits still need token-aware budgeting; model planning is not fully exercised through an injected planner; approval expiry uses wall time. HTTPS validation does not certify destination safety.

## Capability limits and manual gates

- Browser search opens Safari after approval. Pebble does not retrieve results, read pages, follow links, or produce verified web citations. Queries and URLs leave the computer through the browser.
- The Mac review is a basic capacity/time summary, not a malware scan, process inspection, file audit, or performance benchmark. No arbitrary shell or app-control executor is present.
- Image questions depend on an installed compatible Ollama vision model in the direct edition. Image generation/editing remains deferred. Apple-only Store configuration has a narrower capability set.
- Conversation context is bounded and in memory; persistent local history/retrieval and unrestricted automation are future work.
- Manual final-build acceptance remains necessary for post-interaction clipping, compact/expanded windows, long approval/error states, physical Control-Space and conflicts, dictation permission recovery, VoiceOver, and reduced-motion/transparency states. Existing screenshot evidence is described in `UX-UAT.md`; these automated runs do not replace it.

## Store and distribution blockers

This can only be labeled a developer preview until its actual artifact and manual gates are checked. Existing distribution documentation identifies ad hoc signing and no notarization; these scripts do not change that status.

App Store submission still requires full Xcode 26+, an owned Apple Developer team/bundle ID and App Store Connect record, distribution signing/provisioning, an actual archive and Organizer validation, and a signed-build test on another eligible Mac. Finish Apple-model unavailable/disabled states and OS permission/accessibility coverage. Prepare screenshots from the actual Store build, support/privacy URLs, ratings and accurate privacy answers. Confirm final name availability and review notes. A project scaffold, parsed plist or green standalone test cannot establish App Review acceptance.

## Release-owner integration acceptance

The final debug app was built and launched after the theme, approval-expiry and vision-selection updates. The release owner inspected light appearance, submitted a Tokyo clock request with Enter, and captured the resulting fully visible header, composer, answer and footer in `media/08-beta-light-interaction.png`. Earlier accepted current-beta captures show rewrite completion, denial and approval. Safari was separately inspected after approval and displayed the exact DuckDuckGo query `Apple accessibility documentation`; no page content was ingested. This is scoped manual evidence, not full accessibility or installation acceptance.

All current Swift sources also compiled successfully with `APP_STORE` defined, Swift language version 5, and an arm64 macOS 26 target. This verifies conditional source compilation only; it is not an Xcode archive, provisioning or Organizer validation. The Xcode project has been regenerated to include the new action and clock files and passes plist syntax validation.

The release-mode ZIP `Pebble-0.3.0-arm64-beta.1.zip` was then built, its SHA-256 verified, ZIP integrity checked, and extracted into a temporary directory. The extracted bundle passed strict/deep codesign verification and reported `io.github.cellfade.pebble`, version `0.3.0`. Its signature remains ad hoc; verification is not notarization or fresh-Mac launch evidence.

## Published prerelease

[0.3.0-beta.1](https://github.com/cellfade/pebble/releases/tag/v0.3.0-beta.1) is published as a prerelease, with ZIP, checksum and sampled demo. [Clean-runner CI](https://github.com/cellfade/pebble/actions/runs/40632055769) passed project validation, build, offline checks, beta regression checks and packaging. The tag resolves to `9d209607ecf74706cc34e4dfbf3b867512975567`. GitHub reports the uploaded ZIP SHA-256 `5ef5329dc00611bb255b8199f023fe31570965d40f4fd82544f02ae35a0c7df6`, matching the local verified artifact.

The packaged release was restarted locally and successfully answered an Enter-submitted London clock request. This uses the existing machine permissions/defaults; fresh-Mac acceptance remains open. Milestone 0.3 beta is complete at this developer-preview scope. [Later milestones](https://github.com/cellfade/pebble/milestones) remain open with explicit acceptance criteria; neither the full North Star roadmap nor Store submission is claimed complete.
