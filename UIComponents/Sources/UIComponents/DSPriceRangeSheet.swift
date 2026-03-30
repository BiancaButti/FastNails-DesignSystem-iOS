import SwiftUI

// MARK: - Default formatter (module-private, cached)

private let defaultPriceFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.numberStyle = .currency
    f.locale = Locale.current
    f.maximumFractionDigits = 0
    return f
}()

private func formatCurrency(_ value: Double) -> String {
    defaultPriceFormatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
}

// MARK: - DSPriceSliderRow

/// Linha de controle deslizante com título e valor formatado.
///
/// Exibe um rótulo e o valor atual à direita, seguido de um `Slider` com a
/// cor de marca do tema. O formatador de valor é completamente customizável.
///
/// ```swift
/// DSPriceSliderRow(
///     title: "Preço mínimo",
///     value: $minPrice,
///     range: 0...490,
///     formatValue: { "R$ \(Int($0))" }
/// )
/// ```
///
/// ## Acessibilidade
/// O `Slider` recebe `accessibilityLabel` com o título e `accessibilityValue`
/// com o valor formatado, permitindo leitura completa pelo VoiceOver.
///
/// - SeeAlso: `DSPriceRangeSheet`
public struct DSPriceSliderRow: View {

    /// Rótulo exibido acima do slider.
    let title: String
    /// Binding bidirecional com o valor atual.
    @Binding var value: Double
    /// Intervalo permitido.
    let range: ClosedRange<Double>
    /// Incremento do slider. Padrão: `10`.
    let step: Double
    /// Closure que converte o valor `Double` em string exibível.
    let formatValue: (Double) -> String

    @Environment(\.dsTheme) private var theme

    /// Cria um `DSPriceSliderRow`.
    /// - Parameters:
    ///   - title: Rótulo do slider.
    ///   - value: Binding com o valor.
    ///   - range: Intervalo mínimo/máximo.
    ///   - step: Incremento do slider. Padrão: `10`.
    ///   - formatValue: Closure de formatação. Padrão: formatter de moeda local.
    public init(
        title: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double = 10,
        formatValue: ((Double) -> String)? = nil
    ) {
        self.title = title
        self._value = value
        self.range = range
        self.step = step
        self.formatValue = formatValue ?? formatCurrency
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            HStack {
                Text(title)
                    .font(theme.labelFont)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(formatValue(value))
                    .font(theme.labelFont)
                    .fontWeight(.semibold)
                    .foregroundStyle(theme.brandColor)
            }
            Slider(value: $value, in: range, step: step)
                .tint(theme.brandColor)
                .accessibilityLabel(title)
                .accessibilityValue(formatValue(value))
        }
    }
}

// MARK: - DSPriceRangeSheet

/// Painel deslizante (bottom sheet) para seleção de faixa de preço.
///
/// Apresenta dois `DSPriceSliderRow` (mínimo e máximo) e um `DSPrimaryButton`
/// de confirmação. Apresentado com `.presentationDetents([.medium])`.
///
/// ```swift
/// // Formatação de moeda padrão (locale atual)
/// .sheet(isPresented: $showPriceSheet) {
///     DSPriceRangeSheet(minPrice: $minPrice, maxPrice: $maxPrice) {
///         viewModel.applyPriceFilter()
///     }
/// }
///
/// // Formatação customizada
/// DSPriceRangeSheet(
///     minPrice: $minPrice,
///     maxPrice: $maxPrice,
///     formatValue: { "R$ \(Int($0))" }
/// ) { viewModel.applyPriceFilter() }
/// ```
///
/// ## Acessibilidade
/// - O indicador de arrasto (drag handle) é decorativo e oculto do VoiceOver.
/// - Cada slider tem label e valor lidos pelo VoiceOver.
/// - O botão de aplicar recebe um `accessibilityHint` configurável.
///
/// - SeeAlso: `DSPriceSliderRow`, `DSPrimaryButton`
public struct DSPriceRangeSheet: View {

