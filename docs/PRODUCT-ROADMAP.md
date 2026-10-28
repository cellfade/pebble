# Pebble product roadmap

**Working plan · October 26, 2026 · America/Denver**  
**North Star:** the most understandable, useful local AI workbench on a Mac: fast to reach, explicit about its context, good at small multimodal jobs, and able to take bounded actions that the person can inspect and approve.

This is a prioritized product plan, not a claim that the backlog is implemented. “Beta tonight” means a reliable, labeled prerelease after its acceptance gates pass. It does not mean App Store submission tonight or a promise that every North Star capability belongs in the first build. Actual release status belongs in the release notes and [beta acceptance record](BETA-ACCEPTANCE.md).

## Product thesis

Pebble should help someone finish a small piece of work without surrendering control of their Mac or understanding of what happened. The character makes the entry point approachable; the substance is an inspectable local workflow.

The wedge is **control with low friction**, not “a smaller copy of a cloud chat application.” Quick entry, voice, screenshots, recipes, retrieval, and tools already exist in competing products. Local inference alone also exists elsewhere. The opportunity is to make this combination unusually coherent:

1. The person sees the text, image, or document excerpt that will enter the model.
2. Pebble shows the engine and locality of that run without requiring model expertise.
3. The result is easy to inspect, compare, copy, or apply.
4. Any action outside the answer has a precise proposed effect, an appropriate approval, and a truthful result.
5. The app fits the Mac's available resources rather than quietly overcommitting memory or implying a model can do things it cannot.

See [research](RESEARCH.md) for current source-backed competitor observations and [design review](DESIGN-REVIEW.md) for craft references. Those documents distinguish public product evidence from hands-on testing. Differentiation here is a product hypothesis to validate, not a claim of universal uniqueness.

## Who the first product serves

**Primary:** a Mac user who writes, designs, researches, or codes; cares about local processing; and repeatedly wants a short answer, rewrite, image explanation, or small desktop action while working in another app.

**Secondary:** a technically comfortable person with Ollama who wants an accessible native front end and honest model/runtime controls.

**Not the initial target:** unattended operations teams, users expecting full browser agents or enterprise administration, or people who need a guarantee that a small on-device model matches the reasoning depth of a large hosted model.

A person should not need to understand quantization, tool schemas, context windows, or inference runners to complete the first useful task. Those details can be inspectable without becoming the primary workflow.

## Jobs to be done

| Job | Situation and desired outcome | What success feels like |
|---|---|---|
| Capture a thought | When I am in another app, I want to reach Pebble and speak or type a thought, so I can get help without rebuilding my context. | Reachable, keyboard-first, no hidden capture. |
| Improve writing | When a draft is rough, I want a controlled transformation that preserves my meaning, so I can review and use a better version. | Clear before/after, easy copy, no surprise rewrite of facts. |
| Understand an image | When I select an image, I want to ask a grounded question about it, so I can inspect what is visible without uploading it to a hosted model. | Obvious attachment, capable engine, candid uncertainty. |
| Trust a factual read | When I ask the time or request a device summary, I want an authoritative reading with its source, so a model does not invent facts about my Mac. | System facts separated from interpretation. |
| Take a small action | When I ask Pebble to open a search or link, I want to approve the exact effect, so I can delegate a step without granting general control. | Proposal → approval → observed result. |
| Reuse a workflow | When I repeat a task, I want a named local recipe and consistent context, so I can finish faster without rewriting instructions. | Predictable input, inspectable rules, repeatable results. |
| Keep useful context | When I intentionally save a source or preference, I want control over its scope and lifetime, so future help is relevant without silent surveillance. | Visible memory, removable sources, no ambient indexing. |
| Recover easily | When a model fails, a permission is denied, or a request is cancelled, I want my work preserved and a clear next step. | No lost draft, no false completion, no mystery state. |

## Guiding principles

