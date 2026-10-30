import SwiftUI
import AppKit
struct SetupView: View {
    @ObservedObject var store: AssistantStore
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                PebbleAvatar(size: 58)
                VStack(alignment: .leading) { Text(Product.name).font(.title2.weight(.semibold)); Text(Product.tagline).foregroundStyle(.secondary) }
            }
            Text("Make yourself at home.").font(.headline)
            Text(Product.isAppStoreBuild ? "Chat, rewrite, and dictate with Apple’s on-device model. No account, API key, or separate runtime installation." : "Chat, rewrite, dictate, and ask about images with models you choose. No account or API key required for local inference.").fixedSize(horizontal: false, vertical: true)
            VStack(alignment: .leading, spacing: 8) {
                Label("Apple on-device · No separate runtime", systemImage: "apple.logo").font(.headline)
                Text(AppleModelClient.availabilityMessage).font(.callout).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
                Button("Use Apple on-device") { store.provider = "Apple"; store.finishSetup() }.disabled(!AppleModelClient.isAvailable)
            }.padding(14).modifier(PebbleGlass())
            if !Product.isAppStoreBuild {
            Divider()
            VStack(alignment: .leading, spacing: 12) {
                Label("1. Install and open Ollama", systemImage: "square.and.arrow.down") .font(.headline)
                Text("Optional Ollama engine: Ollama runs the models. Install its Mac app, move it to Applications, then open it.").font(.callout).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
                Link("Download Ollama for macOS ↗", destination: Product.ollamaURL)
                Label("2. Download a chat model", systemImage: "internaldrive").font(.headline)
                Text("Run this in Terminal. Downloads need internet and several GB of free space; the app never starts them automatically.").font(.callout).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
                command("ollama pull qwen3:8b")
                Text("Optional image understanding: ollama pull qwen3.5:9b").font(.caption).foregroundStyle(.secondary).textSelection(.enabled)
                Label("3. Check your connection", systemImage: "checkmark.circle").font(.headline)
                Text(store.status).font(.callout).textSelection(.enabled)
                HStack {
                    Button(store.checking ? "Checking…" : "Check Ollama") { store.provider = "Ollama"; Task { await store.refresh() } }.disabled(store.checking)
                    Text("127.0.0.1:11434").font(.caption.monospaced()).foregroundStyle(.secondary)
                }
            }
            }
            Divider()
            Text("⌃Space opens dictation · Enter sends · Shift-Enter adds a line").font(.caption)
            Text("Microphone and Speech Recognition permissions are requested only when you choose dictation. Speech stays on-device when supported. Browser search and Share are explicit actions.").font(.caption).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
            HStack {
                Text(Product.isAppStoreBuild ? "macOS 26+ · Apple Intelligence required" : "macOS 14+ · Apple silicon recommended").font(.caption).foregroundStyle(.secondary)
                Spacer()
                Button("Continue") { store.finishSetup() }.buttonStyle(.borderedProminent).foregroundStyle(Color.onCobalt)
            }
            HStack { Link("Privacy policy ↗", destination: Product.privacyURL); Link("Support ↗", destination: Product.supportURL) }.font(.caption)
        }.padding(24).frame(maxWidth: 470).task { await store.refresh() }
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
        GeometryReader { viewport in
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 9) { PebbleAvatar(size: 42); VStack(alignment: .leading, spacing: 2) { Text("Pebble").font(.system(size: 20, weight: .semibold, design: .rounded)); Text("YOUR LOCAL COMPANION").font(.system(size: 8, weight: .semibold)).tracking(1).foregroundStyle(.secondary) } }.padding(.horizontal, 16).padding(.top, 20)
                List(selection: Binding<String?>(get: { store.mode }, set: { if let value = $0 { voice.stop(); store.mode = value; store.showingSetup = false } })) {
                    Section("WORKSPACE") {
                        Label("Chat", systemImage: "bubble.left").tag("Ask")
                        Label("Rewrite", systemImage: "text.alignleft").tag("Rewrite")
                        Label("Actions", systemImage: "checkmark.shield").tag("Actions")
                        if !Product.isAppStoreBuild { Label("Image questions", systemImage: "photo").tag("Images") }
                    }
                }.listStyle(.sidebar).disabled(store.busy)
                VStack(alignment: .leading, spacing: 12) {
                    Text("RUNS ON YOUR MAC").font(.caption2.weight(.semibold)).foregroundStyle(.secondary)
                    Picker("Engine", selection: $store.provider) { Text("Apple on-device").tag("Apple"); if !Product.isAppStoreBuild { Text("Ollama").tag("Ollama") } }.disabled(store.busy)
                    if store.provider == "Ollama" { Picker("Model", selection: $store.model) { ForEach(store.models) { Text($0.name).tag($0.name) } }.disabled(store.busy) }
                    Label(store.provider == "Apple" ? (AppleModelClient.isAvailable ? "Apple model ready" : "Apple model unavailable") : (store.models.isEmpty ? "Ollama not ready" : "Ollama connected"), systemImage: "desktopcomputer").font(.caption).foregroundStyle(.secondary)
                    Text(store.shortcutStatus).font(.caption2).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
                    Divider()
                    Button { voice.stop(); store.showingSetup = true } label: { Label("Setup & help", systemImage: "gearshape") }.buttonStyle(.plain)
                    Text("v\(Product.version) · \(Product.editionLabel)").font(.caption2).foregroundStyle(.secondary)
                }.padding(16)
            }.frame(width: 210).frame(maxHeight: .infinity).background(.regularMaterial)
            Divider()
            Group {
            if store.showingSetup { ScrollView { SetupView(store: store).frame(maxWidth: .infinity) }.background(.background) }
            else if store.mode == "Actions" { ActionCenterView(store: store) }
            else { AssistantView(store: store, voice: voice) }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }.tint(.cobalt).frame(width: viewport.size.width, height: viewport.size.height).clipped()
        }.frame(minWidth: 860, minHeight: 640)
         .preferredColorScheme(store.appearance == "Light" ? .light : store.appearance == "Dark" ? .dark : nil)
         .onChange(of: store.busy) { _, busy in if busy { voice.stop() } }
         .onChange(of: store.showingSetup) { _, showing in if showing { voice.stop() } }
         .onChange(of: store.provider) { _, _ in Task { await store.refresh() } }
         .task { await store.refresh() }
    }
}
