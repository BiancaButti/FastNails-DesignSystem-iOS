import SwiftUI

/// A tab-based container that replaces the system tab bar with ``DSTabBar``.
///
/// `DSTabBarView` combines a SwiftUI `TabView` with the Design System's
/// ``DSTabBar``. It is intended to be used as the root container for
/// tab-based application navigation.
///
/// The system tab bar is hidden for each tab, while the custom ``DSTabBar``
/// is inserted at the bottom of the safe area.
///
/// Because the content is backed by `TabView`, each tab maintains its own view
/// hierarchy while it is not currently selected. This allows navigation stacks,
/// scroll positions, and other state owned by the tab's hierarchy to be
/// preserved when switching between tabs.
///
/// ## Example
///
/// ```swift
/// struct RootView: View {
///     @State private var tab: AppTab = .home
///
///     var body: some View {
///         DSTabBarView(
///             selection: $tab,
///             badges: [
///                 .bookings: 2
///             ]
///         ) { tab in
///             switch tab {
///             case .home:
///                 NavigationStack {
///                     Text("Home")
///                         .navigationTitle("Home")
///                 }
///
///             case .bookings:
///                 NavigationStack {
///                     Text("Bookings")
///                         .navigationTitle("Bookings")
///                 }
///
///             case .profile:
///                 NavigationStack {
///                     Text("Profile")
///                         .navigationTitle("Profile")
///                 }
///             }
///         }
///     }
/// }
/// ```
///
/// ## Tabs
///
/// The available tabs are obtained from `Tab.allCases`.
///
/// Their visual and content order therefore follows the order defined by the
/// conforming type's `allCases` collection.
///
/// `DSTabBarView` does not accept a separate `tabs` parameter. Use
/// ``DSTabBar`` directly when a subset or custom ordering of tabs is required.
///
/// ## Selection
///
/// The selected tab is owned by the caller through the `selection` binding.
///
/// Changing the binding updates both the displayed `TabView` content and the
/// selected state of the custom ``DSTabBar``.
///
/// Tapping a tab in the custom bar updates the same binding, keeping the
/// container and the tab bar synchronized.
///
/// ## Badges
///
/// Badge counts are passed to ``DSTabBar`` through the `badges` dictionary.
///
/// A tab without an entry, or with a count of `0`, displays no badge. Badge
/// presentation and accessibility formatting are handled by the tab bar
/// components.
///
/// ## Appearance
///
/// The container does not define its own tab bar colors. The custom bar reads
/// its appearance from the ``DSTabBarStyle`` provided through the SwiftUI
/// environment.
///
/// For example:
///
/// ```swift
/// DSTabBarView(selection: $tab) { tab in
///     content(for: tab)
/// }
/// .dsTabBarStyle(
///     DSTabBarStyle(
///         selectedColor: .indigo,
///         dividerColor: nil
///     )
/// )
/// ```
///
/// ## Safe Area
///
/// The custom tab bar is installed using `safeAreaInset(edge: .bottom)`.
///
/// This keeps the tab bar outside the main content's layout area while
/// allowing the system to account for the bar when laying out content near
/// the bottom edge.
///
/// ## Navigation
///
/// `DSTabBarView` provides the tab container but does not create navigation
/// stacks for individual tabs. When a tab requires independent navigation,
/// create its `NavigationStack` inside the `content` closure.
///
/// - Important: The `Tab` type must conform to ``DSTabItem`` and therefore
/// provide the tab metadata required by ``DSTabBar``.
///
/// - SeeAlso: ``DSTabBar``
/// - SeeAlso: ``DSTabItem``
/// - SeeAlso: ``DSTabBarStyle``
public struct DSTabBarView<Tab: DSTabItem, Content: View>: View {

    /// The currently selected tab.
    ///
    /// This binding synchronizes the selection between the underlying
    /// `TabView` and the custom ``DSTabBar``.
    @Binding private var selection: Tab

    /// Badge counts associated with individual tabs.
    ///
    /// Missing entries and zero values result in no badge.
    private let badges: [Tab: Int]

    /// Builds the content associated with each tab.
    private let content: (Tab) -> Content

    /// Creates a tab-based container using the custom ``DSTabBar``.
    ///
    /// - Parameters:
    ///   - selection: A binding to the currently selected tab.
    ///   - badges: Badge counts keyed by tab. Missing entries and zero values
    ///     display no badge.
    ///   - content: A view builder that creates the content for each tab.
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
            DSTabBar(
                selection: $selection,
                badges: badges
            )
        }
    }
}
