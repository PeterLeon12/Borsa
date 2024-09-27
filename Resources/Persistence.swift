import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // Preview setup for SwiftUI previews with in-memory persistence
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let newLandmark = Landmark(context: viewContext)
            newLandmark.name = "Landmark \(i)"
            newLandmark.category = "Category \(i)"
            newLandmark.city = "City \(i)"
            newLandmark.state = "State \(i)"
            newLandmark.latitude = Double(i)
            newLandmark.longitude = Double(i)
            newLandmark.landmarkDescription = "Description \(i)"
            newLandmark.isFavorite = i % 2 == 0 // Mark every second as favorite
            newLandmark.isFeatured = i % 3 == 0 // Mark every third as featured
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    // Initialize the persistence controller
    init(inMemory: Bool = false) {
        // Use 'LandmarksModel 3' as the Core Data model name
        container = NSPersistentContainer(name: "LandmarksModel")

        if inMemory {
            // Set up in-memory store for testing or previewing
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        // Load persistent stores and handle any errors
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        // Automatically merges changes from the parent context
        container.viewContext.automaticallyMergesChangesFromParent = true

        // Add a check if the database is empty, populate with initial data
        seedIfEmpty()
    }

    // Helper function to seed the database if it's empty
    private func seedIfEmpty() {
        let viewContext = container.viewContext

        let fetchRequest: NSFetchRequest<Landmark> = Landmark.fetchRequest()
        fetchRequest.includesSubentities = false

        do {
            let count = try viewContext.count(for: fetchRequest)

            if count == 0 {
                // Add initial landmarks when the database is empty
                for i in 0..<10 {
                    let newLandmark = Landmark(context: viewContext)
                    newLandmark.name = "Initial Landmark \(i)"
                    newLandmark.category = "Category \(i)"
                    newLandmark.city = "City \(i)"
                    newLandmark.state = "State \(i)"
                    newLandmark.latitude = Double(i)
                    newLandmark.longitude = Double(i)
                    newLandmark.landmarkDescription = "Description \(i)"
                    newLandmark.isFavorite = i % 2 == 0 // Mark every second as favorite
                    newLandmark.isFeatured = i % 3 == 0 // Mark every third as featured
                }

                try viewContext.save()
            }

        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
