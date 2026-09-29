import SwiftUI

// MARK: - DSProfileCard

/// A card row that presents a user's profile information alongside a ``DSAvatar``.
///
/// `DSProfileCard` displays a primary name, an optional secondary description,
/// and either a custom avatar image or the initial fallback provided to
/// ``DSAvatar``.
///
/// The component uses the Design System surface, border, spacing, and
/// typography tokens to maintain consistent profile presentation.
public struct DSProfileCard: View {

    /// The primary profile name displayed as the card's main title.
    let name: String

    /// Optional secondary information displayed below the profile name.
    ///
    /// This can represent supporting information such as an email address,
    /// phone number, role, or other contextual profile text.
    let description: String?

    /// The fallback initial passed to ``DSAvatar`` when no custom image is provided.
    ///
    /// ``DSAvatar`` is responsible for trimming and normalizing the initial.
    let avatarInitial: String

    /// An optional custom image displayed by ``DSAvatar``.
    ///
    /// When provided, the image takes precedence over the initial fallback.
    let avatarImage: Image?

    /// Creates a profile card.
    ///
    /// - Parameters:
    ///   - name: The primary profile name displayed in the card.
    ///   - description: Optional supporting information displayed below the name.
    ///   - avatarInitial: The fallback initial displayed when no avatar image
    ///     is provided.
    ///   - avatarImage: An optional custom image displayed instead of the
    ///     initial fallback.
    public init(
        name: String,
        description: String? = nil,
        avatarInitial: String,
        avatarImage: Image? = nil
    ) {
        self.name = name
        self.description = description
        self.avatarInitial = avatarInitial
        self.avatarImage = avatarImage
    }

    /// The continuous rounded rectangle shape used by the card container.
    private var shape: RoundedRectangle {
        RoundedRectangle(
            cornerRadius: DSRadius.xxlarge,
            style: .continuous
        )
    }

    public var body: some View {
        HStack(spacing: DSSpacing.lg) {
            DSAvatar(
                initial: avatarInitial,
                image: avatarImage
            )

            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text(name)
                    .font(DSFont.sectionHeader)
                    .foregroundColor(DSColor.ink)

                if let description {
                    Text(description)
                        .font(DSFont.fieldLabel)
                        .foregroundColor(DSColor.ink60)
                }
            }

            Spacer()
        }
        .padding(DSPadding.regular)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DSColor.paper)
        .clipShape(shape)
        .overlay(
            shape.strokeBorder(
                DSColor.line,
                lineWidth: DSBorder.thin
            )
        )
    }
}
