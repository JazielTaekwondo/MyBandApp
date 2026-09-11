import Foundation
import AVFoundation
import Combine

class AudioRecorder: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    @Published var isRecording: Bool = false
    @Published public var audioURL: URL?
    
    private var audioFileURL: URL {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folderURL = documentsDirectory.appendingPathComponent("TemporaryFiles", isDirectory: true)
        
        // Crear el directorio "TemporaryFiles" si no existe en el sistema de archivos
        if !fileManager.fileExists(atPath: folderURL.path) {
            do {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
            } catch {
                print("Error al crear la carpeta TemporaryFiles: \(error.localizedDescription)")
            }
        }
        audioURL = folderURL
        return folderURL.appendingPathComponent("melodia.m4a")
    }
    
    init() {
        requestMicrophonePermission()
    }
    
    private func requestMicrophonePermission() {
        #if os(iOS)
        AVAudioApplication.requestRecordPermission { granted in
            if !granted {
                print("Permiso de micrófono denegado.")
            }
        }
        #endif
    }
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        #if os(iOS)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try session.setActive(true)
        } catch {
            print("Error al configurar AVAudioSession: \(error.localizedDescription)")
            return
        }
        #endif
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            audioRecorder?.record()
            
            DispatchQueue.main.async {
                self.isRecording = true
                print("Grabando en: \(self.audioFileURL.path)")
            }
        } catch {
            print("No se pudo iniciar la grabación: \(error.localizedDescription)")
        }
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        
        #if os(iOS)
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error al desactivar AVAudioSession: \(error.localizedDescription)")
        }
        #endif
        
        DispatchQueue.main.async {
            self.isRecording = false
            print("Grabación finalizada y guardada en: \(self.audioFileURL.path)")
        }
    }
}
