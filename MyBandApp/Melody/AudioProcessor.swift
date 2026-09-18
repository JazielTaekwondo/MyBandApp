import Foundation

struct AudioProcessor {
    // Configuración general para cada banda con umbral YIN independiente
    struct BandConfig {
        let name: String
        let lowCutoff: Double
        let highCutoff: Double
        let windowSize: Int
        let rmsThreshold: Float
        let yinThreshold: Float // Umbral personalizado de YIN
    }
    
    // Cálculo de Valor Eficaz (RMS)
    static func calculateRMS(data: [Float]) -> Float {
        guard !data.isEmpty else { return 0.0 }
        var sumSquares: Float = 0.0
        for sample in data {
            sumSquares += sample * sample
        }
        return sqrt(sumSquares / Float(data.count))
    }
    
    // Aplica la verificación de RMS con umbral específico
    static func passesRMSFilter(data: [Float], threshold: Float) -> Bool {
        return calculateRMS(data: data) >= threshold
    }
    
    // Filtro Paso Banda Biquad IIR de 2.º orden
    static func bandPassFilter(pcmData: [Float], sampleRate: Double, lowCutoff: Double, highCutoff: Double) -> [Float] {
        guard !pcmData.isEmpty else { return [] }
        
        let centerFreq = sqrt(lowCutoff * highCutoff)
        let bandwidth = highCutoff - lowCutoff
        let q = centerFreq / bandwidth
        
        let omega = 2.0 * .pi * centerFreq / sampleRate
        let alpha = sin(omega) / (2.0 * q)
        
        let b0 = Float(alpha)
        let b1 = Float(0.0)
        let b2 = Float(-alpha)
        let a0 = Float(1.0 + alpha)
        let a1 = Float(-2.0 * cos(omega))
        let a2 = Float(1.0 - alpha)
        
        return applyBiquad(data: pcmData, b0: b0/a0, b1: b1/a0, b2: b2/a0, a1: a1/a0, a2: a2/a0)
    }
    
    // Ejecución de la ecuación en diferencias Biquad Direct Form I
    private static func applyBiquad(data: [Float], b0: Float, b1: Float, b2: Float, a1: Float, a2: Float) -> [Float] {
        var output = [Float](repeating: 0.0, count: data.count)
        var x1: Float = 0.0, x2: Float = 0.0
        var y1: Float = 0.0, y2: Float = 0.0
        
        for i in 0..<data.count {
            let x0 = data[i]
            let y0 = b0 * x0 + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2
            output[i] = y0
            x2 = x1; x1 = x0
            y2 = y1; y1 = y0
        }
        return output
    }
}
