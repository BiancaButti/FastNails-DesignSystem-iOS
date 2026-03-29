import SwiftUI

/// Avatar circular de placeholder para foto de manicure.
///
/// Exibe um ícone `person.fill` sobre um fundo circular rosa translúcido.
/// Pode ser usado como fallback enquanto a imagem real não carrega.
///
/// ```swift
/// // Avatar decorativo (oculto do VoiceOver)
/// DSManicuristPhotoView(size: 64)
///
/// // Avatar com label para VoiceOver
/// DSManicuristPhotoView(size: 64, accessibilityLabel: "Foto de Ana Paula")
/// ```
///
/// ## Acessibilidade
/// Por padrão o componente é **decorativo** e fica oculto do VoiceOver.
/// Passe um valor em `accessibilityLabel` para torná-lo perceptível por leitores de tela.
public struct DSManicuristPhotoView: View {

    /// Diâmetro do avatar em pontos. Valores negativos são tratados como `0`.
    let size: CGFloat
    /// Label lida pelo VoiceOver. `nil` torna o componente decorativo e invisível para leitores de tela.
    var accessibilityLabel: String?
    /// Fator de escala do ícone em relação ao diâmetro. Padrão `0.45` — boa proporção para `person.fill`.
    var iconScale: CGFloat
    @Environment(\.dsTheme) private var theme

    /// - Parameters:
    ///   - size: Diâmetro do avatar. Clamped to a minimum of 0.
    ///   - iconScale: Fator multiplicativo sobre `size` para o tamanho do ícone. Padrão `0.45`.
    ///   - accessibilityLabel: Optional label for VoiceOver. When `nil` the view is decorative and hidden from VoiceOver.
    public init(size: CGFloat, iconScale: CGFloat = 0.45, accessibilityLabel: String? = nil) {
        self.size = max(size, 0)
        self.iconScale = min(max(iconScale, 0.1), 0.9)
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(theme.brandColor.opacity(0.15))
            Image(systemName: "person.fill")
                .font(.system(size: size * iconScale))
                .foregroundStyle(theme.brandColor)
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityHidden(accessibilityLabel == nil)
        .accessibilityLabel(accessibilityLabel ?? "")
    }
}
