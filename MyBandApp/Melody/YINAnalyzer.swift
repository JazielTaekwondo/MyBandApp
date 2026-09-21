//
//  YINAnalyzer.swift
//  frecuencia
//
//  Created by Victor Flores on 26/08/26.
//

import Foundation
import AVFoundation

struct YinAnalyzer {
    
    // Configuración separada con umbral YIN por banda:
    // Graves: Umbrales más restrictivos (0.10 - 0.15) para evitar subarmónicos/armónicos erróneos
    // Agudos: Umbrales más permisivos (0.20 - 0.30) para tolerar la pérdida de amplitud del filtro
    nonisolated static let subBassBand = AudioProcessor.BandConfig(
        name: "subBass", lowCutoff: 20, highCutoff: 60, windowSize: 4096, rmsThreshold: 0.025, yinThreshold: 0.10
    )
    
    nonisolated static let mainBands: [AudioProcessor.BandConfig] = [
        .init(name: "bass", lowCutoff: 60, highCutoff: 250, windowSize: 2048, rmsThreshold: 0.020, yinThreshold: 0.15),
        .init(name: "lowMid", lowCutoff: 250, highCutoff: 500, windowSize: 1024, rmsThreshold: 0.015, yinThreshold: 0.20),
        .init(name: "mid", lowCutoff: 500, highCutoff: 2000, windowSize: 512, rmsThreshold: 0.010, yinThreshold: 0.25),
        .init(name: "highMid", lowCutoff: 2000, highCutoff: 4200, windowSize: 256, rmsThreshold: 0.004, yinThreshold: 0.35)
    ]
    
    nonisolated static func processMelody(from audioURL: URL) async -> Bool {
        guard let (floatData, sampleRate, totalSamples) = loadAudioBuffer(from: audioURL) else { return false }
        
        let hopSize = Int(sampleRate / 20.0) // 20 lecturas/seg
        let maxWindowSize = 4096
        
        // 1. Ejecución paralela usando async let
        async let subBassTask = processSubBassTrack(floatData: floatData, sampleRate: sampleRate, totalSamples: totalSamples, hopSize: hopSize, maxWindowSize: maxWindowSize)
        
        let mainBandsResults = processMainBandsTrack(floatData: floatData, sampleRate: sampleRate, totalSamples: totalSamples, hopSize: hopSize, maxWindowSize: maxWindowSize)
        
        let subBassResults = await subBassTask
        
        // 2. Formatear output
        var outputLines: [String] = []
        let totalFrames = min(subBassResults.count, mainBandsResults.count)
        
        for i in 0..<totalFrames {
            let currentTime = Double(i * hopSize) / sampleRate
            let subBassNote = subBassResults[i]
            let mainNotes = mainBandsResults[i].joined(separator: ", ")
            
            outputLines.append(String(format: "%.2f, %@, %@", currentTime, subBassNote, mainNotes))
        }
        
        return saveOutputToFile(outputLines)
    }
    
    private nonisolated static func processSubBassTrack(floatData: [Float], sampleRate: Double, totalSamples: Int, hopSize: Int, maxWindowSize: Int) async -> [String] {
        var results: [String] = []
        var samplePointer = 0
        
        while samplePointer + maxWindowSize < totalSamples {
            let note = analyzeSingleBand(band: subBassBand, samplePointer: samplePointer, floatData: floatData, sampleRate: sampleRate)
            results.append(note)
            samplePointer += hopSize
        }
        return results
    }
    
    private nonisolated static func processMainBandsTrack(floatData: [Float], sampleRate: Double, totalSamples: Int, hopSize: Int, maxWindowSize: Int) -> [[String]] {
        var results: [[String]] = []
        var samplePointer = 0
        
        while samplePointer + maxWindowSize < totalSamples {
            let frameNotes = mainBands.map { band in
                analyzeSingleBand(band: band, samplePointer: samplePointer, floatData: floatData, sampleRate: sampleRate)
            }
            results.append(frameNotes)
            samplePointer += hopSize
        }
        return results
    }
    
    private nonisolated static func analyzeSingleBand(band: AudioProcessor.BandConfig, samplePointer: Int, floatData: [Float], sampleRate: Double) -> String {
        let chunk = Array(floatData[samplePointer..<(samplePointer + band.windowSize)])
        let filteredChunk = AudioProcessor.bandPassFilter(pcmData: chunk, sampleRate: sampleRate, lowCutoff: band.lowCutoff, highCutoff: band.highCutoff)
        
        guard AudioProcessor.passesRMSFilter(data: filteredChunk, threshold: band.rmsThreshold) else {
            return "REST"
        }
        
        // Se pasa la configuración completa de la banda a la función de cálculo
        let pitch = calculateYinPitch(pcmData: filteredChunk, sampleRate: sampleRate, band: band)
        return frequencyToNoteName(pitch, minFreq: band.lowCutoff, maxFreq: band.highCutoff)
    }
    
