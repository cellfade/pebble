import AppKit
import SwiftUI

final class SubmitTextView: NSTextView {
    var onSubmit: (() -> Void)?
    static func shouldSubmit(keyCode: UInt16, modifiers: NSEvent.ModifierFlags, composing: Bool) -> Bool {
        (keyCode == 36 || keyCode == 76) && !modifiers.contains(.shift) && !modifiers.contains(.option) && !modifiers.contains(.control) && !composing
    }
    override func keyDown(with event: NSEvent) {
        if Self.shouldSubmit(keyCode: event.keyCode, modifiers: event.modifierFlags, composing: hasMarkedText()) { onSubmit?(); return }
        super.keyDown(with: event)
    }
}
struct PromptEditor: NSViewRepresentable {
    @Binding var text: String
    var editable: Bool
    var onSubmit: () -> Void
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    func makeNSView(context: Context) -> NSScrollView {
        let scroll = NSScrollView()
        let view = SubmitTextView()
        view.isRichText = false
        view.font = .preferredFont(forTextStyle: .body)
        view.textColor = .labelColor
        view.drawsBackground = false
        view.isVerticallyResizable = true
        view.isHorizontallyResizable = false
        view.autoresizingMask = [.width]
        view.textContainer?.widthTracksTextView = true
        view.textContainerInset = NSSize(width: 8, height: 8)
        view.delegate = context.coordinator
        view.setAccessibilityLabel("Prompt")
        view.setAccessibilityHelp("Enter sends the prompt. Shift Enter inserts a new line.")
        scroll.documentView = view
        scroll.hasVerticalScroller = true
        scroll.drawsBackground = false
        return scroll
    }
    func updateNSView(_ scroll: NSScrollView, context: Context) {
        context.coordinator.parent = self
        guard let view = scroll.documentView as? SubmitTextView else { return }
        if view.string != text { view.string = text }
        view.isEditable = editable
        view.onSubmit = onSubmit
    }
    final class Coordinator: NSObject, NSTextViewDelegate {
        var parent: PromptEditor
        init(_ parent: PromptEditor) { self.parent = parent }
        func textDidChange(_ notification: Notification) {
            if let view = notification.object as? NSTextView { parent.text = view.string }
        }
    }
}
