import Foundation
struct ClockService {
    static func isClockRequest(_ text: String) -> Bool {
        var value = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "’", with: "'")
        let polite = ["please ", "can you ", "could you ", "would you ", "tell me ", "show me ", "check ", "read "]
        var changed = true
        while changed { changed = false; for prefix in polite where value.hasPrefix(prefix) { value.removeFirst(prefix.count); changed = true; break } }
        if value.contains("time complexity") { return false }
        return ["what time is it", "what time it is", "what time is that", "what's the time", "what is the time", "what's the current time", "what is the current time", "current time", "time right now", "time on this mac", "system clock", "date today", "today's date", "what's today's date", "what day is it"].contains(where: value.hasPrefix)
    }
    static func report(for text: String, now: Date = Date(), localZone: TimeZone = .current) -> String {
        func stamp(_ zone: TimeZone) -> String {
            let format = DateFormatter(); format.locale = Locale(identifier: "en_US_POSIX"); format.timeZone = zone
            format.dateFormat = "EEEE, MMMM d, yyyy · h:mm:ss a zzz"
            return format.string(from: now) + " (" + zone.identifier + ")"
        }
        var lines = ["Mac system clock", stamp(localZone)]
        let lower = text.lowercased()
        for (phrases, identifier) in [(["new zealand", "auckland"], "Pacific/Auckland"), (["mountain", "denver"], "America/Denver"), (["london"], "Europe/London"), (["tokyo", "japan"], "Asia/Tokyo"), (["new york", "eastern time"], "America/New_York"), (["utc"], "UTC")] {
            if phrases.contains(where: lower.contains), identifier != localZone.identifier, let zone = TimeZone(identifier: identifier) { lines.append(stamp(zone)) }
        }
        lines.append("Source: this Mac’s system clock and time-zone database. No model estimate or web lookup.")
        return lines.joined(separator: "\n\n")
    }
}
// Conservative UTF-8 budgets reserve room for instructions, message framing and output.
// They are not a tokenizer estimate. Oversized current requests fail intact.
enum RequestBudget {
    static let maximumPromptBytes = 2048
    static let combinedTextBytes = 2304
    static func validate(_ prompt: String) throws {
        guard prompt.utf8.count <= maximumPromptBytes else {
            throw NSError(domain: "PebbleInput", code: 1, userInfo: [NSLocalizedDescriptionKey: "This request is too long for the local context budget (2 KB of text). Shorten it or split it into smaller requests. Your draft is unchanged."])
        }
    }
    static func prefix(_ text: String, bytes limit: Int) -> String {
        var result = "", used = 0
        for character in text {
            let size = String(character).utf8.count
            guard used + size <= limit else { break }
            result.append(character); used += size
        }
        return result
    }
}
struct ConversationTurn: Equatable {
    let user: String
    let assistant: String
    static func context(_ turns: [ConversationTurn], prompt: String = "") -> [ConversationTurn] {
        var available = max(0, RequestBudget.combinedTextBytes - prompt.utf8.count)
        var selected: [ConversationTurn] = []
        for turn in turns.suffix(4).reversed() {
            let shortened = Self(user: RequestBudget.prefix(turn.user, bytes: 192), assistant: RequestBudget.prefix(turn.assistant, bytes: 320))
            let size = shortened.user.utf8.count + shortened.assistant.utf8.count
            guard size <= available else { break }
            selected.append(shortened); available -= size
        }
        return selected.reversed()
    }
}
struct RunReceipt {
    let engine: String
    let model: String
    let inputCharacters: Int
    let includedImage: Bool
    let contextTurns: Int
    let elapsed: TimeInterval
}