- **Truth before fluency.** A system clock reading is not an LLM guess. A proposed action is not a performed action. Opening a search is not reading its results.
- **Context is a first-class object.** Show what is included, why, and whether it is temporary. Do not silently add clipboard contents, active windows, or unrelated files.
- **Approval is scoped to effects.** A natural-language request, a model output, or a web page cannot expand an approval's destinations or data scope.
- **Local is a boundary to explain.** On-device model use does not mean the browser, sharing destination, Ollama background activity, or the entire operating system is offline.
- **Native craft over visual noise.** Use Apple glass around navigation and action surfaces. Reading, editing, and comparing text need stable contrast and predictable geometry.
- **Capability is earned.** Expose only actions with end-to-end success, failure, cancellation, and review behavior. Unsupported capabilities should explain their limits.
- **Small complete workflows beat broad demos.** Finish capture → input → result → review → reuse before adding another modality or tool family.
- **No mandatory telemetry.** Quality can be measured with local/manual diagnostics and consented test sessions before an analytics service is considered.

## Current baseline and gaps

**Status update · October 27, 2026.** Source now includes the neutral stone/ink-face Pebble identity, native Apple text and optional direct-edition Ollama vision, dictation, a transactional composer, bounded recent text context, run details, deterministic clock handling, and approved Safari search/HTTPS/basic Mac summary. Accepted real captures cover the branded rewrite result, native approval sheet, and completed Safari action. These are a bounded beta slice, not the full workbench described below.

Recent context includes four truncated text turns (1,200 user/1,800 assistant characters each); eight turns are retained in process memory. Rewrite and image requests exclude context. A full removable context tray, durable memory, reviewable diffs, and resource-aware model routing remain future work. Basic receipts exist; richer source/action provenance remains future work.

The reported interaction clipping and accidental composer concatenation have implementation fixes and accepted beta captures. Broader fresh-Mac, accessibility, permission, minimum-size, and repeated-use acceptance remain release gates; screenshots do not prove every path. Physical shortcut dispatch outside Pebble needs broader machine/conflict coverage.

Safari search opens a DuckDuckGo query after approval; HTTPS navigation requires an explicit credential-free URL. The basic Mac summary reads OS version, logical processors, physical RAM, home-volume free space, and system clock. It does not inspect screens, app contents, personal files, process lists, or runtime performance. No fetched web citations or image generation are included.

Final CI, exact package/version/media alignment, prerelease publication, signed/notarized distribution, fresh-machine acceptance, and App Store archive/provisioning/review remain separate gates. The stone mascot is the approved creative direction, not a naming-clearance conclusion.

## Tonight's beta: one coherent horizontal slice

**Outcome:** someone can install/build the preview, reach a stable workspace, choose a ready local engine, complete a text/voice task, review the result, and approve a small supported action without losing their draft or mistaking capability limits.

### P0 — Release blockers

| Outcome | Required behavior | Acceptance gate |
|---|---|---|
| Stable workspace | Header, input, navigation, result, and bottom controls remain reachable after typing, sending, selecting modes, opening sheets, resizing, and moving. | Before/after screenshots at normal and minimum supported sizes; repeated interaction sequence passes. |
| Request boundaries | A sent request does not become the prefix of the next question. Failed/cancelled input has a documented recovery path. | Send A, then B; B contains only intentional input. No accidental double-send. |
| Truthful clock | Current time comes from the Mac's clock and displays the relevant zone; conversions identify the requested zone. | Compare with an independent system reading within the declared tolerance; no invented time. |
| Bounded action approval | No external navigation or device-summary read executes before the required approval. | Deny causes no side effect; approve uses exactly the reviewed query/URL/read scope; result is truthful. |
| No silent data expansion | Voice, clipboard, attachments, and model/provider changes are visible and intentional. | Included context matches UI; unsupported inputs fail before transmission. |
| Recoverable failures | Offline engines, denied permissions, cancellation, and malformed proposals leave the app usable. | No lost draft, stale completion, spinner stuck indefinitely, or unexpected action retry. |

### P1 — Beta quality bar

- Light/dark and native glass surfaces pass screenshot inspection with readable text and distinct disabled/focus states.
- One keyboard path completes the core task; all icon controls have names, meaningful help, and sane tab order.
- Waiting feedback starts promptly, is cancellable, and does not replace a useful prior answer with an unexplained blank.
- Copy/share/save are explicit and reviewable. “Copy” is not “apply,” and opening a share sheet is not “sent.”
- Engine availability and request error states explain what to do next. Image questions clearly require a vision engine in the direct edition.
- First-launch setup does not request microphone permission until the person chooses voice. Model downloads are explicit multi-GB operations.
- Product media uses the actual app, synthetic example content, and no personal prompts, contacts, credentials, or unrelated desktop windows.
- Preview assets identify architecture, version, signing/notarization state, checksum, and known limitations.

