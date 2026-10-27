import AppKit
import UniformTypeIdentifiers
struct ImageAttachment {
    let name: String
    let data: Data
    static func load(_ url: URL) throws -> ImageAttachment {
        let access = url.startAccessingSecurityScopedResource()
        defer { if access { url.stopAccessingSecurityScopedResource() } }
        let size = try url.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
        guard size <= 20_000_000 else { throw failure("Choose an image smaller than 20 MB.") }
        let raw = try Data(contentsOf: url)
        guard let source = CGImageSourceCreateWithData(raw as CFData, nil),
              let image = CGImageSourceCreateThumbnailAtIndex(source, 0, [kCGImageSourceCreateThumbnailFromImageAlways: true, kCGImageSourceThumbnailMaxPixelSize: 1600, kCGImageSourceCreateThumbnailWithTransform: true] as CFDictionary) else { throw failure("This image could not be opened. Try a PNG or JPEG.") }
        let bitmap = NSBitmapImageRep(cgImage: image)
        guard let data = bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.85]) else { throw failure("Could not prepare this image.") }
        return ImageAttachment(name: url.lastPathComponent, data: data)
    }
    private static func failure(_ message: String) -> NSError { NSError(domain: "Image", code: 1, userInfo: [NSLocalizedDescriptionKey: message]) }
}
