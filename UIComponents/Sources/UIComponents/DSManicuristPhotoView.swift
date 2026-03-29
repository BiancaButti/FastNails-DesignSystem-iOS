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

    /// - Parameters:
    ///   - size: Diameter of the avatar. Clamped to a minimum of 0.
    ///   - accessibilityLabel: Optional label for VoiceOver. When `nil` the view is decorative and hidden from VoiceOver.
    public init(size: CGFloat, accessibilityLabel: String? = nil) {
        self.size = max(size, 0)
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(Color.appPink.opacity(0.15))
            Image(systemName: "person.fill")
                .font(.system(size: size * 0.45))
                .foregroundStyle(Color.appPink)
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityHidden(accessibilityLabel == nil)
        .accessibilityLabel(accessibilityLabel ?? "")
    }
}
