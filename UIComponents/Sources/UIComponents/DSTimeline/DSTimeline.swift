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
        VStack(alignment: .leading, spacing: .zero) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                let isLast = index == steps.count - 1
                
                HStack(alignment: .top, spacing: DSSpacing.lg) {
                    // Vertical Indicator Column (Node + Track Line)
                    VStack(spacing: .zero) {
                        nodeView(for: step.state)
                        // A constante slot mantém o centro estável evitando jittering nas quinas
                            .frame(width: DSTimelineMetrics.nodeSlot,
                                   height: DSTimelineMetrics.nodeSlot)
                            // Removido o modificador interno antigo de animação daqui
                        
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
                }
                // Centralizado o gatilho de animação de estado no bloco de linha completo
                .animation(.spring(response: DSTimelineMetrics.nodeSpringResponse,
                                   dampingFraction: DSTimelineMetrics.nodeSpringDamping), value: step.state)
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
        .environment(\.colorScheme, .light)
        .onAppear {
            // O uso de linear com repetição infinita evita soluços de parada
            withAnimation(.linear(duration: DSTimelineMetrics.pulseDuration).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
}

private extension DSTimeline {
    
    // MARK: - Animated Node Element Mapping
    
    /// Renders a single identity container structure.
    /// Properties mutate smoothly instead of recreating views via switch.
    @ViewBuilder
    private func nodeView(for state: DSTimelineStepState) -> some View {
        ZStack {
            // 1. Halo de pulso (Apenas visível se for .current)
            Circle()
                .fill(DSColor.enamel.opacity(DSTimelineMetrics.haloFillOpacity))
                .frame(width: DSTimelineMetrics.currentHalo, height: DSTimelineMetrics.currentHalo)
                .scaleEffect(state == .current && isPulsing ? DSTimelineMetrics.pulseScaleMax : DSTimelineMetrics.pulseScaleMin)
                .opacity(state == .current && isPulsing ? DSTimelineMetrics.pulseOpacityMin : (state == .current ? DSTimelineMetrics.pulseOpacityMax : 0))
            
            // 2. Bolinha Central Estável (Muda de cor e tamanho suavemente)
            Circle()
                .fill(nodeColor(for: state))
                .frame(width: nodeSize(for: state), height: nodeSize(for: state))
        }
    }
    
    private func nodeColor(for state: DSTimelineStepState) -> Color {
        switch state {
        case .pending: return DSColor.line
        case .current: return DSColor.enamel
        case .completed: return DSColor.confirmed
        }
    }
    
    private func nodeSize(for state: DSTimelineStepState) -> CGFloat {
        switch state {
        case .pending: return DSTimelineMetrics.pendingDot
        case .current: return DSTimelineMetrics.currentDot
        case .completed: return DSTimelineMetrics.completedDot
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
        }
        .frame(maxHeight: .infinity)
    }
}
