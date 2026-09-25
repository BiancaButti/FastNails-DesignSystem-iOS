import SwiftUI
// MARK: - DSMenuRow

/// A standard list row used inside menu cards to display an icon, a title,
/// and optional trailing status elements like indicators or counts.
public struct DSMenuRow: View {
    let icon: Image
    let title: String
    let badgeText: String?
    let showChevron: Bool
    let action: () -> Void

    /// Creates a `DSMenuRow`.
    /// - Parameters:
    ///   - icon: The image or SF Symbol to align on the leading edge.
    ///   - title: The descriptive title text.
    ///   - badgeText: Optional text to show as a status or count on the trailing edge (e.g. "2", "1.0.0").
    ///   - showChevron: Whether to show the navigation arrow on the right (default `true`).
    ///   - action: The closure to execute when the row is tapped.
    public init(
        icon: Image,
        title: String,
        badgeText: String? = nil,
        showChevron: Bool = true,
        action: @escaping () -> Void = {}
    ) {
        self.icon = icon
        self.title = title
        self.badgeText = badgeText
        self.showChevron = showChevron
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: DSSpacing.md) {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: DSSize.large,
                           height: DSSize.large)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(DSColor.ink)
                
                Spacer()
                
                if let badgeText {
                    Text(badgeText)
                        .font(.subheadline)
                        .foregroundColor(DSColor.ink60)
                }
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(DSFont.fieldLabel)
                        .foregroundColor(DSColor.ink60.opacity(0.7))
                }
            }
            .padding(.vertical, DSPadding.regular)
            .padding(.horizontal, DSPadding.regular)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
