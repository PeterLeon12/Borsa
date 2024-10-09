import Foundation
import CoreData
import SwiftUI

class LandmarkData: ObservableObject {
    @Published var landmarks: [Landmark] = []

    // Initialize with data from Core Data or fetch from elsewhere
    init() {
        loadLandmarks()
    }

    func loadLandmarks() {
        // Load the landmarks from Core Data
        // Example fetch request here (modify as needed)
        let fetchRequest: NSFetchRequest<Landmark> = Landmark.fetchRequest()
        
        do {
            let context = PersistenceController.shared.container.viewContext
            landmarks = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch landmarks: \(error.localizedDescription)")
        }
    }

    func updateLandmark(_ landmark: Landmark) {
        if let index = landmarks.firstIndex(where: { $0.id == landmark.id }) {
            landmarks[index] = landmark
        }
    }
}
