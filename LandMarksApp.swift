import SwiftUI

@main
struct LandmarksApp: App {
    // Create a persistence controller
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Inject the viewContext into the environment
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
