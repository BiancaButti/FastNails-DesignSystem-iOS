import SwiftUI

/// A dynamic status tracker timeline component with continuous pulse animation for the Fast Nails Design System.
public struct DSTimeline: View {
    // Internal animation trigger for the continuous heartbeat pulse
    @State private var isPulsing = false
    
    private let steps: [DSTimelineStepItem]
    
    public init(steps: [DSTimelineStepItem]) {
        self.steps = steps
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                let isLast = index == steps.count - 1
                
                HStack(alignment: .top, spacing: DSSpacing.lg) {
                    // Vertical Indicator Column (Node + Track Line)
                    VStack(spacing: 0) {
                        nodeView(for: step.state)
                        // A constant slot keeps every state's dot centered on
                        // the same point, so changing state never shifts the
                        // node or the track line.
                            .frame(width: DSTimelineMetrics.nodeSlot,
                                   height: DSTimelineMetrics.nodeSlot)
                            .animation(.spring(response: DSTimelineMetrics.nodeSpringResponse,
                                               dampingFraction: DSTimelineMetrics.nodeSpringDamping),
                                       value: step.state)
                        
                        if !isLast {
                            trackLineView(
                                currentState: step.state,
                                nextState: steps[index + 1].state
                            )
                        }
                    }
                    
                    // Context Content Column
                    VStack(alignment: .leading, spacing: DSSpacing.xs) {
                        Text(step.title)
                            .font(step.state == .pending ? DSFont.fieldLabel : DSFont.descriptionBold)
                            .foregroundStyle(step.state == .pending ? DSColor.text : DSColor.ink)
                        
                        if let subtitle = step.subtitle {
                            Text(subtitle)
                                .font(DSFont.caption)
                                .foregroundStyle(DSColor.ink60)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(.bottom, isLast ? .zero : DSPadding.regular)
                    .animation(.easeInOut(duration: DSTimelineMetrics.contentFade), value: step.state)
                }
            }
        }
        .padding(DSPadding.large)
        .background(DSColor.paper)
        .clipShape(
            RoundedRectangle(
                cornerRadius: DSRadius.large,
                style: .continuous))
        .overlay(
            RoundedRectangle(
                cornerRadius: DSRadius.large,
                style: .continuous)
                .stroke(DSColor.line, lineWidth: DSTimelineMetrics.borderWidth)
        )
        // Single-appearance lock: the design system is light-only.
        .environment(\.colorScheme, .light)
        // Starts the looping layout clock as soon as the view is mounted
        .onAppear {
            withAnimation(.easeInOut(duration: DSTimelineMetrics.pulseDuration).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
}
private extension DSTimeline {
    // MARK: - Animated Node Element Mapping
    @ViewBuilder
    private func nodeView(for state: DSTimelineStepState) -> some View {
        switch state {
        case .pending:
            Circle()
                .fill(DSColor.line)
                .frame(width: DSTimelineMetrics.pendingDot, height: DSTimelineMetrics.pendingDot)

        case .current:
            ZStack {
                // Expanding continuous background shadow pulse
                Circle()
                    .fill(DSColor.enamel.opacity(DSTimelineMetrics.haloFillOpacity))
                    .frame(width: DSTimelineMetrics.currentHalo, height: DSTimelineMetrics.currentHalo)
                    .scaleEffect(isPulsing ? DSTimelineMetrics.pulseScaleMax : DSTimelineMetrics.pulseScaleMin)
                    .opacity(isPulsing ? DSTimelineMetrics.pulseOpacityMin : DSTimelineMetrics.pulseOpacityMax)

                // Solid center anchor dot
                Circle()
                    .fill(DSColor.enamel)
                    .frame(width: DSTimelineMetrics.currentDot, height: DSTimelineMetrics.currentDot)
            }
            .transition(.scale.combined(with: .opacity))

        case .completed:
            Circle()
                .fill(DSColor.confirmed)
                .frame(width: DSTimelineMetrics.completedDot, height: DSTimelineMetrics.completedDot)
                .transition(.scale)
        }
    }
    
    // MARK: - Animated Track Line Mapping
    
    @ViewBuilder
    private func trackLineView(currentState: DSTimelineStepState, nextState: DSTimelineStepState) -> some View {
        let isFilled = (currentState == .completed && nextState != .pending)
        
        ZStack(alignment: .top) {
            Rectangle()
                .fill(DSColor.line)
                .frame(width: DSTimelineMetrics.trackWidth)

            Rectangle()
                .fill(DSColor.confirmed)
                .frame(width: DSTimelineMetrics.trackWidth)
                .scaleEffect(y: isFilled ? 1.0 : 0.0, anchor: .top)
                .animation(.easeInOut(duration: DSTimelineMetrics.trackFill), value: isFilled)
        }
        .frame(maxHeight: .infinity)
    }
}
