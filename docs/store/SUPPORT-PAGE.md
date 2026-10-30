# Support-page draft

Prepared 27 October 2026; updated 29 October 2026. Publication-ready structure, **not yet a verified public support URL**. Owner must replace contact fields and confirm hosting before linking it from the app or Connect. Apple requires a support website with actual contact information: [platform version fields](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information), checked 27 October 2026.

## Pebble support

A little help. Close to home.

Pebble's Mac App Store edition provides text chat, rewriting, optional on-device dictation, and a small set of approved Mac actions. It uses Apple’s on-device model and does not require Ollama, an API key, or a Pebble account.

### Requirements

Use a compatible Apple Intelligence Mac running macOS 26 or later, with Apple Intelligence enabled and the model ready. Language, region, and system-model availability can vary. Pebble shows the current availability message. On-device dictation needs a supported language plus Microphone and Speech Recognition permissions.

### The model is unavailable

Check Apple Intelligence in System Settings and the exact status shown by Pebble. If the model is preparing, allow the system to finish. An ineligible Mac cannot use this Store edition's model; there is no hosted fallback. You do not need to grant microphone permission to type.

### Dictation does not start

Check System Settings → Privacy & Security → Microphone and Speech Recognition for Pebble. If your recognizer or language does not support on-device recognition, use typing. Pebble will not switch to network speech recognition. Stop recording before moving to another task; review your draft before sending.

### Keyboard and window controls

Enter sends, Shift-Enter adds a line, and Command-Enter also sends. Command-Shift-D starts/stops dictation. Control-Space opens Pebble and starts/stops dictation while it is running; if another app has claimed the chord, use the menu-bar item or Dictate button. The window can be dragged by its title bar and resized. Closing the window leaves the menu-bar companion running; Quit ends it.

### Search and actions

Actions propose an exact Safari query, explicit HTTPS destination, or basic Mac summary. Cancel does nothing; Approve & run applies once to the reviewed proposal. Search sends the query to DuckDuckGo in Safari. Pebble does not read results, verify citations, run terminal commands, send messages, or control arbitrary apps.

### A request is too long

Pebble reserves context space for instructions and a response. Model requests above 2,048 UTF-8 bytes are rejected without changing your draft; shorten the request or split it into parts. Recent chat context is shortened and reduced as needed. This is a conservative text budget, not unlimited memory.

### Reset a conversation

Clear removes the in-memory conversation, answer, attachment state and run details. It does not delete files you deliberately saved or information already copied/shared. Pebble does not keep app-owned chat history on disk. Setup and window/appearance preferences are separate.

### Report a problem

Contact: **[OWNER MUST SUPPLY A REAL SUPPORT EMAIL OR OTHER LEGALLY APPROPRIATE CONTACT]**.

Include Pebble version/build, macOS version, whether the Apple model is ready, the steps that failed, and expected/actual behavior. Please use a synthetic example. Do not send private prompts, audio, credentials, documents, Mac-summary output, or screenshots containing unrelated personal information. If sending a screenshot, crop it to the relevant Pebble control and check it first.

[OWNER MUST ADD CORRESPONDENCE RETENTION/DELETION POLICY AND PRIVACY LINK BEFORE PUBLICATION.]
