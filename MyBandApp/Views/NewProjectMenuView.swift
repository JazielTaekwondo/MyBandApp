//
//  NewProjectMenuView.swift
//  MyBandApp
//
//  Created by Victor Flores on 09/09/26.
//

import SwiftUI

// MARK: - Vista Principal
struct NewProjectMenuView: View {
    @Bindable var audioSettings = settings
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                Text("Choose the type of track to get started!")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)

                ScrollView {
                    VStack(spacing: 16) {

                        // MARK: - 1. Ritmo
                        ConfiguringRhythmView(
                            audioSettings: audioSettings,
                            isInputFocused: $isInputFocused
                        )

                        // MARK: - 2. Melodía
                        NavigationLink(destination: RecorderView(audioSettings: audioSettings)) {
                            TrackOptionCardView(
                                title: "MELODY",
                                description: "Record your song's lead vocal or guitar solo.",
                                systemImageName: "waveform",
                                gradientColors: [.yellow, .orange],
                                shadowColor: .orange.opacity(0.3)
                            )
                        }
                        .buttonStyle(.plain)

                        // MARK: - 3. Armonía
                        NavigationLink(destination: RecorderView(audioSettings: audioSettings)) {
                            TrackOptionCardView(
                                title: "HARMONY",
                                description: "Record the chords for your song's accompaniment.",
                                systemImageName: "music.note",
                                gradientColors: [.red, .pink],
                                shadowColor: .red.opacity(0.3)
                            )
                        }
                        .buttonStyle(.plain)

                    } // Fin de VStack Lista de Tarjetas
                    .padding(.horizontal)
                } // Fin de ScrollView
            } // Fin de VStack Principal
            .navigationTitle("New Project")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isInputFocused = false
                    } // Fin de Button Done
                    .font(.body.bold())
                } // Fin de ToolbarItemGroup
            } // Fin de toolbar
        } // Fin de NavigationStack
    } // Fin de body
} // Fin de struct NewProjectMenuView

#Preview {
    NewProjectMenuView()
}
