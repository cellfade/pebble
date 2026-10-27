import AppKit
import SwiftUI
import os

@MainActor final class AssistantAppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    private let store = AssistantStore()
    private let voice = DictationService()
    private let hotKey = GlobalHotKey()
    private var statusItem: NSStatusItem?
    private let popover = NSPopover()
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        item.button?.image = NSImage(systemSymbolName: "sparkle", accessibilityDescription: Product.name)
        item.button?.toolTip = "\(Product.name) · Control-Space to dictate"
        item.button?.target = self; item.button?.action = #selector(togglePopover)
        statusItem = item
        popover.behavior = .transient
        popover.delegate = self
        popover.contentViewController = NSHostingController(rootView: AssistantRootView(store: store, voice: voice))
        hotKey.onPress = { [weak self] in self?.openAndDictate() }
        let result = hotKey.register()
        Logger(subsystem: "com.local.LocalAssistant", category: "shortcut").notice("Control-Space registration result: \(result)")
        store.shortcutStatus = result == noErr ? "⌃Space opens dictation" : "Control-Space unavailable (\(result)). Check Keyboard → Keyboard Shortcuts → Input Sources."
        showPopover()
    }
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool { showPopover(); return false }
    @objc private func togglePopover() {
        if popover.isShown { popover.performClose(nil) } else { showPopover() }
    }
    private func showPopover() {
        guard let button = statusItem?.button else { return }
        NSApp.activate(ignoringOtherApps: true)
        if !popover.isShown { popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY) }
        popover.contentViewController?.view.window?.makeKey()
    }
    private func openAndDictate() {
        Logger(subsystem: "com.local.LocalAssistant", category: "shortcut").notice("Global shortcut pressed")
        store.showingSetup = false
        showPopover()
        guard !store.busy else { voice.message = "Wait for the current response or cancel it before dictating."; return }
        if voice.recording || voice.preparing { voice.stop(); return }
        let original = store.prompt
        Task { [weak self] in
            guard let self else { return }
            await self.voice.start { [weak self] transcript in
            self?.store.prompt = original + (original.isEmpty ? "" : "\n") + transcript
        } }
    }
    func popoverDidClose(_ notification: Notification) { voice.stop() }
    func applicationWillTerminate(_ notification: Notification) { voice.stop(); hotKey.unregister() }
}
