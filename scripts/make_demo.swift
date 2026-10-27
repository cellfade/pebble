import AppKit
import AVFoundation
import CoreMedia

// Encodes genuine CUA app captures using their recorded capture timestamps.
// This is a sampled interaction demo, not continuous 30fps screen capture.
struct Frame: Decodable { let file: String; let time: Double }
@main struct MakeDemo {
    static func main() async throws {
        guard CommandLine.arguments.count == 3 else { fatalError("Usage: make_demo manifest.json output.mp4") }
        let manifest = URL(fileURLWithPath: CommandLine.arguments[1])
        let frames = try JSONDecoder().decode([Frame].self, from: Data(contentsOf: manifest))
        guard !frames.isEmpty else { fatalError("No captures") }
        let output = URL(fileURLWithPath: CommandLine.arguments[2])
        if FileManager.default.fileExists(atPath: output.path) { try FileManager.default.removeItem(at: output) }
        let writer = try AVAssetWriter(outputURL: output, fileType: .mp4)
        let width = 1280, height = 1080
        let input = AVAssetWriterInput(mediaType: .video, outputSettings: [AVVideoCodecKey: AVVideoCodecType.h264, AVVideoWidthKey: width, AVVideoHeightKey: height])
        input.expectsMediaDataInRealTime = false
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input, sourcePixelBufferAttributes: [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB, kCVPixelBufferWidthKey as String: width, kCVPixelBufferHeightKey as String: height])
        writer.add(input)
        guard writer.startWriting() else { throw writer.error! }
        writer.startSession(atSourceTime: .zero)
        let duration = max(12, frames.last!.time + 3)
        let fps = 12.0
        var index = 0
        for tick in 0..<Int(duration * fps) {
            let seconds = Double(tick) / fps
            while index + 1 < frames.count && frames[index + 1].time <= seconds { index += 1 }
            let url = manifest.deletingLastPathComponent().appendingPathComponent(frames[index].file)
            guard let source = CGImageSourceCreateWithURL(url as CFURL, nil), let image = CGImageSourceCreateImageAtIndex(source, 0, nil) else { fatalError("Invalid captured image") }
            while !input.isReadyForMoreMediaData { try await Task.sleep(for: .milliseconds(10)) }
            var pixel: CVPixelBuffer?
            CVPixelBufferPoolCreatePixelBuffer(nil, adaptor.pixelBufferPool!, &pixel)
            let buffer = pixel!
            CVPixelBufferLockBaseAddress(buffer, [])
            let context = CGContext(data: CVPixelBufferGetBaseAddress(buffer), width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer), space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)!
            context.setFillColor(CGColor(red: 0.06, green: 0.08, blue: 0.14, alpha: 1)); context.fill(CGRect(x: 0, y: 0, width: width, height: height))
            let scale = min(1000.0 / Double(image.height), 800.0 / Double(image.width))
            let w = Double(image.width) * scale, h = Double(image.height) * scale
            context.interpolationQuality = .high
            context.draw(image, in: CGRect(x: (Double(width)-w)/2, y: (Double(height)-h)/2, width: w, height: h))
            CVPixelBufferUnlockBaseAddress(buffer, [])
            guard adaptor.append(buffer, withPresentationTime: CMTime(value: Int64(tick), timescale: 12)) else { throw writer.error! }
        }
        input.markAsFinished()
        await writer.finishWriting()
        guard writer.status == .completed else { throw writer.error! }
        print("Created sampled interaction demo: \(output.path)")
    }
}
