//
//  TrackOptionCardView.swift
//  MyBandApp
//
//  Created by Victor Flores on 14/09/26.
//

import SwiftUI

// MARK: - Tarjeta Reutilizable de Opción de Pista
struct TrackOptionCardView: View {
    let title: String
    let description: String
    let systemImageName: String
    let gradientColors: [Color]
    let shadowColor: Color

    var body: some View {
        NavigationLink(destination: RecorderView(audioSettings: settings)) { 
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.25))
                        .frame(width: 48, height: 48)

                    Image(systemName: systemImageName)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                } // Fin de ZStack Ícono

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline.bold())
                        .foregroundStyle(.white)

                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.leading)
                } // Fin de VStack Textos

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundStyle(.white.opacity(0.6))
            } // Fin de HStack Principal
            .padding(16)
            .background(
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
        } // Fin de NavigationLink
    } // Fin de body
} // Fin de struct TrackOptionCardView
