# Security

Please avoid posting private prompts, personal images, tokens, or sensitive logs in public issues. For an issue affecting data exposure or execution, use the repository's private vulnerability reporting mechanism if enabled; otherwise contact the repository owner without publishing the exploit details first.

The app does not execute model tools or accept a configurable hosted endpoint. The local Ollama service itself is outside the app's process boundary and should remain bound to loopback for this product's intended setup. Source-build and preview artifacts are provided for testing. Do not treat an ad hoc signed preview as a notarized release.
