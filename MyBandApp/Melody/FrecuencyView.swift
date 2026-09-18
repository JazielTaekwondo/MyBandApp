//
//  ContentView.swift
//  frecuencia
//
//  Created by Victor Flores on 25/08/26.
//

import SwiftUI

struct FrecuencyView: View {
    var audioURL: URL? = nil

    @State private var correctMelody: Bool = false
    @State private var isProcessing: Bool = false

    var body: some View {
        VStack {
            Text("YIN ANALYZER").font(.largeTitle)

            if isProcessing {
                ProgressView("Procesando melodía...")
                    .padding()
            } else if correctMelody {
                Text("MELODÍA CORRECTAMENTE GUARDADA").padding()
            } else {
                Text("MELODÍA NO DETECTADA").padding()
            }
        }
        .padding()
        .onAppear {
            processAudioWithYIN(at: resolvedAudioURL)
        }
    }

    // MARK: - Ruta resuelta

    /// Devuelve la URL a procesar:
    /// - Si se pasó `audioURL` explícita, la usa.
    /// - Si no, reconstruye la ruta por defecto de `AudioRecorder`.
    private var resolvedAudioURL: URL {
        if let audioURL { return audioURL }

        let documentsDirectory = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]

        return documentsDirectory
            .appendingPathComponent("TemporaryFiles", isDirectory: true)
            .appendingPathComponent("melodia.m4a")
    }

    // MARK: - Procesamiento

    private func processAudioWithYIN(at audioURL: URL) {
        // Validación rápida: si el archivo no existe, no tiene sentido procesar
        guard FileManager.default.fileExists(atPath: audioURL.path) else {
            print("FrecuencyView: no se encontró el archivo en \(audioURL.path)")
            self.correctMelody = false
            self.isProcessing = false
            return
        }

        print("FrecuencyView: procesando \(audioURL.path)")
        isProcessing = true

        Task.detached(priority: .userInitiated) {
            let success = await YinAnalyzer.processMelody(from: audioURL)

            await MainActor.run {
                self.correctMelody = success
                self.isProcessing = false
            }
        }
    }
}

#Preview {
    FrecuencyView()
}
