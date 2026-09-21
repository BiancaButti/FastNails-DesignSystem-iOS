import SwiftUI

// MARK: - Models & Enums

/// A status shown by a ``DSStatusCard``: a human-readable label plus the tone
/// that drives its color.
///
/// It keeps meaning (`tone`) separate from wording (`legibleText`), so the same
/// tone can back many labels while the card decides the color in one place.
public struct DSStatusCardIndicator: Hashable, Sendable {

    /// The semantic meaning of a status, mapped to a color by the card.
    public enum Tone: Sendable {

        /// Succeeded / confirmed.
        case positive

        /// Waiting / needs attention, but not an error.
        case pending

        /// Error, declined, or cancelled.
        case critical

        /// Neutral / finished — no longer asking for attention.
        case inactive
    }

    /// The text shown to the person, e.g. "Confirmed by the salon".
    public let legibleText: String

    /// The status meaning, used to pick the color.
    public let tone: Tone

    /// Creates a status indicator.
    ///
    /// - Parameters:
    ///   - legibleText: The text shown to the person.
    ///   - tone: The status meaning that drives its color.
    public init(_ legibleText: String,
                tone: Tone) {
        self.legibleText = legibleText
        self.tone = tone
    }
}

/// How much of a ``DSStatusCard`` is shown.
public enum DSStatusCardVariant: Sendable {

    /// Eyebrow + title + details + badge + actions.
    case expanded

    /// The status becomes the eyebrow with a dot; no actions.
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

// MARK: - Environment Setup

extension EnvironmentValues {

    /// The variant applied to ``DSStatusCard`` views in this hierarchy.
    @Entry public var statusCardVariant: DSStatusCardVariant = .expanded

    /// The color emphasis applied to ``DSStatusCard`` views in this hierarchy.
    @Entry public var statusCardEmphasis: DSStatusCardEmphasis = .standard
}
