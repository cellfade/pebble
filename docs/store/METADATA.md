# Store metadata draft

Prepared 27 October 2026; source reconciled 29 October 2026. Copy for the **Apple-only Store configuration**, not the direct Ollama preview. Nothing has been entered into App Store Connect. Replace owner fields, verify URLs, and reconcile with the exact signed build before submission.

| Field | Draft / required decision |
|---|---|
| Name | Pebble (6 characters; name availability/rights not verified) |
| Subtitle | Local help for thoughtful work (30 characters) |
| Primary language | English (US), proposed; owner confirms |
| Primary category | Productivity; matches `public.app-category.productivity` |
| Secondary category | None proposed |
| Bundle identifier | `io.github.cellfade.pebble`; owner must confirm registration/control before first upload |
| Version/build | Source Store plist currently 0.3.0 / 4; increment build if already uploaded; no account history inspected |
| SKU | `pebble-macos` proposed; owner confirms before record creation |
| Price / territories | Owner decision; no price, tax, trader, or legal agreement choices made |
| Copyright | `2026 [verified rights-holder name]` — owner supplies; do not publish placeholder |
| Privacy Policy URL | Current in-app link: https://github.com/cellfade/pebble/blob/main/docs/PRIVACY.md. Current context/privacy corrections are published and the raw policy was verified publicly readable on29October. Owner retention/contact details and actual in-app link behavior still need approval/acceptance. See PRIVACY-ANSWERS.md. |
| Support URL | Current in-app link is https://github.com/cellfade/pebble/issues. This is a developer issue channel, not yet a verified support page displaying actual owner contact information. Owner must supply a real contact and final public page; see SUPPORT-PAGE.md. |
| Marketing URL | Optional; repository is https://github.com/cellfade/pebble until a verified product page exists |
| Review contact | Actual reachable first/last name, email, phone; owner supplies privately in Connect |
| Release option | Manual release recommended for first Store version, owner confirms |

Apple permits a name/subtitle up to 30 characters; keywords are limited to 100 bytes. These drafts fit those fields. Sources: [app information](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/), [platform version fields](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information), checked 27 October 2026.

## Promotional text

A little help. Close to home. Chat, refine a draft, or dictate a thought with Apple’s on-device model. Review every supported Mac action before it runs.

## Keywords

`local,assistant,rewrite,dictation,writing,private,on-device,productivity`

ASCII, 72 bytes. Do not add competing app names, unsupported capabilities, or unverifiable superlatives.

## Description

A little help. Close to home.

Pebble is a native Mac companion for local conversations and clearer drafts. Its quiet stone character and simple workspace make it easy to bring a thought, review an answer, and get back to your work.

WRITE AND THINK LOCALLY
Ask a question or refine a draft with Apple’s on-device language model. No Pebble account, API key, or separate model runtime is needed. Recent text context stays bounded to your current session; Clear starts fresh.

SPEAK, THEN REVIEW
Use optional on-device dictation to turn speech into editable text. Review your words before sending. Type whenever you prefer. Enter sends; Shift-Enter adds a line.

KEEP CONTROL OF THE NEXT STEP
Copy, share, or save a response through explicit controls. Pebble can propose a Safari search, open an explicit HTTPS link, or show a basic Mac capacity summary. Review the precise effect and approve that single action before it runs.

KNOW THE LIMITS
Safari opens the approved search or page; Pebble does not read web results or verify citations. The Store edition handles text and dictation, not image analysis or image generation. AI answers can be incorrect. Recognized time/date requests use the Mac system clock instead of a model estimate.

REQUIREMENTS
Requires macOS 26 or later, a compatible Apple Intelligence Mac, Apple Intelligence enabled, and the on-device model ready. On-device dictation also depends on microphone/speech permissions and support for your selected language. If the model is unavailable, Pebble explains why; it does not fall back to a hosted model.

## What's New

For a first submission, do not claim an update from a previous Store version. If the field is required for a later version, write changes relative to the last approved Store build, not the GitHub beta.

## Do not publish these claims

No “best,” universal privacy/security guarantee, full Mac control, fetched web citations, image capability, unlimited memory, or Ollama setup in Store metadata. Do not market this as a beta/trial Store release; use TestFlight for testing. A GitHub prerelease does not establish Store availability.
