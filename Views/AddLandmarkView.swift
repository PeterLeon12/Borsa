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
            ScrollView {
                VStack(spacing: 20) {
                    Section(header: Text("Landmark Info")) {
                        TextField("Name", text: $name)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        TextField("Category", text: $category)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        TextField("City", text: $city)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        TextField("State", text: $state)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        TextField("Latitude", value: $latitude, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        TextField("Longitude", value: $longitude, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        TextField("Description", text: $description)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        Toggle("Favorite", isOn: $isFavorite)
                            .padding()

                        Toggle("Featured", isOn: $isFeatured)
                            .padding()
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
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Add Landmark")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage, imageData: $imageData)
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    // Function to save the landmark to Core Data
    private func addNewLandmark() {
        guard !name.isEmpty else {
            // Show an alert or prompt if required fields are not filled
            print("Landmark name is required.")
            return
        }

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

    // Function to dismiss keyboard when tapping outside the keyboard area
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AddLandmarkView()
}
