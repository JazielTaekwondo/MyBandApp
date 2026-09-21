//
//  FrecuencyStatusCard.swift
//  MyBandApp
//
//  Created by Victor Flores on 21/09/26.
//

import SwiftUI

struct FrecuencyStatusCard: View {
    let state: FrecuencyURL.ProcessingState

    var body: some View {
        let style = FrecuencyStyle(state: state)

        return HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.25))
                    .frame(width: 48, height: 48)

                if case .processing = state {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Image(systemName: style.stateIcon)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(style.stateTitle)
                    .font(.headline.bold())
                    .foregroundStyle(.white)

                Text(style.stateDescription)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(LinearGradient(colors: style.stateGradient, startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: style.stateShadowColor, radius: 8, x: 0, y: 4)
    }
}

struct FrecuencyRetryButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.clockwise")
                    .font(.headline.bold())
                Text("Reintentar")
                    .font(.headline.bold())
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(LinearGradient(colors: [.purple, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .padding(.bottom, 20)
    }
}
