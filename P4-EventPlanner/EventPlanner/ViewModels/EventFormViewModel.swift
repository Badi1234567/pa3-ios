import SwiftUI
import SwiftData
import PhotosUI
import Observation

/// ViewModel del formulario: maneja creación y edición.
@Observable
final class EventFormViewModel {
    private let context: ModelContext
    private let eventoExistente: Evento?

    // Estado editable del formulario
    var titulo: String
    var descripcion: String
    var fecha: Date
    var color: Color
    var imagenData: Data?
    var fotoSeleccionada: PhotosPickerItem?

    var esEdicion: Bool { eventoExistente != nil }
    var puedeGuardar: Bool { !titulo.trimmingCharacters(in: .whitespaces).isEmpty }

    init(context: ModelContext, evento: Evento? = nil) {
        self.context = context
        self.eventoExistente = evento
        self.titulo = evento?.titulo ?? ""
        self.descripcion = evento?.descripcion ?? ""
        self.fecha = evento?.fecha ?? .now
        self.color = Color(hex: evento?.colorHex ?? "#007AFF")
        self.imagenData = evento?.imagenData
    }

    /// Carga la imagen elegida en el PhotosPicker
    @MainActor
    func cargarImagen() async {
        guard let item = fotoSeleccionada else { return }
        if let data = try? await item.loadTransferable(type: Data.self) {
            imagenData = data
        }
    }

    func guardar() {
        let tituloLimpio = titulo.trimmingCharacters(in: .whitespaces)
        if let evento = eventoExistente {
            evento.titulo = tituloLimpio
            evento.descripcion = descripcion
            evento.fecha = fecha
            evento.colorHex = color.toHex()
            evento.imagenData = imagenData
        } else {
            let nuevo = Evento(titulo: tituloLimpio,
                               descripcion: descripcion,
                               fecha: fecha,
                               colorHex: color.toHex(),
                               imagenData: imagenData)
            context.insert(nuevo)
        }
        try? context.save()
    }

    func eliminar() {
        guard let evento = eventoExistente else { return }
        context.delete(evento)
        try? context.save()
    }
}