### Narrow action set for the beta

The implemented beta proposals are limited to:

- Open a Safari search for an exact query.
- Open an approved explicit HTTPS URL in Safari (no embedded credentials).
- Read a basic Mac summary: OS version, logical processor count, physical RAM capacity, available home-volume storage, current time, and time zone. No personal files, application content, process command lines, account data, or credentials.

The action system should reject unsupported intent instead of approximating it with an arbitrary command. A review of the Mac is a scoped diagnostic read, not permission to scan the home directory or alter configuration. Any diagnostic interpretation should distinguish measured facts from a model's advice.

**Explicitly out tonight:** unrestricted shell, autonomous multi-step browser use, messages/payments/deletion, automatic screen capture, always-on microphone, broad filesystem indexing, cloud fallback, image generation/editing, and claims of verified web citations.

## Next release: the inspectable local workbench

**Outcome:** users understand and repeat a useful local workflow rather than treating Pebble as a disposable chat box.

| Priority | Product increment | Definition of useful completion | Dependencies |
|---|---|---|---|
| P0 | Context tray | Text, selected excerpts, images, and optional recent turns appear as removable items before a run. “Clear” and “New task” have distinct, understandable effects. | Stable composer and request lifecycle. |
| P0 | Extend basic run receipts | Every result can show engine/model, included source types, start/completion times, context-memory scope, tool results, and whether any external action occurred. No hidden prompt logging. | Consistent run/result identity. |
| P0 | Expose the recent-context contract | Extend the existing bounded text context so recent turns are visible, bounded, and removable; the person can choose a fresh task. Truncation is disclosed rather than silently pretending old context remains. | Engine context budgets and lifecycle tests. |
| P1 | Reviewable transformations | Rewrite shows before/after, preserves the original, and makes the intended operation clear. Copy/apply never silently replaces source material. | Transactional drafts; text comparison/accessibility review. |
| P1 | Local recipes | Small named tasks such as clarify, shorten, summarize, extract action items, or describe an image have editable instructions and explicit inputs. | Context tray; predictable output contract. |
| P1 | Resource-aware model choices | Pebble explains cold loading, memory pressure, unavailable modalities, and engine tradeoffs; it recommends a suitable local engine without silently downloading or switching providers. | Capability discovery; truthful diagnostics. |
| P1 | Shortcut preferences | Users can choose another global chord, inspect registration failure, and test it from another app. Defaults do not overwrite system or other-app assignments. | Shortcut dispatch acceptance on real Macs. |
| P1 | Voice refinement | Partial text, stop/review, timeout, interruption, and permission recovery are clear. Dictation does not accidentally submit or destroy a typed draft. | Capture-state tests and locale/device coverage. |

### Research questions for this release

- Can a nontechnical user explain what went into the last model run after one minute with the product?
- Which three recipes produce repeat use instead of a long unused command catalog?
- Is “chat,” “task,” or “workbench” the clearest mental model for temporary context?
- Does explicit provider choice improve trust or create unnecessary cognitive load? Keep “Auto” off until routing is reliable and visible.
- Does the character improve approachability without making a factual diagnostic feel less serious?

## Following release: grounded multimodal work

**Outcome:** the app can answer useful questions about selected local material and complete a few safe workflows with evidence.

| Increment | User-visible promise | Must be true before release |
|---|---|---|
| Selected-source retrieval | Answer about documents the user intentionally adds; show source excerpts and locations. | Scope, retention, deletion, indexing status, unsupported formats, and citation validation all work. No ambient home-folder indexing. |
| Image workspace | Compare selected images, extract visible text, ask grounded questions, and inspect which images were included. | Capability checks, orientation/size handling, uncertainty, source thumbnails, and accessible descriptions are verified. |
| Optional grounded web research | With explicit network consent, retrieve selected public pages and answer with traceable sources. | Query transmission is disclosed; citations point to actually retrieved content; failures and paywalls are visible; page content cannot authorize tools. Browser-only mode remains available. |
| Action plans with checkpoints | Show a small ordered plan, permissions, inputs, and expected effects before execution. | Each effect is bounded, errors stop dependent work, state is observed rather than assumed, and approvals cannot be reused for a different destination or action. |
| Local source collections | Save a deliberate collection for a project with visible expiry and remove controls. | Raw content, indexes, summaries, and derived embeddings follow the same retention/deletion contract. |
| Reproducible run comparison | Compare two engines or recipes on the same selected context. | Resource/cost implications are explicit; quality is compared by task outcomes, not a misleading single score. |

