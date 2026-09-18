//
//  StartMenuView.swift
//  MyBandApp
//
//  Created by Victor Flores on 09/09/26.
//

import SwiftUI

// MARK: - Menú Principal de Inicio
struct StartMenuView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    // MARK: - Encabezado / Perfil del Usuario
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.cyan, .blue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 110, height: 110)
                                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)

                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 55, height: 55)
                                .foregroundStyle(.white)
                        } // Fin de ZStack Foto Perfil

                        VStack(spacing: 2) {
                            Text("WELCOME!")
                                .font(.caption.weight(.bold))
                                .tracking(2)
                                .foregroundStyle(.secondary)

                            Text("Victor Flores")
                                .font(.largeTitle.bold())
                                .foregroundStyle(.primary)
                        } // Fin de VStack Nombres
                    } // Fin de VStack Encabezado Perfil
                    .padding(.top, 10)

                    // MARK: - Opciones Principales del Menú
                    VStack(spacing: 16) {

                        // 1. Botón: Nuevo Proyecto (Azul GarageBand / Gradiente)
                        NavigationLink(destination: NewProjectMenuView()) {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 48, height: 48)

                                    Image(systemName: "plus")
                                        .font(.title2.bold())
                                        .foregroundStyle(.white)
                                } // Fin de ZStack Ícono Nuevo Proyecto

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("NEW PROJECT")
                                        .font(.headline.bold())
                                        .foregroundStyle(.white)

                                    Text("Start creating a new audio composition.")
                                        .font(.subheadline)
                                        .foregroundStyle(.white.opacity(0.9))
                                        .multilineTextAlignment(.leading)
                                } // Fin de VStack Textos

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white.opacity(0.6))
                            } // Fin de HStack Tarjeta NEW PROJECT
                            .padding(16)
                            .background(
                                LinearGradient(
                                    colors: [Color.cyan, Color.blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        } // Fin de NavigationLink NEW PROJECT

                        // 2. Botón: Mis Proyectos (Verde Esmeralda)
                        NavigationLink(destination: Text("My Projects View")) {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 48, height: 48)

                                    Image(systemName: "folder.fill")
                                        .font(.title2.bold())
                                        .foregroundStyle(.white)
                                } // Fin de ZStack Ícono Mis Proyectos

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("MY PROJECTS")
                                        .font(.headline.bold())
                                        .foregroundStyle(.white)

                                    Text("Access and edit your saved tracks.")
                                        .font(.subheadline)
                                        .foregroundStyle(.white.opacity(0.9))
                                        .multilineTextAlignment(.leading)
                                } // Fin de VStack Textos

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white.opacity(0.6))
                            } // Fin de HStack Tarjeta MY PROJECTS
                            .padding(16)
                            .background(
                                LinearGradient(
                                    colors: [Color.emeraldAccent, Color.teal],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .teal.opacity(0.3), radius: 8, x: 0, y: 4)
                        } // Fin de NavigationLink MY PROJECTS

                        // 3. Botón: Mis Bandas / Social (Purpura / Violeta)
                        NavigationLink(destination: Text("My Bands View")) {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 48, height: 48)

                                    Image(systemName: "guitars.fill")
                                        .font(.title2.bold())
                                        .foregroundStyle(.white)
                                } // Fin de ZStack Ícono Mis Bandas

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("MY BANDS")
                                        .font(.headline.bold())
                                        .foregroundStyle(.white)

                                    Text("Collaborate and practice with your group.")
                                        .font(.subheadline)
                                        .foregroundStyle(.white.opacity(0.9))
                                        .multilineTextAlignment(.leading)
                                } // Fin de VStack Textos

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white.opacity(0.6))
                            } // Fin de HStack Tarjeta MY BANDS
                            .padding(16)
                            .background(
                                LinearGradient(
                                    colors: [Color.purple, Color.indigo],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
                        } // Fin de NavigationLink MY BANDS

                    } // Fin de VStack Tarjetas de Menú
                    .padding(.horizontal)

                } // Fin de VStack Contenido Principal
                .padding(.bottom, 20)
            } // Fin de ScrollView
            .navigationBarTitleDisplayMode(.inline)
        } // Fin de NavigationStack
    } // Fin de body
} // Fin de struct StartMenuView

// extensión auxiliar de color para consistencia si no está definido previamente
private extension Color {
    static let emeraldAccent = Color(red: 0.1, green: 0.75, blue: 0.5)
}

#Preview {
    StartMenuView()
}
