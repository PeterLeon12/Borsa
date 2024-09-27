import SwiftUI

struct LandmarkList: View {
    @FetchRequest(
        entity: Landmark.entity(),
        sortDescriptors: [] // Optionally add sort descriptors here
    ) var landmarks: FetchedResults<Landmark>

    @State private var showFavoritesOnly = false
    @State private var showAddLandmarkView = false

    @Environment(\.managedObjectContext) private var viewContext

    var filteredLandmarks: [Landmark] {
        landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                if landmarks.isEmpty {
                    VStack {
                        Text("No landmarks available")
                            .foregroundColor(.gray)
                            .font(.headline)

                        // Button to add a landmark if none exist
                        Button(action: {
                            showAddLandmarkView.toggle()
                        }) {
                            Label("Add Landmark", systemImage: "plus.circle")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .sheet(isPresented: $showAddLandmarkView) {
                            AddLandmarkView()
                            // No need to pass viewContext, it's already in the environment
                        }
                    }
                } else {
                    List {
                        Toggle(isOn: $showFavoritesOnly) {
                            Text("Favorites only")
                        }

                        ForEach(filteredLandmarks) { landmark in
                            NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
                                LandmarkRow(landmark: landmark)
                            }
                        }
                    }
                    .navigationTitle("Landmarks")
                }
            }
        }
    }
}
#Preview {
    LandmarkList()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
