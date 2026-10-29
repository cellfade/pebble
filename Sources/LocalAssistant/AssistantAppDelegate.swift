import AppKit
import SwiftUI
import os

@MainActor final class AssistantAppDelegate: NSObject, NSApplicationDelegate {
    let store = AssistantStore()
    let voice = DictationService()
    private let hotKey = GlobalHotKey()
    private var statusItem: NSStatusItem?
    private var workspaceWindow: NSWindow?
    private var closeObserver: NSObjectProtocol?
    private var moveObserver: NSObjectProtocol?
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        store.onBeginOperation = { [weak self] in self?.voice.stop() }
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let url = Bundle.main.url(forResource: "MenuBarMark", withExtension: "pdf"), let image = NSImage(contentsOf: url) {
            image.size = NSSize(width: 19, height: 19); image.isTemplate = true; item.button?.image = image
        } else { item.button?.image = NSImage(systemSymbolName: "circle.hexagongrid.fill", accessibilityDescription: Product.name) }
        item.button?.toolTip = "Pebble · Control-Space to dictate"
        item.button?.target = self; item.button?.action = #selector(toggleWindow)
        statusItem = item
        hotKey.onPress = { [weak self] in self?.openAndDictate() }
        let result = hotKey.register()
        Logger(subsystem: "io.github.cellfade.pebble", category: "shortcut").notice("Control-Space registration result: \(result)")
        store.shortcutStatus = result == noErr ? "⌃ Space to dictate" : "Shortcut unavailable (\(result)); check Keyboard Shortcuts → Input Sources."
        if CommandLine.arguments.contains("--appearance-light") { NSApp.appearance = NSAppearance(named: .aqua) }
        if CommandLine.arguments.contains("--appearance-dark") { NSApp.appearance = NSAppearance(named: .darkAqua) }
        if CommandLine.arguments.contains("--show-setup") { store.showingSetup = true }
        NSApp.activate(ignoringOtherApps: true)
    }
    func bindWindow(_ window: NSWindow) {
        guard workspaceWindow !== window else { return }
        workspaceWindow = window
        window.isMovableByWindowBackground = true
        window.isReleasedWhenClosed = false
        window.setFrameAutosaveName("PebbleWorkspaceV3")
        if let closeObserver { NotificationCenter.default.removeObserver(closeObserver) }
        closeObserver = NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: window, queue: .main) { [weak self] _ in Task { @MainActor in self?.voice.stop() } }
        #if DEBUG
        if let moveObserver { NotificationCenter.default.removeObserver(moveObserver) }
        moveObserver = NotificationCenter.default.addObserver(forName: NSWindow.didMoveNotification, object: window, queue: .main) { notification in
            if let moved = notification.object as? NSWindow { let frame = moved.frame; Logger(subsystem: "io.github.cellfade.pebble", category: "window").notice("Workspace moved: \(Int(frame.origin.x)),\(Int(frame.origin.y))") }
        }
        #endif
    }
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        guard workspaceWindow != nil else { return true }; showWindow(); return false
    }
    @objc private func toggleWindow() {
        if workspaceWindow?.isVisible == true && NSApp.isActive { voice.stop(); workspaceWindow?.orderOut(nil) } else { showWindow() }
    }
    private func showWindow() { NSApp.activate(ignoringOtherApps: true); workspaceWindow?.deminiaturize(nil); workspaceWindow?.makeKeyAndOrderFront(nil) }
    private func openAndDictate() {
        Logger(subsystem: "io.github.cellfade.pebble", category: "shortcut").notice("Global shortcut pressed")
        store.showingSetup = false; showWindow()
        guard !store.busy else { voice.message = "Wait for the response or cancel it before dictating."; return }
        if voice.recording || voice.preparing { voice.stop(); return }
        if store.mode == "Actions" { store.mode = "Ask" }
        let original = store.prompt
        Task { [weak self] in
            guard let self else { return }
            await self.voice.start { [weak self] transcript in self?.store.prompt = original + (original.isEmpty ? "" : "\n") + transcript }
        }
    }
    func applicationDidResignActive(_ notification: Notification) { voice.stop() }
    func applicationWillTerminate(_ notification: Notification) { voice.stop(); hotKey.unregister() }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { false }
}