**Do not add automatic agent loops just because tool calling works once.** Multi-step behavior needs a tested planner/executor boundary, denial and stop behavior, prompt-injection resistance, and useful failure recovery.

## Longer-term North Star research

These are exploration tracks, not committed release scope:

1. **Ambient reach without ambient capture.** A small companion/quick-entry surface with opt-in selection capture and visible context. Review permission burden, accessibility, and accidental capture before any background behavior.
2. **Voice as a first-class editing workflow.** Speech, typed corrections, image references, and a reviewable result in one task; interruption and repair matter more than a theatrical animated character.
3. **Screen understanding with explicit selection.** A selected window or region, a visible capture thumbnail, expiry, and per-run inclusion. Screen Recording permission does not become standing permission to inspect unrelated windows.
4. **Local personal knowledge.** User-owned collections, explainable recall, source-aware answers, portable exports, and a verifiable delete/reset path. Memory should be inspectable rather than a mysterious personality.
5. **A safe Mac action catalog.** Useful typed actions with independent validation and previews. Expand from navigation and diagnostics to user-selected file transformations only after diffs and rollback exist.
6. **Image generation/editing.** A separate, optional, explicitly chosen backend with license/hardware/storage checks, cancellable jobs, clear provenance, and honest edition availability. This is not enabled by a vision model alone.
7. **Accessible alternative interfaces.** Compact quick entry, large-text workspace, full keyboard operation, VoiceOver-first actions, and reduced-motion/transparency behavior as equal experiences.
8. **User-owned extensions.** A permissioned recipe/tool system with visible capabilities, signing/provenance expectations, and revocation. Never start with arbitrary downloaded code that bypasses the product's approval boundary.

## Edition and capability matrix

This matrix describes the intended release boundaries; the shipped build's release notes remain authoritative.

| Capability | Direct-download edition | App Store-oriented edition | Gate or constraint |
|---|---|---|---|
| Apple on-device text | Compatible macOS 26+ Macs | Primary standalone engine | Apple Intelligence enabled and model ready. |
| Ollama text | Optional local engine | Not exposed in current configuration | Runtime availability, local-model validation, memory/disk. |
| Ollama image questions | Optional vision model | Not exposed in current configuration | Actual vision capability and attachment checks. |
| Local dictation | On-device support required | On-device support required | Permissions, locale/assets, interruption recovery. |
| Browser navigation | Explicit user action/proposal | Explicit user action/proposal if validated for store build | Exact destination review; no claim of page reading. |
| Basic Mac summary | Scoped read after approval | Only sandbox-compatible facts | No filesystem/process-content survey. |
| Selected document retrieval | Future, opt-in | Future, sandbox-scoped | Explicit file access, sources, retention, deletion. |
| Web-grounded answers | Future, optional | Future, requires revisiting network/privacy configuration | Retrieval evidence and App Store configuration review. |
| Image generation/editing | Future optional backend | Separate feasibility/review decision | Not part of a text or vision model by implication. |
| Unrestricted terminal agent | Not planned for beta | Not planned | Requires a different risk and product model. |

Changing the Store edition's capabilities requires a fresh entitlement, privacy, metadata, and review assessment. A working direct build is not proof that the same feature is appropriate for the Store edition.

## Approval model

An approval should be understandable without reading a model's reasoning. It names the exact action, input, data accessed or sent, destination, and expected effect.

