import Foundation
import Observation

@MainActor
@Observable
final class MovieListViewModel {
    enum Estado: Equatable {
        case inicial
        case cargando
        case cargado
        case error(String)
    }

    private let service: MovieServicing
    private let termino = "star"

    private(set) var estado: Estado = .inicial
    private(set) var peliculas: [Movie] = []
    var textoBusqueda = ""

    /// Búsqueda local (no vuelve a llamar a la API)
    var peliculasFiltradas: [Movie] {
        let texto = textoBusqueda.trimmingCharacters(in: .whitespaces)
        guard !texto.isEmpty else { return peliculas }
        return peliculas.filter {
            $0.titulo.localizedCaseInsensitiveContains(texto) ||
            $0.genero.localizedCaseInsensitiveContains(texto) ||
            $0.director.localizedCaseInsensitiveContains(texto)
        }
    }

    init(service: MovieServicing = ITunesMovieService()) {
        self.service = service
    }

    func cargar(simularError: Bool = false) async {
        estado = .cargando
        do {
            // Pequeña pausa para que la pantalla de carga sea visible
            try await Task.sleep(for: .milliseconds(2500))
            peliculas = try await service.fetchMovies(term: termino, simularError: simularError)
            estado = .cargado
        } catch {
            peliculas = []
            estado = .error(error.localizedDescription)
        }
    }
}
