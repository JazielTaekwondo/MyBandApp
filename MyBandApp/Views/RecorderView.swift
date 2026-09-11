import SwiftUI

struct RecorderView: View {
    @StateObject private var recorder = AudioRecorder()
    // Arreglo de escalas fijas para la onda
    let escalas: [CGFloat] = [0.262, 0.524, 1.048, 0.524, 0.262]
    // Paleta de colores para la animación de la grabación
    let coloresGrabacion: [Color] = [.purple, .blue, .cyan, .blue, .purple]
    
    // Desplazamiento de índice para rotar la onda y el color
    @State private var shiftIndex: Int = 0
    // Temporizador para hacer avanzar la animación
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 30) {
            HStack(spacing: 8) {
                ForEach(escalas.indices, id: \.self) { index in
                    let currentScaleIndex = (index + shiftIndex) % escalas.count //Indice para cambiar escala y color del rectangulo
                    
                    RoundedRectangle(cornerRadius: 10)
                        // Color dinámico según el estado de grabación
                        .fill(recorder.isRecording ? coloresGrabacion[currentScaleIndex] : Color.gray)
                        .frame(width: 25, height: 25)
                        .scaleEffect(
                            x: 1.0,
                            y: recorder.isRecording ? 1.0 + escalas[currentScaleIndex] : 1.0
                        )
                        // Transición suave tanto de escala como de color
                        .animation(.easeInOut(duration: 0.25), value: shiftIndex)
                }
            }
            .frame(height: 60)
            
            Text(recorder.isRecording ? "Grabando..." : "Listo para grabar")
                .font(.headline)
                .foregroundColor(recorder.isRecording ? .green : .primary)
            
            Button(action: {
                recorder.toggleRecording()
            }) {
                ZStack {
                    Circle()
                        .fill(recorder.isRecording ? Color.green : Color.red)
                        .frame(width: 100, height: 100)
                        .shadow(radius: 5)
                    
                    Image(systemName: recorder.isRecording ? "stop.fill" : "mic.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .onChange(of: recorder.isRecording) { _, isRecording in
            if isRecording {
                startWaveAnimation()
            } else {
                stopWaveAnimation()
            }
        }
    }

    private func startWaveAnimation() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { _ in
            shiftIndex = (shiftIndex + 1) % escalas.count
        }
    }

    private func stopWaveAnimation() {
        timer?.invalidate()
        timer = nil
        
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            shiftIndex = 0
        }
    }
}

#Preview {
    RecorderView()
}
