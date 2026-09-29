import SwiftUI

/// Defines the visual appearance of a ``DSTabBar``.
///
/// `DSTabBarStyle` groups the colors required by the tab bar into a single
/// configuration object. The style is injected through the SwiftUI environment
/// using ``SwiftUICore/View/dsTabBarStyle(_:)``.
///
/// This allows a parent view to customize the appearance of every
/// ``DSTabBar`` descendant without passing the style explicitly through the
/// view hierarchy.
///
/// Values not explicitly customized use the Design System's default tokens.
///
/// ## Example
///
/// Apply a custom appearance to a tab bar:
///
/// ```swift
/// DSTabBar(selection: $tab)
///     .dsTabBarStyle(
///         DSTabBarStyle(
///             selectedColor: .indigo,
///             dividerColor: nil
///         )
///     )
/// ```
///
/// The same style can also be applied to a container, affecting every
/// ``DSTabBar`` below it:
///
/// ```swift
/// VStack {
///     ContentView()
///     DSTabBar(selection: $tab)
/// }
/// .dsTabBarStyle(.default)
/// ```
///
/// ## Appearance
///
/// The style controls four visual aspects of the tab bar:
///
/// - `selectedColor`: selected tab content and badge background.
/// - `unselectedColor`: unselected tab content.
/// - `background`: tab bar surface, including the bottom safe area.
/// - `dividerColor`: optional top divider.
///
/// Set `dividerColor` to `nil` when the top divider should not be rendered.
///
/// - SeeAlso: ``DSTabBar``
/// - SeeAlso: ``DSTabBarButton``
/// - SeeAlso: ``SwiftUICore/View/dsTabBarStyle(_:)``
public struct DSTabBarStyle {

    /// Tint applied to the selected tab's icon and label.
    ///
    /// The same color is used as the visual background of tab badges.
    public var selectedColor: Color

    /// Tint applied to unselected tab icons and labels.
    public var unselectedColor: Color

    /// Background color of the tab bar.
    ///
    /// The ``DSTabBar`` extends this background through the bottom safe area.
    public var background: Color

    /// Color of the one-pixel visual divider along the top edge of the bar.
    ///
    /// Set to `nil` to remove the divider.
    public var dividerColor: Color?

    /// Creates a tab bar style.
    ///
    /// Every parameter has a Design System default, allowing callers to
    /// override only the appearance values that need to change.
    ///
    /// - Parameters:
    ///   - selectedColor: Tint applied to the selected tab and badge.
    ///     Defaults to ``DSColor/legacyBrand``.
    ///   - unselectedColor: Tint applied to unselected tabs.
    ///     Defaults to ``DSColor/legacyContentTertiary``.
    ///   - background: Background of the tab bar.
    ///     Defaults to ``DSColor/surface``.
    ///   - dividerColor: Color of the top divider, or `nil` to hide it.
    ///     Defaults to ``DSColor/divider``.
    public init(
        selectedColor: Color = DSColor.legacyBrand,
        unselectedColor: Color = DSColor.legacyContentTertiary,
        background: Color = DSColor.surface,
        dividerColor: Color? = DSColor.divider
    ) {
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.background = background
        self.dividerColor = dividerColor
    }

    /// The standard Fast Nails tab bar appearance.
    ///
    /// Used as the environment default when no custom style has been supplied
    /// through ``SwiftUICore/View/dsTabBarStyle(_:)``.
    public static let `default` = DSTabBarStyle()
}

/// The environment key used to provide a ``DSTabBarStyle``.
private struct DSTabBarStyleKey: EnvironmentKey {

    /// The style used when no ancestor overrides the environment value.
    static let defaultValue = DSTabBarStyle.default
}

public extension EnvironmentValues {

    /// The ``DSTabBarStyle`` applied to the current view hierarchy.
    ///
    /// Most callers should use ``SwiftUICore/View/dsTabBarStyle(_:)`` instead
    /// of modifying the environment value directly.
    var dsTabBarStyle: DSTabBarStyle {
        get {
            self[DSTabBarStyleKey.self]
        }
        set {
            self[DSTabBarStyleKey.self] = newValue
        }
    }
}

public extension View {

    /// Applies a ``DSTabBarStyle`` to all ``DSTabBar`` instances in this
    /// view's descendant hierarchy.
    ///
    /// The style is stored in the SwiftUI environment, so nested views inherit
    /// it automatically. A descendant can override the inherited style by
    /// applying this modifier again.
    ///
    /// - Parameter style: The tab bar appearance to provide to descendants.
    /// - Returns: A view with the supplied tab bar style in its environment.
    ///
    /// ## Example
    ///
    /// ```swift
    /// DSTabBar(selection: $tab)
    ///     .dsTabBarStyle(
    ///         DSTabBarStyle(
    ///             selectedColor: .indigo,
    ///             dividerColor: nil
    ///         )
    ///     )
    /// ```
    func dsTabBarStyle(_ style: DSTabBarStyle) -> some View {
        environment(\.dsTabBarStyle, style)
    }
}
