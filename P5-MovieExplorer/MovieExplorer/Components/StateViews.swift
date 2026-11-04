import SwiftUI

/// Pantalla de carga
struct LoadingStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)
            Text("Cargando películas…")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Manejo de errores con opción de reintentar
struct ErrorStateView: View {
    let mensaje: String
    let reintentar: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label("No se pudo cargar", systemImage: "wifi.exclamationmark")
        } description: {
            Text(mensaje)
        } actions: {
            Button("Reintentar", action: reintentar)
                .buttonStyle(.borderedProminent)
        }
    }
}

/// Estado vacío (sin resultados de la API o de la búsqueda local)
struct EmptyStateView: View {
    let busqueda: String

    var body: some View {
        if busqueda.isEmpty {
            ContentUnavailableView("Sin películas",
                                   systemImage: "film.stack",
                                   description: Text("La API no devolvió resultados."))
        } else {
            ContentUnavailableView.search(text: busqueda)
        }
    }
}
