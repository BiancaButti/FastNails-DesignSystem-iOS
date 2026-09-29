import SwiftUI

/// A single selectable tab displayed by a ``DSTabBar``.
///
/// `DSTabBarButton` renders the tab's icon, title, and optional badge. It does
/// not own selection state; the parent ``DSTabBar`` provides the current
/// selection and handles the action triggered by a tap.
///
/// The button adapts its icon size to Dynamic Type using `@ScaledMetric` and
/// maintains the Design System's minimum touch target.
///
/// ## Selection
///
/// The `isSelected` value determines the visual state of the tab and which
/// icon is displayed:
///
/// - Selected tabs use ``DSTabItem/selectedIcon`` and the style's
///   `selectedColor`.
/// - Unselected tabs use ``DSTabItem/icon`` and the style's
///   `unselectedColor`.
///
/// ## Badges
///
/// A positive badge count is displayed over the icon. Counts greater than
/// `99` are visually represented as `99+`.
///
/// The badge itself is hidden from accessibility because the count is exposed
/// through the button's accessibility value, preventing VoiceOver from
/// announcing the same information twice.
///
/// ## Accessibility
///
/// The button exposes the tab title as its accessibility label and the badge
/// count as its accessibility value. Selected tabs receive the
/// `.isSelected` accessibility trait.
///
/// A large content viewer is also provided for contexts where the tab's icon
/// and title need to be presented at a larger size.
///
/// - Note: `DSTabBarButton` is an internal building block of ``DSTabBar`` and
/// is not responsible for managing tab selection.
struct DSTabBarButton<Tab: DSTabItem>: View {

    /// The minimum scale factor allowed for the tab title.
    private let minimumTextScale: CGFloat = 0.8

    /// Horizontal offset applied to the badge relative to the icon.
    private let badgeOffsetX: CGFloat = 10

    /// Vertical offset applied to the badge relative to the icon.
    private let badgeOffsetY: CGFloat = -6

    /// The tab represented by this button.
    let tab: Tab

    /// Indicates whether this tab is currently selected.
    ///
    /// The parent ``DSTabBar`` owns the selection state and passes the
    /// corresponding value to the button.
    let isSelected: Bool

    /// The optional badge count associated with the tab.
    ///
    /// Values less than or equal to zero are treated as having no badge.
    let badge: Int?

    /// The visual style inherited from the parent ``DSTabBar``.
    let style: DSTabBarStyle

    /// The action executed when the tab is tapped.
    let action: () -> Void

    /// The icon size, scaled according to the user's Dynamic Type setting.
    @ScaledMetric(relativeTo: .caption2)
    private var iconSize: CGFloat = DSSize.mediumCompact

    var body: some View {
        Button(action: action) {
            VStack(spacing: DSSpacing.xs) {
                iconView
                    .overlay(alignment: .topTrailing) {
                        badgeView
                    }

                Text(tab.title)
                    .font(DSFont.tabLabel)
                    .lineLimit(DSTextLimit.title)
                    .minimumScaleFactor(minimumTextScale)
            }
            .foregroundStyle(
                isSelected
                    ? style.selectedColor
                    : style.unselectedColor
            )
            .frame(
                maxWidth: .infinity,
                minHeight: DSSize.touchTarget
            )
        }
        .buttonStyle(.plain)
        .animation(
            .easeOut(duration: DSAnimation.fastDuration),
            value: isSelected
        )
        .accessibilityLabel(Text(tab.title))
        .accessibilityValue(badgeAccessibilityValue)
        .accessibilityAddTraits(
            isSelected ? .isSelected : []
        )
        .accessibilityShowsLargeContentViewer {
            iconView
            Text(tab.title)
        }
    }

    /// The badge displayed at the icon's top-trailing corner.
    ///
    /// The badge is rendered only when ``DSTabBarBadge/displayText(_:)``
    /// returns a value. Visual counts greater than `99` are capped at `99+`.
    ///
    /// The badge is hidden from assistive technologies because its value is
    /// exposed through the button's accessibility value.
    @ViewBuilder
    private var badgeView: some View {
        if let text = DSTabBarBadge.displayText(badge) {
            Text(text)
                .font(DSFont.captionSemibold)
                .monospacedDigit()
                .foregroundStyle(.white)
                .padding(.horizontal, DSPadding.xsmall)
                .frame(
                    minWidth: DSSize.medium,
                    minHeight: DSSize.medium
                )
                .background(
                    Capsule()
                        .fill(style.selectedColor)
                )
                .offset(
                    x: badgeOffsetX,
                    y: badgeOffsetY
                )
                .accessibilityHidden(true)
        }
    }

    /// The icon displayed by the tab.
    ///
    /// Uses ``DSTabItem/selectedIcon`` when selected and ``DSTabItem/icon``
    /// otherwise. The icon scales with the user's Dynamic Type setting.
    private var iconView: some View {
        (isSelected ? tab.selectedIcon : tab.icon)
            .resizable()
            .scaledToFit()
            .frame(
                width: iconSize,
                height: iconSize
            )
    }

    /// The accessibility value associated with the tab's badge.
    ///
    /// Returns an empty value when there is no positive badge count.
    private var badgeAccessibilityValue: Text {
        guard let value = DSTabBarBadge.accessibilityValue(badge) else {
            return Text(verbatim: "")
        }

        return Text(value)
    }
}

// MARK: - Badge Helpers

/// Formatting and accessibility helpers for tab bar badges.
///
/// `DSTabBarBadge` keeps badge-count rules independent from the SwiftUI view,
/// making the same rules reusable and straightforward to unit test.
///
/// The helper defines two representations of a badge count:
///
/// - A visual representation, capped at `99+`.
/// - A localized accessibility representation containing the complete count.
enum DSTabBarBadge {

    /// The highest count displayed numerically inside the badge.
    private static let maxVisibleCount: Int = 99

    /// Creates the localized accessibility value for a badge count.
    ///
    /// The returned string is resolved through `Localizable.stringsdict` using
    /// the `tabBarBadgeValue` key, allowing the localization system to apply
    /// the appropriate pluralization rules.
    ///
    /// Counts that are `nil` or less than or equal to zero do not produce an
    /// accessibility value.
    ///
    /// - Parameter count: The badge count.
    /// - Returns: A localized accessibility string, or `nil` when the badge
    ///   should not be announced.
    static func accessibilityValue(_ count: Int?) -> String? {
        guard let count, count > 0 else {
            return nil
        }

        let format = NSLocalizedString(
            "tabBarBadgeValue",
            bundle: .module,
            comment: "Tab bar badge count announced by VoiceOver"
        )

        return String(format: format, count)
    }

    /// Creates the text displayed inside the badge.
    ///
    /// Positive counts up to `99` are displayed as their numeric value.
    /// Counts greater than `99` are displayed as `99+`.
    ///
    /// `nil` and non-positive values return `nil`, indicating that the badge
    /// should not be rendered.
    ///
    /// - Parameter count: The badge count.
    /// - Returns: The visual badge text, or `nil` when no badge should be shown.
    static func displayText(_ count: Int?) -> String? {
        guard let count, count > 0 else {
            return nil
        }

        return count > maxVisibleCount
            ? "\(maxVisibleCount)+"
            : "\(count)"
    }
}
