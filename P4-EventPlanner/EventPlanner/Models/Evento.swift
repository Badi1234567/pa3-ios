import Foundation
import SwiftData

/// Modelo persistido con SwiftData.
@Model
final class Evento {
    var titulo: String
    var descripcion: String
    var fecha: Date
    /// Color representativo guardado como hexadecimal (#RRGGBB)
    var colorHex: String
    /// Imagen asociada (se guarda fuera de la base para no inflarla)
    @Attribute(.externalStorage) var imagenData: Data?
    var creadoEn: Date

    init(titulo: String,
         descripcion: String,
         fecha: Date,
         colorHex: String,
         imagenData: Data? = nil) {
        self.titulo = titulo
        self.descripcion = descripcion
        self.fecha = fecha
        self.colorHex = colorHex
        self.imagenData = imagenData
        self.creadoEn = .now
    }
}
