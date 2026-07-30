import SwiftUI

/// Botão de login social (Apple / Google) com aparência ditada pela marca do provedor.
///
/// Ao contrário dos demais componentes, este **não** usa o `DSTheme` da marca do app:
/// Apple e Google exigem cores próprias nos seus botões. O componente apenas escolhe a
/// variante correta para o `colorScheme` atual (claro/escuro) e aplica um retângulo
/// arredondado cujo raio você pode ajustar para casar com o resto da sua UI.
///
/// O **logo** entra por parâmetro (`Image`) para que você use a **arte oficial** de cada
/// provedor — a lib nunca recria os logos:
/// - Apple: pode usar o SF Symbol `Image(systemName: "apple.logo")` (ele é monocromático e
///   é tingido automaticamente na cor do texto).
/// - Google: use o "G" oficial de 4 cores (baixado do Google) — ele é renderizado com as
///   cores originais, sem tingimento.
///
/// ```swift
/// DSSocialButton(
///     style: .apple,
///     title: "Continuar com a Apple",
///     logo: Image(systemName: "apple.logo")
/// ) {
///     // dispara o fluxo Sign in with Apple
/// }
/// ```
///
/// ## Acessibilidade
/// O `title` é usado como `accessibilityLabel`.
public struct DSSocialButton: View {

    /// Provedor social, que determina as cores da marca em claro/escuro.
    public enum Style {
        case apple
        case google
    }

    private let style: Style
    private let title: String
    private let logo: Image
    private let cornerRadius: CGFloat
    private let action: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    /// Cria um `DSSocialButton`.
    /// - Parameters:
    ///   - style: Provedor (`.apple` ou `.google`) — define as cores da marca.
    ///   - title: Texto do botão (ex.: "Continuar com a Apple"). Também é o `accessibilityLabel`.
    ///   - logo: Arte oficial do provedor. Para Apple, `Image(systemName: "apple.logo")` serve.
    ///   - cornerRadius: Raio do retângulo arredondado. Padrão: `DSRadius.lg` (12).
    ///   - action: Ação executada ao tocar.
    public init(
        style: Style,
        title: String,
        logo: Image,
        cornerRadius: CGFloat = DSRadius.lg,
        action: @escaping () -> Void
    ) {
        self.style = style
        self.title = title
        self.logo = logo
        self.cornerRadius = cornerRadius
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: DSSpacing.sm) {
                logoView
                Text(title)
                    .font(.system(size: 16, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 1)
            )
        }
        .accessibilityLabel(title)
    }

    // MARK: - Logo

    @ViewBuilder
    private var logoView: some View {
        switch style {
        case .apple:
            // Monocromático: acompanha a cor do texto (branco no preto, preto no branco).
            logo
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 17, height: 17)
                .foregroundStyle(foregroundColor)
        case .google:
            // O "G" oficial mantém as 4 cores — nunca tingir.
            logo
                .resizable()
                .renderingMode(.original)
                .scaledToFit()
                .frame(width: 18, height: 18)
        }
    }

    // MARK: - Brand colors (claro / escuro)

    private var backgroundColor: Color {
        switch style {
        case .apple:
            return colorScheme == .dark ? .white : .black
        case .google:
            return colorScheme == .dark
                ? Color(red: 0.075, green: 0.075, blue: 0.078)   // #131314
                : .white
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .apple:
            return colorScheme == .dark ? .black : .white
        case .google:
            return colorScheme == .dark
                ? .white
                : Color(red: 0.122, green: 0.122, blue: 0.122)   // #1F1F1F
        }
    }

    private var borderColor: Color {
        switch style {
        case .apple:
            return .clear
        case .google:
            return colorScheme == .dark
                ? Color.white.opacity(0.18)
                : Color(red: 0.855, green: 0.863, blue: 0.878)   // #DADCE0
        }
    }
}
