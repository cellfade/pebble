# Pebble — editable Figma handoff

Created 26 October 2026; finalized 27 October 2026, with the approved neutral stone and floating black ink-face direction. This is a brand reference and marketing storyboard, not a completed website or App Store submission.

[Open the complete board in Figma](https://www.figma.com/design/WIZgIiOGFHdfGDg0wgGZBs?node-id=3-196)

## Contents

| Frame | Node | Purpose |
|---|---|---|
| Complete board | `3:196` | Eight-panel composition |
| Brand essence | `3:212` | Name, positioning, approved stone mark, small promise |
| Mark system | `3:231` | Color and monochrome editable SVG, size examples, misuse rules |
| Color and typography | `3:299` | Cobalt/ink/cream/stone/slate, SF Pro, material guidance |
| Voice and behavior | `3:329` | Plain language, truthful state, explicit boundaries |
| Marketing hero | `3:344` | Navigation/hero/CTAs and accepted real beta screenshot |
| Local engines | `3:367` | Apple and optional Ollama routes, permissions, local boundary |
| Start and download | `3:387` | Three-step start, published beta CTA, Store preparation gates |
| Delivery checklist | `3:414` | Approved identity, accepted evidence, implemented beta scope, release gates |
| Construction library | `3:202` | Main components outside the composition |
| Primary CTA component | `3:206` | Reusable editable component |
| Secondary CTA component | `3:209` | Reusable editable component |

## Editable construction

The composition contains native SF Pro text, auto-layout frames, vector paths imported from the canonical SVGs, reusable CTA instances, and semantic color aliases. The composition uses editable text, 36 logo vectors, SVG groups, auto-layout frames, five palette rectangles, four CTA instances, and one authentic native-app screenshot. The screenshot is intentionally raster evidence; the surrounding layout and logo remain editable. The brand collection contains 14 primitive/semantic variables with Light/Dark values; the board itself was reviewed in its light reference state. It does not constitute a dark-mode product UI review.

The connector renderer needed explicit line-aware text heights and container sizing after the initial composition exposed clipping. The corrected full composition was exported and visually inspected; it now has separated headings/body content and readable note/engine cards. Text boxes remain editable, but sizable copy changes should trigger another layout/export review. CTA component label properties exist; font resolution through the connector's `setProperties` path failed, so current instance labels were edited directly after fonts loaded. Do not assume that property automation has been validated.

## Canonical assets

- `brand/pebble.svg` — canonical color stone/ink mark, supplied by the app implementation owner.
- `brand/pebble-mono.svg` — canonical monochrome mark, intended for small/template applications.
- `brand/pebble-brand-marketing-board.png` — 4096 × 2773 composition export, visually reviewed.
- Approved generated art source: `../../brand-exploration/v2/pebble-stone-icon.png` relative to the repository root's parent output folder; the editable board uses the canonical SVG instead of a flattened image.

The Figma mark is the simple SVG reference. The dimensional app-icon tile is a separate packaging asset. Do not revive the earlier robot/visor direction. Tiny mark examples make the face progressively less legible; ship a tested template silhouette for menu-bar use, with an accessible name.

## Truth and release gates

The former screenshot placeholder now contains the release owner’s accepted real native-app rewrite capture, docs/media/01-beta-response.png. No generated interface was used as product evidence.

The beta CTA links to the published v0.3.0-beta.1 GitHub prerelease. Show architecture, version, checksum, signing/notarization status, and installation requirements alongside the actual asset. App Store copy states preparation in progress, without suggesting approval or availability.

The storyboard now labels approval-based Safari search, open HTTPS, basic Mac summary, truthful clock, and bounded recent context as implemented in beta, with accepted UAT captures referenced. Opening browser search is not web-result retrieval or a sourced research answer. Image understanding depends on the selected vision-capable Ollama model; generation remains pending. The Apple route requires compatible Apple Intelligence hardware, macOS 26+, and model readiness. Optional Ollama setup is a separate direct-edition route.

## Next production work

1. Maintain the accepted real product capture and add the release owner’s real interaction recording when ready.
2. Keep release/source links aligned and refine the installation CTA to its exact guide destination.
3. Reconcile every capability statement against the release acceptance report.
4. Produce responsive marketing layouts and focused panel exports when the website implementation begins.
5. Complete signing, fresh-Mac installation testing, metadata, accessibility evidence, archive validation, and Apple review before any Store availability claim.

Research rationale: [RESEARCH.md](RESEARCH.md). Native UI acceptance contract: [DESIGN-REVIEW.md](DESIGN-REVIEW.md).

## Accepted evidence, links, and final validation

The release owner supplied and accepted `docs/media/01-beta-response.png`, `05-beta-approval.png`, and `07-beta-approved-result.png`. The first is uploaded through supported Figma asset storage as an image fill on node `3:363` at its original aspect ratio, with no recreated UI. The other two are linked by exact evidence filenames in the delivery panel. Panel 05 now identifies v0.3.0-beta.1 as a developer preview, **not notarized**; the beta destination is the published prerelease. Bounded action/clock/context labels have advanced to implemented in beta; App Store availability remains unclaimed.

The source CTA text links to https://github.com/cellfade/pebble. Beta CTA text links to the verified published prerelease https://github.com/cellfade/pebble/releases/tag/v0.3.0-beta.1. The release owner verified that it is public, not draft, marked prerelease, and has all three assets uploaded, with the server ZIP digest matching the local package. CI run 40632055769 succeeded for source commit 9d20960. The installation CTA should be refined to the installation guide when that exact published destination is finalized.

Final status annotation nodes: `20:7` beta/notarized status; `21:6` published-prerelease caption (replaces `20:8`); `20:9`–`20:10` accepted evidence; `20:11`–`20:12` implemented beta scope; `20:13` exact UAT references; `20:14` permission boundary. These annotations use Inter because the connector renderer kept stale SF Pro text runs on updates. The main brand type reference remains SF Pro. This is a rendering workaround confined to board annotations, not a recommendation to change native app typography.

The final full-board PNG was downloaded and visually inspected after the annotation correction. It shows the real app capture intact, readable status/permission notes, and the approved neutral stone identity. Root and panel IDs are unchanged. No app source, CUA, Git, or external release publication was touched by this handoff.

Final publication annotation: the screenshot caption now reads “Published beta prerelease · v0.3.0-beta.1 · Not notarized · CI passed” and links directly to the release. The changed board was exported again and visually inspected; the real screenshot and caption are intact. This updates publication status only. Developer ID signing/notarization, fresh-Mac acceptance, and App Store archive/provisioning/review remain separate gates.
