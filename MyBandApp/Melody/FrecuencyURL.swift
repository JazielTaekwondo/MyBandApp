//
//  FrecuencyURL.swift
//  MyBandApp
//
//  Created by Victor Flores on 21/09/26.
//

import Foundation

/// Se encarga exclusivamente de resolver la URL de la grabación
/// y orquestar el análisis YIN, publicando su estado.
@Observable
class FrecuencyURL {

    // MARK: - Estado observable

    enum ProcessingState: Equatable {
        case idle
        case processing
        case success
        case failure(String)
    }

    var state: ProcessingState = .idle
    var outputFileURL: URL?

    // MARK: - Configuración

    private let providedAudioURL: URL?

    init(audioURL: URL? = nil) {
        self.providedAudioURL = audioURL
    }

    // MARK: - Resolución de la URL

    /// URL de la grabación a procesar.
    /// - Si se pasó `audioURL` al inicializar, la usa directamente.
    /// - Si no, reconstruye la ruta por defecto de `AudioRecorder`:
    ///   `Documents/TemporaryFiles/melodia.m4a`
    var resolvedAudioURL: URL {
        if let providedAudioURL { return providedAudioURL }

        let documentsDirectory = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]

        return documentsDirectory
            .appendingPathComponent("TemporaryFiles", isDirectory: true)
            .appendingPathComponent("melodia.m4a")
    }

    // MARK: - Procesamiento

    /// Ejecuta el análisis de la melodía. Actualiza `state` conforme avanza.
    @MainActor
    func process() async {
        let url = resolvedAudioURL

        guard FileManager.default.fileExists(atPath: url.path) else {
            print("⚠️ FrecuencyURL: no se encontró el archivo en \(url.path)")
            state = .failure("No se encontró la grabación en el dispositivo.")
            return
        }

        // 1. Publicar el estado ANTES de empezar a trabajar
        state = .processing
        print("🎧 FrecuencyURL: procesando \(url.path)")

        // 2. Dejar que SwiftUI pinte el spinner y la transición antes del trabajo pesado.
        //    Este `await` cede el hilo principal al run loop.
        try? await Task.sleep(for: .milliseconds(250))

        // 3. Ejecutar el análisis en un hilo de fondo.
        //    Task.detached NO hereda el aislamiento de MainActor,
        //    así que su closure corre en el executor concurrente global.
        let success = await Task.detached(priority: .userInitiated) {
            await YinAnalyzer.processMelody(from: url)
        }.value

        // 4. De vuelta en MainActor: actualizar estado.
        if success {
            let documentsDirectory = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)[0]
            outputFileURL = documentsDirectory
                .appendingPathComponent("melodia_resultado.txt")
            state = .success
        } else {
            state = .failure("No se pudo analizar la grabación.")
        }
    }
}
