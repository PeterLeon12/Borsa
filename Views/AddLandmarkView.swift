import SwiftUI
import CoreData

struct AddLandmarkView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // State variables for user input
    @State private var name = ""
    @State private var category = ""
    @State private var city = ""
    @State private var state = ""
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var description = ""
    @State private var isFavorite = false
    @State private var isFeatured = false
    @State private var selectedImage: UIImage? = nil
    @State private var imageData: Data? = nil
    @State private var showImagePicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Landmark Info")) {
                    TextField("Name", text: $name)
                    TextField("Category", text: $category)
                    TextField("City", text: $city)
                    TextField("State", text: $state)
                    TextField("Latitude", value: $latitude, formatter: NumberFormatter())
                    TextField("Longitude", value: $longitude, formatter: NumberFormatter())
                    TextField("Description", text: $description)
                    Toggle("Favorite", isOn: $isFavorite)
                    Toggle("Featured", isOn: $isFeatured)
                }

                Section(header: Text("Add Image")) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    Button("Choose Image") {
                        showImagePicker = true
                    }
                }

                Button("Save Landmark") {
                    addNewLandmark()
                }
            }
            .navigationTitle("Add Landmark")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage, imageData: $imageData)
            }
        }
    }

    // Function to save the landmark to Core Data
    private func addNewLandmark() {
        let newLandmark = Landmark(context: viewContext)
        newLandmark.name = name
        newLandmark.category = category
        newLandmark.city = city
        newLandmark.state = state
        newLandmark.latitude = latitude
        newLandmark.longitude = longitude
        newLandmark.landmarkDescription = description
        newLandmark.isFavorite = isFavorite
        newLandmark.isFeatured = isFeatured

        if let imageData = imageData {
            newLandmark.imageName = imageData
        }

        // Save the landmark
        do {
            try viewContext.save()
        } catch {
            print("Failed to save landmark: \(error.localizedDescription)")
        }
    }
}
#Preview {
    AddLandmarkView()
}
