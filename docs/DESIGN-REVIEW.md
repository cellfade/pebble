# Pebble design synthesis and acceptance contract

Review date: October 26, 2026 (America/Denver).

This document turns the competitive research into a practical visual and interaction standard. It is **not a UAT sign-off**. The owner reported clipping after interacting with the app, and a separate debugging/UAT pass owns reproduction, repaired screenshots, and code verification. A polished first frame is insufficient.

## Visual position

Pebble should feel like a small, capable native workbench with a friendly, ink-faced stone companion—not an enterprise dashboard with many empty metrics. The character gives the product recognition; the working surface should earn attention through clarity.

The reference review favors Bear’s quiet editor hierarchy, Things’ clear navigation landmarks, Raycast’s keyboard economy, and Craft’s progressive disclosure. Those are design inferences from official material, not a claim to have tested the apps directly. See [research and evidence limits](RESEARCH.md).

## Material and hierarchy

Apple defines Liquid Glass as a functional layer for controls/navigation and advises against putting it throughout content or overusing custom glass. Standard materials serve the content layer. [Apple materials guidance](https://developer.apple.com/design/human-interface-guidelines/materials).

Apply that distinction to Pebble:

| Layer | Treatment | Acceptance |
|---|---|---|
| Window/title bar/sidebar | Native system structure and materials; normal traffic lights, drag, resize, and focus behavior | Moving/resizing never offsets the content, and restoring the window never leaves primary controls outside the visible area |
| Primary action group | One coherent native glass group for mic, attachments, and send/cancel where custom treatment is useful | Every control remains legible in active/inactive light/dark states; no nested glass-on-glass decoration |
| Prompt and answer | Stable system-adaptive reading surface; quiet separators; selectable text | Long text scrolls within its own region, not by pushing the whole workspace offscreen |
| Status and approval | Clear text with an icon and exact state; a standard approval sheet for action details | Status is not color-only; the user can distinguish a proposal, approval, execution, failure, and completion |
| Mascot | Static, small stone with floating ink-dot eyes and a loose smiling ink line | It never displaces the main task, covers content, or animates continuously while idle |

The key implementation preference is **standard components first**. Apple recommends testing custom glass with display/accessibility settings and limiting its use to important functional controls. [Adopting Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass).

## Color, type, and spacing

- Cobalt identifies selected navigation and the primary actionable state. Use semantic foreground/background colors for text, errors, disabled controls, and reading surfaces; do not place all body content on a blue translucent wash.
- Keep the stone character neutral and the floating face black/ink. Recording needs a word such as “Listening” and a visible Stop action; a colored dot alone must never imply recording. The earlier cobalt robot is an unused exploration, not the current approved direction.
- Prefer system text styles and a readable response size. Treat 14–16 pt body copy as a design starting range, then test actual rendering and accessibility settings. Tiny uppercase slogans are optional decoration, not essential information.
- Use a predictable spacing rhythm and aligned control baselines. Avoid a very large empty answer card while compressing the editor and actions. A compact window may reduce decorative space before reducing useful input or clipping controls.
- Keep one primary action. Secondary actions should be labeled or exposed in a consistent More menu, not scattered across multiple unrelated toolbar rows.
- Inspect the icon at 16, 32, 128, and 1024 px on light/dark backgrounds. The color mark, simplified SVG, and monochrome menu-bar mark should share a recognizable silhouette. Verify transparent edge quality; do not mistake a large attractive render for a production-ready small icon.

## Interaction contract

### Composer and conversation

1. Enter sends, Shift-Enter inserts a line, and IME marked-text composition takes precedence.
2. Sending is transactional: snapshot the request, show it in the conversation, start the task, and clear only the submitted draft. A failed task can restore/retry without duplicating input or erasing a new draft.
3. New typing starts a new draft. The app must not concatenate independent questions into a growing invisible request.
4. If the app is single-turn, label that limitation. If it supports recent conversation context, show its boundary and provide an explicit New chat/Clear context action.
5. A response belongs to a visible request. Keeping an older answer during loading/error recovery is acceptable only if its association remains clear.
6. Show useful progress immediately. Keep Cancel available and make cancellation distinguishable from a failed request. Do not animate the entire reading surface during generation.

### Voice

A shortcut opens the correct window and starts recording only after a deliberate invocation. Recording, transcribing, stopped, permission denied, unsupported language, and request generation are different states. Dictation must preserve the current draft and leave text reviewable before sending. Test focus loss, window close, a second shortcut, timeout, and interruptions. Do not silently switch to a network recognizer.

### Capability and context

An image attachment should show its filename/thumbnail and selected processing route. If the current engine cannot analyze it, explain the requirement rather than silently pretending it can. Do not make attaching a file, reading the clipboard, or opening a browser an invisible side effect of a freeform model answer.

A device clock request should use the real system clock with a time-zone/source label. A model’s unsupported guess must not be displayed as a measured system fact. Likewise, a browser search opening is not a sourced research result.

### Approvals and external actions

The approval surface must show the action type, exact app/destination or scope, and the data involved. Use specific verbs such as **Open Safari search**, **Open this URL**, or **Read this Mac summary**. The model proposes; validated app code acts only after the relevant approval. Rejection must leave the draft/result intact. A completed operation gets a factual receipt; an error must not say “Done.”

Do not make an action button look like an ordinary chat-send button if it changes the outside world. For future document edits, show a preview/diff and retain a recovery path. An approval applies to the displayed action, not an unrestricted chain of later actions.

## Accessibility acceptance

Apple recommends auditing interface accessibility and testing material and motion adaptations. Native system behavior helps, but does not prove custom controls work. [Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility), [motion](https://developer.apple.com/design/human-interface-guidelines/motion).

| Area | Required check |
|---|---|
| VoiceOver | Navigate the sidebar, engine selector, editor, attachment removal, mic, send/cancel, response, and approval sheet; labels must describe purpose/state without reading decorative slogans twice |
| Keyboard | Complete a typed request, newline, cancellation, mode change, copy/save, and approval rejection without a pointer; focus remains visible and returns predictably after sheets |
| Contrast | Check text/icons/selection/focus in active and inactive light/dark windows plus Increase Contrast; measure custom color combinations rather than relying on a screenshot impression |
| Transparency | Reduce Transparency leaves every control clear and preserves hierarchy; the app must not ask users to turn it off for the intended appearance |
| Motion | Reduce Motion avoids custom spatial/morphing flourishes; a useful waiting label remains available even if motion is reduced |
| Text and layout | Large/long text, long model tags, file names, permission guidance, and translated strings do not overlap, hide actions, or force inaccessible horizontal scrolling |
| Assistive input | Full Keyboard Access, IME composition, dictation, and text selection do not move the entire workspace or trigger Send unexpectedly |

## Screenshot-led UAT matrix

Capture real app screenshots with synthetic content only. Reject any image that is cropped, half-rendered, or showing an unintended state; do not publish a generated UI mockup as implementation evidence.

Run this sequence at the runtime minimum size, approximately 1060×800, and a larger window. Test light/dark appearances; repeat the important states on a shorter display or scaled resolution.

| Step | Sequence and screenshot | Passing condition |
|---|---|---|
| 1 | Empty workspace after launch | Full header, navigation, composer, and bottom controls visible |
| 2 | Click editor; type a multi-line draft; select/copy text | Only the intended editor scrolls; no column/window displacement |
| 3 | Switch Chat → Rewrite → Chat; toggle sidebar twice | Stable geometry, retained intended draft, no clipped controls |
| 4 | Send; capture waiting and finished states | Visible request association, prompt transaction correct, no layout jump beyond expected content growth |
| 5 | Cancel; retry; simulate unavailable engine | Recoverable state and exact error; no fabricated successful answer |
| 6 | Attach/remove a test image and change engine | Honest capability/route information and no orphan attachment |
| 7 | Start/stop dictation; repeat after focus change | Recording is explicit; partial text preserved; no hidden capture or automatic send |
| 8 | Open/dismiss Share or Save; reject an action approval | Focus returns correctly; no unintended send/write/action; personal sharing contacts excluded from public media |
| 9 | Move, resize, minimize, close/reopen; repeat steps 2–4 | Window geometry and internal scroll positions remain correct throughout |
| 10 | Accessibility settings and keyboard pass | All primary work remains possible and legible; no pointer-only critical control |

The current clipping is a **release blocker** until this interaction sequence passes with post-interaction evidence. A first-launch screenshot or a correct accessibility tree alone is not sufficient.

## Priorities for the beta

**P0 — correctness:** fix the interaction-triggered clipping; eliminate draft accumulation; provide truthful clock/system/action responses; make errors and cancellation recoverable; verify approval boundaries.

**P1 — ease:** clear task/input/output association, configurable hotkey and conflict guidance, honest model/image routing, readable first-run setup, predictable sheet focus, and a small run-details view.

**P2 — craft:** refine spacing/density, reduce decorative uppercase copy, inspect icon edges/small sizes, tune only meaningful material transitions, and use the mascot for clear optional state rather than constant activity.

Do not add dashboard metrics, many capability tabs, or autonomous background actions to make the beta appear more feature-rich. Every visible capability should have a tested end-to-end path or a clear unavailable state.
