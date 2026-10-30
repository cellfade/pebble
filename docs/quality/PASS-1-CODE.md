# Pass 1 — independent code and reliability review

Reviewed working-tree HEAD `36960a9`. Scope: source, standalone backend/input tests, safety boundaries and accessibility semantics. No GUI interaction, SwiftPM build, real Safari request, microphone capture, or Store archive validation was performed. This is an implementation-quality score, not an App Review prediction.

## Scores

| Dimension | Score / 10 | Evidence and limit |
| --- | ---: | --- |
| Reliability | 7.0 | Draft transactions, cancellation recovery, action identity/expiry and reset have passing fixtures. Context sizing and cross-surface dictation lifecycle remain weak. |
| Privacy / safety | 7.5 | Typed actions require approval; action results are separate; local model metadata checked; dictation requires on-device recognition. URL redirects are not constrained, and ongoing dictation is not coordinated with Actions. Store entitlement restrictions reduce network exposure in that edition. |
| Code quality | 7.5 | Small understandable files, MainActor store, immutable proposals and injected chat/executor dependencies. Planning bypasses injection; string-valued mode/provider state and multiple booleans allow inconsistent transitions. |
| Test coverage | 7.0 | Two meaningful offline suites pass; input composition, local metadata, failures and approvals are covered. Planner lifecycle, redirects, voice state and Apple context exhaustion lack deterministic coverage. Manual accessibility remains unknown. |
| **Overall code quality** | **7.3** | Below an 8/10 gate until the actionable reliability/privacy gaps below are corrected and regressed. |

## Fresh verification

Executed sequentially, from the repository:

1. `./script/test_beta.sh` — exit **0**. Passed clock/time-zone fixtures and clock-intent boundaries; recent context limits; action kind/URL/credential/control validation; transactional drafts, follow-up, reset, failure and cancellation; matching/denied/expired approvals, exactly-once dispatch and execution failure.
2. `./script/test_offline.sh` — exit **0**. Passed Enter/newline/composition, remote metadata, initial loopback destination, local chat request, HTTP failure and nonvision refusal.

No input-modified warnings occurred in these fresh runs. Existing tests passing does not cover the defects below. No production or test edits were made by this reviewer.

## Prioritized findings

### P1 — request/context budget can exceed the configured context window

Locations: `Sources/LocalAssistant/ClockService.swift:30`, `AssistantStore.swift:72`, `AppleModelClient.swift:34–36`, `OllamaClient.swift:41–43`.

Four recent turns permit approximately 12,000 characters, plus a current prompt up to 12,000 characters, system text and role overhead. Ollama fixes a 4,096-token context with up to 1,024 output tokens. Apple receives the assembled text without a fit budget. Character count is not a token guarantee, especially for code, emoji, CJK and other non-English text. The resulting request can overflow, reject, or silently lose important context while the receipt reports turns included.

Fix: enforce a conservative total input budget including instructions and output reserve before dispatch; preserve the current request, drop oldest context first, and fail clearly when the current request itself cannot fit. Use runtime token counting where supported; otherwise expose conservative estimates and omitted-context disclosure without guaranteeing exact fit. Test maximum prompts/history, Unicode/code, dropped context, receipt accuracy, and recovery from a backend context-window error.

### P1 — direct-edition loopback restriction does not reject HTTP redirects

Locations: `Sources/LocalAssistant/OllamaClient.swift:8–10`, `OllamaClient.swift:21`.

The client starts at a fixed loopback endpoint and disables proxies, but its URLSession has no redirect delegate. Standard redirect handling can follow a response to a non-loopback host; a 307/308 can preserve the POST body containing prompts or images. A malicious/compromised local endpoint is required, so this is a boundary-hardening gap rather than evidence of an observed leak. It contradicts a strict promise that inference requests cannot leave loopback. The Store edition's absent network entitlement is a separate restriction.

Fix: reject all redirects for model requests, or validate every redirect hop before sending it. Checking only the final response URL is too late. Add a controlled HTTP fixture serving a 307/308 and assert no redirected request/body is dispatched; never send test content to a real external service.

### P1 — dictation state is not coordinated with the Actions surface

Locations: `Sources/LocalAssistant/AssistantAppDelegate.swift:53–61`, `ActionCenterView.swift:14`, `ActionCenterView.swift:21–23`, `ActionCenterView.swift:41`, `AssistantView.swift:8`.

The chat submit path explicitly stops voice. Action planning, direct proposals and approval do not. The global shortcut starts dictation regardless of the selected mode, but its callback writes the chat prompt, while Actions edits a different `actionDraft`. A user can record into an invisible prompt or enter an action operation while recognition remains active. The busy guard prevents starting a new recording during work; it does not stop one already running. This undermines predictable capture and action review.

Fix: define one voice lifecycle across navigation and operation boundaries. Either return to/focus the chat composer on hotkey activation or dictate into the visibly focused action field; stop capture before proposal/planning/approval and when leaving the recording surface. Test voice-active → Actions → plan/approve and hotkey-in-Actions with an injected voice service; manually verify the indicator and permission recovery.

### P2 — Save response uses mutable text after the save panel opens

Location: `Sources/LocalAssistant/AssistantView.swift:145–152`.

The completion handler writes `store.answer` rather than a snapshot captured when Save was chosen. A later result or Clear can change what is written while the save sheet is open. Capture the intended answer before displaying the panel. Test that a later store mutation cannot alter the saved payload.

### P2 — action progress and failures lack explicit accessibility announcements

Locations: `Sources/LocalAssistant/ActionCenterView.swift:13`, `ActionCenterView.swift:25–26`, `AssistantStore.swift:145–157`, compared with chat announcements at `AssistantStore.swift:161`.

Native controls have meaningful text labels and the approval sheet has fixed decision controls with a bounded scrolling body. However, action planning/completion/failure statuses do not use the existing announcement path, and progress has no explicit action-specific accessibility label. A screen-reader user may not learn that a plan, result, or error has arrived without searching the page. Add concise announcements at state transitions and an appropriate progress label; verify with VoiceOver rather than inferring conformance from source.

## Important coverage gaps and unknowns

- `planAction` uses concrete clients rather than the injected responder. Typed parser and dispatch tests do not validate the full planning lifecycle, cancellation, refusal, explicit-link provenance and late-response behavior. Introduce a planner abstraction or closure and test these paths offline.
- Apple model work has cancellation checks after completion but no app-level deadline. Whether its framework cancels promptly on every target OS is not established by the fake responder. Exercise a real slow request and Stop/retry; add a bounded timeout strategy if cancellation is not prompt.
- Control-Space registration, actual dispatch from other apps and conflicts remain manual coverage. A configurable shortcut is a useful next-release improvement.
- VoiceOver traversal, focus restoration after a sheet, keyboard-only navigation, input methods, high contrast, reduced transparency/motion, and compact-height long-error states need rendered/manual evidence. This review assigns no accessibility conformance claim.
- Full Xcode Store archive, provisioning/signing, fresh-machine install, Apple Intelligence unavailable states and actual entitlements remain separate gates. Green standalone tests do not validate a Store artifact.

## Positive boundaries retained

Pending proposals are cleared before replacement planning; approvals match a specific UUID, are consumed once and reject future/expired timestamps. The executor exposes no shell, arbitrary file read, messages or page contents. Local vision capability is checked before attaching image content to an inference request. Clock reports come from a deterministic source, and normal model prompts explicitly deny browsing/citation claims. Diagnostic results no longer overwrite shareable chat answers. These are useful foundations; preserve their existing regression coverage while making the fixes above.
