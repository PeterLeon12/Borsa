import SwiftUI

struct CategoryHome: View {
    @EnvironmentObject var landmarkData: LandmarkData // Access the shared data

    // Fetch landmarks from Core Data
    @FetchRequest(
        entity: Landmark.entity(),
        sortDescriptors: []
    ) var landmarks: FetchedResults<Landmark>

    @State private var showingProfile = false

    // Featured landmarks
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

    var body: some View {
        NavigationSplitView {
            List {
                // Show featured landmarks in a horizontal scroll view
                PageView(pages: features.map { FeatureCard(landmark: $0) })
                    .listRowInsets(EdgeInsets())

                // Show landmarks grouped by category
                ForEach(categories.keys.sorted(), id: \.self) { key in
                    CategoryRow(categoryName: key, items: categories[key] ?? [])
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.inset)
           /// .navigationTitle("Featured")
          /*  .toolbar {
                Button {
                    showingProfile.toggle()
                } label: {
                    Label("User Profile", systemImage: "person.crop.circle")
                }
            } */
            /*.sheet(isPresented: $showingProfile) {
                ProfileHost()
            }*/
        } detail: {
            Text("Select a Landmark")
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    return CategoryHome()
        .environment(\.managedObjectContext, context)
}
