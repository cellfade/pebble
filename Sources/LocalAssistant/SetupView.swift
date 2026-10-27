import SwiftUI
import AppKit
struct SetupView: View {
    @ObservedObject var store: AssistantStore
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Image(systemName: "sun.max.fill").font(.title).foregroundStyle(.orange).accessibilityHidden(true)
                VStack(alignment: .leading) { Text(Product.name).font(.title2.weight(.semibold)); Text(Product.tagline).foregroundStyle(.secondary) }
            }
            Text("A small assistant, running on your Mac.").font(.headline)
            Text("Chat, rewrite, dictate, and ask about images with models you choose. No account or API key required for local inference.").fixedSize(horizontal: false, vertical: true)
            Divider()
            VStack(alignment: .leading, spacing: 12) {
                Label("1. Install and open Ollama", systemImage: "square.and.arrow.down") .font(.headline)
                Text("Ollama runs the models. Install its Mac app, move it to Applications, then open it.").font(.callout).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
                Link("Download Ollama for macOS ↗", destination: Product.ollamaURL)
                Label("2. Download a chat model", systemImage: "internaldrive").font(.headline)
                Text("Run this in Terminal. Downloads need internet and several GB of free space; the app never starts them automatically.").font(.callout).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
                command("ollama pull qwen3:8b")
                Text("Optional image understanding: ollama pull qwen3.5:9b").font(.caption).foregroundStyle(.secondary).textSelection(.enabled)
                Label("3. Check your connection", systemImage: "checkmark.circle").font(.headline)
                Text(store.status).font(.callout).textSelection(.enabled)
                HStack {
                    Button(store.checking ? "Checking…" : "Check connection") { Task { await store.refresh() } }.disabled(store.checking)
                    Text("127.0.0.1:11434").font(.caption.monospaced()).foregroundStyle(.secondary)
                }
            }
            Divider()
            Text("⌃Space opens dictation · Enter sends · Shift-Enter adds a line").font(.caption)
            Text("Microphone and Speech Recognition permissions are requested only when you choose dictation. Speech stays on-device when supported. Browser search and Share are explicit actions.").font(.caption).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
            HStack {
                Text("macOS 14+ · Apple silicon recommended").font(.caption).foregroundStyle(.secondary)
                Spacer()
                Button("Continue") { store.finishSetup() }.buttonStyle(.borderedProminent)
            }
        }.padding(24).frame(width: 470).background(Color(nsColor: .windowBackgroundColor)).task { await store.refresh() }
    }
    private func command(_ text: String) -> some View {
        HStack {
            Text(text).font(.callout.monospaced()).textSelection(.enabled)
            Spacer()
            Button { NSPasteboard.general.clearContents(); NSPasteboard.general.setString(text, forType: .string) } label: { Image(systemName: "doc.on.doc") }.accessibilityLabel("Copy model installation command")
        }.padding(10).background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
    }
}
struct AssistantRootView: View {
    @ObservedObject var store: AssistantStore
    @ObservedObject var voice: DictationService
    var body: some View {
        Group { if store.showingSetup { SetupView(store: store) } else { AssistantView(store: store, voice: voice) } }
    }
}
