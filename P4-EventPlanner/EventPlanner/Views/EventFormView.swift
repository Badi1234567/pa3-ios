import SwiftUI
import PhotosUI

/// Pantalla de creación / edición de un evento.
struct EventFormView: View {
    @State private var viewModel: EventFormViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var confirmarEliminar = false

    init(viewModel: EventFormViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Form {
            // Vista hija que se comunica con el padre mediante @Binding
            EventFieldsSection(titulo: $viewModel.titulo,
                               descripcion: $viewModel.descripcion,
                               fecha: $viewModel.fecha,
                               color: $viewModel.color)

            Section("Imagen asociada") {
                if let data = viewModel.imagenData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                PhotosPicker(selection: $viewModel.fotoSeleccionada, matching: .images) {
                    Label(viewModel.imagenData == nil ? "Elegir imagen" : "Cambiar imagen",
                          systemImage: "photo.on.rectangle")
                }
                if viewModel.imagenData != nil {
                    Button("Quitar imagen", role: .destructive) { viewModel.imagenData = nil }
                }
            }

            if viewModel.esEdicion {
                Section {
                    Button("Eliminar evento", role: .destructive) { confirmarEliminar = true }
                }
            }
        }
        .navigationTitle(viewModel.esEdicion ? "Editar evento" : "Nuevo evento")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.fotoSeleccionada) {
            Task { await viewModel.cargarImagen() }
        }
        .toolbar {
            if !viewModel.esEdicion {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Guardar") {
                    viewModel.guardar()
                    dismiss()
                }
                .disabled(!viewModel.puedeGuardar)
            }
        }
        .confirmationDialog("¿Eliminar este evento?", isPresented: $confirmarEliminar, titleVisibility: .visible) {
            Button("Eliminar", role: .destructive) {
                viewModel.eliminar()
                dismiss()
            }
        }
    }
}
