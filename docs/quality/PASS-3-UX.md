# Pass 3 — final native UX/UAT

Reviewed October 29, 2026 (America/Denver) against the `APP_STORE`-compiled, ad hoc signed Store preview. This is the third and final planned review pass; repairs and verification below occur within this pass. No Apple account submission, permission grants, or system accessibility setting changes were performed.

## Reproduced defect verification

The pass-2 reproduction **UX-201 now passes** at the same 903 × 672 screenshot size: Tokyo clock request → expanded run details → over-budget synthetic draft → Enter. Header/avatar/subtitle, composer and Copy/Share/More/Clear remain within the viewport; the variable error, answer and receipt scroll inside the response region. The exact rejected draft remains intact. [Fixed combined state](../media/quality/pass3-01-compact-error-fixed.png).

The initial dark-appearance review found saturated dark cobalt labels on dark material, reducing secondary control legibility. A semantic light/dark accent repair improved the secondary labels, but the lightened dark-mode accent initially left white labels on light-blue prominent buttons. [Initial dark controls](../media/quality/pass3-06-dark-rewrite.png) and [primary foreground follow-up](../media/quality/pass3-10-dark-accent-active.png) record those intermediate findings rather than presenting them as final accepted marketing assets.

## Real runtime evidence

| State | Observed result | Evidence |
| --- | --- | --- |
| Live Apple model generation | Visible native spinner, elapsed feedback, disabled conflicting controls, reachable Cancel and stable compact layout | [Waiting](../media/quality/pass3-02-apple-waiting.png) |
| Live Apple completion | Short welcome completed in 5.6s, composer cleared, correct distinct request/response and response controls visible | [Completed](../media/quality/pass3-03-apple-complete.png) |
| Model capability stress | Longer technical and creative requests produced capability refusals; these remain quality limitations, not successful task completion | [Refusal](../media/quality/pass3-04-model-limitation.png) |
| Immediate Escape after rewrite submission | Draft remained/restored and app returned idle; no live busy-state capture before Escape, so this is limited evidence, not accepted mid-generation cancellation | [Draft](../media/quality/pass3-05-rewrite-cancel-draft.png) |
| Focused short rewrite | Actual Apple response preserved meaning, cleared composer and completed in 0.9s | [Dark rewrite](../media/quality/pass3-06-dark-rewrite.png) |
| Store setup | Correct macOS26/Apple Intelligence requirement, no Ollama/image setup, visible Privacy policy and Support links | [Setup](../media/quality/pass3-07-store-setup.png) |
| Long approval | Body scrolls; Cancel and Approve remain visible and separate from scrollable destination | [Approval](../media/quality/pass3-08-long-approval.png) |
| Approval cancellation | Escape closes sheet and shows “Not approved. Nothing executed.” No external action was approved | [Denied](../media/quality/pass3-09-approval-denied.png) |

All evidence is actual native app capture with synthetic requests. The model refusals cannot be dismissed as UI bugs or used as cancellation proof. The app is most convincing in short rewriting, concise assistance and deterministic/approved tool workflows. It has not established broad parity with hosted general-purpose assistants.

## Remaining acceptance limits

VoiceOver speech/output order, physical Control-Space outside this app and conflict recovery, microphone/speech permission denial/regrant, unsupported recognizer locales, Increase Contrast, Reduce Transparency, Reduce Motion, fresh-machine installation and signed Store archive validation remain unaccepted in this run. Accessibility labels and native controls are useful evidence but do not certify those paths. Final Store screenshots must be from the signed candidate and conform to current Apple specifications; these working captures are development evidence.

## Final within-pass verification and score

The final repaired candidate uses light adaptive cobalt for secondary labels in dark appearance and a separate deep-cobalt fill for prominent buttons. The earlier outer foreground modifier did not change the native prominent label; that intermediate candidate was rejected. The final actual captures show the repaired treatment:

- [Accepted dark active Send](../media/quality/pass3-12-accepted-dark-send.png): white label on deep cobalt; secondary Dictate/Paste/Clear labels remain light and legible.
- [Accepted dark approval](../media/quality/pass3-13-accepted-dark-approval.png): legible Cancel and white-on-deep-cobalt Approve; Escape denied the action again.
- [Accepted light active Send](../media/quality/pass3-14-accepted-light-send.png): light appearance remains coherent and readable.
- [Native wide draft](../media/quality/pass3-15-store-wide-draft.png) and [actual Store-config response, 1280 × 800](../media/quality/pass3-16-store-response-1280x800.png): resized through the real window edge, not raster scaling or generated UI. The final short rewrite completed in 1.1s and cleared its composer. These are Store-configuration development captures, not signed-archive certification.

All final files above were visually inspected when captured. This is visual legibility review, not a measured WCAG contrast certification or acceptance under Increase Contrast.

| Dimension | Final score / 10 | Rationale |
| --- | ---: | --- |
| Visual craft | 8.3 | Coherent identity, restrained native materials, repaired light/dark controls, stable compact/wide framing. Some metadata remains small and should receive real accessibility-setting review. |
| Interaction clarity and task success | 8.0 | Explicit requests, transactional drafts, clear approval boundaries, successful short rewrite and deterministic clock. Broader model-task refusals and the unconfirmed live cancellation path prevent a stronger score. |
| Accessibility | 7.4 | Usable native semantics, labels/help, keyboard Enter/Escape, and fixed reachable controls. Spoken VoiceOver navigation, high-contrast settings, global shortcut and permission recovery remain unverified. |
| State resilience and UAT coverage | 8.0 | Exact compact overflow fixed; real error/receipt/wait/completion, long approval, denial, light/dark and native resize observed. Fresh-machine/unavailable-model/permission matrix is incomplete. |
| **Overall observed UX** | **7.9** | Arithmetic mean 7.925, rounded to one decimal. **Below the requested 8/10 threshold; stop after the third pass.** |

No reproduced critical clipping or active-control contrast defect remains in the final observed states. That does not make untested accessibility or distribution paths pass. The score is deliberately not rounded up to meet the target. The next useful acceptance work is targeted human accessibility/permissions/global-shortcut testing and task-quality evaluation of the Apple engine, rather than another visual polish loop.

CUA ownership returned to the release owner. No source edits were made by this reviewer.
