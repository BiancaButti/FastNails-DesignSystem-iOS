import SwiftUI

/// The contract for a tab shown by the ``DSTabBar``.
///
/// Any app `enum` becomes a tab bar by conforming to this protocol: each `case`
/// is a tab, and the tab order follows the order of `allCases`.
///
/// ```swift
/// enum AppTab: DSTabItem {
///     case home, bookings, profile
///
///     var title: LocalizedStringKey {
///         switch self {
///         case .home: "Home"
///         case .bookings: "Bookings"
///         case .profile: "Profile"
///         }
///     }
///
///     var icon: Image {
///         switch self {
///         case .home: Image(systemName: "house")
///         case .bookings: Image(systemName: "calendar")
///         case .profile: Image(systemName: "person.crop.circle")
///         }
///     }
///
///     // `selectedIcon` is optional — without it, the selected icon matches `icon`.
///     var selectedIcon: Image {
///         switch self {
///         case .home: Image(systemName: "house.fill")
///         case .bookings: Image(systemName: "calendar")
///         case .profile: Image(systemName: "person.crop.circle.fill")
///         }
///     }
/// }
/// ```
///
/// - Note: `Identifiable` is already satisfied by the default extension
///   (`id == self`), so the `enum` only needs to provide `title`, `icon`, and —
///   optionally — `selectedIcon`.
public protocol DSTabItem: Hashable, CaseIterable, Identifiable {

    /// Label shown below the icon. Use `LocalizedStringKey` to get automatic
    /// localization.
    var title: LocalizedStringKey { get }

    /// The tab's icon in the unselected state.
    var icon: Image { get }

    /// The icon shown when the tab is selected.
    ///
    /// Optional: without a custom implementation, the default extension returns
    /// the same value as ``icon``.
    var selectedIcon: Image { get }
}

public extension DSTabItem {

    /// Uses the case itself as identity, so no manual `id` is needed.
    var id: Self { self }

    /// Default fallback: when a tab defines no selected icon, it reuses ``icon``.
    var selectedIcon: Image { icon }
}
