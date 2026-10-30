# Pass 2 — independent code and safety review

Reviewed 29 October 2026 (America/Denver), current working tree based on `36960a9`. This follows the fixes identified in [Pass 1](PASS-1-CODE.md). Scope is implementation and standalone regression checks. No native UI interaction, real microphone capture, network redirect integration server, SwiftPM build, signed Store artifact, or App Store submission was exercised by this reviewer.

## Scores

| Dimension | Score / 10 | Reason |
| --- | ---: | --- |
| Reliability | 8.0 | Current requests fail intact at an explicit UTF-8 input limit; recent context is dropped to a combined budget; output reserve is reduced; transactional drafts and approvals remain regressed. Framework cancellation and multimodal context fit still require live testing. |
| Privacy / safety | 8.7 | Inference requests reject redirects before following them; proxies remain disabled; model metadata is checked; operation boundaries stop capture; reviewed typed actions remain one-use and bounded. No finding of off-loopback transmission or unapproved execution occurred. |
| Code quality | 7.8 | Focused clients, immutable proposals, MainActor state and one shared budget are understandable. String mode/provider values, boolean state and concrete planner dependencies still make lifecycle reasoning harder than necessary. |
| Test coverage | 7.6 | Both fresh suites pass and cover meaningful request, draft, approval and input behavior. The redirect callback is directly exercised, not tested through a real controlled HTTP redirect server. Planner, voice lifecycle integration, save-panel timing and real Apple errors lack dedicated deterministic coverage. |
| **Overall code quality** | **8.0** | Arithmetic mean 8.025, rounded to one decimal. Meets the scoped implementation-quality threshold; does not certify full UX/accessibility or Store readiness. |

No unresolved P0 or P1 defect was found within the reviewed source boundaries. That is a bounded review result, not proof of absence. The product gate must also consider rendered UX/UAT findings and separate distribution hard gates.

## Fresh checks

Ran sequentially from the repository, with no reviewer source/test changes:

1. `./script/test_beta.sh` — exit **0**. Log: `work/pass2-code-beta.log` in the chat workspace. Passed clock/time-zone fixtures and intent boundaries; recent context and Unicode/input budget; action kind/URL/credential/control validation; transactional drafts, follow-up context, clear, failure and cancellation; matching/denied/expired approvals, exactly-once execution and executor failure.
2. `./script/test_offline.sh` — exit **0**. Log: `work/pass2-code-offline.log`. Passed Enter/newline/input-composition behavior, remote metadata refusal, fixed loopback request destination, 307/308 response refusal and redirect-delegate decision, local chat, HTTP failure and nonvision refusal.

These fixtures do not open Safari, collect the real Mac summary, grant permissions, or transcribe audio. The test output is green for the reviewed working tree; it is not a clean-runner CI or archive claim.

## Pass 1 fixes confirmed

| Finding | Current source evidence | Regression evidence and limit |
| --- | --- | --- |
| Redirect boundary | `OllamaClient.swift:2–7` returns `nil` in `willPerformHTTPRedirection`; `request` supplies that delegate via `data(for:delegate:)`, including injected test sessions. | Offline suite checks synthetic 307/308 HTTP refusal and exact delegate callback. No redirected request is resumed. A controlled real network redirect integration test is still desirable. |
| Unbounded prompt/context | `RequestBudget` limits current input to 2,048 UTF-8 bytes without truncating it; `ConversationTurn.context(_:prompt:)` bounds combined current/history text to 2,304 bytes and selects at most four recent shortened turns. Both clients use it; outputs are capped at 768 tokens. | Beta checks over-budget CJK input refusal, combined budget, intact Unicode, draft preservation and no dispatch. This is a conservative byte policy, not exact tokenizer accounting or a guarantee for image-token costs. |
| Voice across Actions | Store `onBeginOperation` is wired to `voice.stop()` at launch. Send, proposal, planning and approval call the hook. Sidebar navigation stops voice before switching; global shortcut moves Actions to the visible Chat composer before dictation. | Beta suite confirms chat operations call the hook. Source confirms remaining boundaries; the action-specific hook paths and actual indicator/transcript behavior still need manual/injected-service verification. |
| Mutable Save response | `AssistantView.saveResponse` captures `responseToSave` before opening `NSSavePanel`, then writes that immutable value in completion. | Source confirmed. No save-panel timing fixture was run; native save permission/error acceptance is separate. |

The current run receipt reports the count of budgeted turns used. A future receipt should also disclose how many older turns were omitted and whether text was shortened, rather than leaving users to infer completeness from a count.

## Remaining P2 improvements

1. **Action accessibility feedback.** `ActionCenterView.swift:13` still has an unlabeled action progress spinner, and action planning/completion/failure/cancel updates in `AssistantStore.swift:130–166` do not call the existing announcement helper. Add action-specific progress labels and concise announcements, then verify VoiceOver behavior, focus return and keyboard-only approval. Native labels and source inspection alone do not establish conformance.
2. **Planner lifecycle coverage.** `planAction` calls concrete clients instead of an injected planner. Add an injectable planning closure/protocol and test refusal, malformed JSON, unsupported kind, invented URL, replacement, cancellation and late result. Current parser/dispatch coverage is useful but cannot establish that full chain.
3. **Budget limitations.** The new limit sharply reduces text overflow risk and is explicit rather than silently changing the current request. It does not count actual model tokens, instructions/framing or image patch tokens. Use available native token accounting where supported; for image/context failures, retain the draft and offer a clear recovery path. Do not advertise a token-perfect fit guarantee.
4. **Live cancellation and deadlines.** Apple work checks cancellation after the framework response; no application deadline is set. A real slow Apple request should confirm Cancel/retry settles promptly on supported OS versions. If it does not, define a bounded timeout/state transition and regress it.
5. **Empty response handling.** Clients can return empty text as successful output. Consider classifying an empty/whitespace model answer as a recoverable failure so a user does not lose the request into an apparently successful blank result. This was not observed in the fresh fixtures.

## Manual and submission hard gates remain

Actual global Control-Space dispatch/conflicts; dictation denied/regranted/unsupported-language paths; VoiceOver navigation and announcements; input methods; high contrast and reduced transparency/motion; compact long-error/approval layouts; real model context exhaustion; first launch on another Mac; Apple Intelligence unavailable/not-ready states; actual signed Store build entitlements; full Xcode archive/Organizer validation; owner signing/provisioning; App Store metadata and submission are outside this code score.

The score is not an App Review prediction and should not be used to mark those gates passed. Existing browser-only policy, no arbitrary shell/files/messages, no fetched web citations, deferred image generation, and in-memory-only chat remain accurate scope limits.
