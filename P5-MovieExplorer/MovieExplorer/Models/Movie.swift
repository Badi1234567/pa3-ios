import Foundation

/// Respuesta JSON de la API de iTunes Search
struct SearchResponseDTO: Codable {
    let resultCount: Int
    let results: [MovieDTO]
}

/// DTO: refleja exactamente el JSON (campos opcionales para no romper el decode)
struct MovieDTO: Codable {
    let trackId: Int?
    let trackName: String?
    let artistName: String?
    let primaryGenreName: String?
    let releaseDate: String?
    let artworkUrl100: String?
    let longDescription: String?
    let contentAdvisoryRating: String?
}

/// Modelo que usa la UI
struct Movie: Identifiable, Hashable {
    let id: Int
    let titulo: String
    let director: String
    let genero: String
    let anio: String
    let posterURL: URL?
    let descripcion: String
    let clasificacion: String

    init?(dto: MovieDTO) {
        guard let id = dto.trackId, let titulo = dto.trackName else { return nil }
        self.id = id
        self.titulo = titulo
        self.director = dto.artistName ?? "Desconocido"
        self.genero = dto.primaryGenreName ?? "Sin género"
        self.anio = String((dto.releaseDate ?? "").prefix(4))
        // iTunes entrega 100x100; pedimos una versión más grande
        self.posterURL = dto.artworkUrl100
            .map { $0.replacingOccurrences(of: "100x100bb", with: "400x600bb") }
            .flatMap(URL.init(string:))
        self.descripcion = dto.longDescription ?? "Sin descripción disponible."
        self.clasificacion = dto.contentAdvisoryRating ?? "NR"
    }
}
