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
struct ConversationTurn: Equatable {
    let user: String
    let assistant: String
    static func context(_ turns: [ConversationTurn]) -> [ConversationTurn] {
        Array(turns.suffix(4)).map { .init(user: String($0.user.prefix(1200)), assistant: String($0.assistant.prefix(1800))) }
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
