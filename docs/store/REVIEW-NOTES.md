# App Review notes draft

Prepared 27 October 2026; updated 29 October 2026. For the actual signed **AppStore** archive only. Owner must replace contact fields and confirm these steps on the submitted build. This draft is not evidence of submission or approval.

## Text for Notes for Review

Pebble is a native macOS text assistant using Apple’s on-device Foundation Models `SystemLanguageModel.default`. This Store configuration does not require Ollama, download a separate executable, expose image attachments, use a hosted inference account, or instantiate a Private Cloud Compute model. No sign-in is required.

Please review on a compatible Apple Intelligence Mac with macOS 26 or later, Apple Intelligence enabled, and the system model ready. Pebble displays the specific model-availability message when the device is ineligible, Apple Intelligence is disabled, or the model is preparing. The app's Apple-only setup guides the user to the model readiness state; it does not require microphone permission for typed tasks.

1. Launch Pebble, select Use Apple on-device when the model is ready, and open Chat. Enter “Give me three ways to organize a writing task” and press Enter.
2. Open Rewrite and enter “please send the project update by friday. thank you for your help.” The original and result remain reviewable; Copy, Share, and Save are deliberate controls.
3. Optional: choose Dictate, grant Microphone and Speech Recognition access, speak a short sentence, stop, and review the draft before sending. Unsupported on-device recognizers report guidance; they do not switch to network recognition. Denying voice permissions leaves typed chat available.
4. In Actions enter “Pebble local writing tools” and choose Search in Safari. Inspect the exact query, destination, and external-data disclosure. Cancel does not navigate. Propose again and Approve & run opens the exact DuckDuckGo query in Safari. Pebble explicitly says it has not read results or verified citations.
5. Review this Mac proposes a limited read: OS version, logical processor count, physical RAM, available storage, time and time zone. Approval is required. It does not inspect personal files, app/screen content, credentials, or process lists.
6. Ask “What time is it?” in Chat to see a direct Mac system-clock response. Clear resets current in-memory conversation context and output.

Recent text chat includes up to four budgeted turns in the next model request; at most eight turns remain in memory. Current requests are limited to 2,048 UTF-8 bytes; recent context is shortened and reduced to fit a combined 2,304-byte text budget. These are conservative limits rather than an exact token count. Over-budget requests retain the draft and ask the user to shorten it. Rewrite requests use only the supplied draft. Pebble does not persist chat content to disk. In-app privacy information explains the browser/share/save boundaries.

Foundation Models is used with the default system guardrails. Pebble has no public user feed, hosted user accounts, or in-app social posting. The owner must assess the applicable content safeguards and age-rating questionnaire against the actual text experience; these notes do not establish Apple’s review interpretation.

The application is sandboxed. The Store entitlements include microphone/audio input and user-selected read/write files for saving responses; they omit network-client access. Safari navigation and system sharing occur through explicit user actions outside model inference. There is no shell executor, arbitrary automation, message sending, browser-page extraction, or image generation.

The window remains available through the menu-bar item after closing its main window; Quit ends the app. Control-Space opens the window and starts/stops optional dictation while Pebble is running. If another app owns that shortcut, use the menu-bar item or Dictate button. It does not install a background service or automatically enroll itself as a login item.

AI responses may be incorrect; model guardrails may refuse some requests. The Store edition is text-only. The separate GitHub direct-download edition has optional Ollama features that are not part of this submission.

## Before using these notes

- Confirm every step on the signed Store build and current shipping macOS, with no preview-only labels or controls.
- Verify in-app Privacy Policy / Support links actually work, including when the model is unavailable.
- Attach Store-build screenshots and, optionally, a short real recording of these exact steps.
- Supply the review contact directly in App Store Connect; no fabricated account or credential is needed.
- If model readiness prevents review, explain the concrete state and supported hardware; do not invent a demo mode or ask Apple to install a separate executable.
