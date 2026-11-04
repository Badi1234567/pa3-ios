import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PosterImage(url: movie.posterURL)
                    .frame(maxWidth: 260)
                    .frame(maxWidth: .infinity)

                Text(movie.titulo)
                    .font(.title2.bold())

                HStack(spacing: 8) {
                    Etiqueta(texto: movie.anio)
                    Etiqueta(texto: movie.genero)
                    Etiqueta(texto: movie.rating)
                }

                Label(movie.canal, systemImage: "tv")
                    .foregroundStyle(.secondary)

                Text(movie.descripcion)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle(movie.titulo)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct Etiqueta: View {
    let texto: String
    var body: some View {
        Text(texto)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(.thinMaterial, in: Capsule())
    }
}
