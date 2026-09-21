import SwiftUI

// MARK: - Models & Enums

/// How much of a ``DSStatusCard`` is shown.
public enum DSStatusCardVariant: Sendable {

    /// The full card: eyebrow, title, details, badge and action buttons.
    case expanded

    /// A tighter layout with reduced padding and no action buttons.
    case compact
}

/// The color emphasis of a ``DSStatusCard``, independent of its layout.
public enum DSStatusCardEmphasis: Sendable, Equatable {

    /// The default appearance, chosen from the variant.
    case standard

    /// Error / cancellation — a dark red surface.
    case critical

    /// A positive, highlighted surface.
    case positive

    /// A muted, light surface for low-urgency states.
    case muted
}

extension DSStatusCardEmphasis {

    /// The emphasis a ``DSStatusCard`` should use.
    ///
    /// An `explicit` emphasis (set via ``SwiftUICore/View/statusCardEmphasis(_:)``)
    /// always wins. When it is `.standard`, the booking `status` drives the
    /// color on its own: `.confirmed` → ``positive`` (green), `.declined` and
    /// `.cancelled` → ``critical`` (red), `.requested` and `.finished` →
    /// ``muted`` (light). Any other status keeps ``standard``.
    ///
    /// - Parameters:
    ///   - explicit: The emphasis explicitly set on the card, or `.standard`.
    ///   - status: The card's booking status, if any.
    /// - Returns: The emphasis to color the card with.
    static func resolved(explicit: DSStatusCardEmphasis,
                         for status: DSBookingStatusBadge?) -> DSStatusCardEmphasis {
        guard explicit == .standard else { return explicit }

        switch status {
        case .confirmed:            return .positive
        case .declined, .cancelled: return .critical
        case .requested, .finished: return .muted
        default:                    return .standard
        }
    }
}

// MARK: - Environment Setup

extension EnvironmentValues {

    /// The variant applied to ``DSStatusCard`` views in this hierarchy.
    @Entry public var statusCardVariant: DSStatusCardVariant = .expanded

    /// The color emphasis applied to ``DSStatusCard`` views in this hierarchy.
    @Entry public var statusCardEmphasis: DSStatusCardEmphasis = .standard
}
