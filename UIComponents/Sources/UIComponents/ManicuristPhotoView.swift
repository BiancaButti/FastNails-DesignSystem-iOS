import SwiftUI

public struct ManicuristPhotoView: View {

    let size: CGFloat

    public init(size: CGFloat) {
        self.size = size
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(Color.appPink.opacity(0.15))
            Image(systemName: "person.fill")
                .font(.system(size: size * 0.45))
                .foregroundStyle(Color.appPink)
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}
