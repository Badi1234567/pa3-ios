import SwiftUI

/// Celda del listado.
struct EventRowView: View {
    let evento: Evento

    var body: some View {
        HStack(spacing: 12) {
            miniatura
            VStack(alignment: .leading, spacing: 4) {
                Text(evento.titulo)
                    .font(.headline)
                Text(evento.fecha.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if !evento.descripcion.isEmpty {
                    Text(evento.descripcion)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            Spacer()
            Circle()
                .fill(Color(hex: evento.colorHex))
                .frame(width: 16, height: 16)
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var miniatura: some View {
        if let data = evento.imagenData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 52, height: 52)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: evento.colorHex).opacity(0.25))
                .frame(width: 52, height: 52)
                .overlay(Image(systemName: "calendar").foregroundStyle(Color(hex: evento.colorHex)))
        }
    }
}
