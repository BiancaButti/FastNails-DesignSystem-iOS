import SwiftUI

// MARK: - DSNoticeItem

/// Defines the content and visual configuration of a single item displayed by ``DSNoticeCard``.
///
/// Use `DSNoticeItem` to provide the semantic icon, icon color, and descriptive text for each notice row.
/// The item's identifier is derived from its title and is used by SwiftUI to identify the row.
///
/// ```swift
/// DSNoticeItem(
///     systemIconName: "clock.fill",
///     iconColor: DSColor.ink60,
///     title: "Cancelamento gratuito até 24 horas antes."
/// )
/// ```
public struct DSNoticeItem: Hashable, Identifiable {
    /// A stable identifier derived from the item's title.
    public var id: String {
        title
    }

    /// The SF Symbol name used for the item's leading icon.
    let systemIconName: String

    /// The color applied to the item's leading icon.
    let iconColor: Color

    /// The descriptive text displayed beside the icon.
    let title: String

    /// Creates a `DSNoticeItem`.
    /// - Parameters:
    ///   - systemIconName: The SF Symbol name used for the leading icon.
    ///   - iconColor: The color applied to the leading icon.
    ///   - title: The descriptive text displayed beside the icon.
    public init(
        systemIconName: String,
        iconColor: Color,
        title: String
    ) {
        self.systemIconName = systemIconName
        self.iconColor = iconColor
        self.title = title
    }
}
