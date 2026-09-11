//
//  ContentView.swift
//  MyBand
//
//  Created by Flores Colín Victor Jaziel on 17/08/26.
//

import SwiftUI

struct ContentView2: View {
    @State private var scale: CGFloat = 1.0
    @State private var animation: Bool = false
    @State private var startAnimation: Bool = false
    @State private var showFinalWhiteScreen: Bool = false
    
    let sinusoidal_scales: [CGFloat] = [1.0, 1.38, 1.7, 1.92, 2.0, 1.92, 1.7, 1.38]
    let sinusoidal_scales_black: [CGFloat] = [1.0,1.0,1.0,1.0,  1.0,1.0,1.0,1.7, 1.7,1.0,1.0,1.0, 1.0,1.0,1.0,2.0,  2.0,1.0,1.0,1.7, 1.7,1.0,1.0,1.5, 1.5,1.0,1.0,1.0,  1.0,1.0,1.0,1.0]
    let black_keys: [Bool] = [
        false, false, false, true,  true, false, false, true,
        true,  false, false, false, false, false, false, true,
        true,  false, false, true,  true, false, false, true,
        true,  false, false, false, false, false, false, true
    ]

    var body: some View {
        ZStack {
            // Se muestra RecorderView cuando finaliza toda la secuencia
            if showFinalWhiteScreen {
                StartMenuView()
                    .transition(.opacity)
            } else {
                // Secuencia de animación de bienvenida (Splash)
                ZStack {
                    VStack { // Teclas blancas
                        Spacer()
                        HStack(spacing: 0) {
                            ForEach(0..<8, id: \.self) { index in
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 100 * scale * sinusoidal_scales[index])
                                    .border(Color.black, width: 2)
                            }
                        }
                    }
                    
                    VStack { // Teclas negras
                        Spacer()
                        HStack(spacing: 0) {
                            ForEach(0..<32, id: \.self) { index in
                                Rectangle()
                                    .fill(black_keys[index] ? Color.black : Color.clear)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 70 * scale * sinusoidal_scales_black[index])
                            }
                        }
                    }
                    
                    // Pantalla blanca intermedia con el logo
                    if animation && startAnimation {
                        ZStack {
                            Color.white
                                .ignoresSafeArea()
                            
                            VStack {
                                Text("MyBand")
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(.black)
                                
                                Image("LogoV1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 350, height: 350)
                            }
                            .padding()
                        }
                        .transition(.opacity)
                    }
                }
                .ignoresSafeArea()
                .transition(.opacity)
            }
        }
        .task {
            // 1. Espera inicial
            try? await Task.sleep(for: .seconds(2))
            
            withAnimation {
                startAnimation = true
            }
            
            // 2. Animación de escala
            withAnimation(.linear(duration: 0.8)) {
                scale = 10.0
            }
            
            // 3. Espera tras la animación del teclado
            try? await Task.sleep(for: .seconds(0.8 + 0.5))
            
            // 4. Muestra la pantalla blanca con el logo
            withAnimation {
                animation = true
            }
            
            // 5. Mantiene el logo visible durante 1.5 s
            try? await Task.sleep(for: .seconds(1.5))
            
            // 6. Transición a RecorderView
            withAnimation(.easeInOut(duration: 0.5)) {
                showFinalWhiteScreen = true
            }
        }
    }
}

#Preview {
    ContentView()
}
