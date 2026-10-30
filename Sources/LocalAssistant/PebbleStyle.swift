import SwiftUI
import AppKit
extension Color {
    static var onCobalt: Color {
        Color(nsColor: NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
                ? NSColor(srgbRed: 0.04, green: 0.06, blue: 0.12, alpha: 1)
                : NSColor.white
        })
    }
    static var cobalt: Color {
        Color(nsColor: NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
                ? NSColor(srgbRed: 0.58, green: 0.72, blue: 1.0, alpha: 1)
                : NSColor(srgbRed: 0.14, green: 0.31, blue: 0.93, alpha: 1)
        })
    }
}
struct PebbleAvatar: View {
    var size: CGFloat = 52
    var body: some View {
        Group {
            if let url = Bundle.main.url(forResource: "AppIcon", withExtension: "png"), let image = NSImage(contentsOf: url) {
                Image(nsImage: image).resizable().scaledToFit()
            } else { Image(systemName: "face.smiling.fill").resizable().scaledToFit().foregroundStyle(Color.cobalt) }
        }.frame(width: size, height: size).accessibilityHidden(true)
    }
}
struct PebbleGlass: ViewModifier {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    func body(content: Content) -> some View {
        if reduceTransparency { content.background(Color(nsColor: .controlBackgroundColor), in: RoundedRectangle(cornerRadius: 18)) }
        else {
            #if compiler(>=6.2)
            if #available(macOS 26.0, *) { content.glassEffect(.regular, in: RoundedRectangle(cornerRadius: 18)) }
            else { content.background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18)) }
            #else
            content.background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
            #endif
        }
    }
}
struct PebbleGlassGroup<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var body: some View {
        #if compiler(>=6.2)
        if #available(macOS 26.0, *) { GlassEffectContainer(spacing: 12) { content() } }
        else { content() }
        #else
        content()
        #endif
    }
}
