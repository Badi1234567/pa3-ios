import SwiftUI

struct MovieGridView: View {
    @State private var viewModel = MovieListViewModel()

    // GridItem adaptive: la cantidad de columnas se ajusta al ancho de pantalla
    private let columnas = [GridItem(.adaptive(minimum: 110, maximum: 180), spacing: 12)]

    var body: some View {
        NavigationStack {
            contenido
                .navigationTitle("Movie Explorer")
                .searchable(text: $viewModel.textoBusqueda, prompt: "Buscar por título, género o director")
                .navigationDestination(for: Movie.self) { movie in
                    MovieDetailView(movie: movie)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button {
                                Task { await viewModel.cargar() }
                            } label: {
                                Label("Recargar", systemImage: "arrow.clockwise")
                            }
                            Button(role: .destructive) {
                                Task { await viewModel.cargar(simularError: true) }
                            } label: {
                                Label("Simular error de red", systemImage: "wifi.slash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
                .task {
                    if viewModel.estado == .inicial {
                        await viewModel.cargar()
                    }
                }
        }
    }

    @ViewBuilder
    private var contenido: some View {
        switch viewModel.estado {
        case .inicial, .cargando:
            LoadingStateView()
        case .error(let mensaje):
            ErrorStateView(mensaje: mensaje) {
                Task { await viewModel.cargar() }
            }
        case .cargado:
            if viewModel.peliculasFiltradas.isEmpty {
                EmptyStateView(busqueda: viewModel.textoBusqueda)
            } else {
                ScrollView {
                    Text("\(viewModel.peliculasFiltradas.count) películas")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    LazyVGrid(columns: columnas, spacing: 16) {
                        ForEach(viewModel.peliculasFiltradas) { movie in
                            NavigationLink(value: movie) {
                                MovieCardView(movie: movie)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .refreshable { await viewModel.cargar() }
            }
        }
    }
}
