import SwiftUI

// MARK: - Status

/// Represents the booking status shown to the person who created the booking.
///
/// `DSBookingStatusBadge` describes the lifecycle of a booking and the
/// cancellation outcomes that can interrupt that lifecycle.
///
/// The normal booking lifecycle is:
///
/// `requested` → `confirmed` → `finished`
///
/// A booking can also end before confirmation through `withdrawn` or
/// `declined`, or be cancelled after confirmation through `cancelled(by:)`.
///
/// Cancellation retains information about who cancelled the booking through
/// ``DSCancelledBy``.
///
/// ## Lifecycle
///
/// - `requested`: The booking request was submitted and is awaiting a
///   response from the salon.
/// - `confirmed`: The salon accepted the booking and the requested slot is
///   confirmed.
/// - `finished`: The scheduled appointment has taken place.
/// - `withdrawn`: The customer withdrew the request before the salon
///   confirmed it.
/// - `declined`: The salon declined the request before confirming it.
/// - `cancelled(by:)`: The booking was cancelled after confirmation.
///
/// - Important: `withdrawn` and `declined` represent outcomes that occur
///   before confirmation, while `cancelled(by:)` represents a cancellation
///   after confirmation.
public enum DSBookingStatusBadge: Equatable {

    /// The booking request was submitted and is waiting for the salon to
    /// respond.
    case requested

    /// The salon confirmed the booking and the requested slot is held.
    case confirmed

    /// The appointment has taken place.
    case finished

    /// The customer withdrew the request before the salon confirmed it.
    case withdrawn

    /// The salon declined the request before confirming it.
    case declined

    /// The booking was cancelled after the salon had confirmed it.
    ///
    /// - Parameter by: The party that cancelled the confirmed booking.
    case cancelled(by: DSCancelledBy)
}

/// Identifies the party responsible for cancelling a confirmed booking.
public enum DSCancelledBy: Equatable {

    /// The customer cancelled the booking.
    case customer

    /// The salon cancelled the booking.
    case salon
}

// MARK: - Appearance

/// Defines the semantic colors associated with a booking status.
///
/// `DSStatusAppearance` keeps status-to-color mapping separate from the
/// presentation layer. Views such as ``DSStatusBadge`` can therefore use the
/// resolved colors without containing the business rules that determine them.
///
/// The appearance consists of a background tint and a foreground color.
///
/// - Note: The colors are resolved from the provided ``DSTheme`` so the status
///   appearance remains consistent with the application's Design System.
struct DSStatusAppearance {

    /// The background color used to represent the status.
    let background: Color

    /// The foreground color used for status text and indicators.
    let foreground: Color

    /// Creates the semantic appearance for a booking status.
    ///
    /// - Parameters:
    ///   - status: The booking status whose appearance should be resolved.
    ///   - theme: The Design System theme providing the semantic status colors.
    init(
        status: DSBookingStatusBadge,
        theme: DSTheme
    ) {
        switch status {

        case .requested:
            background = theme.warningColor.opacity(0.14)
            foreground = theme.warningColor

        case .confirmed:
            background = theme.successColor.opacity(0.14)
            foreground = theme.successColor

        case .finished:
            background = theme.secondaryColor.opacity(0.14)
            foreground = theme.secondaryColor

        case .withdrawn:
            background = theme.secondaryColor.opacity(0.14)
            foreground = theme.secondaryColor

        case .declined, .cancelled:
            background = theme.errorColor.opacity(0.12)
            foreground = theme.errorColor
        }
    }
}
