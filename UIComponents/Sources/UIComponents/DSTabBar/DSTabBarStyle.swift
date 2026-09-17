import SwiftUI

/// The visual appearance of a ``DSTabBar``.
///
/// Set it through the ``SwiftUICore/View/dsTabBarStyle(_:)`` modifier; the bar
/// reads it from the environment, so any ancestor can override it. Unspecified
/// values fall back to the ``default`` tokens.
///
/// ```swift
/// DSTabBar(selection: $tab)
///     .dsTabBarStyle(.init(selectedColor: .indigo, dividerColor: nil))
/// ```
public struct DSTabBarStyle {

    /// Tint of the selected tab's icon and label, and the badge background.
    public var selectedColor: Color

    /// Tint of the unselected tabs' icons and labels.
    public var unselectedColor: Color

    /// Fill behind the bar, extended into the bottom safe area.
    public var background: Color

    /// Color of the hairline divider along the top edge. `nil` hides it.
    public var dividerColor: Color?
 
    /// Creates a style, overriding only the tokens you pass.
    ///
    /// - Parameters:
    ///   - selectedColor: Tint of the selected tab. Defaults to `.brand`.
    ///   - unselectedColor: Tint of the unselected tabs. Defaults to `.contentTertiary`.
    ///   - background: Fill behind the bar. Defaults to `.surface`.
    ///   - dividerColor: Top hairline color, or `nil` to hide it. Defaults to `.divider`.
    public init(
        selectedColor: Color = .brand,
        unselectedColor: Color = .contentTertiary,
        background: Color = .surface,
        dividerColor: Color? = .divider
    ) {
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.background = background
        self.dividerColor = dividerColor
    }
 
    /// The standard Fast Nails appearance, used when no style is provided.
    public static let `default` = DSTabBarStyle()
}
 
private struct DSTabBarStyleKey: EnvironmentKey {
    static let defaultValue = DSTabBarStyle.default
}
 
public extension EnvironmentValues {
    var dsTabBarStyle: DSTabBarStyle {
        get { self[DSTabBarStyleKey.self] }
        set { self[DSTabBarStyleKey.self] = newValue }
    }
}
 
public extension View {

    /// Sets the ``DSTabBarStyle`` for every ``DSTabBar`` in this view hierarchy.
    func dsTabBarStyle(_ style: DSTabBarStyle) -> some View {
        environment(\.dsTabBarStyle, style)
    }
}
