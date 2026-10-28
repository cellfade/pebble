import AppKit
import Foundation

enum MacActionKind: String, Decodable { case searchSafari, openSafariURL, reviewMac, unsupported }
struct ActionProposal: Identifiable {
    let id: UUID
    let kind: MacActionKind
    let value: String
    let createdAt: Date
    init(kind: MacActionKind, value: String, createdAt: Date = Date()) throws {
        guard kind != .unsupported else { throw Self.failure("That action is outside this beta’s capabilities.") }
        let value = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.unicodeScalars.contains(where: { CharacterSet.controlCharacters.contains($0) }) else { throw Self.failure("The proposed action contains control characters.") }
        if kind == .searchSafari { guard !value.isEmpty && value.count <= 500 else { throw Self.failure("Use a search query between 1 and 500 characters.") } }
        if kind == .openSafariURL {
            guard value.count <= 2048, let url = URL(string: value), url.scheme?.lowercased() == "https", let host = url.host, !host.isEmpty, url.user == nil, url.password == nil else { throw Self.failure("Only explicit HTTPS links without embedded credentials can be opened.") }
        }
        self.id = UUID(); self.kind = kind; self.value = kind == .reviewMac ? "" : value; self.createdAt = createdAt
    }
    static func parse(_ text: String) throws -> ActionProposal {
        struct Plan: Decodable { let kind: MacActionKind; let value: String }
        var text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.hasPrefix("```") { let lines = text.components(separatedBy: "\n"); text = lines.dropFirst().dropLast().joined(separator: "\n") }
        let plan = try JSONDecoder().decode(Plan.self, from: Data(text.utf8))
        return try ActionProposal(kind: plan.kind, value: plan.value)
    }
    var title: String {
        switch kind { case .searchSafari: return "Search in Safari"; case .openSafariURL: return "Open a link in Safari"; case .reviewMac: return "Review a basic Mac summary"; case .unsupported: return "Unavailable action" }
    }
    var destination: URL? {
        switch kind {
        case .openSafariURL: return URL(string: value)
        case .searchSafari:
            var components = URLComponents(string: "https://duckduckgo.com/")!
            components.queryItems = [URLQueryItem(name: "q", value: value)]; return components.url
        default: return nil
        }
    }
    var disclosure: String {
        if kind == .reviewMac { return "Read macOS version, processor count, physical RAM, available storage, current time and time zone. No files, app contents, screen, browser history, passwords, or process list will be read. The summary stays in Pebble." }
        return "Open Safari with the exact destination below. The search provider or website will receive this request. Pebble will not read the page, follow links, click controls, or send messages." }
    static func failure(_ message: String) -> NSError { NSError(domain: "PebbleAction", code: 1, userInfo: [NSLocalizedDescriptionKey: message]) }
}
@MainActor protocol MacActionExecuting { func execute(_ action: ActionProposal) async throws -> String }
@MainActor struct MacActionExecutor: MacActionExecuting {
    func execute(_ action: ActionProposal) async throws -> String {
        guard (0.0..<300.0).contains(Date().timeIntervalSince(action.createdAt)) else { throw ActionProposal.failure("This approval expired. Review a new proposal.") }
        if action.kind == .reviewMac {
            let process = ProcessInfo.processInfo
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            let free = (attributes[.systemFreeSize] as? NSNumber)?.int64Value ?? 0
            return ["Mac summary · read only", "macOS: \(process.operatingSystemVersionString)", "Logical processors: \(process.processorCount)", "Physical RAM: \(ByteCountFormatter.string(fromByteCount: Int64(process.physicalMemory), countStyle: .memory))", "Available volume storage: \(ByteCountFormatter.string(fromByteCount: free, countStyle: .file))", ClockService.report(for: "current time"), "This is a basic capacity summary, not a performance benchmark, malware scan, memory-pressure reading, or file audit."].joined(separator: "\n\n")
        }
        guard let url = action.destination, let safari = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.Safari") else { throw ActionProposal.failure("Safari is unavailable or the link is invalid.") }
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            NSWorkspace.shared.open([url], withApplicationAt: safari, configuration: NSWorkspace.OpenConfiguration()) { app, error in
                if let error { continuation.resume(throwing: error) }
                else if app != nil { continuation.resume() }
                else { continuation.resume(throwing: ActionProposal.failure("Safari did not open.")) }
            }
        }
        return "Opened Safari: \(url.absoluteString)\n\nPebble did not retrieve or read the results. No citations have been verified."
    }
}

struct ActionIntent {
    static func infer(_ input: String) -> (MacActionKind, String)? {
        var original = input.trimmingCharacters(in: .whitespacesAndNewlines)
        for prefix in ["please ", "can you ", "could you "] {
            if original.lowercased().hasPrefix(prefix) { original.removeFirst(prefix.count) }
        }
        let lower = original.lowercased()
        for prefix in ["open safari and search for ", "search safari for ", "search the web for ", "search for "] {
            if lower.hasPrefix(prefix) { return (.searchSafari, String(original.dropFirst(prefix.count))) }
        }
        for prefix in ["open safari to ", "open in safari ", "open "] {
            if lower.hasPrefix(prefix) { let value = String(original.dropFirst(prefix.count)); if value.lowercased().hasPrefix("https://") { return (.openSafariURL, value) } }
        }
        if ["review this mac", "review my mac", "review this system", "review my system", "check this mac", "check my mac"].contains(where: lower.contains) { return (.reviewMac, "") }
        return nil
    }
}
