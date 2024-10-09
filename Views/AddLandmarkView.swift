import SwiftUI
import CoreData
import UIKit // To use UIImage and UIApplication

struct AddLandmarkView: View {
    @EnvironmentObject var landmarkData: LandmarkData // Access shared data

    @Environment(\.managedObjectContext) private var viewContext
    var landmark: Landmark? = nil // Optional landmark for editing
    

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
    @State private var selectedImage: UIImage? = nil // UIImage from UIKit
    @State private var imageData: Data? = nil // Data type from Foundation
    @State private var showImagePicker = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Section(header: Text("Landmark Info").font(.headline)) {
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
                    }

                    Section(header: Text("Settings").font(.headline)) {
                        Toggle("Favorite", isOn: $isFavorite)
                            .padding()

                        Toggle("Featured", isOn: $isFeatured)
                            .padding()
                    }

                    Section(header: Text("Add Image").font(.headline)) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .padding()
                        }

                        Button("Choose Image") {
                            showImagePicker = true
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }

                    Button("Save Landmark") {
                        addOrUpdateLandmark()
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
            .navigationTitle(landmark == nil ? "Add Landmark" : "Edit Landmark") // Adjust title for editing
            .onAppear {
                if let landmark = landmark {
                    // Populate fields with existing landmark data for editing
                    name = landmark.name ?? ""
                    category = landmark.category ?? ""
                    city = landmark.city ?? ""
                    state = landmark.state ?? ""
                    latitude = landmark.latitude
                    longitude = landmark.longitude
                    description = landmark.landmarkDescription ?? ""
                    isFavorite = landmark.isFavorite
                    isFeatured = landmark.isFeatured
                    imageData = landmark.imageName
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage, imageData: $imageData)
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    // Function to either add a new landmark or update an existing one
    private func addOrUpdateLandmark() {
        let landmarkToUpdate = landmark ?? Landmark(context: viewContext) // If no landmark, create new one

        landmarkToUpdate.name = name
        landmarkToUpdate.category = category
        landmarkToUpdate.city = city
        landmarkToUpdate.state = state
        landmarkToUpdate.latitude = latitude
        landmarkToUpdate.longitude = longitude
        landmarkToUpdate.landmarkDescription = description
        landmarkToUpdate.isFavorite = isFavorite
        landmarkToUpdate.isFeatured = isFeatured

        landmarkToUpdate.name = name // Other fields...

           // Update image if one was selected
           if let imageData = imageData {
               landmarkToUpdate.imageName = imageData
           }

           // Save changes to Core Data
           do {
               try viewContext.save()
               landmarkData.updateLandmark(landmarkToUpdate) // Update shared data
           } catch {
               print("Failed to save landmark: \(error.localizedDescription)")
           }
       }
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#Preview {
    // Create a mock view context
    let context = PersistenceController.preview.container.viewContext

    // Create a mock landmark for preview purposes (for the edit scenario)
    let previewLandmark = Landmark(context: context)
    previewLandmark.name = "Preview Landmark"
    previewLandmark.category = "Preview Category"
    previewLandmark.city = "Preview City"
    previewLandmark.state = "Preview State"
    previewLandmark.latitude = 34.011286
    previewLandmark.longitude = -116.166868
    previewLandmark.landmarkDescription = "This is a description for a preview landmark."
    previewLandmark.isFavorite = true
    previewLandmark.isFeatured = false

    // Mock image data (optional)
    if let image = UIImage(systemName: "photo") {
        let imageData = image.pngData()
        previewLandmark.imageName = imageData
    }

    return Group {
        // Preview for adding a new landmark
        AddLandmarkView()
            .environment(\.managedObjectContext, context)
            .previewDisplayName("Add New Landmark")

        // Preview for editing an existing landmark
        AddLandmarkView(landmark: previewLandmark)
            .environment(\.managedObjectContext, context)
            .previewDisplayName("Edit Existing Landmark")
    }
}
