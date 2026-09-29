import SwiftUI

/// Defines the contract for a tab displayed by ``DSTabBar``.
///
/// Conform an application `enum` to `DSTabItem` to describe the tabs available
/// in the application's tab-based navigation.
///
/// Each enum case represents one tab. The order of the cases in `allCases`
/// determines the order in which the tabs are rendered by ``DSTabBar`` and
/// ``DSTabBarView``.
///
/// The protocol provides the tab's localized title, unselected icon, and
/// optionally a different icon for the selected state.
///
/// ## Example
///
/// ```swift
/// enum AppTab: DSTabItem {
///     case home
///     case bookings
///     case profile
///
///     var title: LocalizedStringKey {
///         switch self {
///         case .home:
///             "Home"
///         case .bookings:
///             "Bookings"
///         case .profile:
///             "Profile"
///         }
///     }
///
///     var icon: Image {
///         switch self {
///         case .home:
///             Image(systemName: "house")
///         case .bookings:
///             Image(systemName: "calendar")
///         case .profile:
///             Image(systemName: "person.crop.circle")
///         }
///     }
///
///     var selectedIcon: Image {
///         switch self {
///         case .home:
///             Image(systemName: "house.fill")
///         case .bookings:
///             Image(systemName: "calendar")
///         case .profile:
///             Image(systemName: "person.crop.circle.fill")
///         }
///     }
/// }
/// ```
///
/// ## Identity
///
/// `DSTabItem` inherits from `Identifiable`, but conforming types do not need
/// to implement `id` manually. The default implementation uses the enum case
/// itself as its identity.
///
/// This works because `DSTabItem` also requires `Hashable`.
///
/// ## Selected Icon
///
/// A tab can provide a dedicated ``selectedIcon`` for its selected state.
///
/// When no custom implementation is provided, the default implementation
/// returns ``icon``. This makes `selectedIcon` effectively optional while
/// keeping the protocol requirement explicit and predictable.
///
/// ## Localization
///
/// The tab title uses `LocalizedStringKey`, allowing callers to provide
/// localization keys directly while retaining SwiftUI's localization support.
///
/// - SeeAlso: ``DSTabBar``
/// - SeeAlso: ``DSTabBarView``
/// - SeeAlso: ``DSTabBarButton``
public protocol DSTabItem: Hashable, CaseIterable, Identifiable {

    /// The localized label displayed below the tab's icon.
    ///
    /// Use a `LocalizedStringKey` so the tab title can be resolved through
    /// SwiftUI's localization system.
    var title: LocalizedStringKey { get }

    /// The icon displayed when the tab is not selected.
    var icon: Image { get }

    /// The icon displayed when the tab is selected.
    ///
    /// If the conforming type does not provide a custom implementation,
    /// ``DSTabItem/selectedIcon`` falls back to ``DSTabItem/icon``.
    var selectedIcon: Image { get }
}

public extension DSTabItem {

    /// Uses the enum case itself as the tab's stable identity.
    ///
    /// Because conforming types are required to be `Hashable`, no separate
    /// identifier property is necessary.
    var id: Self {
        self
    }

    /// Uses the unselected icon for the selected state by default.
    ///
    /// Override this property when the selected tab should use a different
    /// icon, such as a filled SF Symbol.
    var selectedIcon: Image {
        icon
    }
}
