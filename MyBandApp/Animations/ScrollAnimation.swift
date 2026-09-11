//
//  ScrollAnimation.swift
//  MyBandApp
//
//  Created by Victor Flores on 04/09/26.
//

import SwiftUI

struct TaskProgressView: View {
    @State private var value: CGFloat = 0.0
    @State private var isAnimating = false
    
    let duration: Double = 2.0
    let targetValue: CGFloat = 300.0

    var body: some View {
        VStack(spacing: 20) {
            Text("Valor: \(value, specifier: "%.1f")")
                .font(.title)
            
            Button("Iniciar Animación") {
                startAnimation()
            }
            .disabled(isAnimating)
        }
    }

    private func startAnimation() {
        isAnimating = true
        value = 0.0
        
        Task {
            let clock = ContinuousClock()
            let start = clock.now
            let durationSeconds = Duration.seconds(duration)
            
            while !Task.isCancelled {
                let elapsed = start.duration(to: clock.now)
                
                if elapsed >= durationSeconds {
                    value = targetValue
                    isAnimating = false
                    break
                }
                
                // Calcular progreso relativo
                let progress = CGFloat(elapsed / durationSeconds)
                value = progress * targetValue
                
                // Esperar aproximadamente 16ms (~60 FPS)
                try? await Task.sleep(for: .milliseconds(16))
            }
        }
    }
}
