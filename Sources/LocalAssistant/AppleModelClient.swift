import Foundation
#if canImport(FoundationModels)
import FoundationModels
#endif
struct AppleModelClient {
    static var availabilityMessage: String {
        #if canImport(FoundationModels)
        if #available(macOS 26.0, *) {
            switch SystemLanguageModel.default.availability {
            case .available: return "Apple on-device model ready"
            case .unavailable(let reason):
                switch reason {
                case .appleIntelligenceNotEnabled: return "Enable Apple Intelligence in System Settings to use the Apple model."
                case .deviceNotEligible: return "This Mac is not eligible for the Apple on-device model."
                case .modelNotReady: return "Apple's on-device model is still preparing. Try again later."
                @unknown default: return "Apple on-device model is unavailable."
                }
            }
        }
        #endif
        return "Apple on-device chat requires macOS 26 and a compatible Apple Intelligence Mac."
    }
    static var isAvailable: Bool {
        #if canImport(FoundationModels)
        if #available(macOS 26.0, *) { return SystemLanguageModel.default.availability == .available }
        #endif
        return false
    }
    func chat(prompt: String, rewrite: Bool, history: [ConversationTurn] = [], customInstructions: String? = nil) async throws -> String {
        #if canImport(FoundationModels)
        if #available(macOS 26.0, *), Self.isAvailable {
            let instructions = customInstructions ?? (rewrite ? "Rewrite the user's text clearly and concisely. Preserve meaning. Return only the rewritten text." : "You are Pebble, a helpful and concise on-device assistant. You have no web browsing tools. Do not invent citations or claim web access. Be candid about uncertainty. Current system time: \(ISO8601DateFormatter().string(from: Date())). Time zone: \(TimeZone.current.identifier).")
            let session = LanguageModelSession(instructions: instructions)
            let context = ConversationTurn.context(history).map { "User: \($0.user)\nAssistant: \($0.assistant)" }.joined(separator: "\n\n")
            let request = context.isEmpty ? prompt : "Recent conversation for context:\n\(context)\n\nCurrent request:\n\(prompt)"
            let response = try await session.respond(to: request)
            try Task.checkCancellation()
            return response.content
        }
        #endif
        throw NSError(domain: "AppleModel", code: 1, userInfo: [NSLocalizedDescriptionKey: Self.availabilityMessage])
    }
}
