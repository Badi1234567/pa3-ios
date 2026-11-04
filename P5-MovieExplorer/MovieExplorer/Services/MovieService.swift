import Foundation

protocol MovieServicing {
    func fetchMovies(simularError: Bool) async throws -> [Movie]
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

/// Consume la API REST pública de TVMaze (no requiere API key)
final class TVMazeMovieService: MovieServicing {
    private let session: URLSession
    private let url = URL(string: "https://api.tvmaze.com/shows?page=0")!

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchMovies(simularError: Bool = false) async throws -> [Movie] {
        if simularError {
            // Para la evidencia del estado de error
            throw URLError(.notConnectedToInternet)
        }

        let (data, response) = try await session.data(from: url)

        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw MovieServiceError.respuestaInvalida(http.statusCode)
        }

        do {
            let shows = try JSONDecoder().decode([ShowDTO].self, from: data)
            return shows.map(Movie.init(dto:))
        } catch {
            throw MovieServiceError.decodificacion
        }
    }
}
