import SwiftUI
import SwiftData

@main
struct EventPlannerApp: App {
    // Contenedor de SwiftData: base de datos local (persiste al cerrar la app)
    let container: ModelContainer = {
        do {
            return try ModelContainer(for: Evento.self)
        } catch {
            fatalError("No se pudo crear el ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            EventListView(viewModel: EventListViewModel(context: container.mainContext))
        }
        .modelContainer(container)
    }
}
