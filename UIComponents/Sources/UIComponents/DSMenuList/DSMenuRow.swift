import SwiftUI

// MARK: - DSMenuRow

/// A standard interactive menu row that displays a leading icon, title, and optional trailing content.
///
/// Use `DSMenuRow` inside grouped menu containers such as ``DSMenuList`` to represent navigation
/// or action items. The row can optionally display a badge and a trailing chevron.
///
/// ```swift
/// DSMenuRow(
///     icon: Image(systemName: "person"),
///     title: "Profile"
/// ) {
///     openProfile()
/// }
/// ```
///
/// ## Accessibility
/// The entire row is exposed as a single button and uses the provided title as its accessible label.
public struct DSMenuRow: View {
    /// The image or SF Symbol displayed at the leading edge of the row.
    let icon: Image

    /// The primary descriptive text displayed in the row.
    let title: String

    /// Optional trailing text used to display a status, count, version, or other supplementary information.
    let badgeText: String?

    /// A Boolean value that determines whether the trailing navigation chevron is displayed.
    let showChevron: Bool

    /// The closure executed when the row is tapped or activated.
    let action: () -> Void

    /// Creates a `DSMenuRow`.
    /// - Parameters:
    ///   - icon: The image or SF Symbol displayed at the leading edge.
    ///   - title: The descriptive title text displayed in the row.
    ///   - badgeText: Optional trailing text used for a status, count, version, or other supplementary information.
    ///   - showChevron: Whether to display the trailing navigation chevron. Defaults to `true`.
    ///   - action: The closure executed when the row is tapped. Defaults to an empty action.
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
                    .frame(
                        width: DSSize.large,
                        height: DSSize.large
                    )

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
