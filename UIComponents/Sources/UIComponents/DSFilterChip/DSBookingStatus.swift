import SwiftUI
 
// MARK: - Status
 
/// The state of a booking, as shown to the person who made it.
///
/// The cycle has **three states** — requested, confirmed, finished. An
/// "in progress" state was considered and dropped: there is no way to know
/// how long an appointment runs, nor who would mark its start and end.
///
/// Cancellation is not part of the cycle. It interrupts it, and carries who
/// did it and whether the salon had already confirmed — which is what tells
/// "declined" apart from "cancelled".
public enum DSBookingStatus: Equatable {
 
    /// Sent, waiting for the salon to answer.
    case requested
 
    /// The salon confirmed. The slot is held.
    case confirmed
 
    /// The appointment happened.
    case finished
 
    /// The person gave up before the salon confirmed. No cost, nothing held.
    case withdrawn
 
    /// The salon declined before confirming.
    case declined
 
    /// Cancelled after the salon had confirmed.
    case cancelled(by: DSCancelledBy)
}
 
public enum DSCancelledBy: Equatable {
    case customer
    case salon
}
 
// MARK: - Appearance
//
// Plain Swift: the rules live here, the view only lays out.
 
struct DSStatusAppearance {
 
    let background: Color
    let foreground: Color
 
    init(status: DSBookingStatus, theme: DSTheme) {
        switch status {
 
        case .requested:
            // Waiting is neither good nor bad. Neutral, but not the same
            // neutral as finished — a pending booking still needs attention.
            background = theme.warningColor.opacity(0.14)
            foreground = theme.warningColor
 
        case .confirmed:
            background = theme.successColor.opacity(0.14)
            foreground = theme.successColor
 
        case .finished:
            // Back to neutral: it already happened, it no longer needs to
            // ask for attention.
            background = theme.secondaryColor.opacity(0.14)
            foreground = theme.secondaryColor
 
        case .withdrawn:
            // The person's own choice, with no consequence. Neutral, not red.
            background = theme.secondaryColor.opacity(0.14)
            foreground = theme.secondaryColor
 
        case .declined, .cancelled:
            background = theme.errorColor.opacity(0.12)
            foreground = theme.errorColor
        }
    }
}
