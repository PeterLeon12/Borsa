import SwiftUI


struct FeatureCard: View {
    var landmark: Landmark

    // Computed property to convert Binary Data to UIImage
    var featureImage: Image? {
        if let imageData = landmark.imageName, let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "photo") // Fallback to a system image if no image is found
        }
    }

    var body: some View {
        featureImage?
            .resizable()
            .overlay {
                TextOverlay(landmark: landmark)
            }
    }
}



struct TextOverlay: View {
    var landmark: Landmark

    var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.6), .black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            gradient
            VStack(alignment: .leading) {
                // Unwrap optional strings safely
                Text(landmark.name ?? "Unknown Landmark")
                    .font(.title)
                    .bold()
                Text(landmark.park ?? "Unknown Park")
            }
            .padding()
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    let modelData = ModelData()
    return FeatureCard(landmark: modelData.features[0])
        .aspectRatio(3 / 2, contentMode: .fit)
}