    private nonisolated static func loadAudioBuffer(from url: URL) -> ([Float], Double, Int)? {
        guard let audioFile = try? AVAudioFile(forReading: url) else { return nil }
        let format = audioFile.processingFormat
        let frameCount = AVAudioFrameCount(audioFile.length)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return nil }
        try? audioFile.read(into: buffer)
        guard let floatData = buffer.floatChannelData?[0] else { return nil }
        return (Array(UnsafeBufferPointer(start: floatData, count: Int(buffer.frameLength))), format.sampleRate, Int(buffer.frameLength))
    }
    
    // Algoritmo YIN con soporte de umbral específico por banda y límite de lags
    private nonisolated static func calculateYinPitch(pcmData: [Float], sampleRate: Double, band: AudioProcessor.BandConfig) -> Double {
        let halfSize = pcmData.count / 2
        var difference = computeDifference(pcmData: pcmData, halfSize: halfSize)
        
        computeCMNDF(&difference, halfSize: halfSize)
        
        let minTau = selectTau(difference: difference, halfSize: halfSize, sampleRate: sampleRate, band: band)
        return interpolatePitch(minTau: minTau, difference: difference, halfSize: halfSize, sampleRate: sampleRate)
    }
    
    private nonisolated static func computeDifference(pcmData: [Float], halfSize: Int) -> [Float] {
        var diff = [Float](repeating: 0.0, count: halfSize)
        for tau in 0..<halfSize {
            for j in 0..<halfSize {
                let delta = pcmData[j] - pcmData[j + tau]
                diff[tau] += delta * delta
            }
        }
        return diff
    }
    
    private nonisolated static func computeCMNDF(_ difference: inout [Float], halfSize: Int) {
        var runningSum: Float = 0.0
        difference[0] = 1.0
        for tau in 1..<halfSize {
            runningSum += difference[tau]
            difference[tau] = difference[tau] * Float(tau) / (runningSum > 0 ? runningSum : 1.0)
        }
    }
    
    private nonisolated static func selectTau(difference: [Float], halfSize: Int, sampleRate: Double, band: AudioProcessor.BandConfig) -> Int {
        // Establecer el lag mínimo permitido en función de la frecuencia máxima de la banda
        // Evita detectar armónicos por encima de highCutoff
        let minLag = max(2, Int(sampleRate / band.highCutoff))
        let maxLag = min(halfSize - 1, Int(sampleRate / band.lowCutoff))
        
        guard minLag < maxLag else { return -1 }
        
        // Búsqueda con el umbral dinámico de la banda
        for tau in minLag...maxLag where difference[tau] < band.yinThreshold {
            var currentTau = tau
            while currentTau + 1 <= maxLag && difference[currentTau + 1] < difference[currentTau] {
                currentTau += 1
            }
            return currentTau
        }
        
        // Fallback al mínimo global respetando los límites de frecuencia de la banda
        return globalMinFallback(difference: difference, minLag: minLag, maxLag: maxLag, threshold: band.yinThreshold)
    }
    
    private nonisolated static func globalMinFallback(difference: [Float], minLag: Int, maxLag: Int, threshold: Float) -> Int {
        var globalMinVal: Float = Float.greatestFiniteMagnitude
        var globalMinTau = -1
        
        for tau in minLag...maxLag where difference[tau] < globalMinVal {
            globalMinVal = difference[tau]
            globalMinTau = tau
        }
        
        // Acepta la caída global únicamente si está en un rango razonable respecto al umbral
        return globalMinVal < (threshold * 2.0) ? globalMinTau : -1
    }
    
    private nonisolated static func interpolatePitch(minTau: Int, difference: [Float], halfSize: Int, sampleRate: Double) -> Double {
        guard minTau > 0 && minTau < halfSize - 1 else { return 0.0 }
        let s0 = Double(difference[minTau - 1])
        let s1 = Double(difference[minTau])
        let s2 = Double(difference[minTau + 1])
        
        let denominator = 2.0 * (2.0 * s1 - s2 - s0)
        let betterTau = abs(denominator) > 1e-6 ? Double(minTau) + (s2 - s0) / denominator : Double(minTau)
        return sampleRate / betterTau
    }
    
    private nonisolated static func frequencyToNoteName(_ frequency: Double, minFreq: Double, maxFreq: Double) -> String {
        guard frequency >= minFreq && frequency <= maxFreq else { return "REST" }
        let noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let midiNumber = Int(round(69.0 + 12.0 * log2(frequency / 440.0)))
        let noteIndex = (midiNumber % 12 + 12) % 12
        let octave = (midiNumber / 12) - 1
        return "\(noteNames[noteIndex])\(octave)"
    }
    
    private nonisolated static func saveOutputToFile(_ lines: [String]) -> Bool {
        guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        let outputFileURL = docs.appendingPathComponent("melodia_resultado.txt")
        print("El archivo TXT está en: \n\(outputFileURL.path)")
        try? lines.joined(separator: "\n").write(to: outputFileURL, atomically: true, encoding: .utf8)
        return true
    }
}