    /// Binding para o valor mínimo.
    @Binding var minPrice: Double
    /// Binding para o valor máximo.
    @Binding var maxPrice: Double
    /// Intervalo do slider mínimo. Padrão: `0...490`.
    let minRange: ClosedRange<Double>
    /// Intervalo do slider máximo. Padrão: `10...500`.
    let maxRange: ClosedRange<Double>
    /// Incremento dos sliders. Padrão: `10`.
    let step: Double
    /// Closure de formatação de valor. Padrão: formatter de moeda local.
    let formatValue: (Double) -> String
    /// Título exibido no topo do painel.
    let title: String
    /// Rótulo do slider mínimo.
    let minLabel: String
    /// Rótulo do slider máximo.
    let maxLabel: String
    /// Título do botão de confirmação.
    let applyTitle: String
    /// Hint de acessibilidade do botão de confirmação.
    let applyAccessibilityHint: String
    /// Ação executada ao confirmar. O dismiss é chamado automaticamente.
    let onApply: () -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.dsTheme) private var theme

    /// Cria um `DSPriceRangeSheet`.
    /// - Parameters:
    ///   - minPrice: Binding do valor mínimo.
    ///   - maxPrice: Binding do valor máximo.
    ///   - minRange: Intervalo do slider mínimo. Padrão: `0...490`.
    ///   - maxRange: Intervalo do slider máximo. Padrão: `10...500`.
    ///   - step: Incremento dos sliders. Padrão: `10`.
    ///   - formatValue: Formatador. Padrão: moeda local via `NumberFormatter`.
    ///   - title: Título do painel. Padrão: `"priceSheetTitle"` localizado.
    ///   - minLabel: Rótulo do mínimo. Padrão: `"priceSheetMin"` localizado.
    ///   - maxLabel: Rótulo do máximo. Padrão: `"priceSheetMax"` localizado.
    ///   - applyTitle: Título do botão. Padrão: `"priceSheetApply"` localizado.
    ///   - applyAccessibilityHint: Hint do botão. Padrão: `"priceSheetApplyHint"` localizado.
    ///   - onApply: Ação executada ao confirmar.
    public init(
        minPrice: Binding<Double>,
        maxPrice: Binding<Double>,
        minRange: ClosedRange<Double> = 0...490,
        maxRange: ClosedRange<Double> = 10...500,
        step: Double = 10,
        formatValue: ((Double) -> String)? = nil,
        title: String? = nil,
        minLabel: String? = nil,
        maxLabel: String? = nil,
        applyTitle: String? = nil,
        applyAccessibilityHint: String? = nil,
        onApply: @escaping () -> Void
    ) {
        self._minPrice = minPrice
        self._maxPrice = maxPrice
        self.minRange = minRange
        self.maxRange = maxRange
        self.step = step
        self.formatValue = formatValue ?? formatCurrency
        self.title = title ?? String(localized: "priceSheetTitle", bundle: .module)
        self.minLabel = minLabel ?? String(localized: "priceSheetMin", bundle: .module)
        self.maxLabel = maxLabel ?? String(localized: "priceSheetMax", bundle: .module)
        self.applyTitle = applyTitle ?? String(localized: "priceSheetApply", bundle: .module)
        self.applyAccessibilityHint = applyAccessibilityHint ?? String(localized: "priceSheetApplyHint", bundle: .module)
        self.onApply = onApply
    }

    public var body: some View {
        VStack(spacing: DSSpacing.xl) {
            dragHandle

            Text(title)
                .font(theme.buttonFont)

            VStack(spacing: DSSpacing.xl) {
                DSPriceSliderRow(
                    title: minLabel,
                    value: $minPrice,
                    range: minRange,
                    step: step,
                    formatValue: formatValue
                )
                .onChange(of: minPrice) { newMin in
                    if newMin > maxPrice { maxPrice = newMin }
                }
                DSPriceSliderRow(
                    title: maxLabel,
                    value: $maxPrice,
                    range: maxRange,
                    step: step,
                    formatValue: formatValue
                )
                .onChange(of: maxPrice) { newMax in
                    if newMax < minPrice { minPrice = newMax }
                }
            }
            .padding(.horizontal, DSSpacing.lg)

            DSPrimaryButton(
                title: applyTitle,
                accessibilityHint: applyAccessibilityHint
            ) {
                onApply()
                dismiss()
            }
            .padding(.horizontal, DSSpacing.lg)
            .padding(.bottom, DSSpacing.xl)
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Drag handle (private)

private extension DSPriceRangeSheet {
    var dragHandle: some View {
        Capsule()
            .fill(dragHandleColor)
            .frame(width: 36, height: DSSpacing.xs)
            .padding(.top, DSSpacing.sm)
            .accessibilityHidden(true)
    }

    var dragHandleColor: Color {
        #if canImport(UIKit)
        Color(UIColor.systemGray4)
        #else
        Color.secondary.opacity(0.4)
        #endif
    }
}