| Action class | Review surface | Execution rule | Evidence after execution |
|---|---|---|---|
| Local factual read | Source and scope; basic clock reads can be an explicit built-in response to the user's request | No unrelated expansion | Measurement, timestamp, zone/source. |
| Browser search/navigation | Browser, exact query or URL, and destination | Execute only the approved normalized action | “Opened in Safari” or actual failure, never “researched.” |
| Selected-file analysis | File/excerpt and its inclusion in context | No implicit adjacent-folder access | Source name/location and what was read. |
| File modification | Before/after or explicit output artifact | Separate approval for replacing existing content | Written path, success check, recovery path. |
| External communication | Exact recipient, content, attachments, and destination | Separate final confirmation; no beta auto-send | Delivery status only when observed. |
| Destructive/security/financial action | Not available in beta | Reject or hand off | Clear explanation of unsupported capability. |

Approval is invalidated when the query, URL, file, recipient, content, or effect changes. Denial produces no side effect. A model's plan, a retrieved page, a document, or a tool response cannot approve the next action. Cancellation must stop unstarted dependent actions and explain any action that already happened.

## Quality, performance, and accessibility gates

The following are **proposed targets**, not measured achievements:

- Visible feedback to a deliberate input action within 150 ms on the reference Mac; waiting feedback within 250 ms of submitting a run.
- No clipping or unreachable essential control at the documented minimum window size after the scripted interaction/resizing sequence.
- Core capture → send → review → copy path succeeds using only the keyboard.
- All meaningful controls have distinct accessible names; announcements report completion/error without narrating every elapsed second.
- Normal text meets a practical contrast target equivalent to WCAG AA (4.5:1), large text 3:1; focus and essential control boundaries remain distinguishable. Screenshots alone do not prove screen-reader usability or numerical contrast.
- Reduce Motion removes nonessential transitions; Reduce Transparency provides readable surfaces; status is not color-only.
- No successful completion is shown after a cancelled/stale run; no external side effect occurs without its required approval.
- Cold-load latency and generation rate are measured separately. Do not promise a universal token rate across hardware or models.
- Model inference quality is tested on representative tasks: meaning preservation, visible-image grounding, factual tool use, unsupported-action refusal, and citation traceability when retrieval exists.

## Measurement without surveillance

Start with a local test ledger and optional on-device diagnostics. Do not collect prompt text, private files, audio, clipboard data, page contents, or contact details by default.

| Signal | Why it matters | Safe first measurement |
|---|---|---|
| First successful local task | Onboarding usefulness | Manual session record: engine state, setup steps, outcome. |
| Completed task without repair | Workflow quality | Test task outcome, not an opaque engagement count. |
| Draft loss/accidental concatenation | Trust and reliability | Deterministic regression tests plus UAT incidents. |
| Approval mismatch/denial side effect | Safety boundary | Zero tolerated; synthetic proposal/executor tests. |
| Time to usable output | Real usefulness | Local timing split by cold load, generation, and review. |
| Repeated recipe use | Product fit | Consented study or optional local counts, not content capture. |
| Accessible task completion | Equal usefulness | Observed keyboard/VoiceOver sessions with consent. |
| Resource pressure/failure | Local engine fit | Local aggregate memory/disk/runtime state with no process contents. |

If analytics is later proposed, it needs an explicit product decision, consent model, retention policy, and updated privacy review. “No analytics SDK” is not the same as proving every system component is offline.

## Release operating model

1. Keep one beta candidate at a time. Freeze scope when its acceptance sequence begins.
2. Record each failure with reproduction steps, expected/actual behavior, severity, affected engine/edition, and a screenshot or named evidence limitation.
3. Fix blockers before adding more capabilities. Add a meaningful regression check for the failure class.
4. Re-run the affected sequence after the last behavior change; do not use an earlier passing screenshot to validate a later binary.
5. Publish a prerelease only after all P0 gates and the accepted P1 bar pass. Document waived lower-priority issues and exact platform coverage.
6. Keep source commit, build version, package checksum, screenshots, video, and release notes aligned.
7. Treat signing/notarization, App Store archive/provisioning, and review acceptance as separate gates.
8. Plan the next increment from observed task failures and user value, not the number of feature requests accumulated.

## What “best” should mean

Pebble earns its place if someone can reliably finish a private local task, understand what entered the model, and trust that approved actions match what happens. Its personality, glass, and cobalt palette should make that experience pleasant—not conceal limits or compensate for a fragile workflow.
