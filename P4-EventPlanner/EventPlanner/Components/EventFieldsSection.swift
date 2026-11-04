import SwiftUI

/// Vista hija: no guarda datos propios, edita los del padre vía @Binding.
struct EventFieldsSection: View {
    @Binding var titulo: String
    @Binding var descripcion: String
    @Binding var fecha: Date
    @Binding var color: Color

    var body: some View {
        Section("Datos del evento") {
            TextField("Título", text: $titulo)
            TextField("Descripción", text: $descripcion, axis: .vertical)
                .lineLimit(3...6)
        }
        Section("Fecha y color") {
            DatePicker("Fecha del evento", selection: $fecha, displayedComponents: [.date, .hourAndMinute])
            ColorPicker("Color representativo", selection: $color, supportsOpacity: false)
        }
    }
}
