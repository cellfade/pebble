import AppKit
import SwiftUI
struct WorkspaceWindowReader: NSViewRepresentable {
    let onWindow: (NSWindow) -> Void
    func makeNSView(context: Context) -> WindowProbe { let view = WindowProbe(); view.onWindow = onWindow; return view }
    func updateNSView(_ view: WindowProbe, context: Context) { view.onWindow = onWindow }
}
final class WindowProbe: NSView {
    var onWindow: ((NSWindow) -> Void)?
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        if let window { DispatchQueue.main.async { [weak self, weak window] in if let window { self?.onWindow?(window) } } }
    }
}
