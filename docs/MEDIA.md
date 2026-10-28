# Beta media evidence

The seven screenshots below are genuine captures of the running Pebble v0.3.0-beta.1 app using the approved stone-and-ink identity. They show synthetic test content. Every listed capture was opened and visually inspected for layout and accidental private content; no private conversation, file path, account identity, or secret was visible.

| Capture | Observed state |
| --- | --- |
| [Rewrite response](media/01-beta-response.png) | A completed local rewrite with a cleared composer and visible copy/share controls |
| [Clock request](media/02-beta-clock-request.png) | A new distinct prompt entered after the rewrite |
| [Clock result](media/03-beta-clock-result.png) | Explicit macOS clock/time-zone source, including Pacific/Auckland |
| [Actions](media/04-beta-actions.png) | Reviewable Safari search request with capability limits |
| [Approval](media/05-beta-approval.png) | Exact query and destination, disclosure, Cancel and Approve controls |
| [Denied](media/06-beta-denied.png) | “Not approved. Nothing executed.” after cancellation |
| [Approved result](media/07-beta-approved-result.png) | Safari-open result with an explicit statement that Pebble did not retrieve results or verify citations |

The final light-appearance interaction is also captured in [light clock response](media/08-beta-light-interaction.png); the complete header and footer remain visible after Enter submits a second request.

## Sampled interaction video

[Watch the beta interaction demo](media/pebble-beta-demo.mp4).

This is a **time-compressed sequence of real screenshots**, not a continuous screen recording. Capture order follows the seven numbered screenshots above. Inter-capture intervals are compressed by 10× with a two-second minimum hold per state, followed by a three-second final hold. It has no audio. Pauses and cursor movement between samples are omitted; it must not be used as latency evidence. The approval capture includes only the sheet, so the video changes framing for that state.

Obsolete setup captures are excluded. Historical clipping evidence under `media/uat/` uses earlier branding and is audit material, not the current product gallery.

The approved-action screenshot records Pebble's completion report. These images do not show Safari's resulting page, establish web-result retrieval, or prove citation support. Permission-denied dictation, VoiceOver, high-contrast settings, and a complete installation flow need separate acceptance evidence.

Encoding uses the existing AVFoundation helper (`scripts/make_demo.swift`), H.264 in an MP4 container. Independent AVFoundation inspection confirmed a 27.833-second duration, one video track, and 1280×1080 dimensions. A decoded frame near the end was also visually inspected.
