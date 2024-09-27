import SwiftUI
import MapKit

struct LandmarkDetail: View {
    var landmark: Landmark

    // Computed property to retrieve the landmark's location coordinate
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude)
    }

    var body: some View {
        ScrollView {
            // Use the computed coordinate to display the map
            MapView(coordinate: locationCoordinate)
                .frame(height: 300)

            Spacer(minLength: 130)

            // Convert the binary image data to a UIImage and then to a SwiftUI Image
            if let imageData = landmark.imageName, let uiImage = UIImage(data: imageData) {
                CircleImage(image: Image(uiImage: uiImage))
                    .offset(y: -130)
                    .padding(.bottom, -130)
            } else {
                // Fallback in case there's no image data
                CircleImage(image: Image(systemName: "photo"))
                    .offset(y: -130)
                    .padding(.bottom, -130)
            }

            VStack(alignment: .leading) {
                HStack {
                    Text(landmark.name ?? "Unknown Landmark")
                        .font(.title)
                    FavoriteButton(isSet: .constant(landmark.isFavorite))
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

    return LandmarkDetail(landmark: newLandmark) // Explicitly returning the view
}
