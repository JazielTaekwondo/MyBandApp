//
//  ConfiguringRhythmView.swift
//  MyBandApp
//
//  Created by Victor Flores on 14/09/26.
//
import SwiftUI

// MARK: - Vista de Configuración de Ritmo
struct ConfiguringRhythmView: View {
    @Bindable var audioSettings: AudioSettings
    var isInputFocused: FocusState<Bool>.Binding

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            // Icono circular a la izquierda (Idéntico a Melodía y Armonía)
            ZStack {
                Circle()
                    .fill(.white.opacity(0.25))
                    .frame(width: 48, height: 48)

                Image(systemName: "metronome")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
            } // Fin de ZStack Icono Metrónomo

            // Columna principal con textos y controles alineados verticalmente
            VStack(alignment: .leading, spacing: 14) {
                
                // Textos de título y descripción
                VStack(alignment: .leading, spacing: 4) {
                    Text("RHYTHM")
                        .font(.headline.bold())
                        .foregroundStyle(.white)

                    Text("Set the tempo and time signature for your track.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.leading)
                } // Fin de VStack Textos

                // Controles de Compás y BPM (Alineados a la izquierda justo debajo del texto)
                HStack(spacing: 16) {
                    
                    // Sección Compás (Time Signature)
                    HStack(spacing: 8) {
                        Text("Time Sig.")
                            .font(.caption.bold())
                            .foregroundStyle(.white.opacity(0.85))

                        VStack(spacing: -2) {
                            TextField("4", text: $audioSettings.numerador)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .focused(isInputFocused)
                                .font(.headline.bold())
                                .foregroundStyle(.white)
                                .frame(width: 28, height: 22)
                                .background(Color.white.opacity(0.2), in: RoundedRectangle(cornerRadius: 4))
                                .onChange(of: audioSettings.numerador) { _, newValue in
                                    audioSettings.numerador = newValue.filter { $0.isNumber }
                                } // Fin de onChange numerador

                            Rectangle()
                                .fill(.white.opacity(0.5))
                                .frame(width: 24, height: 1.5)
                                .padding(.vertical, 1)

                            TextField("4", text: $audioSettings.denominador)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .focused(isInputFocused)
                                .font(.headline.bold())
                                .foregroundStyle(.white)
                                .frame(width: 28, height: 22)
                                .background(Color.white.opacity(0.2), in: RoundedRectangle(cornerRadius: 4))
                                .onChange(of: audioSettings.denominador) { _, newValue in
                                    audioSettings.denominador = newValue.filter { $0.isNumber }
                                } // Fin de onChange denominador
                        } // Fin de VStack Fracción Compás
                    } // Fin de HStack Compás

                    Divider()
                        .frame(height: 28)
                        .background(.white.opacity(0.35))

                    // Sección Tempo (BPM)
                    HStack(spacing: 6) {
                        TextField("100", text: $audioSettings.bpm)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .focused(isInputFocused)
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                            .frame(width: 52, height: 32)
                            .background(Color.white.opacity(0.2), in: RoundedRectangle(cornerRadius: 6))
                            .onChange(of: audioSettings.bpm) { _, newValue in
                                audioSettings.bpm = newValue.filter { $0.isNumber }
                            } // Fin de onChange BPM

                        Text("BPM")
                            .font(.caption.bold())
                            .foregroundStyle(.white.opacity(0.9))
                    } // Fin de HStack BPM
                } // Fin de HStack Controles
            } // Fin de VStack Columna Central

            Spacer(minLength: 0)
            
        } // Fin de HStack Tarjeta Principal
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color.cyan, Color.blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
    } // Fin de body
} // Fin de struct ConfiguringRhythmView
