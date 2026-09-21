//
//  FrecuencyView.swift
//  MyBandApp
//
//  Created by Victor Flores on 25/08/26.
//

import SwiftUI

struct FrecuencyView: View {

    @State private var processor: FrecuencyURL
    @State private var rotation: Double = 0
    @State private var isSpinning: Bool = false

    /// - Parameter audioURL: URL opcional de la grabación a procesar.
    init(audioURL: URL? = nil) {
        _processor = State(initialValue: FrecuencyURL(audioURL: audioURL))
    }

    var body: some View {
        ZStack {
            VStack(spacing: 28) {
                Spacer(minLength: 20)

                FrecuencyHeaderView(
                    state: processor.state,
                    rotation: rotation,
                    isSpinning: isSpinning
                )

                FrecuencyStatusCard(state: processor.state)
                    .padding(.horizontal, 4)

                Spacer()

                if case .failure = processor.state {
                    FrecuencyRetryButton {
                        Task { await processor.process() }
                    }
                }
            }
            .padding(.horizontal, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if case .idle = processor.state {
                await processor.process()
            }
        }
        .onChange(of: processor.state) { _, newState in
            updateSpinner(for: newState)
        }
        .onAppear {
            updateSpinner(for: processor.state)
        }
    }

    private func updateSpinner(for state: FrecuencyURL.ProcessingState) {
        switch state {
        case .processing:
            rotation = 0
            isSpinning = true
            withAnimation(.linear(duration: 1.1).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        case .idle, .success, .failure:
            isSpinning = false
            withAnimation(.easeInOut(duration: 0.3)) {
                rotation = 0
            }
        }
    }
}

#Preview {
    NavigationStack {
        FrecuencyView()
    }
}
