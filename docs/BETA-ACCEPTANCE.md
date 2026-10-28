# Pebble beta acceptance plan

**Candidate date:** October 26, 2026 (America/Denver)  
**Purpose:** release a dependable developer beta before attempting Store submission.  
**Status:** acceptance plan, not a blanket pass. Fill the run record against the final candidate binary.

## Release decision

**Do not publish a beta asset with any open P0 issue.** Interaction-driven clipping is a known P0 until the exact reproduction sequence passes after the fix. Accidental request concatenation and false clock/device claims are also release blockers for the corresponding workflow. An unimplemented action should be explicitly unavailable rather than represented as working.

A developer beta may still have documented P2 limitations and remain ad hoc signed. It must not be described as notarized, App Store-ready, or approved without the relevant evidence. A source repository with green CI is not by itself a validated install experience.

## Test record

Record this once per candidate:

| Field | Value |
|---|---|
| App version/build | To record |
| Git commit | To record |
| Package filename and SHA-256 | To record |
| macOS version/build | To record |
| Hardware/architecture/RAM | To record |
| Engine and exact model | To record |
| Direct or Store configuration | To record |
| Signing state | To record |
| Appearance and accessibility settings | To record |
| Window sizes exercised | To record |
| Permission state before test | To record |
| Tester/date | To record |

Use **Pass / Fail / Blocked / Not run / Not applicable**. “Observed once” can be a note; it is not equivalent to all edge cases passing. Attach safe evidence paths and a concise expected/actual result. Never publish a private prompt, clipboard value, file, recipient list, or unrelated desktop capture as evidence.

## Severity

- **P0:** core workflow becomes inaccessible, draft/data is lost, action occurs outside approval, sensitive context is silently included, or factual tool output is misrepresented.
- **P1:** core task fails or becomes misleading with an expected environment/input, permission recovery is broken, or an essential accessibility path is blocked.
- **P2:** usable with a clear workaround; visual polish, secondary affordance, or narrower unsupported condition.
- **P3:** enhancement or future scope rather than a defect in a promised workflow.

## Known starting issues

| ID | Starting evidence | Starting status | Gate |
|---|---|---|---|
| BUG-001 | User confirms interaction pushes header/navigation/other controls above and outside the window. | Fail; layout investigation active. | P0 |
| BUG-002 | Submitted text remains in the composer; typing another question can append it to the prior request. | Fail; request-boundary fix required. | P0 |
| BUG-003 | Apple text responses cannot establish the Mac's actual clock/device state and may answer without authoritative context. | Fail for factual-read workflow; deterministic read or honest unsupported state required. | P0 |
| BUG-004 | Control-Space API registration succeeds, but physical dispatch outside the app is not fully accepted. | Not run across required app/conflict paths. | P1 |
| GAP-001 | Browser links open search but no result content is retrieved or verified. | Known capability limit, not “web research complete.” | Scope disclosure |
| GAP-002 | Full Xcode, Apple distribution identity/provisioning, and Store archive validation are unavailable locally. | Blocked for submission; not for a correctly labeled source/developer beta. | Store gate |

These are starting findings. Mark them resolved only with the final candidate's reproduction results. [UX-UAT.md](UX-UAT.md), if present, contains the layout investigator's evidence and findings.

## Baseline fixtures

Use synthetic, nonpersonal content:

- Prompt A: “Rewrite this note clearly: Please send the project update before Friday.”
- Prompt B: “Give me three short ways to say thank you.”
- Newline fixture: two short lines, then a send.
- Long text fixture: a generated multiparagraph sample, no private document.
- Image fixtures: a generated solid-color image, a small sample chart, a rotated image, and a deliberately invalid/oversize file.
- Browser fixture: search for “Apple accessibility keyboard navigation”; open a known public documentation URL.
- Approval rejection fixtures: changed query, unsupported URL scheme, malformed proposal, unsupported action, and denied approval.
- Diagnostic fixture: only the approved OS/architecture/RAM/disk/time/runtime fields—no personal directories or process content.

## Interaction regression sequence: clipping

Run the same sequence in both light and dark appearance, at normal size and the minimum supported size. Repeat at least three times per candidate; include moving/resizing between runs.

