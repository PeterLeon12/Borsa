import SwiftUI

struct CategoryItem: View {
    var landmark: Landmark

    var body: some View {
        VStack(alignment: .leading) {
            // Load image from binary data
            if let imageData = landmark.imageName, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 155, height: 155)
                    .cornerRadius(5)
            } else {
                // Fallback if no image is available
                Image(systemName: "photo")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 155, height: 155)
                    .cornerRadius(5)
            }

            Text(landmark.name ?? "Unknown Landmark")
                .foregroundStyle(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}
