import Foundation
import SwiftUI
import AppKit
struct InstalledModel: Decodable, Identifiable {
    let name: String
    let remote_host: String?
    let remote_model: String?
    var id: String { name }
    var isLocal: Bool { remote_host == nil && remote_model == nil && !name.lowercased().contains("cloud") }
}
struct ModelList: Decodable { let models: [InstalledModel] }
@MainActor final class AssistantStore: ObservableObject {
    @Published var showingSetup = !UserDefaults.standard.bool(forKey: "setupCompleted")
    @Published var checking = false
    @Published var models: [InstalledModel] = []
    @Published var model = "qwen3:8b"
    @Published var prompt = ""
    @Published var answer = ""
    @Published var status = "Checking Ollama…"
    @Published var busy = false
    @Published var mode = "Ask"
    @Published var startedAt: Date?
    @Published var hasError = false
    @Published var shortcutStatus = ""
    @Published var copied = false
    @Published var choosingImage = false
    @Published var attachment: ImageAttachment?
    var canSend: Bool { !busy && !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && models.contains(where: {$0.name == model}) }
    private var task: Task<Void, Never>?
    private let client = OllamaClient()
    func refresh() async {
        guard !checking, !busy else { return }
        checking = true
        defer { checking = false }
        do {
            let list = try await client.models()
            hasError = false
            models = list.models.filter(\.isLocal)
            if !models.contains(where: {$0.name == model}) { model = models.first?.name ?? "" }
            status = models.isEmpty ? "No local models installed" : "Ollama ready · \(models.count) local models"
        } catch { hasError = true; models = []; status = "Ollama unavailable · \(error.localizedDescription)" }
    }
    func finishSetup() {
        UserDefaults.standard.set(true, forKey: "setupCompleted")
        showingSetup = false
    }
    func send() {
        guard canSend else { return }
        let text = prompt, selected = model, rewrite = mode == "Rewrite", image = attachment?.data
        busy = true; startedAt = Date(); hasError = false; status = "Generating locally…"
        task = Task {
            defer { busy = false; startedAt = nil; task = nil }
            do {
                let start = Date()
                let result = try await client.chat(model: selected, prompt: text, rewrite: rewrite, image: image)
                try Task.checkCancellation()
                answer = result
                status = String(format: "Finished locally · %.1fs", Date().timeIntervalSince(start))
                announce("AI response ready.")
            } catch {
                hasError = !Task.isCancelled
                status = Task.isCancelled ? "Cancelled" : "Request failed · \(error.localizedDescription)"
                announce(status)
            }
        }
    }
    func attach(_ url: URL) {
        do {
            attachment = try ImageAttachment.load(url)
            if models.contains(where: {$0.name == "qwen3.5:9b"}) { model = "qwen3.5:9b" }
            hasError = false
            status = "Image attached. Ask a question about it."
        } catch { hasError = true; status = error.localizedDescription }
    }
    private func announce(_ message: String) {
        NSAccessibility.post(element: NSApplication.shared, notification: .announcementRequested, userInfo: [.announcement: message, .priority: NSAccessibilityPriorityLevel.medium.rawValue])
    }
    func cancel() { task?.cancel() }
}
