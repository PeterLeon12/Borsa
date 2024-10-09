import SwiftUI

struct ContentView: View {
    @StateObject var landmarkData = LandmarkData() // Use as shared data

    var body: some View {
        TabView {
            CategoryHome()
                .environmentObject(landmarkData) // Pass the landmark data to all views that need it
                .tabItem {
                    Label("Featured", systemImage: "star")
                }

            LandmarkList()
                .environmentObject(landmarkData) // Pass the landmark data
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }

            AddLandmarkView()
                .environmentObject(landmarkData) // Also pass it to add/edit views
                .tabItem {
                    Label("Add Landmark", systemImage: "plus.circle")
                }
        }
    }
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
