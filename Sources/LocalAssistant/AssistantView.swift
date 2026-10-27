import SwiftUI
import AppKit
import UniformTypeIdentifiers
struct AssistantView: View {
    @ObservedObject var store: AssistantStore
    @ObservedObject var voice: DictationService
    private func submit() { guard !voice.preparing else { return }; voice.stop(); store.send() }
    private func saveResponse() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.plainText]
        panel.nameFieldStringValue = "Local Assistant Response.txt"
        panel.begin { result in
            guard result == .OK, let url = panel.url else { return }
            do { try store.answer.write(to: url, atomically: true, encoding: .utf8) }
            catch { store.hasError = true; store.status = "Could not save: \(error.localizedDescription)" }
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "sparkle").foregroundStyle(.tint).accessibilityHidden(true)
                Text(Product.name).font(.headline)
                Spacer()
                Button { Task { await store.refresh() } } label: { Image(systemName: "arrow.clockwise").frame(width: 24, height: 24) }
                    .accessibilityLabel("Refresh runtime status").help("Refresh runtime status").disabled(store.busy)
            }
            Text(store.shortcutStatus).font(.caption).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
            Label(store.status, systemImage: store.hasError ? "exclamationmark.triangle" : "desktopcomputer")
                .font(.callout).foregroundStyle(store.hasError ? .primary : .secondary).fixedSize(horizontal: false, vertical: true)
            Picker("Model", selection: $store.model) { ForEach(store.models) { Text($0.name).tag($0.name) } }.disabled(store.busy)
            Picker("Mode", selection: $store.mode) { Text("Ask").tag("Ask"); Text("Rewrite").tag("Rewrite") }.pickerStyle(.segmented).disabled(store.busy)
            HStack {
                Text(store.mode == "Rewrite" ? "Text to rewrite" : "Your prompt").font(.subheadline.weight(.medium))
                Spacer()
                Button {
                    if voice.recording { voice.stop() }
                    else {
                        let original = store.prompt
                        Task { await voice.start { transcript in store.prompt = original + (original.isEmpty ? "" : "\n") + transcript } }
                    }
                } label: {
                    Label(voice.preparing ? "Enabling…" : voice.recording ? "Stop dictation" : "Dictate", systemImage: voice.recording ? "stop.circle.fill" : "mic")
                }.keyboardShortcut("d", modifiers: [.command, .shift]).disabled(store.busy || voice.preparing)
                 .help("Start or stop on-device dictation (Command-Shift-D)")
            }
            PromptEditor(text: $store.prompt, editable: !store.busy && !voice.recording && !voice.preparing, onSubmit: submit)
                .frame(height: 110).background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
            HStack {
                Button {
                    voice.stop()
                    guard let text = NSPasteboard.general.string(forType: .string), !text.isEmpty else { store.status = "No text on the clipboard."; return }
                    store.prompt += (store.prompt.isEmpty ? "" : "\n") + text
                } label: { Label("Paste", systemImage: "doc.on.clipboard") }
                .disabled(store.busy || voice.preparing).help("Append clipboard text to your prompt. Command-V pastes at the cursor in the editor.")
                Button { store.choosingImage = true } label: { Label("Attach image", systemImage: "photo") }.disabled(store.busy)
                if let image = store.attachment {
                    if let preview = NSImage(data: image.data) { Image(nsImage: preview).resizable().scaledToFit().frame(width: 32, height: 32).accessibilityLabel("Attached image preview") }
                    Text(image.name).font(.caption).lineLimit(1).help(image.name)
                    Button { store.attachment = nil } label: { Image(systemName: "xmark.circle") }.accessibilityLabel("Remove attached image").disabled(store.busy)
                }
            }
            if !voice.message.isEmpty { Text(voice.message).font(.callout).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true) }
            HStack {
                Text("Enter to send · Shift-Enter for a new line").font(.caption).foregroundStyle(.secondary)
                Spacer()
                if store.busy {
                    Button("Cancel") { store.cancel() }.keyboardShortcut(.cancelAction)
                } else {
                    Button(store.mode == "Rewrite" ? "Rewrite" : "Send", action: submit).keyboardShortcut(.return, modifiers: .command)
                        .buttonStyle(.borderedProminent).disabled(!store.canSend || voice.preparing)
                }
            }
            HStack {
                Button {
                    var components = URLComponents(string: "https://duckduckgo.com/")!
                    components.queryItems = [URLQueryItem(name: "q", value: store.prompt)]
                    if let url = components.url { NSWorkspace.shared.open(url) }
                } label: { Label("Search in browser", systemImage: "safari") }
                .disabled(store.prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .help("Open this prompt as a search in your default browser. The app does not fetch results.")
                Spacer()
            }
            Divider()
            if store.busy {
                HStack(spacing: 12) {
                    ProgressView().controlSize(.small).accessibilityLabel("Waiting for AI response")
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Working on your response…").font(.callout.weight(.medium))
                        TimelineView(.periodic(from: .now, by: 1)) { timeline in
                            Text("Running locally · \(Int(timeline.date.timeIntervalSince(store.startedAt ?? timeline.date)))s elapsed").font(.caption).foregroundStyle(.secondary)
                        }.accessibilityHidden(true)
                    }
                    Spacer()
                }.padding(12).background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
            }
            ScrollView {
                Text(store.answer.isEmpty ? (store.busy ? "You can cancel while the model is working." : "Ask a question, dictate a prompt, or choose Rewrite.") : store.answer)
                    .foregroundStyle(store.answer.isEmpty ? .secondary : .primary).textSelection(.enabled).frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityLabel(store.answer.isEmpty ? "Response placeholder" : "AI response").accessibilityValue(store.answer)
            }.frame(height: store.busy ? 130 : 190)
            HStack {
                Button(store.copied ? "Copied" : "Copy response") {
                    NSPasteboard.general.clearContents(); NSPasteboard.general.setString(store.answer, forType: .string); store.copied = true
                }.disabled(store.answer.isEmpty || store.busy).keyboardShortcut("c", modifiers: [.command, .shift]).help("Copy the AI response (Command-Shift-C)")
                ShareLink(item: store.answer) { Label("Share…", systemImage: "square.and.arrow.up") }.disabled(store.answer.isEmpty || store.busy).help("Choose a macOS sharing destination")
                Menu("More") {
                    Button("Setup & installation…") { voice.stop(); store.showingSetup = true }
                    Button("About \(Product.name)…") { NSApplication.shared.orderFrontStandardAboutPanel(options: [.applicationName: Product.name, .applicationVersion: Product.version, .credits: NSAttributedString(string: "A native macOS companion for local Ollama models.")]) }
                    Divider()
                    Button("Copy prompt") {
                        NSPasteboard.general.clearContents(); NSPasteboard.general.setString(store.prompt, forType: .string)
                    }.disabled(store.prompt.isEmpty)
                    Button("Save response…") { saveResponse() }.disabled(store.answer.isEmpty || store.busy)
                }
                Button("Clear") { voice.stop(); store.prompt = ""; store.answer = ""; store.attachment = nil; store.copied = false }.disabled(store.busy || voice.preparing)
                Spacer()
                Button("Quit") { voice.stop(); NSApplication.shared.terminate(nil) }
            }
            Text("Text and voice processed on this Mac").font(.caption).foregroundStyle(.secondary)
        }.padding(20).frame(width: 470).background(Color(nsColor: .windowBackgroundColor))
         .task { await store.refresh() }.onDisappear { voice.stop() }
         .fileImporter(isPresented: $store.choosingImage, allowedContentTypes: [.png, .jpeg, .heic, .webP]) { result in
             switch result { case .success(let url): store.attach(url); case .failure(let error): store.hasError = true; store.status = error.localizedDescription }
         }
         .onChange(of: store.answer) { _, _ in store.copied = false }
    }
}
