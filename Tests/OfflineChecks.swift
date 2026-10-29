import Foundation
import AppKit
final class MockProtocol: URLProtocol {
    static var mode = "local"
    static var sawImage = false
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        guard request.url?.host == "127.0.0.1", request.url?.port == 11434 else { fatalError("Unexpected inference destination") }
        var payload: [String: Any] = [:]
        var status = 200
        switch request.url!.path {
        case "/api/tags":
            payload = ["models": [["name": "test:local"]]]
            if Self.mode == "remote" { payload = ["models": [["name": "test:local", "remote_host": "example.com"]]] }
        case "/api/show":
            payload = Self.mode == "showRemote" ? ["remote_model": "cloud"] : ["capabilities": ["completion"]]
        case "/api/chat":
            if Self.mode == "httpError" { status = 500 }
            if Self.mode == "redirect307" { status = 307 }
            if Self.mode == "redirect308" { status = 308 }
            payload = ["message": ["content": "CHECK_OK"], "done_reason": "stop"]
        default: status = 404
        }
        let response = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: "HTTP/1.1", headerFields: ["Content-Type":"application/json", "Location":"https://example.invalid/collect"])!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: try! JSONSerialization.data(withJSONObject: payload))
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}
@main struct OfflineChecks {
    static func main() async throws {
        guard SubmitTextView.shouldSubmit(keyCode: 36, modifiers: [], composing: false),
              SubmitTextView.shouldSubmit(keyCode: 76, modifiers: [], composing: false),
              !SubmitTextView.shouldSubmit(keyCode: 36, modifiers: .shift, composing: false),
              !SubmitTextView.shouldSubmit(keyCode: 36, modifiers: [], composing: true) else { fatalError("Keyboard input policy failed") }
        let json = Data(#"{"models":[{"name":"ok"},{"name":"x:cloud"},{"name":"x","remote_host":"example.com"},{"name":"y","remote_model":"remote"}]}"#.utf8)
        let models = try JSONDecoder().decode(ModelList.self, from: json)
        guard models.models.filter(\.isLocal).map(\.name) == ["ok"] else { fatalError("Remote model filter failed") }
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockProtocol.self]
        let client = OllamaClient(session: URLSession(configuration: config))
        let answer = try await client.chat(model: "test:local", prompt: "test", rewrite: false)
        guard answer == "CHECK_OK" else { fatalError("Local request failed") }
        for mode in ["remote", "showRemote", "httpError", "redirect307", "redirect308"] {
            MockProtocol.mode = mode
            var refused = false
            do { _ = try await client.chat(model: "test:local", prompt: "test", rewrite: false) } catch { refused = true }
            guard refused else { fatalError("Expected refusal: \(mode)") }
        }
        MockProtocol.mode = "local"
        var refused = false
        do { _ = try await client.chat(model: "test:local", prompt: "test", rewrite: false, image: Data([1])) } catch { refused = true }
        guard refused else { fatalError("Nonvision model accepted an image") }
        // Exercise the exact per-task delegate installed for injected and production sessions.
        // These redirect requests contain synthetic secrets and must never be forwarded.
        let policySession = URLSession(configuration: .ephemeral)
        let task = policySession.dataTask(with: URL(string: "http://127.0.0.1:11434/api/chat")!)
        for status in [307, 308] {
            let response = HTTPURLResponse(url: task.originalRequest!.url!, statusCode: status, httpVersion: "HTTP/1.1", headerFields: ["Location": "https://example.invalid/collect"])!
            var redirected = URLRequest(url: URL(string: "https://example.invalid/collect")!)
            redirected.httpMethod = "POST"
            redirected.httpBody = Data("synthetic-private-prompt-and-image".utf8)
            var called = false
            LocalInferenceRedirectPolicy.shared.urlSession(policySession, task: task, willPerformHTTPRedirection: response, newRequest: redirected) { accepted in
                guard accepted == nil else { fatalError("Redirect forwarded inference payload") }
                called = true
            }
            guard called else { fatalError("Redirect decision was not completed") }
        }
        policySession.invalidateAndCancel()
        print("PASS: Enter/newline/composition, remote metadata, loopback-only destination, rejected 307/308 redirects, local chat, HTTP failure, nonvision refusal")
    }
}
