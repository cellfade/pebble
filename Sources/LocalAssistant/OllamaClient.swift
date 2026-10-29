import Foundation
final class LocalInferenceRedirectPolicy: NSObject, URLSessionTaskDelegate, @unchecked Sendable {
    static let shared = LocalInferenceRedirectPolicy()
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        // Never forward prompts or images, even to a different loopback endpoint.
        completionHandler(nil)
    }
}
struct OllamaClient {
    private let base = "http://127.0.0.1:11434"
    private let session: URLSession
    init(session: URLSession? = nil) {
        if let session { self.session = session }
        else {
            let config = URLSessionConfiguration.ephemeral
            config.connectionProxyDictionary = [:]
            self.session = URLSession(configuration: config)
        }
    }
    func request(_ path: String, body: [String: Any]? = nil, timeout: TimeInterval = 120) async throws -> Data {
        var request = URLRequest(url: URL(string: base + path)!)
        request.timeoutInterval = timeout
        if let body {
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        let (data, response) = try await session.data(for: request, delegate: LocalInferenceRedirectPolicy.shared)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw NSError(domain: "Ollama", code: 1, userInfo: [NSLocalizedDescriptionKey: "Ollama rejected the request. Check the selected model and runtime."])
        }
        return data
    }
    func models() async throws -> ModelList { try JSONDecoder().decode(ModelList.self, from: await request("/api/tags", timeout: 8)) }
    func chat(model: String, prompt: String, rewrite: Bool, image: Data? = nil, history: [ConversationTurn] = [], customInstructions: String? = nil, formatJSON: Bool = false) async throws -> String {
        try RequestBudget.validate(prompt)
        let installed = try await models()
        guard installed.models.contains(where: {$0.name == model && $0.isLocal}) else { throw URLError(.resourceUnavailable) }
        let info = try JSONSerialization.jsonObject(with: await request("/api/show", body: ["model": model])) as? [String: Any]
        guard info?["remote_host"] == nil, info?["remote_model"] == nil else { throw URLError(.noPermissionsToReadFile) }
        if image != nil {
            let capabilities = info?["capabilities"] as? [String] ?? []
            guard capabilities.contains("vision") else { throw NSError(domain: "Ollama", code: 2, userInfo: [NSLocalizedDescriptionKey: "Choose a vision model such as qwen3.5:9b for image questions."]) }
        }
        var userMessage: [String: Any] = ["role": "user", "content": prompt]
        if let image { userMessage["images"] = [image.base64EncodedString()] }
        let instructions = customInstructions ?? (rewrite ? "Rewrite the user's text clearly and concisely. Preserve its meaning. Return only the rewritten text." : "You are Pebble, a helpful local assistant. Be accurate and concise. Current system time: \(ISO8601DateFormatter().string(from: Date())). Time zone: \(TimeZone.current.identifier). You have no web page contents or screen access. Do not invent citations or claim to execute actions. Use the app's explicit Actions mode for approved Safari or Mac summary requests.")
        var messages: [[String: Any]] = [["role": "system", "content": instructions]]
        if !rewrite { for turn in ConversationTurn.context(history, prompt: prompt) { messages.append(["role":"user", "content":turn.user]); messages.append(["role":"assistant", "content":turn.assistant]) } }
        messages.append(userMessage)
        var body: [String: Any] = ["model": model, "stream": false, "think": false, "options": ["num_ctx": 4096, "num_predict": 768], "messages": messages]
        if formatJSON { body["format"] = "json" }
        let data = try await request("/api/chat", body: body)
        struct Reply: Decodable { struct Message: Decodable { let content: String }; let message: Message; let done_reason: String? }
        let result = try JSONDecoder().decode(Reply.self, from: data)
        return result.message.content + (result.done_reason == "length" ? "\n\n[Output reached the token limit.]" : "")
    }
}
