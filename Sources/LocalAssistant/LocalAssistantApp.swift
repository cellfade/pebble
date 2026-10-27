import AppKit
@main enum LocalAssistantApp {
    @MainActor static func main() {
        let app = NSApplication.shared
        let delegate = AssistantAppDelegate()
        app.delegate = delegate
        withExtendedLifetime(delegate) { app.run() }
    }
}
