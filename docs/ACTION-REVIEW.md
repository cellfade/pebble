# Beta bounded-action review

Review date: October 26–27, 2026. This is a source review and offline regression record, not an independent security certification or evidence of real Safari or permission testing.

## Scope and result

`./script/test_beta.sh` passes against the current backend. It compiles a standalone Swift executable using fake model responses and a fake action executor. It never opens Safari, reads the clipboard, or collects the real Mac summary.

The checks cover authoritative clock/time-zone fixtures and intent boundaries; bounded recent conversation context; action-kind, HTTPS, credentials, and control-character validation; composer clearing, exact draft recovery, previous-answer association, cancellation and reset; approval identity, denial, expiry, exactly-once dispatch, execution failure, and separate action-result handling.

These checks support the beta’s narrow action contract: a local proposal requires approval of a specific immutable proposal; only a browser search, an explicit HTTPS destination, or a limited read-only Mac capacity summary can execute. There is no shell, arbitrary file access, browser-page extraction, automatic link following, or message-sending executor in this implementation.

## Findings addressed during review

- Clock detection previously intercepted unrelated prompts and omitted a common current-time variant. Explicit prefix checks, polite-prefix normalization, exclusions, and regression fixtures now cover these cases. This remains a small intent heuristic, not a general natural-language parser.
- Invalid replacement proposals could leave the old approval active. Both `propose` and `planAction` now discard the pending proposal before replacement validation/planning. The offline regression includes an overlong replacement-planning request that must leave no pending approval and no active work.
- Cancellation immediately after approval had ambiguous side-effect semantics. Approval now commits the action; the UI disables cancellation while execution runs, and a cancellation check precedes executor dispatch. Cancelling an approved browser launch does not undo it.
- Failed or cancelled generations could associate a previous answer with a new prompt and lose draft whitespace. The pending prompt and successful answer association are now separate, and recovery preserves the raw draft.
- Action output could replace chat text and be unintentionally exposed through chat sharing. `actionResult` now holds it separately; successful and failed actions preserve the previous chat answer and prompt association. A failed action preserves the prior successful action result, and Clear removes action output.

## Remaining follow-up

1. **Make shortened context visible and budget by tokens.** Four recent turns are bounded by characters, but those bounds plus a new prompt can exceed the Ollama context setting. Character limits do not guarantee token fit. Explain omitted/shortened history and reserve token budget before claiming reliable multi-turn recall.
2. **Exercise the planning boundary separately.** The injected responder currently covers chat, while model planning calls concrete clients. Add a separately injectable planner to test malicious JSON, model refusal, timeout, cancellation, stale-plan replacement, and explicit-URL provenance without a live model. The current offline suite validates parsing and dispatch, not the complete live planner.
3. **Verify presentation and OS effects manually.** Confirm the complete destination and external-data disclosure are visible before approval, Safari opens the reviewed destination once, keyboard focus cannot accidentally confirm, sensitive Mac output has no unintended share path, and permission denial is recoverable. See `BETA-ACCEPTANCE.md` for the broader release gate.

## Threat and privacy boundaries

Model output and user-supplied destinations remain untrusted. Typed decoding and allowlisted actions limit the executor’s capability; model instructions alone are not the approval boundary. Unknown JSON keys grant no authority. Every reviewed action should show its exact destination or diagnostic fields before approval.

An HTTPS link can still lead to a malicious website, tracking endpoint, private-network host, or a server action triggered by a visit. This beta opens a user-approved destination in Safari; it does not certify sites. Search queries leave the computer through Safari and the search provider after approval. Local inference does not make browser searches private.

The five-minute age check uses wall time, so clock changes can affect expiry. For stronger future guarantees, use a monotonic approval lifetime and explicit invalidation on app/session transitions. Multi-step workflows, file changes, remote models, plugins, persistent memory, and arbitrary automation require separate permission models and reviews before activation.


## Separate UI/OS evidence

The release owner accepted real native captures of the approval sheet (`docs/media/05-beta-approval.png`) and completed approved Safari search (`docs/media/07-beta-approved-result.png`). Approval bodies scroll within a 320-point review region while Cancel and Approve remain fixed. These captures are UI/OS evidence supplied by the release owner, distinct from the fake-executor regression results above. They do not prove every failure, permission, keyboard-focus, or fresh-machine path. Broader real acceptance remains tracked in the beta report.
