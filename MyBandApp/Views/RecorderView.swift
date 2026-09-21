import SwiftUI
import AudioToolbox

struct RecorderView: View {
    @StateObject private var recorder = AudioRecorder()
    
    @Bindable var audioSettings: AudioSettings
    
    let escalas: [CGFloat] = [0.262, 0.524, 1.048, 0.524, 0.262]
    let coloresGrabacion: [Color] = [.purple, .blue, .cyan, .blue, .purple]
    let coloresDegradaoGrabacion: [Color] = [.pink, .cyan, .mint, .cyan, .pink]
    
    @State private var shiftIndex: Int = 0
    @State private var timer: Timer?
    @State private var tickCount: Int = 0
    @State private var metronomeTickCount: Int = 0
    
    @State private var duration: String = "00:00"
    @State private var secondsElapsed: Int = 0
    @State private var isBeatActive: Bool = false

    // MARK: - Navegación automática al analizador
    @State private var goToAnalyzer: Bool = false
    @State private var wasRecording: Bool = false
    @State private var isLeavingView: Bool = false

    var body: some View {
        VStack(spacing: 30) {
            Text(recorder.isRecording ? "\(duration)" : "00:00")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            
            HStack(spacing: 8) {
                ForEach(escalas.indices, id: \.self) { index in
                    let currentScaleIndex = (index + shiftIndex) % escalas.count
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            recorder.isRecording
                            ? LinearGradient(colors: [coloresGrabacion[currentScaleIndex], coloresDegradaoGrabacion[currentScaleIndex]], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [.pink, .purple], startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: 25, height: 25)
                        .scaleEffect(
                            x: 1.0,
                            y: recorder.isRecording ? 1.0 + escalas[currentScaleIndex] : 1.0
                        )
                        .animation(.easeInOut(duration: 0.1), value: shiftIndex)
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
                    ZStack {
                        if recorder.isRecording {
                            Circle()
                                .stroke(Color.cyan.opacity(1.9), lineWidth: 12)
                                .scaleEffect(isBeatActive ? 1.0 : 1.0)
                                .opacity(isBeatActive ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.15), value: isBeatActive)
                        }
                    }
                    .frame(width: 110, height: 110)
                    
                    Circle()
                        .fill(
                            recorder.isRecording
                            ? LinearGradient(colors: [.green, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [.orange, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
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
                wasRecording = true
                startUnifiedTimer()
            } else {
                stopUnifiedTimer()
                // Solo navega si la grabación terminó estando en la vista
                // (no cuando se detiene por salir de la vista)
                if wasRecording && !isLeavingView {
                    wasRecording = false
                    goToAnalyzer = true
                }
            }
        }
        // Destino de navegación automática
        .navigationDestination(isPresented: $goToAnalyzer) {
            FrecuencyView()
        }
        .onDisappear {
            if recorder.isRecording {
                isLeavingView = true
                recorder.toggleRecording()
            }
            stopUnifiedTimer()
        }
    }

    private func startUnifiedTimer() {
        timer?.invalidate()
        tickCount = 0
        metronomeTickCount = 0
        secondsElapsed = 0
        duration = "00:00"
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            let bpmInt = Int(audioSettings.bpm) ?? 120
            let ticksPerBeat = max(1, Int(round((60.0 / Double(bpmInt)) / 0.1)))
            
            shiftIndex = (shiftIndex + 1) % escalas.count
            
            metronomeTickCount += 1
            if metronomeTickCount >= ticksPerBeat {
                metronomeTickCount = 0
                triggerMetronomeBeat()
            }
            
            tickCount += 1
            if tickCount >= 10 {
                tickCount = 0
                if secondsElapsed < 600 {
                    secondsElapsed += 1
                    let minutes = secondsElapsed / 60
                    let seconds = secondsElapsed % 60
                    duration = String(format: "%02d:%02d", minutes, seconds)
                } else {
                    recorder.toggleRecording()
                }
            }
        }
    }

    private func stopUnifiedTimer() {
        timer?.invalidate()
        timer = nil
        tickCount = 0
        metronomeTickCount = 0
        secondsElapsed = 0
        duration = "00:00"
        isBeatActive = false
        
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            shiftIndex = 0
        }
    }
    
    private func triggerMetronomeBeat() {
        AudioServicesPlaySystemSound(1104)
        
        isBeatActive = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            isBeatActive = false
        }
    }
}

#Preview {
    NavigationStack {
        RecorderView(audioSettings: AudioSettings())
    }
}
