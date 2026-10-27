import SwiftUI
@main struct LocalAssistantApp: App {
    @NSApplicationDelegateAdaptor(AssistantAppDelegate.self) private var delegate
    var body: some Scene {
        WindowGroup(Product.name, id: "workspace") {
            AssistantRootView(store: delegate.store, voice: delegate.voice)
                .background(WorkspaceWindowReader(onWindow: delegate.bindWindow))
                .onDisappear { delegate.voice.stop() }
        }
        .defaultSize(width: 1060, height: 800)
        .defaultPosition(.center)
        .windowResizability(.contentMinSize)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
    }
}