1. Launch a clean workspace and capture the full window, including its native title bar.
2. Focus the composer; type several words; insert a newline; replace a selection; paste the synthetic fixture.
3. Send, observe waiting, then observe a completed answer.
4. Type a new request; send it; cancel a longer request.
5. Select Rewrite, return to Chat, select Image questions when the edition supports it.
6. Open/close setup, a file picker, the More menu, and a share sheet without sending to a recipient.
7. Collapse/expand the sidebar.
8. Resize down to minimum, then larger; move the window; minimize/restore; close/reopen from the menu bar or Dock.
9. Capture the same full-window state and verify every essential area remains reachable.
10. Restart and verify the restored window is on a visible display with usable dimensions.

**Pass condition:** no interaction displaces, clips, overlaps, or permanently hides header, navigation, input, result, or action controls. Scrollable content scrolls only within its intended region. No pointer workaround is needed to recover the UI. An accessibility tree containing an invisible control does not prove it is visually reachable.

## UAT matrix

All rows start **Not run** unless a separate candidate-specific evidence record says otherwise.

| ID | Priority | Given / When | Required observable result | Evidence |
|---|---|---|---|---|
| L01 | P0 | Given a fresh launch, when the workspace appears | Header, composer, primary action, result area, navigation, and footer are fully visible. | Full-window screenshot. |
| L02 | P0 | Given a usable window, when the clipping sequence above runs | No cumulative displacement or lost controls after interaction. | Before/after screenshots and repetition count. |
| L03 | P0 | Given the minimum supported window, when a long prompt and long answer are present | Text remains editable/readable; intended regions scroll; essential controls remain reachable. | Minimum-size screenshot and scroll observation. |
| L04 | P1 | Given a moved/resized window, when it is minimized, restored, closed, reopened, and relaunched | Position/size restoration is useful; no window reopens entirely offscreen. | Frame/behavior observation and screenshot. |
| L05 | P1 | Given a different display or a smaller visible area, when the workspace opens | The person can recover the window and reach controls without editing preferences manually. | Device/display run or named coverage limit. |
| C01 | P0 | Given prompt A, when it is sent, followed by typing prompt B | B is a new intentional request, not A concatenated with B. The previous request remains inspectable if conversation is shown. | Two request/result boundaries in UI. |
| C02 | P0 | Given a sent draft, when generation fails or is cancelled | The draft has a clear recovery/retry path; an older answer is not relabeled as the new result. | Failure/cancel screenshots. |
| C03 | P1 | Given an empty or whitespace-only draft, when Enter is pressed | No request or action is created. | Interaction observation. |
| C04 | P1 | Given text composition in progress, when Enter confirms composition | The composition is committed without premature send. | IME/manual test; unit policy check is supporting evidence only. |
| C05 | P1 | Given a multiline draft, when Shift-Enter is pressed | A newline appears; Enter/Command-Enter sends once after composition is complete. | Keyboard observation. |
| C06 | P1 | Given quick repeated submit input, when the app is busy | No duplicate concurrent run or unexpected repeated action occurs. | Run identity/state observation. |
| C07 | P1 | Given independent-request mode or bounded recent turns, when a follow-up refers to earlier text | The UI's memory contract matches the model context. Missing/truncated context is disclosed. | Controlled follow-up and context state. |
| T01 | P0 | Given “What time is it?”, when Pebble answers | Current time is a system reading with a named zone/source, within five seconds of an independent read at comparison time. | Paired time readings. |
| T02 | P1 | Given a time-zone conversion request, when Pebble answers | Target zone and daylight-saving interpretation are explicit; unknown/ambiguous zones ask for clarification or explain the limit. | Known-zone fixtures and independent comparison. |
| T03 | P0 | Given a request to review the Mac, when the tool is proposed | Scope states exactly which basic facts will be read; no personal files/process contents are included. | Proposal and approved result. |
| A01 | P0 | Given a proposed Safari search, when approval is denied | Safari does not open; no query is transmitted; result says denied/not executed. | Denial behavior. |
| A02 | P0 | Given an approved Safari search, when it executes | Exact reviewed query opens in Safari; UI says “opened,” not “researched” or “sources verified.” | Approved proposal and browser destination. |
| A03 | P0 | Given an approved URL, when its destination or effect changes before execution | Prior approval is invalidated; a new proposal is required. | Changed-input fixture. |
| A04 | P0 | Given a malformed proposal, unsupported action, or non-HTTP(S) link, when it is processed | It is rejected before execution; no shell, file, or browser side effect occurs. | Synthetic proposal checks. |
| A05 | P0 | Given a plan with several effects, when the first effect is approved | Approval does not silently authorize different data, destinations, or later effects. | Multi-effect fixture or explicit unsupported-state test. |
| A06 | P1 | Given an action failure or unavailable Safari, when execution fails | No false success; useful recovery; no unapproved automatic retry. | Failure fixture/coverage limit. |
| A07 | P0 | Given text in a document/page that asks for another action, when it enters model context | It cannot approve or broaden an action. | Prompt-injection fixture. |
| V01 | P1 | Given first voice use, when Dictate is chosen | Relevant OS permissions appear only then; typing remains usable if denied. | Fresh-permission run. |
| V02 | P1 | Given a typed draft, when partial dictation updates arrive | Speech appends/replaces only its intended draft segment; partial results do not duplicate earlier words. | Dictation observation. |
| V03 | P1 | Given active recording, when Stop, window close, focus loss, or timeout occurs | Microphone capture ends and the latest reviewable transcript remains; no automatic send. | State/OS indicator observation. |
| V04 | P1 | Given unsupported on-device speech or denied access, when voice is requested | Clear guidance appears; no silent remote recognizer fallback or permanently stuck enabling state. | Unsupported/denied run or named limit. |
| K01 | P1 | Given Pebble is running in the background, when physical Control-Space is pressed in another app | Workspace opens and the intended dictation state begins. A second press stops according to the documented contract. | Physical keyboard observation; API registration alone is insufficient. |
| K02 | P1 | Given a shortcut conflict, when registration or dispatch fails | The app explains the problem and retains a usable menu-bar/keyboard path; no system assignment is changed silently. | Conflict fixture or coverage limit. |
| M01 | P1 | Given Apple model unavailable/disabled/not ready, when selected | Accurate reason and recovery, no cloud fallback, no enabled send that silently fails. | Each available-state fixture. |
| M02 | P1 | Given Ollama offline, missing model, or cloud/remote metadata, when used | Local-only validation holds; clear recovery; no download or hosted fallback occurs automatically. | Offline/missing/remote tests. |
| M03 | P1 | Given an engine switch, when a draft/attachment/run exists | Context is not silently dropped or sent to an incapable engine; busy-state changes follow a documented rule. | Switch sequence. |
| M04 | P1 | Given cold loading or a long generation, when waiting | Feedback starts promptly; elapsed state is understandable; cancellation returns a usable app and stale completion cannot overwrite it. | Timed observation. |
| I01 | P1 | Given a valid selected image and vision model, when sent | Correct image is visibly included; an image question completes with honest uncertainty. | Synthetic image/result screenshot. |
| I02 | P1 | Given an invalid/oversize/rotated image or nonvision engine, when attached/sent | Validation is clear; previous attachment behavior is visible; no inappropriate transmission occurs. | File fixtures. |
| I03 | P1 | Given the Store configuration, when navigation/setup is inspected | Ollama installer/model selection/image features are not promised or exposed as available. | Actual Store-build screenshot or named archive blocker. |
| P01 | P1 | Given synthetic clipboard text, when Paste is chosen | Only deliberate clipboard content enters the intended draft location; no background polling. | Clipboard roundtrip using safe fixture. |
| P02 | P1 | Given a result, when Copy is chosen | Exact response is copied and confirmation appears; no other app is modified. | Safe pasteback check. |
| P03 | P1 | Given a result, when Share opens then is dismissed | Correct content is offered; no send occurs without the user's destination/final action. | Native sheet observation; do not publish contact suggestions. |
| P04 | P1 | Given Save response, when destination selection is cancelled or completed | Cancel writes nothing; approved save contains the intended text at the selected destination. | Safe temporary destination and file comparison. |
| X01 | P1 | Given keyboard-only use, when the core task is completed | Focus order, names, shortcuts, and cancellation allow completion without pointer dependence. | Manual keyboard UAT. |
| X02 | P1 | Given VoiceOver, when navigation/input/waiting/result/action review occurs | Controls have distinct names; response/error/completion are discoverable; elapsed updates do not overwhelm announcements. | VoiceOver UAT; screenshot is not sufficient. |
| X03 | P1 | Given dark/light appearance, when normal, waiting, error, and approval states appear | Contrast, disabled states, focus, text wrapping, and hierarchy remain readable. | Accepted screenshot set. |
| X04 | P1 | Given Reduce Transparency or Reduce Motion, when the same states appear | Content remains usable; nonessential motion is reduced; state is not color-only. | Setting-specific UAT and screenshot. |
| R01 | P0 | Given a packaged candidate, when extracted and launched/built using documented steps | Correct version/architecture/resources, honest trust status, usable first-run guide, and no unmentioned dependency. | Clean-path install/build record. |
| R02 | P1 | Given the final source commit, when CI and package checks complete | Relevant tests pass; source, binary, checksum, screenshots, video, and release notes match. | CI URL, commit, checksum, media review. |

