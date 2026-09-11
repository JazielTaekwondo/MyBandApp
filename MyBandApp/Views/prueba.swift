import SwiftUI

struct ContentView: View {
    @State private var numeroTexto: String = "10"
    @FocusState private var estaEnFoco: Bool

    var body: some View {
        VStack(spacing: 16) {
            
            // Un TextField formateado para lucir exactamente como un Text grande
            TextField("", text: $numeroTexto)
                .font(.system(size: 80, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(.blue)
                .keyboardType(.numberPad)
                .focused($estaEnFoco)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(estaEnFoco ? Color.blue.opacity(0.15) : Color.blue.opacity(0.08))
                )
                .fixedSize() // Mantiene el tamaño ajustado al contenido
                .onChange(of: numeroTexto) { _, nuevoValor in
                    // Filtra solo números
                    numeroTexto = nuevoValor.filter { $0.isNumber }
                }

            Text(estaEnFoco ? "Toca 'Listo' para guardar" : "Toca el número para editar")
                .font(.caption)
                .foregroundStyle(.gray)
        }
        // Agrega la barra sobre el teclado numérico para poder ocultarlo
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Listo") {
                    estaEnFoco = false
                }
                .bold()
            }
        }
    }
}

#Preview {
    ContentView()
}
