import Foundation
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
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw NSError(domain: "Ollama", code: 1, userInfo: [NSLocalizedDescriptionKey: "Ollama rejected the request. Check the selected model and runtime."])
        }
        return data
    }
    func models() async throws -> ModelList { try JSONDecoder().decode(ModelList.self, from: await request("/api/tags", timeout: 8)) }
    func chat(model: String, prompt: String, rewrite: Bool, image: Data? = nil) async throws -> String {
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
        let data = try await request("/api/chat", body: ["model": model, "stream": false, "think": false, "options": ["num_ctx": 4096, "num_predict": 1024], "messages": [["role": "system", "content": rewrite ? "Rewrite the user's text clearly and concisely. Preserve its meaning. Return only the rewritten text." : "Be helpful, accurate, and concise. Current time: \(ISO8601DateFormatter().string(from: Date())). User time zone: \(TimeZone.current.identifier). You have no web search tools. Do not claim to have searched the web or invent source URLs. Image generation is unavailable; explain this if asked to create an image."], userMessage]])
        struct Reply: Decodable { struct Message: Decodable { let content: String }; let message: Message; let done_reason: String? }
        let result = try JSONDecoder().decode(Reply.self, from: data)
        return result.message.content + (result.done_reason == "length" ? "\n\n[Output reached the token limit.]" : "")
    }
}
