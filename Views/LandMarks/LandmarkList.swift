import SwiftUI

struct LandmarkList: View {
    @EnvironmentObject var landmarkData: LandmarkData // Access the shared data

    @State private var showAddLandmarkView = false

    // Filter for favorite landmarks only
    var favoriteLandmarks: [Landmark] {
        landmarkData.landmarks.filter { $0.isFavorite }
    }

    var body: some View {
        NavigationView {
            VStack {
                if favoriteLandmarks.isEmpty {
                    VStack {
                        Text("No favorite landmarks available")
                            .foregroundColor(.gray)
                            .font(.headline)
                    }
                } else {
                    List {
                        ForEach(favoriteLandmarks, id: \.self) { landmark in
                            NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
                                LandmarkRow(landmark: landmark)
                            }
                        }
                    }
                    .navigationTitle("Favorite Landmarks")
                }
            }
        }
    }
}
#Preview {
    let context = PersistenceController.preview.container.viewContext
    let landmarkData = LandmarkData()
    return LandmarkList()
        .environment(\.managedObjectContext, context)
        .environmentObject(landmarkData) // Pass shared data model
}

