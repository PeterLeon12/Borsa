import SwiftUI
import MapKit

struct LandmarkDetail: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var landmark: Landmark

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
            }
            .padding()
        }
        .navigationTitle(landmark.name ?? "Unknown Landmark")
        .navigationBarTitleDisplayMode(.inline)
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
}

#Preview {
    // Add a dummy landmark to preview
    let context = PersistenceController.preview.container.viewContext
    let newLandmark = Landmark(context: context)
    newLandmark.name = "Example Landmark"
    newLandmark.latitude = 34.011286
    newLandmark.longitude = -116.166868
    newLandmark.imageName = Data() // You can add actual data for preview if needed
    newLandmark.park = "Joshua Tree National Park"
    newLandmark.state = "California"
    newLandmark.isFavorite = true
    newLandmark.landmarkDescription = "A beautiful national park."

    return LandmarkDetail(landmark: newLandmark)
        .environment(\.managedObjectContext, context)
}
