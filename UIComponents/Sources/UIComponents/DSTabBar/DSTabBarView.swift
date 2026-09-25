import SwiftUI

/// A tab-based container that swaps the native tab bar for the ``DSTabBar``.
///
/// It wraps a `TabView`, hides the system tab bar, and pins the ``DSTabBar`` to
/// the bottom safe area. Because it builds on `TabView`, each tab keeps its own
/// state (scroll position, navigation stack) while it is off screen.
///
/// The tabs come from `Tab.allCases`, and their order follows that sequence.
///
/// ```swift
/// struct RootView: View {
///     @State private var tab: AppTab = .home
///
///     var body: some View {
///         DSTabBarView(selection: $tab, badges: [.bookings: 2]) { tab in
///             switch tab {
///             case .home:
///                 NavigationStack { Text("Home").navigationTitle("Home") }
///             case .bookings:
///                 NavigationStack { Text("Bookings").navigationTitle("Bookings") }
///             case .profile:
///                 NavigationStack { Text("Profile").navigationTitle("Profile") }
///             }
///         }
///     }
/// }
/// ```
///
/// - SeeAlso: ``DSTabBar`` for the bar on its own, and ``DSTabItem`` for the tab contract.
public struct DSTabBarView<Tab: DSTabItem, Content: View>: View {
    @Binding private var selection: Tab
    private let badges: [Tab: Int]
    private let content: (Tab) -> Content
 
    /// Creates a tab container backed by the ``DSTabBar``.
    ///
    /// - Parameters:
    ///   - selection: The currently selected tab.
    ///   - badges: The badge count to show per tab. Tabs with no entry (or a
    ///     value of `0`) show no badge.
    ///   - content: The view builder that produces the screen for each tab.
    public init(
        selection: Binding<Tab>,
        badges: [Tab: Int] = [:],
        @ViewBuilder content: @escaping (Tab) -> Content
    ) {
        self._selection = selection
        self.badges = badges
        self.content = content
    }
 
    public var body: some View {
        TabView(selection: $selection) {
            ForEach(Array(Tab.allCases)) { tab in
                content(tab)
                    .tag(tab)
                    .toolbar(.hidden, for: .tabBar)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: .zero) {
            DSTabBar(selection: $selection, badges: badges)
        }
    }
}
