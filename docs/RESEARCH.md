# Pebble product research

Research date: October 26, 2026 (America/Denver). This is a primary-source competitive and interaction review, not a hands-on usability benchmark or a claim of market exclusivity. Product capabilities and distribution can change; links are the verification record. No competitor was installed, signed into, or instrumented for this review.

## Recommendation

Build **an inspectable local workbench for small, consequential Mac tasks**, rather than a smaller clone of a general cloud chat app. A friendly character, global shortcut, dictation, attachments, and tools are useful entry points, but they are already common. Pebble can earn preference through the combination of clear context boundaries, useful local transformations, honest model/runtime behavior, and actions that are easy to approve, inspect, and recover from.

The near-term promise should be concrete: **bring a thought or an artifact, see exactly what Pebble will use, get a useful result on this Mac, and approve anything that acts outside the conversation.** This is a product hypothesis to validate with users—not evidence that every alternative lacks these properties.

## Eight reference products

| Reference | Verified baseline from official material | What Pebble should learn | What not to claim |
|---|---|---|---|
| **Claude Desktop** | Quick Entry supports global access, screenshot/window context, and reviewable voice transcription. Voice is optional and shortcuts have configuration/conflict guidance. [Official Quick Entry help](https://support.claude.com/en/articles/12626668-use-quick-entry-with-claude-desktop-on-mac). | Context capture belongs close to the request; recording must remain distinct from sending. Make permissions and shortcut conflicts understandable. | A global shortcut, dictation, or screenshot attachment is unique. |
| **ChatGPT desktop / Classic** | The current desktop app combines Chat, Work, and Codex. Classic remains a separately identified product. [Migration help](https://help.openai.com/en/articles/20001276-moving-to-the-new-chatgpt-desktop-app). Classic Work with Apps documents visible context banners and reviewable edits. [Work with Apps](https://help.openai.com/en/articles/10119604-work-with-apps-on-macos). New desktop Pets provide floating chat/voice controls and status. [Pets](https://learn.chatgpt.com/docs/pets). | Show included context before use; preserve the difference between a proposal and an applied change. A mascot should communicate useful state, not substitute for it. | A floating companion, app context, reviewable edits, or activity status is an uncontested gap. Avoid treating Classic documentation as the full current app. |
| **Raycast** | AI Commands package recurring prompts; AI Chat documents history, memory, attachments, and tool use; extension tools can be selected from natural-language requests. [AI Commands](https://manual.raycast.com/ai/ai-commands), [AI Chat](https://manual.raycast.com/ai/ai-chat), [Extensions](https://manual.raycast.com/extensions). | Keyboard efficiency, named reusable tasks, progressive disclosure, and a unified action vocabulary matter more than a large dashboard. | Reusable prompts or natural-language tools are novel. |
| **LM Studio** | Downloaded-model chat, document RAG, and localhost serving can operate offline. [Offline operation](https://lmstudio.ai/docs/app/offline). | Locality is a credible capability only when the entire active path is understood, including document processing and runtime behavior. | “Local AI” or local document retrieval alone differentiates Pebble across the market. |
| **Superwhisper** | Its official page presents offline transcription, custom vocabulary, modes, custom shortcuts, and insertion into other apps. It also offers online/model choices, so offline transcription does not imply every mode is offline. [Product page](https://superwhisper.com/). | Voice needs task-specific vocabulary and recovery, not just a microphone button. Keep raw transcript review separate from optional polishing and destination actions. | Voice-to-polished-text or offline transcription is unique; a competitor’s entire pipeline is local without checking the selected mode. |
| **Bear** | The native note app supports mixed content, tags, export, and an editor-led interface; official material includes a full Mac screenshot. [Product page](https://bear.app/). | Inspecting that screenshot shows quiet chrome, a clear sidebar/list/document hierarchy, and action groups subordinate to the text. Borrow the hierarchy and restraint, not the exact layout or decoration. | A homepage screenshot proves keyboard quality, accessibility, or all runtime states. |
| **Things** | Official material presents a focused native task hierarchy, navigation, search, and keyboard-oriented interaction. [Features](https://culturedcode.com/things/features/), [product overview](https://culturedcode.com/things/). | The reviewed official marketing crop uses strong icon/text landmarks and restrained surfaces. Features should reveal themselves at the moment of need instead of competing on the first screen. | A marketing crop is a full workflow audit or evidence for Pebble’s own implementation quality. |
| **Craft** | Its official 3.5.4 notes document Mac Quick Entry with **Control-Space** by default and a substantial reliability/polish focus. [Quick Entry release](https://www.craft.do/blog/craft-update-3-5-4). Another release describes sidebar customization and a pinnable Mac Assistant panel. [Sidebar/panel release](https://www.craft.do/pt-BR/blog/craft-update-3-4-2). | Control-Space conflict handling is a real interoperability issue. Pinning, hiding unnecessary navigation, and reliable focus/scroll behavior are product features. | Control-Space is globally available, or a complex feature set excuses interaction regressions. |

### Evidence depth

- Official documentation and release notes were read for the capability comparisons above.
- Two official marketing images were visually inspected: [Bear’s full Mac window](https://bear.app/images/home/hero_mac.jpg) and [Things’ navigation crop](https://static.culturedcode.com/things/videos/2026-06-25-meet-things-remastered-2/meettheallnewthings-poster-e.jpg). These are reference imagery, not direct app tests. The Things image is a crop and does not support claims about the whole screen.
- Craft’s homepage fetch timed out; its official releases and App Store material supplied the documentary evidence instead. No unsupported claim of hands-on Craft visual validation is made.
- No latency, quality, energy, privacy, or accessibility benchmark was run across the competitors. No pricing comparison or completeness ranking is implied.

## Table stakes before differentiation

A beta needs correct request/response transactions, a stable movable window, recoverable errors, accessible keyboard input, visible recording/waiting state, accurate capability labels, and a clear path when the runtime is unavailable. A decorative treatment cannot compensate for clipped controls or accumulated prompts. Streaming and conversation context should be considered familiar expectations, with limitations stated if they are absent.

Current capability names must be literal:

- **Image understanding** is not image generation or editing.
- **Open a search in Safari** is not retrieved web research or verified citations.
- **A proposed action** is not a completed action.
- **An available local model** is not a guarantee of accuracy, speed, or compatibility with every task.
- **No developer-owned inference upload** is not a guarantee that the operating system, sharing service, browser, or separate runtime never uses a network.

## Three high-value differentiation bets

These recommendations combine known patterns around a specific local-first user need. They are not claims that nobody has implemented similar features.

### 1. Context you can inspect, results you can account for

**User problem:** “What did this answer see, where did the computation happen, and what did it actually do?”

Before each request, show a compact context tray with explicit items: typed/dictated text, an attached image, selected excerpts, a bounded Mac summary, or approved web evidence. Each item can be removed. Each has a source label and a useful limit, such as a crop or page range. Do not silently include ambient screen, clipboard, or folder content.

After completion, offer a local run receipt: engine/model, input item count, source identifiers, time taken, tool proposals, approvals, completed actions, and limits/truncation. Avoid pretending a receipt proves the truth of the generated answer. Keep raw prompts and images out of persistent diagnostics unless the user elects to save a workspace.

**Small beta slice:** engine/model and elapsed-time receipt; deterministic system-clock source; explicit distinction between opening a browser and reading results; an approval card for every proposed external action.

**Tradeoffs:** visible receipts add cognitive load; make the summary one line and details optional. Storage can itself expose sensitive data; default receipts should remain in memory. Never imply OS/network attestation from a UI label.

**Validation:** can a first-time tester accurately say which data were included, which engine ran, and whether an action happened? Target at least 4 of 5 testers answering all three correctly in a small formative study.

### 2. A local transformation workbench, not a prompt treadmill

**User problem:** “I repeatedly turn rough voice notes, screenshots, and drafts into useful material, but I keep explaining the same format and cannot trust what changed.”

Offer a small set of named transformations: clean a transcript, shorten without losing commitments, turn selected notes into a checklist, explain a screenshot, and extract visible text. Preserve the original beside the result; highlight changed or uncertain material; provide Copy, Save, and explicit Apply only when a destination integration exists. Make recipes editable and portable as plain text/JSON, with their expected input/output and model requirements visible.

**Small beta slice:** transactional composer clearing; a visible last request; Rewrite comparison; two or three well-tested transformations. Do not add a dozen presets before testing the core editing loop.

**Tradeoffs:** smaller models may drop details or invent structure. Preserve originals and test meaning, names, numbers, dates, and commitments. A visual diff is review assistance, not a proof that meaning was preserved. Image OCR and visual reasoning need separate evaluation.

**Validation:** benchmark 20 realistic edits against preserved facts, then test whether users can accept or reject an output and return to their work without losing the source. Measure task completion and unwanted edits, not raw token speed alone.

### 3. Local capability routing that respects the Mac

**User problem:** “I do not want to become a model administrator or discover halfway through a task that this engine cannot do it.”

Expose task-level capabilities first: text, image understanding, transcription, document retrieval, or approved actions. Explain the available local route, whether a model must load, and when a capability is unavailable. Let users choose a quiet/efficient preference or a higher-quality local route. Ask before a download, switching to any nonlocal provider, or changing persistent system settings. Keep optional resource details in an inspector, not the main composer.

**Small beta slice:** honest Apple/Ollama availability states; no silent engine change on attachment; direct system facts for clock/basic Mac summary; retry/cancel; a clear model-loading state when detectable.

**Tradeoffs:** resource-aware estimates are uncertain and device-specific. Do not promise a power or memory saving without measurement. Automatic switching can destroy trust and increase load latency; show the route and keep an override. Store and direct-download editions have different capability/distribution constraints and must be described separately.

**Validation:** test on supported low-memory hardware and at least one additional Mac. Check an unloaded model, busy runtime, unsupported image engine, Apple Intelligence disabled/not-ready, low disk, and cancellation. Report measured ranges for the exact tested model/device rather than a universal “instant” claim.

## What to defer

- Arbitrary shell execution and broad unattended computer control.
- Persistent ambient screenshot/clipboard indexing before its retention and permission model is designed.
- A plugin store, multi-agent task runner, or autonomous background agent before typed tools and approval receipts are reliable.
- Image generation until a backend, resource budget, provenance, cancel/retry path, and distribution story are selected.
- “Verified web answers” until the app actually retrieves sources, records URLs/timestamps/excerpts, and distinguishes search snippets from fetched content. External text must remain untrusted input, not instructions to execute tools.

## Next research with users

Run five short sessions with people who handle sensitive drafts, use dictation, or prefer local tools. Ask them to complete one rewrite, one image question, one unsupported-engine task, one cancelled task, and one approval/rejection. Observe interpretation errors and recovery, especially where “chat,” “action,” and “search” differ. Follow with a week of voluntary task diaries before committing to a large automation or memory system.
