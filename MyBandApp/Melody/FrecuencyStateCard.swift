//
//  FrecuencyStateCard.swift
//  MyBandApp
//
//  Created by Victor Flores on 21/09/26.
//

import SwiftUI

/// Tarjeta reutilizable para mostrar el estado del análisis.
/// Recibe título, mensaje, icono y paleta de colores como parámetros,
/// y opcionalmente muestra un aro girando en lugar del icono cuando
/// `isLoading` es `true`.
struct FrecuencyStateCard: View {

    struct Config {
        let title: String
        let message: String
        let icon: String?
        let gradient: [Color]
        let shadow: Color
        var isLoading: Bool = false
    }

    let config: Config

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            iconContainer

            VStack(alignment: .leading, spacing: 4) {
                Text(config.title)
                    .font(.headline.bold())
                    .foregroundStyle(.white)

                Text(config.message)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: config.gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: config.shadow, radius: 8, x: 0, y: 4)
    }

    // MARK: - Círculo con icono o spinner

    private var iconContainer: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.25))
                .frame(width: 48, height: 48)

            if config.isLoading {
                SpinningRing()
                    .frame(width: 26, height: 26)
            } else if let icon = config.icon {
                Image(systemName: icon)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
            }
        }
    }
}

/// Aro circular girando, usado como indicador de carga dentro de la tarjeta.
private struct SpinningRing: View {
    @State private var rotation: Double = 0

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.75)
            .stroke(
                Color.white,
                style: StrokeStyle(lineWidth: 3, lineCap: .round)
            )
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(
                    .linear(duration: 0.9).repeatForever(autoreverses: false)
                ) {
                    rotation = 360
                }
            }
    }
}
