import SwiftUI

/// Pantalla de listado de eventos.
struct EventListView: View {
    @State private var viewModel: EventListViewModel   // dueño del VM del listado
    @State private var mostrarCrear = false            // estado visual local

    init(viewModel: EventListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.eventos.isEmpty {
                    ContentUnavailableView("Sin eventos",
                                           systemImage: "calendar.badge.plus",
                                           description: Text("Toca + para crear tu primer evento."))
                } else {
                    List {
                        ForEach(viewModel.eventos) { evento in
                            NavigationLink {
                                EventFormView(viewModel: viewModel.makeFormViewModel(para: evento))
                            } label: {
                                EventRowView(evento: evento)
                            }
                        }
                        .onDelete(perform: viewModel.eliminar)
                    }
                }
            }
            .navigationTitle("Event Planner Pro")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        mostrarCrear = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                if !viewModel.eventos.isEmpty {
                    ToolbarItem(placement: .topBarLeading) { EditButton() }
                }
            }
            .sheet(isPresented: $mostrarCrear, onDismiss: viewModel.cargar) {
                NavigationStack {
                    EventFormView(viewModel: viewModel.makeFormViewModel())
                }
            }
            .onAppear(perform: viewModel.cargar)
        }
    }
}
