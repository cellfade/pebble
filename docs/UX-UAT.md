# Layout regression investigation and screenshot UAT

Date: October 26, 2026. Scope: the clipping beta blocker and the native workspace layout, before the next backend/action integration. These are actual app captures with synthetic prompts, not image-generated mockups. They use the historical cobalt robot identity, before the owner selected the final neutral stone-and-ink Pebble identity. The layout evidence remains valid; it is not final-brand marketing media.

## Verdict

The interaction-triggered clipping regression is fixed in the tested workspace states. A short, explicit native-pane layout replaces the unstable native NavigationSplitView sizing path. This is a targeted layout fix, not evidence that all beta flows are complete.

## Root cause and rejected hypotheses

The native window stayed **989×758** while interaction caused `NavigationSplitRepresentable` to grow from **989×758 at (0,0)** to **989×1155 at (0,-172)**. Header and footer were laid out outside the visible window. The earlier startup-only geometry dumps missed this after-state.

- Scroll-origin propagation was rejected: editor and response clip bounds remained at zero.
- Custom Liquid Glass was rejected: the issue reproduced with the native custom glass wrappers disabled.
- Incorrect initial window placement was rejected: the actual window dimensions remained unchanged while the split representation grew.
- An explicit GeometryReader/frame around NavigationSplitView alone did not prevent its native representation from escaping the viewport.
- A bounded HStack with the same native sidebar List and detail content removes the problematic split bridge. After editing, mode changes, generation, and native zoom/restore, the header and footer stay visible.

The beta now uses a fixed 210-point sidebar. Collapsible/resizable sidebar behavior should return only with its own regression evidence. Native window resizing, zoom, movement, and the main content remain available. The reading column is capped at 1000 points so zooming does not produce screen-wide prose lines. Real Apple glass remains enabled for the controls; Reduce Transparency retains its opaque fallback.

Private before/after native-tree snapshots are in the task's work/uat directory. Temporary geometry-writing timers were removed from production source after evidence collection.

## Screenshot steps

1. **Before regression — broken.** [00-clipping-regression-before.png](media/uat/00-clipping-regression-before.png) shows the top of the editor above the viewport, missing title/header and absent bottom controls.
2. **Light, edited rewrite and response — healthy.** [01-light-after-interaction.png](media/uat/01-light-after-interaction.png) shows the full header, editor, glass action strip, local result, sidebar runtime controls, and copy/share/clear row after the trigger sequence.
3. **Expanded native window — healthy layout, readability improved.** [02-expanded-after-interaction.png](media/uat/02-expanded-after-interaction.png) records native Zoom at 2560×1311. All controls remain visible. This evidence exposed overly long lines; the subsequent 1000-point reading cap addresses that craft issue.
4. **Compact-height empty state — healthy.** [03-dark-compact-empty.png](media/uat/03-dark-compact-empty.png) shows the empty state with the header/footer intact at 1280×669, approximately the 640-point minimum content height.
5. **Dark compact-height generation result — healthy.** [04-dark-compact-after-generation.png](media/uat/04-dark-compact-after-generation.png) shows a real Apple on-device response to a synthetic beta-check prompt, after editing and generation, with header/footer still visible.

Every saved file above was reopened and visually inspected. The light expanded capture predates the final reading-width cap; it is audit evidence, not the preferred marketing image.

## Observed behavior and verification

- Built and launched the native SwiftUI app with the explicit viewport layout.
- Typed a synthetic prompt, changed Chat → Rewrite, generated a real local response, and confirmed the same sequence no longer clips.
- Used native Zoom/restore and a native top-left tiled window to exercise large and minimum-height layouts.
- Repeated text entry and a real local generation in dark appearance at compact height.
- Setup opened inside its own intentional scroll region rather than pushing the workspace. A later setup scroll-to-Continue check was interrupted by the computer-use service's app-change guard and is not claimed complete.
- Existing native window movement was observed in the app's debug window events; no change to title-bar drag behavior was required for the clipping fix.

## Historical pre-integration findings

- **P1, parent integration:** error/approval states and the new Actions surface must be rechecked after the backend/action changes land. Current screenshots do not validate those new flows.
- **P1, parent integration:** separate user prompts instead of concatenating repeated typed questions, and show a clear bounded conversation context policy. The current model cannot be expected to read system clock or device information without an explicit tool path.
- **P2:** `DictationService.stop()` changes the status even when no recording was active; startup/focus changes can show “Dictation stopped” unnecessarily. Make inactive stop a no-op for the visible message.
- **P2:** the optional Ollama setup's Check connection currently shows the selected Apple engine status if Apple is selected. The connection test should explicitly test Ollama or clearly name the selected engine.
- **P2:** compact-height error text should be constrained or scroll within the intended region so long errors cannot push the response tools out again.
- **P2:** a future collapse/resize affordance for the sidebar needs a dedicated native-layout test rather than restoring the old NavigationSplitView blindly.
- VoiceOver, high contrast, Increase Contrast, Reduce Transparency, Reduce Motion, all permission-denial states, and physical global shortcut dispatch need explicit acceptance coverage. Labels and semantic colors alone are not proof of accessibility conformance.

The latest computer-use session occasionally reported that the app changed under Documents and rejected actions even without a source rebuild. This limited the final setup-scroll check. It is documented separately from the now-reproduced-and-fixed app clipping bug.

## Post-integration acceptance gate

The backend and approval surface changed after these captures. Retest the final integrated build rather than treating the earlier layout captures as proof of new capabilities:

- Submit, cancel, retry, then send a second distinct prompt; confirm the visible draft and submitted prompt remain unambiguous and the header/footer remain within the viewport.
- Open each proposed action, inspect its exact destination, cancel by button and Escape, and confirm neither cancellation executes anything. Approve once, verify the observed result, and ensure stale/expired approval cannot run again.
- Exercise a very long action value and destination at minimum window height. The current approval sheet needs a bounded scrollable review body with fixed Cancel/Approve controls so arbitrary model text cannot make the decision controls unreachable. This is a P1 usability risk from source inspection, not a reproduced approval bypass.
- Confirm Copy prompt and browser-search controls operate on the prompt their labels imply after submission; the editor can display pendingPrompt during generation while these controls reference the draft.
- Capture the final stone-and-ink build in light/dark, normal/minimum/expanded sizes, after interaction, with both approval and error states.

Read-only frontend inspection found no obvious P0 approval bypass. Runtime approval execution and stale-request rejection require the final integration test.

## Current three-pass quality cycle — 29 October 2026

The historical findings above are retained as the investigation record. Current source/tests address request boundaries, authoritative clock output, inactive dictation status, explicit Ollama refresh, one-shot approval validation, and bounded approval bodies. Pass2 reproduced a separate combined compact-window error/expanded-receipt overflow. Pass3 places all variable response content in one scroll region with fixed header, composer and action row, and scrolls new run/error/output feedback into view. Current evidence and unresolved manual gates are recorded in `quality/PASS-3-UX.md`, `quality/PASS-3-CODE.md` and `quality/PASS-3-STORE.md`; do not infer a blanket pass from the earlier screenshots.
