import SwiftUI

// MARK: - DSScreenHeader

/// Cabeçalho de tela: um título de destaque com subtítulo, opcionalmente
/// precedido por um ícone.
///
/// Título e subtítulo ficam centralizados, e as cores e a fonte do título vêm do
/// `DSTheme` (`titleColor`, `titleFont`).
///
/// ```swift
/// // Sem ícone
/// DSScreenHeader(
///     title: "Esqueceu a senha?",
///     subtitle: "Digite seu e-mail e enviaremos um código."
/// )
///
/// // Com ícone (ex.: confirmação de envio)
/// DSScreenHeader(
///     systemImage: "envelope.badge",
///     title: "Confira seu e-mail",
///     subtitle: "Se existir uma conta, enviamos um código."
/// )
/// ```
///
/// ## Acessibilidade
/// O ícone é decorativo e fica oculto do VoiceOver. O título recebe o traço de
/// cabeçalho. Quando `accessibilityLabel` é informado, o bloco inteiro vira um
/// elemento único com esse texto — útil para anunciar uma mudança de estado de
/// uma vez só, em vez de em pedaços.
public struct DSScreenHeader: View {

    /// Nome de um SF Symbol exibido acima do título. Opcional.
    let systemImage: String?
    /// Título de destaque.
    let title: String
    /// Texto de apoio abaixo do título.
    let subtitle: String?
    /// Quando informado, agrupa tudo num único elemento acessível com esse texto.
    let accessibilityLabel: String?
    /// Tamanho do ícone.
    let iconSize: CGFloat

    @Environment(\.dsTheme) private var theme

    /// Cria um `DSScreenHeader`.
    /// - Parameters:
    ///   - systemImage: SF Symbol decorativo acima do título. Padrão: nenhum.
    ///   - title: Título de destaque.
    ///   - subtitle: Texto de apoio. Padrão: nenhum.
    ///   - accessibilityLabel: Texto único para o VoiceOver ler o bloco inteiro.
    ///   - iconSize: Tamanho do ícone (padrão 48 pt).
    public init(
        systemImage: String? = nil,
        title: String,
        subtitle: String? = nil,
        accessibilityLabel: String? = nil,
        iconSize: CGFloat = 48
    ) {
        self.systemImage = systemImage
        self.title = title
        self.subtitle = subtitle
        self.accessibilityLabel = accessibilityLabel
        self.iconSize = iconSize
    }

    public var body: some View {
        VStack(spacing: DSSpacing.md) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: iconSize))
                    .foregroundStyle(theme.brandColor)
                    .accessibilityHidden(true)
            }

            Text(title)
                .font(theme.titleFont)
                .foregroundStyle(theme.titleColor)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .modifier(GroupedAccessibility(label: accessibilityLabel))
    }
}

// MARK: - Acessibilidade agrupada

/// Agrupa o cabeçalho num único elemento acessível quando há um rótulo próprio.
/// Sem rótulo, mantém a navegação item a item.
private struct GroupedAccessibility: ViewModifier {
    let label: String?

    func body(content: Content) -> some View {
        if let label {
            content
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(label)
                .accessibilityAddTraits(.isHeader)
        } else {
            content
        }
    }
}
