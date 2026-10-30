# Store privacy-answer draft

Prepared 27 October 2026; updated 29 October 2026 from source review, not submitted answers or a legal certification. Apply only to the exact Apple-only Store archive. Owner must reconcile any changed services, support channels, SDKs, or diagnostics before publishing.

## Proposed Connect answers

| Question / area | Draft and evidence |
|---|---|
| Do you or third-party partners collect data from this app? | Proposed **No, we do not collect data from this app**, conditional on final artifact/service review. Text inference and speech remain on-device; no developer server, analytics SDK, account, tracking or prompt-upload mechanism found. |
| Tracking | No tracking found; manifest `NSPrivacyTracking=false`, empty domains. No ATT request proposed. |
| User content/audio | Processed locally in memory, not sent to a developer server. Audio is not saved by the app. Do not mistake the existence of text/voice controls for off-device collection. |
| Diagnostics | Shortcut/dispatch OS logs omit prompt text. No automatic developer diagnostics upload found. Support reports voluntarily sent to the owner require separate policy/retention review. |
| Search/share | Exact approved query or URL leaves via Safari; selected answer leaves through the chosen sharing service. Do not claim the entire system is offline. No embedded search SDK or web view is included. Review final privacy answers if a search service, fetched results, analytics, or hosted model is later integrated. |
| On-device context | Eight session turns retained in process memory; up to four recent shortened turns can enter text chat, within the combined UTF-8 text budget. Rewrite excludes recent context. Clear resets; quit loses session content. No app-owned disk history found. |

Apple defines collection around off-device transmission with access beyond real-time servicing; solely on-device processing is not collected. Developers must account for incorporated partners and maintain accurate answers. See [Apple privacy details](https://developer.apple.com/app-store/app-privacy-details/), checked 27 October 2026. This draft does not excuse disclosing any actual collection.

## Privacy manifest review

`Resources/PrivacyInfo.xcprivacy` is a project resource and declares:

- UserDefaults / `CA92.1`: setup, window and appearance preferences for this app.
- DiskSpace / `85F4.1`: display free-space information in the approved Mac summary.
- No collected data types, tracking, or tracking domains.

The disk-space reason prohibits sending accessed or derived data over the Internet. Keep the Mac summary outside chat history, model requests, generic response sharing, support uploads, or automated telemetry. Current action output is separate from chat output; it is selectable, so the policy cannot promise users are technically prevented from manually copying information outside Pebble. Do not add an app-provided off-device summary workflow under this reason without a fresh assessment. [Apple required-reason API reference](https://developer.apple.com/documentation/bundleresources/app-privacy-configuration/nsprivacyaccessedapitypes/nsprivacyaccessedapitype), checked 27 October 2026.

The archive gate must verify the manifest is present in `Contents/Resources`, and inspect actual signed entitlements. Source plists alone do not prove archive contents or App Store privacy validation.

## Public privacy-page text draft

Pebble's Store edition uses Apple’s on-device model for text and rewriting. It requires a compatible Mac and a ready Apple Intelligence model. It does not use a hosted inference provider or a Pebble account.

Typed prompts, responses, and recent conversation context remain in process memory. Pebble keeps up to eight text turns during a session. For chat, it considers up to four recent turns, shortening each user message to 192 UTF-8 bytes and each answer to 320 bytes, and drops older context as needed to keep the current request plus context within 2,304 bytes. Current model requests above 2,048 UTF-8 bytes are rejected intact so the draft can be shortened. These are conservative text budgets, not exact tokenizer measurements. Rewrite uses the current draft. Clear removes the conversation and output; quitting ends the session. Pebble does not save chat history or audio recordings to disk. Setup, appearance, and window preferences may remain in macOS app preferences.

Dictation is optional. Pebble requests Microphone and Speech Recognition access when you start it and requires an on-device recognizer. Unsupported languages report guidance instead of using network recognition. Stop ends capture; typing works without voice permissions. You can revoke those permissions in System Settings → Privacy & Security.

Copy writes the answer to the clipboard only when chosen; Paste reads text when chosen. Save writes a file you select. Share passes the chosen answer to your chosen service. Those services and clipboard utilities have their own policies.

Actions require approval of the exact Safari query, HTTPS destination, or Mac-summary scope. Search sends the approved query to DuckDuckGo through Safari. Pebble does not read web results or verify citations. A basic Mac summary displays OS version, processor count, physical RAM, available volume storage, and system time; it does not scan your files, screens, app contents, or process list. Diagnostic action output is separate from chat sharing and is not fed into model context.

Pebble includes no advertising or analytics SDK and does not track you. Shortcut-related OS logs omit prompt text. Apple’s operating system and browser services follow their own policies; local inference is not a promise that your entire computer never uses a network.

For privacy questions or voluntarily supplied support information, contact [OWNER'S VERIFIED PRIVACY CONTACT]. [OWNER MUST DEFINE SUPPORT CORRESPONDENCE RETENTION/DELETION HERE.] These placeholders are preparation fields and must be replaced before this page is published or submitted.

## Pass 2 reconciliation

Current source adds visible Privacy Policy and Support links to Setup and the More menu. This resolves the missing-link control finding at source level only. The earlier public 1,200/1,800-character context description has now been corrected. Live public policy was rechecked on29October and contains the 2,048/2,304-byte limits, Apple engine description, redirect refusal and separate diagnostic output. A verified public page still does not complete owner contact/retention approval or actual in-app link acceptance. No user-facing contact or support-correspondence retention policy has been invented.

## Pass 3 archive evidence

Clean-runner CI40976673954 successfully created an actual unsigned AppStore archive for source5f7a043. Its checker found a packaged privacy manifest with no tracking or collected data types. The enhanced checker was subsequently run against the downloaded archive and verified packaged CA92.1/85F4.1 entries. Actual signed entitlements remain unverified; keep unsigned and signed evidence distinct. No privacy answers have been submitted to Apple.
