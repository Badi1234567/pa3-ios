import Foundation
import SwiftData
import Observation

/// ViewModel del listado: lee y elimina eventos de SwiftData.
@Observable
final class EventListViewModel {
    private let context: ModelContext
    private(set) var eventos: [Evento] = []

    init(context: ModelContext) {
        self.context = context
        cargar()
    }

    func cargar() {
        let descriptor = FetchDescriptor<Evento>(sortBy: [SortDescriptor(\.fecha, order: .forward)])
        eventos = (try? context.fetch(descriptor)) ?? []
    }

    func eliminar(at offsets: IndexSet) {
        for index in offsets {
            context.delete(eventos[index])
        }
        try? context.save()
        cargar()
    }

    /// Crea el ViewModel del formulario (nuevo o edición)
    func makeFormViewModel(para evento: Evento? = nil) -> EventFormViewModel {
        EventFormViewModel(context: context, evento: evento)
    }
}
