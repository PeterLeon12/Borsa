import Foundation
import CoreData
import SwiftUI

class LandmarkData: ObservableObject {
    @Published var landmarks: [Landmark] = []

    // Initialize with data from Core Data
    init() {
        loadLandmarks()
    }

    func loadLandmarks() {
        // Fetch landmarks from Core Data and assign them to the @Published landmarks array
        let fetchRequest: NSFetchRequest<Landmark> = Landmark.fetchRequest()
        
        do {
            let context = PersistenceController.shared.container.viewContext
            landmarks = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch landmarks: \(error.localizedDescription)")
        }
    }

    func addLandmark(_ landmark: Landmark) {
        // Add new landmark to the array and Core Data
        landmarks.append(landmark)
        saveContext()
    }

    func updateLandmark(_ landmark: Landmark) {
        // Find the index of the landmark to update
        if let index = landmarks.firstIndex(where: { $0.id == landmark.id }) {
            landmarks[index] = landmark
            saveContext() // Save changes to Core Data
        }
    }

    func deleteLandmark(_ landmark: Landmark) {
        // Remove from the array and delete from Core Data
        if let index = landmarks.firstIndex(where: { $0.id == landmark.id }) {
            landmarks.remove(at: index)
            let context = PersistenceController.shared.container.viewContext
            context.delete(landmark) // Remove from Core Data
            saveContext()
        }
    }

    private func saveContext() {
        let context = PersistenceController.shared.container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error.localizedDescription)")
            }
        }
    }
}
