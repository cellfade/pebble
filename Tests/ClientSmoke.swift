import Foundation
import AppKit
@main struct ClientSmoke {
    static func main() async throws {
        guard SubmitTextView.shouldSubmit(keyCode: 36, modifiers: [], composing: false),
              SubmitTextView.shouldSubmit(keyCode: 36, modifiers: .command, composing: false),
              !SubmitTextView.shouldSubmit(keyCode: 36, modifiers: .shift, composing: false),
              !SubmitTextView.shouldSubmit(keyCode: 36, modifiers: [], composing: true),
              !SubmitTextView.shouldSubmit(keyCode: 0, modifiers: [], composing: false) else { fatalError("Keyboard behavior failed") }
        let data = Data(#"{"models":[{"name":"qwen3:8b"},{"name":"remote","remote_host":"example.com"},{"name":"x:cloud"}]}"#.utf8)
        let list = try JSONDecoder().decode(ModelList.self, from: data)
        guard list.models.filter(\.isLocal).map(\.name) == ["qwen3:8b"] else { fatalError("Remote filtering failed") }
        let client = OllamaClient()
        let live = try await client.models()
        guard live.models.contains(where: {$0.name == "qwen3:8b" && $0.isLocal}) else { fatalError("Local model missing") }
        let answer = try await client.chat(model: "qwen3:8b", prompt: "Reply with exactly WIDGET_OK", rewrite: false)
        guard answer.trimmingCharacters(in: .whitespacesAndNewlines) == "WIDGET_OK" else { fatalError("Ask failed: \(answer)") }
        let rewrite = try await client.chat(model: "qwen3:8b", prompt: "pleaze send teh report tomorow", rewrite: true)
        guard rewrite.lowercased().contains("report"), rewrite.lowercased().contains("tomorrow") else { fatalError("Rewrite failed: \(rewrite)") }
        var refused = false
        do { _ = try await client.chat(model: "missing-audit-model", prompt: "hi", rewrite: false) } catch { refused = true }
        guard refused else { fatalError("Missing model was accepted") }
        var visionRefused = false
        do { _ = try await client.chat(model: "qwen3:8b", prompt: "What is this?", rewrite: false, image: Data([1,2,3])) } catch { visionRefused = true }
        guard visionRefused else { fatalError("Nonvision model accepted an image") }
        let temp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".png")
        defer { try? FileManager.default.removeItem(at: temp) }
        let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 64, pixelsHigh: 64, bitsPerSample: 8, samplesPerPixel: 3, hasAlpha: false, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
        for x in 0..<64 { for y in 0..<64 { bitmap.setColor(NSColor(deviceRed: 1, green: 0, blue: 0, alpha: 1), atX: x, y: y) } }
        try bitmap.representation(using: .png, properties: [:])!.write(to: temp)
        let image = try ImageAttachment.load(temp)
        guard NSImage(data: image.data) != nil else { fatalError("Image preparation failed") }
        let vision = try await client.chat(model: "qwen3.5:9b", prompt: "What is the dominant color of this image? Answer with one color word.", rewrite: false, image: image.data)
        guard vision.lowercased().contains("red") else { fatalError("Vision check failed: \(vision)") }
        print("PASS: remote filtering, live model discovery, ask, rewrite, missing model refusal, keyboard submit/newline/IME policy, nonvision image refusal, image preparation, live image understanding")
    }
}
