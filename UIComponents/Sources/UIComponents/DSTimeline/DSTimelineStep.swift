import SwiftUI

// MARK: - Step State

/// Describes the current state of a step displayed by ``DSTimeline``.
///
/// The state determines how the step's indicator and surrounding timeline
/// track are rendered.
///
/// - `pending`: The step has not been reached yet.
/// - `current`: The step is currently active.
/// - `completed`: The step has already been completed.
public enum DSTimelineStepState: Equatable {

    /// The step has not been reached yet.
    case pending

    /// The step is currently active.
    case current

    /// The step has been completed.
    case completed
}

// MARK: - Step Item

/// A single step displayed by ``DSTimeline``.
///
/// Each item contains the information needed to render one timeline step:
/// a stable identifier, a title, an optional supporting subtitle, and its
/// current state.
///
/// The `id` should remain stable while the timeline is being updated so
/// SwiftUI can correctly preserve the identity of each step and animate
/// state changes.
///
/// ## Example
///
/// ```swift
/// let step = DSTimelineStepItem(
///     id: "confirmation",
///     title: "Appointment confirmed",
///     subtitle: "Your salon has confirmed the booking.",
///     state: .current
/// )
/// ```
///
/// - SeeAlso: ``DSTimeline``
/// - SeeAlso: ``DSTimelineStepState``
public struct DSTimelineStepItem: Identifiable, Equatable {

    /// A stable identifier used by SwiftUI to track the step.
    public let id: String

    /// The primary title displayed for the step.
    public let title: String

    /// Optional supporting text displayed below the title.
    public let subtitle: String?

    /// The current state of the step.
    public let state: DSTimelineStepState

    /// Creates a timeline step.
    ///
    /// - Parameters:
    ///   - id: A stable identifier for the step. Keep this value unchanged
    ///     across timeline updates.
    ///   - title: The primary text displayed for the step.
    ///   - subtitle: Optional supporting text displayed below the title.
    ///   - state: The current state of the step. Defaults to `.pending`.
    public init(
        id: String,
        title: String,
        subtitle: String? = nil,
        state: DSTimelineStepState = .pending
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.state = state
    }
}
