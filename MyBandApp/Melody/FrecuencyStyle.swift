//
//  FrecuencyStyle.swift
//  MyBandApp
//
//  Created by Victor Flores on 21/09/26.
//

import SwiftUI

struct FrecuencyStyle {
    let state: FrecuencyURL.ProcessingState

    var headerIcon: String {
        switch state {
        case .idle: return "waveform"
        case .processing: return "arrow.triangle.2.circlepath"
        case .success: return "checkmark"
        case .failure: return "exclamationmark"
        }
    }

    var headerCaption: String {
        switch state {
        case .idle: return "PREPARANDO"
        case .processing: return "ANALIZANDO"
        case .success: return "LISTO"
        case .failure: return "SIN RESULTADO"
        }
    }

    var headerTitle: String {
        switch state {
        case .idle: return "Iniciando análisis"
        case .processing: return "Obteniendo melodía"
        case .success: return "Melodía detectada"
        case .failure: return "No se pudo analizar"
        }
    }

    var stateIcon: String {
        switch state {
        case .idle: return "waveform"
        case .processing: return "arrow.triangle.2.circlepath"
        case .success: return "checkmark.seal.fill"
        case .failure: return "exclamationmark.triangle.fill"
        }
    }

    var stateTitle: String {
        switch state {
        case .idle, .processing: return "PROCESANDO"
        case .success: return "COMPLETADO"
        case .failure: return "ERROR"
        }
    }

    var stateDescription: String {
        switch state {
        case .idle:
            return "Preparando el análisis de tu grabación..."
        case .processing:
            return "Analizando las frecuencias de tu grabación..."
        case .success:
            return "Tu melodía fue analizada y guardada correctamente."
        case .failure(let message):
            return message
        }
    }

    var headerGradient: [Color] {
        switch state {
        case .idle, .processing: return [.blue, .indigo]
        case .success: return [.green, .teal]
        case .failure: return [.orange, .red]
        }
    }

    var headerShadowColor: Color {
        switch state {
        case .idle, .processing: return .blue.opacity(0.3)
        case .success: return .teal.opacity(0.3)
        case .failure: return .red.opacity(0.3)
        }
    }

    var stateGradient: [Color] {
        switch state {
        case .idle, .processing: return [.blue, .indigo]
        case .success: return [Color(red: 0.1, green: 0.75, blue: 0.5), .teal]
        case .failure: return [.orange, .red]
        }
    }

    var stateShadowColor: Color {
        switch state {
        case .idle, .processing: return .blue.opacity(0.3)
        case .success: return .teal.opacity(0.3)
        case .failure: return .red.opacity(0.3)
        }
    }
}
