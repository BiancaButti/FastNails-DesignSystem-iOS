import SwiftUI

// MARK: - DSPasswordStrength

/// Nível de força de uma senha.
///
/// Use para classificar a senha do usuário e alimentar o `DSPasswordStrengthBar`.
///
/// ```swift
/// var forca: DSPasswordStrength {
///     switch senha.count {
///     case 0:        return .empty
///     case 1...5:    return .weak
///     case 6...9:    return .medium
///     default:       return .strong
///     }
/// }
/// ```
public enum DSPasswordStrength: Equatable {
    /// Nenhuma senha digitada. A barra fica oculta.
    case empty
    /// Senha fraca (curta ou previsível).
    case weak
    /// Senha de força média.
    case medium
    /// Senha forte.
    case strong

    /// Rótulo textual localizado correspondente ao nível (ex.: "Fraca", "Média", "Forte").
    /// Retorna `""` para `.empty`.
    @available(macOS 12.0, iOS 15.0, *)
    public var label: String {
        switch self {
        case .empty:  return ""
        case .weak:   return String(localized: "passwordStrengthWeak", bundle: .module)
        case .medium: return String(localized: "passwordStrengthMedium", bundle: .module)
        case .strong: return String(localized: "passwordStrengthStrong", bundle: .module)
        }
    }

    /// Cor semântica associada ao nível (`colorDestructive`, `appRating` ou `colorSuccess`).
    @available(macOS 10.15, iOS 13.0, *)
    public var color: Color {
        switch self {
        case .empty:  return .clear
        case .weak:   return .colorDestructive
        case .medium: return .appRating
        case .strong: return .colorSuccess
        }
    }

    /// Número de barras preenchidas (0–3).
    public var filledBars: Int {
        switch self {
        case .empty:  return 0
        case .weak:   return 1
        case .medium: return 2
        case .strong: return 3
        }
    }
}

// MARK: - DSPasswordStrengthBar

/// Barra visual de indicação de força de senha com 3 segmentos animados.
///
/// Exibe de 0 a 3 cápsulas preenchidas (com animação escalonada) e um rótulo
/// textual abaixo. A barra e o rótulo ficam ocultos quando `strength == .empty`.
///
/// ```swift
/// DSPasswordStrengthBar(strength: .medium)
/// // → 2 barras amarelas + "Força da senha: Média"
/// ```
///
/// ## Acessibilidade
/// O componente é lido pelo VoiceOver como um elemento único:
/// "Força da senha: Média" (ou "Forte", "Fraca"). Quando `.empty`, o label de
/// acessibilidade fica em branco.
///
/// - SeeAlso: `DSPasswordStrength`
@available(macOS 12.0, iOS 15.0, *)
public struct DSPasswordStrengthBar: View {

    /// Nível de força a exibir.
    let strength: DSPasswordStrength
    @Environment(\.dsTheme) private var theme

    /// Cria um `DSPasswordStrengthBar`.
    /// - Parameter strength: Nível de força da senha.
    public init(strength: DSPasswordStrength) {
        self.strength = strength
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            HStack(spacing: DSSpacing.xs) {
                ForEach(0..<3, id: \.self) { index in
                    Capsule()
                        .fill(index < strength.filledBars ? strengthColor : Color(uiColor: .systemGray5))
                        .frame(height: 4)
                        .animation(
                            .easeInOut(duration: 0.25).delay(Double(index) * 0.06),
                            value: strength
                        )
                }
            }
            if strength != .empty {
                HStack(spacing: DSSpacing.xs) {
                    Text(String(localized: "passwordStrengthLabel", bundle: .module))
                        .foregroundStyle(.secondary)
                    Text(strength.label)
                        .foregroundStyle(strengthColor)
                        .fontWeight(.medium)
                }
                .font(theme.feedbackFont)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            strength == .empty
                ? ""
                : String(
                    format: String(localized: "passwordStrengthAccessibility", bundle: .module),
                    strength.label
                  )
        )
    }

    private var strengthColor: Color {
        switch strength {
        case .empty:  return .clear
        case .weak:   return theme.errorColor
        case .medium: return theme.ratingColor
        case .strong: return theme.successColor
        }
    }
}
