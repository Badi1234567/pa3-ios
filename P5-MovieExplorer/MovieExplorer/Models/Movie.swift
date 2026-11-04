import Foundation

/// DTO: refleja el JSON de TVMaze (https://api.tvmaze.com/shows)
struct ShowDTO: Codable {
    let id: Int
    let name: String
    let genres: [String]?
    let premiered: String?
    let summary: String?
    let image: ImageDTO?
    let network: CanalDTO?
    let webChannel: CanalDTO?
    let rating: RatingDTO?

    struct ImageDTO: Codable {
        let medium: String?
        let original: String?
    }
    struct CanalDTO: Codable {
        let name: String?
    }
    struct RatingDTO: Codable {
        let average: Double?
    }
}

/// Modelo que usa la UI
struct Movie: Identifiable, Hashable {
    let id: Int
    let titulo: String
    let canal: String
    let genero: String
    let anio: String
    let posterURL: URL?
    let descripcion: String
    let rating: String

    init(dto: ShowDTO) {
        self.id = dto.id
        self.titulo = dto.name
        self.canal = dto.network?.name ?? dto.webChannel?.name ?? "Desconocido"
        self.genero = dto.genres?.first ?? "Sin género"
        self.anio = String((dto.premiered ?? "").prefix(4))
        self.posterURL = (dto.image?.medium ?? dto.image?.original).flatMap(URL.init(string:))
        // El resumen viene con etiquetas HTML (<p>, <b>): se limpian
        let texto = (dto.summary ?? "Sin descripción disponible.")
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        self.descripcion = texto
        self.rating = dto.rating?.average.map { String(format: "★ %.1f", $0) } ?? "★ –"
    }
}
