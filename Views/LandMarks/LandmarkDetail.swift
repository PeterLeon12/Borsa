import SwiftUI
import MapKit

struct LandmarkDetail: View {
    @EnvironmentObject var landmarkData: LandmarkData // Access the shared data
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var landmark: Landmark
    @State private var showEditView = false // State to show the edit view
    @State private var showDeleteConfirmation = false // State to control the delete confirmation alert
    @Environment(\.presentationMode) var presentationMode // For dismissing view

    // Computed property to retrieve the landmark's location coordinate
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude)
    }

    var body: some View {
        ScrollView {
            // Use the computed coordinate to display the map
            MapView(coordinate: locationCoordinate)
                .frame(height: 300)

            ZStack {
                // Background layer: Blurred image
                if let imageData = landmark.imageName, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .clipped()
                        .blur(radius: 5)
                        .opacity(0.5)
                }

                // Foreground layer: Circular image
                if let imageData = landmark.imageName, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 4)
                        )
                        .shadow(radius: 7)
                        .padding(.bottom, 20)
                } else {
                    // Fallback in case there's no image data
                    CircleImage(image: Image(systemName: "photo"))
                        .offset(y: -130)
                        .padding(.bottom, -130)
                }
            }
            .padding(.bottom, 30)

            VStack(alignment: .leading) {
                HStack {
                    Text(landmark.name ?? "Unknown Landmark")
                        .font(.title)

                    Button(action: {
                        toggleFavorite()
                    }) {
                        Image(systemName: landmark.isFavorite ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }

                HStack {
                    Text(landmark.park ?? "Unknown Park")
                    Spacer()
                    Text(landmark.state ?? "Unknown State")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                Divider()

                Text("About \(landmark.name ?? "this landmark")")
                    .font(.title2)
                Text(landmark.landmarkDescription ?? "No description available.")

                // Button to open in Maps
                Button(action: {
                    openInMaps()
                }) {
                    Label("Open in Maps", systemImage: "map")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                .padding(.top)

                // Edit and Delete buttons
                HStack {
                    Button(action: {
                        showEditView.toggle() // Show the edit view
                    }) {
                        Label("Edit", systemImage: "pencil")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }

                    Spacer()

                    Button(action: {
                        showDeleteConfirmation = true // Trigger the delete confirmation alert
                    }) {
                        Label("Delete", systemImage: "trash")
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle(landmark.name ?? "Unknown Landmark")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showEditView) {
            AddLandmarkView(landmark: landmark) // Pass landmark to edit
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete Landmark"),
                message: Text("Are you sure you want to delete this landmark?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteLandmark() // Call the delete function if the user confirms
                },
                secondaryButton: .cancel()
            )
        }
    }

    // Function to open the Maps app with directions to the landmark
    private func openInMaps() {
        let placemark = MKPlacemark(coordinate: locationCoordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = landmark.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }

    // Function to toggle favorite status and save it to Core Data
    private func toggleFavorite() {
        landmark.isFavorite.toggle()
        do {
            try viewContext.save()
        } catch {
            print("Failed to save favorite status: \(error.localizedDescription)")
        }
    }

    // Function to delete the landmark
    private func deleteLandmark() {
        viewContext.delete(landmark)
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss() // Navigate back after deletion
        } catch {
            print("Failed to delete landmark: \(error.localizedDescription)")
        }
    }
}


#Preview {
    // Create a mock view context
    let context = PersistenceController.preview.container.viewContext

    // Create a mock landmark for preview purposes
    let previewLandmark = Landmark(context: context)
    previewLandmark.name = "Preview Landmark"
    previewLandmark.park = "Preview Park"
    previewLandmark.state = "Preview State"
    previewLandmark.latitude = 34.011286
    previewLandmark.longitude = -116.166868
    previewLandmark.landmarkDescription = "This is a beautiful national park used for preview purposes."
    previewLandmark.isFavorite = true

    // Mock image data (optional)
    let image = UIImage(systemName: "photo")!
    let imageData = image.pngData()
    previewLandmark.imageName = imageData

    return LandmarkDetail(landmark: previewLandmark)
        .environment(\.managedObjectContext, context)
}
