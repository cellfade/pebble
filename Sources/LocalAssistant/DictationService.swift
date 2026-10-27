import AVFoundation
import Speech
import SwiftUI

@MainActor final class DictationService: ObservableObject {
    @Published var recording = false
    @Published var preparing = false
    @Published var message = ""
    private let engine = AVAudioEngine()
    private var recognition: SFSpeechRecognitionTask?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var tapInstalled = false
    private var sessionID: UUID?
    private var timeout: Task<Void, Never>?
    func start(onTranscript: @escaping (String) -> Void) async {
        guard !recording && !preparing else { return }
        let id = UUID(); sessionID = id; preparing = true; message = "Requesting voice access…"
        defer { preparing = false }
        let speech = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { continuation.resume(returning: $0) }
        }
        guard sessionID == id else { return }
        guard speech == .authorized else { message = "Enable Speech Recognition for Local Assistant in System Settings → Privacy & Security."; return }
        let mic = await AVCaptureDevice.requestAccess(for: .audio)
        guard sessionID == id else { return }
        guard mic else { message = "Enable Microphone for Local Assistant in System Settings → Privacy & Security."; return }
        guard let recognizer = SFSpeechRecognizer(locale: .current), recognizer.isAvailable, recognizer.supportsOnDeviceRecognition else {
            message = "On-device dictation is unavailable for your current language. Use typing or enable a supported dictation language in System Settings."; return
        }
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.requiresOnDeviceRecognition = true
        request.shouldReportPartialResults = true
        self.request = request
        let input = engine.inputNode
        let format = input.outputFormat(forBus: 0)
        guard format.sampleRate > 0, format.channelCount > 0 else { message = "No microphone input available."; self.request = nil; return }
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in request.append(buffer) }
        tapInstalled = true
        recognition = recognizer.recognitionTask(with: request) { [weak self] result, error in
            let transcript = result?.bestTranscription.formattedString
            let final = result?.isFinal ?? false
            let failed = error != nil
            Task { @MainActor in
                guard let self, self.sessionID == id else { return }
                if let transcript { onTranscript(transcript) }
                if final || failed {
                    self.stop()
                    self.message = failed ? "Dictation stopped. Review the text and try again if needed." : "Dictation ready to review."
                }
            }
        }
        do {
            engine.prepare(); try engine.start(); recording = true; message = "Listening on this Mac… Stop when finished."
            timeout = Task { [weak self] in
                try? await Task.sleep(for: .seconds(55))
                guard !Task.isCancelled else { return }
                self?.stop(); self?.message = "Dictation paused after 55 seconds. Review or continue recording."
            }
        } catch { stop(); message = "Could not start microphone: \(error.localizedDescription)" }
    }
    func stop() {
        sessionID = nil; timeout?.cancel(); timeout = nil
        engine.stop()
        if tapInstalled { engine.inputNode.removeTap(onBus: 0); tapInstalled = false }
        request?.endAudio(); recognition?.cancel(); recognition = nil; request = nil
        recording = false
        if !preparing { message = "Dictation stopped. Review your text before sending." }
    }
}