## Evidence and media acceptance

- Capture real rendered app states only. Generated icon artwork is brand exploration, not product functionality evidence.
- Reject cropped, blank, half-rendered, blocked, or wrong-state screenshots. A clipped screenshot is a defect/evidence item, not marketing media.
- Keep a numbered set: setup, ready workspace, composed request, waiting, completed result, action proposal, action outcome, and image question when supported. Add minimum-size and dark-mode comparisons.
- Keep a short note beside every accepted screenshot: state, health, what was tested, what was not tested.
- A sampled interaction video must be labeled as sampled; do not call it a continuous real-time recording. Do not accelerate waiting without disclosure or fabricate states/outputs.
- Never publish share suggestions, personal prompts/files, unrelated windows, account data, or notification content.
- Store screenshots must come from the actual Store configuration, not a direct-edition screenshot with unavailable features.

## Test layers

| Layer | Covers | Does not prove |
|---|---|---|
| Offline deterministic checks | Request validation, safe action parsing, approval matching, input policy, model metadata refusal, state transitions. | Actual OS permissions, global dispatch, screen-reader quality, live model quality. |
| Live local-engine checks | Real model generation, rewrite, image route/capability, local runtime behavior. | Every hardware configuration, output correctness for all tasks, production Store archive. |
| Native UI UAT | Interaction, focus, geometry, visual craft, permission surfaces, user recovery, real action effects. | Automated broad coverage or numerical contrast by screenshots alone. |
| Packaging/signing checks | Resource completeness, version, signature/entitlements, architecture, checksum, extraction. | Apple notarization/review acceptance without their separate outcomes. |
| Fresh-machine acceptance | First-run dependency and permission experience without developer state. | Every OS/device/locale; document the tested envelope. |

## Exit checklist for tonight

- [ ] All P0 issues are resolved or the affected capability is removed/clearly unavailable.
- [ ] Core interaction sequence passes after the final behavior change in normal/minimum sizes and light/dark mode.
- [ ] Fresh tests cover accidental concatenation, clock truth, approval denial/matching, and stale cancellation.
- [ ] Relevant offline/live checks pass for the chosen candidate.
- [ ] A physical shortcut test is recorded or its unverified status is explicit and an alternative path works.
- [ ] Release notes state engine/modalities, memory behavior, browser limitations, unsupported actions, and known P1/P2 issues.
- [ ] Package, checksum, source commit, safe screenshots, and demo align.
- [ ] Developer preview signing/notarization state is visible before download.
- [ ] No Apple submission claim is made; Store gates remain separate.

## Regression discipline

Every UAT failure should become a focused test or repeatable manual sequence that would catch the same class of regression. Do not add assertions that merely duplicate implementation wording. Keep the accepted evidence tied to the final binary. A fresh code change, engine-routing change, or action-policy change invalidates the relevant prior pass and requires a scoped rerun.
