import SwiftUI

// MARK: - DSStatusCard Component

/// A card that surfaces the state of something (an appointment, a request) with
/// an eyebrow, a title, supporting detail lines, an optional status badge, and
/// optional actions.
///
/// The layout adapts to ``DSStatusCardVariant`` read from the environment:
/// `.expanded` shows a large title and the action buttons, `.compact` shows a
/// smaller title and hides the actions.
///
/// ```swift
/// DSStatusCard(
///     eyebrow: "Your next appointment",
///     title: "Fri, 28/08 · 14:00",
///     details: ["Studio Ana Lima · Hands · R$ 35"],
///     status: DSStatusBadge(title: "Confirmed", status: .confirmed)
/// ) {
///     DSButton(title: "Directions") {}
/// }
/// ```
public struct DSStatusCard<Actions: View>: View {
    /// The layout density, read from the environment via
    /// ``SwiftUICore/View/statusCardVariant(_:)``.
    @Environment(\.statusCardVariant)
    private var variant

    @Environment(\.statusCardEmphasis)
    private var emphasis

    @Environment(\.dsTheme)
    private var theme
    
    /// The uppercase overline shown above the title.
    private let eyebrow: String

    /// The card's headline.
    private let title: String

    /// Supporting lines rendered under the title, one per entry.
    private let details: [String]

    /// The optional status badge, shown as-is under the details.
    private let status: DSStatusBadge?

    /// The action buttons, shown only in the `.expanded` variant.
    private let actions: Actions

    /// Creates a status card.
    ///
    /// - Parameters:
    ///   - eyebrow: The uppercase overline shown above the title.
    ///   - title: The card's headline.
    ///   - details: Supporting lines rendered under the title.
    ///   - status: An optional ready-made ``DSStatusBadge`` to display.
    ///   - actions: The action buttons, shown only when `.expanded`.
    public init(
        eyebrow: String,
        title: String,
        details: [String] = [],
        status: DSStatusBadge? = nil,
        @ViewBuilder actions: () -> Actions
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.details = details
        self.status = status
        self.actions = actions()
    }

    /// The emphasis actually used to color the card.
    ///
    /// An explicit ``SwiftUICore/View/statusCardEmphasis(_:)`` always wins; when
    /// left at `.standard`, the status drives the color on its own — `.confirmed`
    /// promotes the card to the positive (green) appearance, while `.declined`
    /// and `.cancelled` promote it to the critical (red) one.
    private var resolvedEmphasis: DSStatusCardEmphasis {
        guard emphasis == .standard else { return emphasis }

        switch status?.status {
        case .confirmed:            return .positive
        case .declined, .cancelled: return .critical
        case .requested, .finished: return .muted
        default:                    return .standard
        }
    }

    /// Whether the card should render its action row.
    ///
    /// Actions only exist in the `.expanded` variant, and only when the caller
    /// actually passed some — a card built without buttons resolves `Actions` to
    /// `EmptyView`, so the whole row (and its spacing) is dropped, leaving no
    /// empty gap at the bottom.
    private var hasActions: Bool {
        variant == .expanded && Actions.self != EmptyView.self
    }

    public var body: some View {
        let palette = DSStatusCardPalette.resolve(variant, emphasis: resolvedEmphasis)

        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            DSStatusCardEyebrow(eyebrow)
                .foregroundStyle(palette.secondary.opacity(0.7))

            Text(title)
                .font(DSFont.titulo)
                .foregroundStyle(palette.secondary)

            ForEach(details, id: \.self) { line in
                Text(line)
                    .font(DSFont.apoio)
                    .foregroundStyle(palette.secondary)
            }

            if let status {
                status
                    .padding(.top, DSSpacing.xs)
            }

            // Actions only render when there are some (see `hasActions`), so a
            // card without buttons skips the row and its top padding entirely —
            // no empty space is left behind.
            //
            // `ViewThatFits` tries the horizontal row first and, if it would
            // overflow the available width — typically at large Dynamic Type
            // sizes — falls back to stacking the buttons vertically. Both
            // branches share the same filled, full-width button style tinted
            // from the palette.
            if hasActions {
                ViewThatFits {
                    HStack(spacing: DSSpacing.xs) { actions }
                    VStack(spacing: DSSpacing.xs) { actions }
                }
                .buttonStyle(.dsStatusCard(background: palette.actionBackground,
                                           foreground: palette.actionForeground))
                .padding(.top, DSSpacing.sm)
            }
        }
        .padding(variant == .expanded ? DSSpacing.md : DSSpacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(palette.background,
                    in: .rect(cornerRadius: DSRadius.large, style: .continuous))
        .environment(\.colorScheme, palette.isDark ? .dark : .light)
        .accessibilityElement(children: .contain)
    }
}

/// Convenience for a card without action buttons.
public extension DSStatusCard where Actions == EmptyView {

    /// Creates a status card with no actions.
    ///
    /// - Parameters:
    ///   - eyebrow: The uppercase overline shown above the title.
    ///   - title: The card's headline.
    ///   - details: Supporting lines rendered under the title.
    ///   - status: An optional ready-made ``DSStatusBadge`` to display.
    init(
        eyebrow: String,
        title: String,
        details: [String] = [],
        status: DSStatusBadge? = nil) {
        self.init(eyebrow: eyebrow,
                  title: title,
                  details: details,
                  status: status) {
            EmptyView()
        }
    }
}
