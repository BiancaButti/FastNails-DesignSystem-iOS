import SwiftUI

// MARK: - DSAvatar

/// A rounded-square avatar container that displays either a custom circle-clipped image
/// or a prominent initial letter inside a circular background fallback.
///
/// It follows the design system tokens by layering a dark circle (`Color.ink`) or a custom photo
/// inside a clean square container background (`Color.paper`).
///
/// ```swift
/// // Text version
/// DSAvatar(initial: "B")
///
/// // Image version
/// DSAvatar(initial: "B", image: Image("profile_picture"))
/// ```
public struct DSAvatar: View {
    /// The single letter initial used as a fallback placeholder.
    let initial: String
    /// An optional custom image to display instead of the text initial.
    let image: Image?
    /// The overall size of the square container (default 48 pt).
    let size: CGFloat
    
    /// Creates a `DSAvatar`.
    /// - Parameters:
    ///   - initial: The fallback character (typically uppercase) to display if no image is present.
    ///   - image: An optional custom `Image` to display inside the circular area.
    ///   - size: The width and height size of the avatar view (default 48 pt).
    public init(
        initial: String,
        image: Image? = nil,
        size: CGFloat = 48
    ) {
        let trimmed = initial.trimmingCharacters(in: .whitespacesAndNewlines)
        self.initial = trimmed.isEmpty ? "?" : String(trimmed.prefix(1)).uppercased()
        self.image = image
        self.size = size
    }

    public var body: some View {
        let innerCirclePadding = size * 0.08
        let innerCircleSize = size - (innerCirclePadding * 2)

        ZStack {
            if let image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: innerCircleSize, height: innerCircleSize)
                    .clipShape(Circle())
            } else {
                ZStack {
                    Circle()
                        .fill(DSColor.ink)
                    
                    Text(initial)
                        .font(DSFont.dynamicBold(scaledFrom: size))
                        .foregroundColor(DSColor.blush)
                }
                .frame(width: innerCircleSize, height: innerCircleSize)
            }
        }
        .frame(width: size, height: size)
        .background(DSColor.paper)
        .clipShape(
            RoundedRectangle(
                cornerRadius: DSRadius.huge * 0.25,
                style: .continuous))
    }
}
