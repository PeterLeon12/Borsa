import SwiftUI

struct CircleImage: View {
    var image: Image

    var body: some View {
        ZStack {
            // Background blurred image
            image
                .resizable()
                .blur(radius: 10) // Apply a blur effect
                .ignoresSafeArea()
                .frame(width: 420, height: 360)

            // Foreground circular image
            image
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 1)
                }
                .shadow(radius: 7)
                .frame(width: 250, height: 250) // Set the size of the circular image
        }
    }
}

#Preview {
    CircleImage(image: Image("turtlerock"))
}
