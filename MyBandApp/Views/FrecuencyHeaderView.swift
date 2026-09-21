//
//  FrecuencyHeaderView.swift
//  MyBandApp
//
//  Created by Victor Flores on 21/09/26.
//

import SwiftUI

struct FrecuencyHeaderView: View {
    let state: FrecuencyURL.ProcessingState
    let rotation: Double
    let isSpinning: Bool

    var body: some View {
        let style = FrecuencyStyle(state: state)

        return VStack(spacing: 18) {
            ZStack {
                Circle()
                    .trim(from: 0, to: 0.28)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.purple.opacity(0.0), .purple.opacity(0.9), .cyan]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 134, height: 134)
                    .rotationEffect(.degrees(rotation))
                    .opacity(isSpinning ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: isSpinning)

                Circle()
                    .fill(LinearGradient(colors: style.headerGradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 110, height: 110)
                    .shadow(color: style.headerShadowColor, radius: 10, x: 0, y: 5)

                if case .processing = state {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2.0)
                } else {
                    Image(systemName: style.headerIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 140, height: 140)

            VStack(spacing: 2) {
                Text(style.headerCaption)
                    .font(.caption.weight(.bold))
                    .tracking(2)
                    .foregroundStyle(.secondary)

                Text(style.headerTitle)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
