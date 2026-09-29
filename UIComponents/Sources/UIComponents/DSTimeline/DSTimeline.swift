import SwiftUI

/// A vertical timeline that represents the progress of a sequence of steps.
///
/// `DSTimeline` displays each ``DSTimelineStepItem`` as a node connected by a
/// vertical track. The visual appearance of each node is determined by its
/// ``DSTimelineStepState``:
///
/// - `pending`: a neutral, inactive step.
/// - `current`: the active step, highlighted with a continuous pulse.
/// - `completed`: a completed step highlighted with the confirmation color.
///
/// The timeline automatically animates changes to a step's state using a spring
/// animation. The current step also displays a continuous pulse to draw
/// attention to the active point in the process.
///
/// ## Example
///
/// ```swift
/// DSTimeline(
///     steps: [
///         DSTimelineStepItem(
///             id: "requested",
///             title: "Solicitação enviada",
///             subtitle: "Aguardando confirmação",
///             state: .completed
///         ),
///         DSTimelineStepItem(
///             id: "confirmed",
///             title: "Agendamento confirmado",
///             subtitle: "Sexta, 28/08 às 14:00",
///             state: .current
///         ),
///         DSTimelineStepItem(
///             id: "finished",
///             title: "Atendimento",
///             state: .pending
///         )
///     ]
/// )
/// ```
///
/// ## Layout
///
/// Steps are displayed vertically in the order provided by `steps`.
/// Every step reserves a fixed node slot, keeping the timeline aligned when
/// node sizes change between states.
///
/// The connecting track is displayed between consecutive steps. A completed
/// connection is filled using the confirmation color; otherwise it remains
/// neutral.
///
/// ## Animation
///
/// State changes use a spring animation so that node size, color, and track
/// changes transition smoothly.
///
/// The current node has an independent continuous pulse animation. The pulse
/// is started when the timeline appears and runs for as long as the view is
/// displayed.
///
/// - Important: The order of `steps` determines the visual order of the
///   timeline. Each step should have a stable identifier so SwiftUI can
///   correctly track changes between updates.
public struct DSTimeline: View {

    /// Controls the continuous pulse animation of the current step.
    @State private var isPulsing = false

    /// The ordered steps displayed by the timeline.
    private let steps: [DSTimelineStepItem]

    /// Creates a timeline from an ordered collection of steps.
    ///
    /// - Parameter steps: The steps to display, in their visual order.
    public init(steps: [DSTimelineStepItem]) {
        self.steps = steps
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                let isLast = index == steps.count - 1

                HStack(alignment: .top, spacing: DSSpacing.lg) {
                    VStack(spacing: .zero) {
                        nodeView(for: step.state)
                            .frame(
                                width: DSTimelineMetrics.nodeSlot,
                                height: DSTimelineMetrics.nodeSlot
                            )

                        if !isLast {
                            trackLineView(
                                currentState: step.state,
                                nextState: steps[index + 1].state
                            )
                        }
                    }

                    VStack(alignment: .leading, spacing: DSSpacing.xs) {
                        Text(step.title)
                            .font(
                                step.state == .pending
                                    ? DSFont.fieldLabel
                                    : DSFont.descriptionBold
                            )
                            .foregroundStyle(
                                step.state == .pending
                                    ? DSColor.text
                                    : DSColor.ink
                            )

                        if let subtitle = step.subtitle {
                            Text(subtitle)
                                .font(DSFont.caption)
                                .foregroundStyle(DSColor.ink60)
                                .transition(
                                    .opacity.combined(
                                        with: .move(edge: .top)
                                    )
                                )
                        }
                    }
                    .padding(
                        .bottom,
                        isLast ? .zero : DSPadding.regular
                    )
                }
                .animation(
                    .spring(
                        response: DSTimelineMetrics.nodeSpringResponse,
                        dampingFraction: DSTimelineMetrics.nodeSpringDamping
                    ),
                    value: step.state
                )
            }
        }
        .padding(DSPadding.large)
        .background(DSColor.paper)
        .clipShape(
            RoundedRectangle(
                cornerRadius: DSRadius.large,
                style: .continuous
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: DSRadius.large,
                style: .continuous
            )
            .stroke(
                DSColor.line,
                lineWidth: DSTimelineMetrics.borderWidth
            )
        )
        .environment(\.colorScheme, .light)
        .onAppear {
            withAnimation(
                .linear(
                    duration: DSTimelineMetrics.pulseDuration
                )
                .repeatForever(autoreverses: true)
            ) {
                isPulsing = true
            }
        }
    }
}

private extension DSTimeline {

    // MARK: - Node

    /// Renders the visual node associated with a step state.
    ///
    /// The node keeps the same view hierarchy for every state so SwiftUI can
    /// animate changes to its size, color, and pulse without replacing the
    /// underlying view.
    @ViewBuilder
    private func nodeView(
        for state: DSTimelineStepState
    ) -> some View {
        ZStack {
            Circle()
                .fill(
                    DSColor.enamel.opacity(
                        DSTimelineMetrics.haloFillOpacity
                    )
                )
                .frame(
                    width: DSTimelineMetrics.currentHalo,
                    height: DSTimelineMetrics.currentHalo
                )
                .scaleEffect(
                    state == .current && isPulsing
                        ? DSTimelineMetrics.pulseScaleMax
                        : DSTimelineMetrics.pulseScaleMin
                )
                .opacity(
                    state == .current && isPulsing
                        ? DSTimelineMetrics.pulseOpacityMin
                        : (state == .current
                           ? DSTimelineMetrics.pulseOpacityMax
                           : 0)
                )

            Circle()
                .fill(nodeColor(for: state))
                .frame(
                    width: nodeSize(for: state),
                    height: nodeSize(for: state)
                )
        }
    }

    /// Returns the node color associated with a step state.
    private func nodeColor(
        for state: DSTimelineStepState
    ) -> Color {
        switch state {
        case .pending:
            return DSColor.line
        case .current:
            return DSColor.enamel
        case .completed:
            return DSColor.confirmed
        }
    }

    /// Returns the node diameter associated with a step state.
    private func nodeSize(
        for state: DSTimelineStepState
    ) -> CGFloat {
        switch state {
        case .pending:
            return DSTimelineMetrics.pendingDot
        case .current:
            return DSTimelineMetrics.currentDot
        case .completed:
            return DSTimelineMetrics.completedDot
        }
    }

    // MARK: - Track

    /// Renders the vertical connection between two consecutive steps.
    ///
    /// The connection is filled when the current step is completed and the
    /// following step has already progressed beyond `pending`.
    @ViewBuilder
    private func trackLineView(
        currentState: DSTimelineStepState,
        nextState: DSTimelineStepState
    ) -> some View {
        let isFilled =
            currentState == .completed
            && nextState != .pending

        ZStack(alignment: .top) {
            Rectangle()
                .fill(DSColor.line)
                .frame(width: DSTimelineMetrics.trackWidth)

            Rectangle()
                .fill(DSColor.confirmed)
                .frame(width: DSTimelineMetrics.trackWidth)
                .scaleEffect(
                    y: isFilled ? 1.0 : 0.0,
                    anchor: .top
                )
        }
        .frame(maxHeight: .infinity)
    }
}
