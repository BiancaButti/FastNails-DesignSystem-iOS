import SwiftUI

// MARK: - DSAvatar

/// Displays a compact avatar using a custom image or an initial fallback.
///
/// Use `DSAvatar` to represent a user's profile or identity in places where a compact visual representation is needed.
/// When no image is provided, the component displays the first non-whitespace character from `initial` in uppercase.
///
/// ```swift
/// DSAvatar(initial: "Bruno")
///
/// DSAvatar(
///     initial: "Bruno",
///     image: Image("profile_picture")
/// )
/// ```
public struct DSAvatar: View {
    /// The normalized initial displayed when no image is provided.
    let initial: String

    /// An optional image displayed instead of the initial.
    let image: Image?

    /// Creates a `DSAvatar`.
    /// - Parameters:
    ///   - initial: The fallback text used to derive the displayed initial. Leading and trailing whitespace is removed, and the first character is converted to uppercase. Defaults to `?` when the value is empty.
    ///   - image: An optional image displayed instead of the initial fallback. Defaults to `nil`.
    public init(
        initial: String,
        image: Image? = nil
    ) {
        let trimmed = initial.trimmingCharacters(in: .whitespacesAndNewlines)
        self.initial = trimmed.isEmpty ? "?" : String(trimmed.prefix(1)).uppercased()
        self.image = image
    }

    public var body: some View {
        let innerCirclePadding = DSSize.huge * 0.08
        let innerCircleSize = DSSize.huge - (innerCirclePadding * 2)

        ZStack {
            if let image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: innerCircleSize,
                        height: innerCircleSize
                    )
                    .clipShape(Circle())
            } else {
                ZStack {
                    Circle()
                        .fill(DSColor.ink)

                    Text(initial)
                        .font(DSFont.dynamicBold(scaledFrom: DSSize.huge))
                        .foregroundColor(DSColor.blush)
                }
                .frame(
                    width: innerCircleSize,
                    height: innerCircleSize
                )
            }
        }
        .frame(
            width: DSSize.huge,
            height: DSSize.huge
        )
        .background(DSColor.paper)
        .clipShape(
            RoundedRectangle(
                cornerRadius: DSRadius.huge * 0.25,
                style: .continuous
            )
        )
    }
}
