import SwiftUI

// MARK: - Models & Enums

/// Defines the layout density of a ``DSStatusCard``.
///
/// The variant controls which parts of the card are displayed and how much
/// spacing is used. It is independent from the card's visual emphasis.
public enum DSStatusCardVariant: Sendable {

    /// Displays the full card layout, including the eyebrow, title, details,
    /// optional status badge, and action buttons.
    case expanded

    /// Displays a more compact card with reduced padding and no action buttons.
    case compact
}

/// Defines the visual emphasis of a ``DSStatusCard``.
///
/// The emphasis controls the semantic color treatment of the card and is
/// independent from its layout variant.
///
/// When `.standard` is used, the card can derive its final emphasis from the
/// booking status. Other values explicitly select the desired appearance.
public enum DSStatusCardEmphasis: Sendable, Equatable {

    /// Uses the default emphasis resolution.
    ///
    /// When no explicit emphasis is provided, the booking status can determine
    /// the final appearance.
    case standard

    /// Uses the critical appearance for error or cancellation states.
    case critical

    /// Uses the positive appearance for successful or confirmed states.
    case positive

    /// Uses a muted appearance for states that require lower visual emphasis.
    case muted
}

// MARK: - Emphasis Resolution

extension DSStatusCardEmphasis {

    /// Resolves the final emphasis used by a ``DSStatusCard``.
    ///
    /// An explicit emphasis always takes precedence over the booking status.
    /// When `explicit` is `.standard`, the status is used to determine the
    /// semantic emphasis:
    ///
    /// - `.confirmed` resolves to `.positive`.
    /// - `.declined` and `.cancelled` resolve to `.critical`.
    /// - `.requested` and `.finished` resolve to `.muted`.
    /// - Other statuses keep `.standard`.
    ///
    /// - Parameters:
    ///   - explicit: The emphasis explicitly configured for the card.
    ///   - status: The optional booking status associated with the card.
    ///
    /// - Returns: The emphasis that should be used to resolve the card's
    ///   visual palette.
    static func resolved(
        explicit: DSStatusCardEmphasis,
        for status: DSBookingStatusBadge?
    ) -> DSStatusCardEmphasis {
        guard explicit == .standard else {
            return explicit
        }

        switch status {
        case .confirmed:
            return .positive

        case .declined, .cancelled:
            return .critical

        case .requested, .finished:
            return .muted

        default:
            return .standard
        }
    }
}

// MARK: - Environment Setup

extension EnvironmentValues {

    /// The layout variant applied to ``DSStatusCard`` instances in the
    /// current view hierarchy.
    ///
    /// The default value is `.expanded`.
    ///
    /// Set this value with ``SwiftUICore/View/statusCardVariant(_:)`` when
    /// multiple status cards in the same hierarchy should share the same
    /// layout configuration.
    @Entry public var statusCardVariant: DSStatusCardVariant = .expanded

    /// The visual emphasis applied to ``DSStatusCard`` instances in the
    /// current view hierarchy.
    ///
    /// The default value is `.standard`. With this value, an individual
    /// ``DSStatusCard`` can derive its emphasis from its booking status.
    ///
    /// Set this value with ``SwiftUICore/View/statusCardEmphasis(_:)`` when
    /// an explicit emphasis should be applied to the cards in a view
    /// hierarchy.
    @Entry public var statusCardEmphasis: DSStatusCardEmphasis = .standard
}
