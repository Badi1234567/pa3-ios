import Foundation

protocol MovieServicing {
    func fetchMovies(term: String, simularError: Bool) async throws -> [Movie]
}

enum MovieServiceError: LocalizedError {
    case respuestaInvalida(Int)
    case decodificacion

    var errorDescription: String? {
        switch self {
        case .respuestaInvalida(let code): return "El servidor respondió con el código \(code)."
        case .decodificacion: return "No se pudo leer la información recibida."
        }
    }
}

/// Consume la API pública de iTunes Search (no requiere API key)
final class ITunesMovieService: MovieServicing {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchMovies(term: String, simularError: Bool = false) async throws -> [Movie] {
        if simularError {
            // Para la evidencia del estado de error
            throw URLError(.notConnectedToInternet)
        }

        var components = URLComponents(string: "https://itunes.apple.com/search")!
        components.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "media", value: "movie"),
            URLQueryItem(name: "entity", value: "movie"),
            URLQueryItem(name: "limit", value: "100"),
            URLQueryItem(name: "country", value: "us")
        ]

        let (data, response) = try await session.data(from: components.url!)

        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw MovieServiceError.respuestaInvalida(http.statusCode)
        }

        do {
            let decoded = try JSONDecoder().decode(SearchResponseDTO.self, from: data)
            return decoded.results.compactMap(Movie.init(dto:))
        } catch {
            throw MovieServiceError.decodificacion
        }
    }
}
