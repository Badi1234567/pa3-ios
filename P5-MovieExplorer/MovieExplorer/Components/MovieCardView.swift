import SwiftUI

struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            PosterImage(url: movie.posterURL)
            Text(movie.titulo)
                .font(.caption.bold())
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            Text("\(movie.anio) · \(movie.genero)")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }
}

/// Póster con carga asíncrona y placeholder
struct PosterImage: View {
    let url: URL?

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFill()
            case .failure:
                placeholder(icono: "film")
            default:
                ZStack {
                    placeholder(icono: nil)
                    ProgressView()
                }
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 2, y: 1)
    }

    private func placeholder(icono: String?) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.2))
            .overlay {
                if let icono {
                    Image(systemName: icono).font(.largeTitle).foregroundStyle(.secondary)
                }
            }
    }
}
