import SwiftUI

// MARK: - DSIconLabel

/// Um ícone seguido de um texto curto — o par usado para informações de apoio
/// como distância, horário disponível ou faixa de preço.
///
/// Ícone e texto têm cores separadas de propósito: o padrão pinta o ícone com a
/// cor da marca e deixa o texto discreto, mas quando a informação é o destaque
/// da linha (um horário livre, por exemplo) os dois podem usar a mesma cor.
///
/// ```swift
/// // Informação de apoio: ícone colorido, texto discreto
/// DSIconLabel(systemImage: "location.fill", text: "1,2 km")
///
/// // Informação em destaque: texto na mesma cor do ícone
/// DSIconLabel(
///     systemImage: "clock",
///     text: "Livre hoje às 16h",
///     font: .footnote.weight(.semibold),
///     textColor: .accentColor
/// )
/// ```
///
/// ## Acessibilidade
/// O ícone é decorativo e fica oculto do VoiceOver — ele lê apenas o texto, ou o
/// `accessibilityLabel` quando informado (útil quando o texto é abreviado, como
/// "1,2 km" para "a 1,2 quilômetros de você").
public struct DSIconLabel: View {

    /// Nome do SF Symbol exibido antes do texto.
    let systemImage: String
    /// Texto exibido ao lado do ícone.
    let text: String
    /// Fonte aplicada ao par. Padrão: `.caption`.
    var font: Font
    /// Cor do ícone. Quando `nil`, usa a cor da marca do tema.
    var iconColor: Color?
    /// Cor do texto. Quando `nil`, usa `.secondary`.
    var textColor: Color?
    /// Texto lido pelo VoiceOver no lugar de `text`.
    var accessibilityLabel: String?

    @Environment(\.dsTheme) private var theme

    /// Cria um `DSIconLabel`.
    /// - Parameters:
    ///   - systemImage: SF Symbol exibido antes do texto.
    ///   - text: Texto ao lado do ícone.
    ///   - font: Fonte do par (padrão `.caption`).
    ///   - iconColor: Cor do ícone (padrão: cor da marca).
    ///   - textColor: Cor do texto (padrão `.secondary`).
    ///   - accessibilityLabel: Texto alternativo para o VoiceOver.
    public init(
        systemImage: String,
        text: String,
        font: Font = .caption,
        iconColor: Color? = nil,
        textColor: Color? = nil,
        accessibilityLabel: String? = nil
    ) {
        self.systemImage = systemImage
        self.text = text
        self.font = font
        self.iconColor = iconColor
        self.textColor = textColor
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        HStack(spacing: DSSpacing.xs) {
            Image(systemName: systemImage)
                .font(font)
                .foregroundStyle(iconColor ?? theme.brandColor)
                .accessibilityHidden(true)

            Text(text)
                .font(font)
                .foregroundStyle(textColor ?? Color.secondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel ?? text)
    }
}
