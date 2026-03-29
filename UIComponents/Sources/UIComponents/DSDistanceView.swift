import SwiftUI

/// Indicador de distância com ícone de localização e texto formatado.
///
/// Por padrão é **decorativo** e fica oculto do VoiceOver — ideal para uso
/// dentro de cards que já expõem a distância em seu próprio `accessibilityLabel`.
/// Passe um `accessibilityLabel` para torná-lo perceptível por leitores de tela.
///
/// ```swift
/// // Decorativo (oculto do VoiceOver) — uso típico em cards
/// DSDistanceView(distance: manicurist.formattedDistance)
///
/// // Acessível (ex.: uso fora de um card)
/// DSDistanceView(
///     distance: manicurist.formattedDistance,
///     accessibilityLabel: "A 2,5 km de você"
/// )
/// ```
///
/// - SeeAlso: `DSTheme`
public struct DSDistanceView: View {

    /// Texto de distância já formatado (ex.: `"2,5 km"`).
    let distance: String
    /// Label lida pelo VoiceOver. `nil` torna o componente decorativo e invisível.
    var accessibilityLabel: String?

    @Environment(\.dsTheme) private var theme

    /// Cria um `DSDistanceView`.
    /// - Parameters:
    ///   - distance: Distância pré-formatada a exibir.
    ///   - accessibilityLabel: Label VoiceOver. Quando `nil` (padrão) o componente é decorativo.
    public init(distance: String, accessibilityLabel: String? = nil) {
        self.distance = distance
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        HStack(spacing: DSSpacing.xs) {
            Image(systemName: "location.fill")
                .foregroundStyle(theme.brandColor)
                .font(theme.captionFont)
                .accessibilityHidden(true)

            Text(distance)
                .font(theme.captionFont)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityHidden(accessibilityLabel == nil)
        .accessibilityLabel(accessibilityLabel ?? "")
    }
}
