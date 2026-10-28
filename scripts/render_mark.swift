import AppKit
import Foundation
import ImageIO

private struct MarkPath {
    let path: NSBezierPath
    let fill: Bool
    let stroke: Bool
    let strokeWidth: CGFloat
}
private enum MarkError: Error, CustomStringConvertible {
    case invalid(String)
    var description: String { if case .invalid(let message) = self { return message }; return "Invalid artwork" }
}

// Reads the canonical monochrome SVG rather than maintaining a second silhouette.
// The deliberately small mark uses only M/L/C/Z paths and inherited fill/stroke.
private final class MarkParser: NSObject, XMLParserDelegate {
    var paths: [MarkPath] = []
    var failure: Error?
    private var styles: [[String: String]] = [["fill": "currentColor", "stroke": "none", "stroke-width": "0"]]
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        var style = styles.last!
        for key in ["fill", "stroke", "stroke-width", "stroke-linecap", "stroke-linejoin"] { if let value = attributeDict[key] { style[key] = value } }
        styles.append(style)
        guard elementName == "path" else { return }
        do {
            guard attributeDict["transform"] == nil, let d = attributeDict["d"] else { throw MarkError.invalid("The monochrome mark must use untransformed SVG paths.") }
            let path = try Self.path(d)
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            path.lineWidth = CGFloat(Double(style["stroke-width"] ?? "0") ?? 0)
            paths.append(MarkPath(path: path, fill: style["fill"] != "none", stroke: style["stroke"] != "none", strokeWidth: path.lineWidth))
        } catch { failure = error; parser.abortParsing() }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) { if styles.count > 1 { styles.removeLast() } }
    private static func path(_ d: String) throws -> NSBezierPath {
        let regex = try NSRegularExpression(pattern: "[A-Za-z]|[-+]?(?:[0-9]*\\.[0-9]+|[0-9]+\\.?)(?:[eE][-+]?[0-9]+)?")
        let string = d as NSString
        let tokens = regex.matches(in: d, range: NSRange(location: 0, length: string.length)).map { string.substring(with: $0.range) }
        let result = NSBezierPath()
        var index = 0
        var command = ""
        func number() throws -> CGFloat {
            guard index < tokens.count, let value = Double(tokens[index]) else { throw MarkError.invalid("Invalid SVG coordinate.") }
            index += 1; return CGFloat(value)
        }
        func point() throws -> NSPoint { let x = try number(); let y = try number(); return NSPoint(x: x, y: y) }
        while index < tokens.count {
            if tokens[index].first?.isLetter == true { command = tokens[index]; index += 1 }
            switch command {
            case "M": result.move(to: try point()); command = "L"
            case "L": result.line(to: try point())
            case "C": let c1 = try point(); let c2 = try point(); let end = try point(); result.curve(to: end, controlPoint1: c1, controlPoint2: c2)
            case "Z", "z": result.close(); command = ""
            default: throw MarkError.invalid("Unsupported SVG command: \(command)")
            }
        }
        return result
    }
}

private final class MarkView: NSView {
    let paths: [MarkPath]
    init(paths: [MarkPath]) { self.paths = paths; super.init(frame: NSRect(x: 0, y: 0, width: 256, height: 256)) }
    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }
    override var isFlipped: Bool { true }
    override func draw(_ dirtyRect: NSRect) {
        NSColor.black.setFill(); NSColor.black.setStroke()
        for item in paths {
            if item.fill { item.path.fill() }
            if item.stroke { item.path.stroke() }
        }
    }
}

@main struct RenderMark {
    static func main() throws {
        let arguments = CommandLine.arguments
        guard arguments.count >= 3 else { throw MarkError.invalid("Usage: render_mark canonical-mono.svg output.pdf [preview-directory]") }
        let input = URL(fileURLWithPath: arguments[1])
        let output = URL(fileURLWithPath: arguments[2])
        let delegate = MarkParser()
        let parser = XMLParser(data: try Data(contentsOf: input)); parser.delegate = delegate
        guard parser.parse(), delegate.failure == nil, !delegate.paths.isEmpty else { throw delegate.failure ?? parser.parserError ?? MarkError.invalid("No vector paths found.") }
        let view = MarkView(paths: delegate.paths)
        let pdf = view.dataWithPDF(inside: view.bounds)
        guard pdf.starts(with: Data("%PDF-".utf8)) else { throw MarkError.invalid("Vector PDF generation failed.") }
        try pdf.write(to: output)
        if arguments.count > 3 {
            let previews = URL(fileURLWithPath: arguments[3]); try FileManager.default.createDirectory(at: previews, withIntermediateDirectories: true)
            for size in [16, 32, 256] {
                let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
                let context = NSGraphicsContext(bitmapImageRep: bitmap)!
                NSGraphicsContext.saveGraphicsState(); NSGraphicsContext.current = context
                context.cgContext.setFillColor(NSColor.white.cgColor)
                context.cgContext.fill(CGRect(x: 0, y: 0, width: size, height: size))
                context.cgContext.translateBy(x: 0, y: CGFloat(size)); context.cgContext.scaleBy(x: CGFloat(size) / 256, y: -CGFloat(size) / 256)
                view.draw(view.bounds)
                NSGraphicsContext.restoreGraphicsState()
                try bitmap.representation(using: .png, properties: [:])!.write(to: previews.appendingPathComponent("menu-mark-\(size).png"))
            }
        }
        try validateResources(output.deletingLastPathComponent())
        print("Vector mark and icon resources validated.")
    }
    private static func validateResources(_ resources: URL) throws {
        func checkPNG(_ url: URL, expected: Int? = nil) throws {
            let data = try Data(contentsOf: url)
            guard data.starts(with: Data([137, 80, 78, 71, 13, 10, 26, 10])), let source = CGImageSourceCreateWithData(data as CFData, nil), let image = CGImageSourceCreateImageAtIndex(source, 0, nil), image.width == image.height else { throw MarkError.invalid("Invalid square PNG: \(url.lastPathComponent)") }
            if let expected { guard image.width == expected else { throw MarkError.invalid("Incorrect rendition size: \(url.lastPathComponent)") } }
            else { guard image.width >= 1024 else { throw MarkError.invalid("App icon master must be at least 1024 px square.") } }
        }
        try checkPNG(resources.appendingPathComponent("AppIcon-source.png"))
        try checkPNG(resources.appendingPathComponent("AppIcon.png"), expected: 256)
        guard try Data(contentsOf: resources.appendingPathComponent("AppIcon.icns")).starts(with: Data("icns".utf8)) else { throw MarkError.invalid("Invalid ICNS file signature.") }
        let catalog = resources.appendingPathComponent("Assets.xcassets/AppIcon.appiconset")
        let manifest = try JSONSerialization.jsonObject(with: Data(contentsOf: catalog.appendingPathComponent("Contents.json"))) as? [String: Any]
        guard let images = manifest?["images"] as? [[String: String]], images.count == 10 else { throw MarkError.invalid("App icon catalog must contain all ten Mac renditions.") }
        for size in [16, 32, 128, 256, 512] {
            for scale in [1, 2] {
                let filename = "icon_\(size)x\(size)" + (scale == 2 ? "@2x" : "") + ".png"
                guard images.contains(where: { $0["filename"] == filename && $0["size"] == "\(size)x\(size)" && $0["scale"] == "\(scale)x" }) else { throw MarkError.invalid("Missing catalog rendition: \(filename)") }
                try checkPNG(catalog.appendingPathComponent(filename), expected: size * scale)
            }
        }
    }
}
