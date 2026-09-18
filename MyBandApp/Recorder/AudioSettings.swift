//
//  AudioSettings.swift
//  MyBandApp
//
//  Created by Victor Flores on 14/09/26.
//

import SwiftUI

// MARK: - Estado Global

@Observable
class AudioSettings {
    var numerador: String = "4"
    var denominador: String = "4"
    var bpm: String = "100"
} // Fin de AudioSettings

let settings = AudioSettings()
