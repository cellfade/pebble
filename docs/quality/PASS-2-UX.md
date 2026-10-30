# Pass 2 — native Store-preview UX/UAT

Reviewed October 29, 2026 (America/Denver). This is the actual `APP_STORE`-compiled, ad hoc signed `dist/StorePreview/Pebble.app`, not an Xcode archive or signed Store distribution. The direct app was quit before launching this exact candidate. No permissions were granted, system settings changed, external action approved, or private content entered.

## Score and gate

| Dimension | Score / 10 | Evidence and limits |
| --- | ---: | --- |
| Visual craft | 8.0 | Coherent stone identity, cobalt primary actions, native adaptive materials and controls; normal compact screen is legible and restrained. |
| Interaction clarity | 7.5 | Enter sends, composer clears after clock response, explicit local clock provenance, budget rejection preserves draft. Error repeats in the response header and overloads the compact state. |
| Accessibility | 6.5 | Accessibility tree exposes Prompt help, semantic buttons and receipt disclosure. The combined error/receipt state hides essential controls. VoiceOver, contrast settings, physical global shortcut and permission recovery are not accepted by this run. |
| State resilience / UAT | 6.5 | Normal and receipt-expanded compact states observed. Combined budget error plus expanded receipt reproduces viewport overflow; broad live-generation/permissions/install matrix remains incomplete. |
| **Overall observed UX** | **7.1** | Arithmetic mean, rounded to one decimal. **Below 8/10; gate fails.** |

The score does not certify Store readiness or average away the blocking layout defect. An 8/10 product score cannot establish Apple acceptance or accessibility conformance.

## Reproduced blocking finding

**UX-201 — compact error plus expanded receipt clips header and response controls (P1, blocks release gate).**

1. Launch the Store preview into the restored compact window (captured at 903 × 672 pixels).
2. Type `What is the current time in Tokyo?`, then press Enter.
3. Expand `Run details · macOS`.
4. Paste `This is a synthetic long-request test. ` repeated 80 times into the prompt, then press Enter.
5. The exact draft is retained and the budget error is correct, but the outer fixed vertical stack exceeds its viewport: the top hero moves above the visible content, its subtitle disappears, the avatar is clipped, and Copy/Share/More/Clear fall partly below the bottom edge.

Evidence: [compact error and expanded receipt](../media/quality/pass2-01-compact-error-receipt.png). This screenshot was captured through native computer use and visually inspected immediately. All content is synthetic or public system-clock text.

**Minimal repair:** constrain variable-height error, submitted request, waiting state, response and expanded receipt to an intentional response scroll region while keeping the hero, composer and bottom controls within the window. Avoid moving the whole window or silently increasing its minimum height to conceal the reproduction. Do not restore the previously broken NavigationSplitView. Avoid duplicating the full error as both an alert and response-status text.

CUA ownership was returned immediately after this reproduction so the release owner can repair and rebuild. No source edits were made by this reviewer.

## Verified before the defect

- Actual candidate sidebar shows Chat, Rewrite and Actions; there is no Image questions entry or image-attachment control.
- Engine shows Apple on-device. Sidebar label is `v0.3.0 · On-device edition`, without beta/developer-preview wording.
- Empty state says `Start with a question or a rough draft.`, without suggesting Store image support.
- Enter-submitted clock request clears the composer and yields a distinct submitted-request label and explicit system-clock/time-zone source.
- Receipt expands through an accessibility disclosure and identifies model, input, context and local-memory policy.
- Over-budget input is rejected before generation and remains intact in the composer.
- Normal compact layout and receipt-only expanded layout fit before adding the error; the combined state is the trigger.

## Still not accepted

A post-fix pass must repeat the exact reproduction and then inspect light/dark, setup privacy/support links, live Apple generation and waiting/cancel states, long approval with fixed buttons, and keyboard-only recovery. Broader Store gates remain: physical global shortcut conflicts, microphone and speech denial/regrant, unsupported speech locale, VoiceOver, Increase Contrast, Reduce Transparency, Reduce Motion, fresh eligible Mac installation, actual signed archive and Store submission.
