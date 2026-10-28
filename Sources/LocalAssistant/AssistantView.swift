import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct AssistantView: View {
    @ObservedObject var store: AssistantStore
    @ObservedObject var voice: DictationService
    private func submit() { guard !voice.preparing else { return }; voice.stop(); store.send() }
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            header
            if store.hasError {
                Label(store.status, systemImage: "exclamationmark.triangle")
                    .font(.callout).padding(12).frame(maxWidth: .infinity, alignment: .leading)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 12)).textSelection(.enabled)
            }
            composer
            response
        }
        .padding(28).frame(maxWidth: 1000, maxHeight: .infinity, alignment: .topLeading)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.background)
        .fileImporter(isPresented: $store.choosingImage, allowedContentTypes: [.png, .jpeg, .heic, .webP]) { result in
            switch result { case .success(let url): Task { store.attach(url); await store.refresh() }; case .failure(let error): store.hasError = true; store.status = error.localizedDescription }
        }
        .onChange(of: store.answer) { _, _ in store.copied = false }
    }
    private var header: some View {
        HStack(alignment: .center, spacing: 14) {
            PebbleAvatar(size: 60)
            VStack(alignment: .leading, spacing: 4) {
                Text(store.mode == "Rewrite" ? "Find the right words." : store.mode == "Images" ? "Take a closer look." : "A little space to think.")
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                Text(store.mode == "Rewrite" ? "Your meaning, a little clearer." : store.mode == "Images" ? "Ask about an image with a local vision model." : "Ask, explore, or talk it through. Right here on your Mac.")
                    .font(.callout).foregroundStyle(.secondary)
            }
            Spacer(minLength: 12)
            Button { Task { await store.refresh() } } label: { Image(systemName: "arrow.clockwise").frame(width: 28, height: 28) }
                .help("Check local model connection").accessibilityLabel("Refresh model connection").disabled(store.busy || store.checking)
        }
    }
    private var composer: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(store.mode == "Rewrite" ? "YOUR DRAFT" : "YOUR PROMPT").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                Spacer()
                Text("Enter ↵ to send").font(.caption).foregroundStyle(.secondary)
            }
            PromptEditor(text: Binding(get: { store.busy && !store.pendingPrompt.isEmpty ? store.pendingPrompt : store.prompt }, set: { store.prompt = $0 }), editable: !store.busy && !voice.recording && !voice.preparing, onSubmit: submit)
                .frame(minHeight: 80, idealHeight: 110, maxHeight: 140)
                .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(.quaternary, lineWidth: 1))
            if let attachment = store.attachment {
                HStack(spacing: 10) {
                    if let preview = NSImage(data: attachment.data) { Image(nsImage: preview).resizable().scaledToFit().frame(width: 40, height: 40).accessibilityLabel("Attached image") }
                    Text(attachment.name).font(.caption).lineLimit(1)
                    Spacer()
                    Button { store.attachment = nil } label: { Image(systemName: "xmark.circle.fill") }.accessibilityLabel("Remove image").disabled(store.busy)
                }.padding(8).background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
            }
            if !voice.message.isEmpty { Text(voice.message).font(.caption).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true) }
            PebbleGlassGroup {
                HStack(spacing: 8) {
                    Button {
                        if voice.recording { voice.stop() }
                        else { let original = store.prompt; Task { await voice.start { store.prompt = original + (original.isEmpty ? "" : "\n") + $0 } } }
                    } label: {
                        Label(voice.preparing ? "Enabling…" : voice.recording ? "Stop" : "Dictate", systemImage: voice.recording ? "stop.circle.fill" : "mic")
                    }.keyboardShortcut("d", modifiers: [.command, .shift]).disabled(store.busy || voice.preparing)
                     .help("Start or stop on-device dictation (Command-Shift-D)")
                    Button { paste() } label: { Image(systemName: "doc.on.clipboard") }.accessibilityLabel("Paste clipboard text").help("Append clipboard text to prompt").disabled(store.busy || voice.preparing)
                    if !Product.isAppStoreBuild { Button { store.choosingImage = true } label: { Image(systemName: "photo.badge.plus") }.accessibilityLabel("Attach image").help("Attach an image for local vision analysis").disabled(store.busy) }
                    Spacer()
                    if store.busy { Button("Cancel") { store.cancel() }.keyboardShortcut(.cancelAction) }
                    else { Button(action: submit) { Label(store.mode == "Rewrite" ? "Rewrite" : "Send", systemImage: "arrow.up") }.keyboardShortcut(.return, modifiers: .command).buttonStyle(.borderedProminent).disabled(!store.canSend || voice.preparing) }
                }.controlSize(.large).padding(10).modifier(PebbleGlass())
            }
            Text("Shift-Enter for a new line · Review dictation before sending").font(.caption2).foregroundStyle(.secondary)
        }
    }
    private var response: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("PEBBLE’S RESPONSE").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                Spacer()
                if !store.busy && !store.answer.isEmpty { Text(store.status).font(.caption).foregroundStyle(.secondary) }
            }
            if !store.lastPrompt.isEmpty {
                Text("You: " + store.lastPrompt).font(.callout).foregroundStyle(.secondary).lineLimit(3).textSelection(.enabled)
            }
            if store.busy {
                HStack(spacing: 12) {
                    ProgressView().controlSize(.small).accessibilityLabel("Waiting for AI response")
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Pebble is thinking…").font(.callout.weight(.medium))
                        TimelineView(.periodic(from: .now, by: 1)) { context in Text("On your Mac · \(max(0, Int(context.date.timeIntervalSince(store.startedAt ?? context.date))))s elapsed").font(.caption).foregroundStyle(.secondary) }.accessibilityHidden(true)
                    }
                    Spacer()
                }.padding(14).modifier(PebbleGlass())
            }
            ScrollView {
                if store.answer.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "bubble.left.and.text.bubble.right").font(.system(size: 28)).foregroundStyle(Color.cobalt.opacity(0.7)).accessibilityHidden(true)
                        Text(store.busy ? "Making room for a good answer." : "Ready when you are.").font(.headline)
                        Text(store.busy ? "You can cancel at any time." : "Start with a question, a rough draft, or an image.").font(.callout).foregroundStyle(.secondary)
                    }.frame(maxWidth: .infinity).padding(.vertical, 30)
                } else {
                    Text(store.answer).font(.system(size: 15)).lineSpacing(4).textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading).accessibilityLabel("AI response").accessibilityValue(store.answer).padding(4)
                }
            }.frame(minHeight: 60, maxHeight: .infinity)
            if let receipt = store.lastReceipt {
                DisclosureGroup("Run details · " + receipt.engine) {
                    Text("Model: \(receipt.model)\nText: \(receipt.inputCharacters) characters · Image: \(receipt.includedImage ? "included" : "none")\nRecent context: \(receipt.contextTurns) shortened turns · Web pages read: none\nSession stays in memory until Clear or Quit.").font(.caption).foregroundStyle(.secondary).textSelection(.enabled).frame(maxWidth: .infinity, alignment: .leading)
                }.font(.caption)
            }
            HStack(spacing: 12) {
                Button { NSPasteboard.general.clearContents(); NSPasteboard.general.setString(store.answer, forType: .string); store.copied = true } label: { Label(store.copied ? "Copied" : "Copy", systemImage: "doc.on.doc") }
                    .keyboardShortcut("c", modifiers: [.command, .shift]).disabled(store.answer.isEmpty || store.busy).help("Copy response (Command-Shift-C)")
                ShareLink(item: store.answer) { Label("Share", systemImage: "square.and.arrow.up") }.disabled(store.answer.isEmpty || store.busy)
                Menu {
                    Button("Copy last request") { NSPasteboard.general.clearContents(); NSPasteboard.general.setString(store.lastPrompt, forType: .string) }.disabled(store.lastPrompt.isEmpty)
                    Button("Save response…") { saveResponse() }.disabled(store.answer.isEmpty || store.busy)
                    Button("Review Safari search…") { search() }.disabled(store.prompt.isEmpty && store.lastPrompt.isEmpty)
                    Picker("Appearance", selection: $store.appearance) { Text("Use system").tag("System"); Text("Light").tag("Light"); Text("Dark").tag("Dark") }
                    Divider()
                    Button("Setup & installation…") { voice.stop(); store.showingSetup = true }
                    Button("About Pebble") { NSApplication.shared.orderFrontStandardAboutPanel(nil) }
                } label: { Label("More", systemImage: "ellipsis") }.fixedSize()
                Spacer()
                Button("Clear") { voice.stop(); store.clearConversation() }.disabled(store.busy || voice.preparing)
            }.controlSize(.regular)
        }
    }
    private func paste() {
        voice.stop()
        guard let text = NSPasteboard.general.string(forType: .string), !text.isEmpty else { store.status = "No text on the clipboard."; return }
        store.prompt += (store.prompt.isEmpty ? "" : "\n") + text
    }
    private func search() {
        let text = store.prompt.isEmpty ? store.lastPrompt : store.prompt
        store.mode = "Actions"; store.actionDraft = text; store.propose(kind: .searchSafari, value: text)
    }
    private func saveResponse() {
        let panel = NSSavePanel(); panel.allowedContentTypes = [.plainText]; panel.nameFieldStringValue = "Pebble response.txt"
        panel.begin { result in
            guard result == .OK, let url = panel.url else { return }
            let scoped = url.startAccessingSecurityScopedResource()
            defer { if scoped { url.stopAccessingSecurityScopedResource() } }
            do { try store.answer.write(to: url, atomically: true, encoding: .utf8) }
            catch { store.hasError = true; store.status = "Could not save: \(error.localizedDescription)" }
        }
    }
}
