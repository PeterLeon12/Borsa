import Foundation
import CoreData

class ModelData: ObservableObject {
    // Managed object context for Core Data
    private let viewContext = PersistenceController.shared.container.viewContext
    
    // Fetching landmarks and hikes from Core Data
    @Published var landmarks: [Landmark] = []
    @Published var hikes: [Hike] = []
    @Published var profile = Profile.default

    init() {
        loadLandmarks()
       // loadHikes()
    }

    // Fetch landmarks from Core Data
    private func loadLandmarks() {
        let fetchRequest: NSFetchRequest<Landmark> = Landmark.fetchRequest()
        do {
            landmarks = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching landmarks: \(error)")
        }
    }

    // Fetch hikes from Core Data (assuming you have Hike entity in Core Data)
   /* private func loadHikes() {
        let fetchRequest: NSFetchRequest<Hike> = Hike.fetchRequest()
        do {
            hikes = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching hikes: \(error)")
        }
    } */

    // Filter featured landmarks
    var features: [Landmark] {
        landmarks.filter { $0.isFeatured }
    }

    // Group landmarks by category
    var categories: [String: [Landmark]] {
        Dictionary(
            grouping: landmarks.compactMap { $0 },
            by: { $0.category ?? "Unknown" }
        )
    }
}
