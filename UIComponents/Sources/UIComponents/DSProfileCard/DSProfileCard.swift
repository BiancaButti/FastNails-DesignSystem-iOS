import SwiftUI

// MARK: - DSProfileCard

/// A card row that groups user profile details, showcasing a ``DSAvatar``
/// alongside a name and an optional secondary descriptive label (like an email or phone).
///
/// It strictly adheres to your design tokens, using `Color.paper` for background,
/// `Color.line` for the continuous border, and standard typography colors.
///
/// ```swift
/// DSProfileCard(
///     name: "Bianca",
///     description: "bianca@email.com",
///     avatarInitial: "B"
/// )
/// ```
public struct DSProfileCard: View {
    /// The primary name title displayed in bold.
    let name: String
    /// The secondary text displayed under the name (e.g., email, subtitle).
    let description: String?
    /// The letter initial passed to the underlying fallback avatar view.
    let avatarInitial: String
    /// An optional custom image to display inside the avatar view.
    let avatarImage: Image?
    /// Inner perimeter margins (default 16 pt).
    let padding: CGFloat
    /// Continuous clipping radius (default 20 pt).
    let cornerRadius: CGFloat

    /// Creates a `DSProfileCard`.
    public init(
        name: String,
        description: String? = nil,
        avatarInitial: String,
        avatarImage: Image? = nil,
        padding: CGFloat = 16,
        cornerRadius: CGFloat = 20
    ) {
        self.name = name
        self.description = description
        self.avatarInitial = avatarInitial
        self.avatarImage = avatarImage
        self.padding = padding
        self.cornerRadius = cornerRadius
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }

    public var body: some View {
        HStack(spacing: 16) {
            DSAvatar(
                initial: avatarInitial,
                image: avatarImage,
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
            shape.strokeBorder(DSColor.line, lineWidth: 1)
        )
    }
}
