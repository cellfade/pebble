import AppKit
@main struct RenderMark {
    static func main() throws {
        let output = URL(fileURLWithPath: CommandLine.arguments[1])
        let view = MarkView(frame: NSRect(x:0,y:0,width:256,height:256))
        try view.dataWithPDF(inside: view.bounds).write(to: output)
    }
}
final class MarkView: NSView {
    override var isFlipped: Bool { true }
    override func draw(_ dirtyRect: NSRect) {
        NSColor.black.setFill()
        let body = NSBezierPath(); body.move(to: NSPoint(x:38,y:198))
        body.curve(to: NSPoint(x:58,y:64), controlPoint1:NSPoint(x:16,y:165), controlPoint2:NSPoint(x:29,y:106))
        body.curve(to: NSPoint(x:148,y:26), controlPoint1:NSPoint(x:83,y:28), controlPoint2:NSPoint(x:117,y:17))
        body.curve(to: NSPoint(x:225,y:138), controlPoint1:NSPoint(x:185,y:36), controlPoint2:NSPoint(x:216,y:91))
        body.curve(to: NSPoint(x:175,y:230), controlPoint1:NSPoint(x:234,y:183), controlPoint2:NSPoint(x:212,y:222))
        body.curve(to: NSPoint(x:38,y:198), controlPoint1:NSPoint(x:124,y:241), controlPoint2:NSPoint(x:61,y:234));body.close()
        let face = NSBezierPath();face.move(to:NSPoint(x:72,y:61))
        face.curve(to:NSPoint(x:83,y:141),controlPoint1:NSPoint(x:48,y:82),controlPoint2:NSPoint(x:52,y:122))
        face.curve(to:NSPoint(x:149,y:175),controlPoint1:NSPoint(x:105,y:152),controlPoint2:NSPoint(x:127,y:164))
        face.curve(to:NSPoint(x:199,y:136),controlPoint1:NSPoint(x:180,y:187),controlPoint2:NSPoint(x:205,y:162))
        face.curve(to:NSPoint(x:134,y:61),controlPoint1:NSPoint(x:196,y:107),controlPoint2:NSPoint(x:163,y:78))
        face.curve(to:NSPoint(x:72,y:61),controlPoint1:NSPoint(x:111,y:48),controlPoint2:NSPoint(x:88,y:47));face.close()
        body.append(face);body.windingRule = .evenOdd;body.fill()
        NSBezierPath(ovalIn:NSRect(x:59,y:213,width:48,height:28)).fill()
        NSBezierPath(ovalIn:NSRect(x:153,y:213,width:48,height:28)).fill()
        for (x,y) in [(96.0,98.0),(142.0,123.0)] {
            let eye=NSBezierPath(ovalIn:NSRect(x:x-11,y:y-17,width:22,height:34))
            let transform=AffineTransform(translationByX:x,byY:y);var t=transform;t.rotate(byDegrees:27);t.translate(x:-x,y:-y);eye.transform(using:t);eye.fill()
        }
    }
}
