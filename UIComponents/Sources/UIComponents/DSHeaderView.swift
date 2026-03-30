import SwiftUI

/// Cabeçalho de navegação com localização e avatar do usuário.
///
/// Exibe, à esquerda, um ícone de mapa seguido do rótulo de localização e
/// da cidade ativa. À direita, um botão de avatar que dispara `onAvatarTap`.
///
/// ```swift
/// // Cidade obrigatória + rótulos padrão (localizados)
/// DSHeaderView(city: "Rio de Janeiro") { print("avatar tapped") }
///
/// // Strings customizadas
/// DSHeaderView(
///     locationLabel: "Região",
///     city: "Rio de Janeiro",
///     onAvatarTap: { navigateToProfile() }
/// )
/// ```
///
/// ## Acessibilidade
/// - O ícone de mapa é decorativo (`.accessibilityHidden(true)`).
/// - O bloco de localização é colapsado em um único elemento com label composta.
/// - O avatar é um botão com `accessibilityLabel` configurável.
///
/// - SeeAlso: `DSTheme`, `DSSpacing`
public struct DSHeaderView: View {

    /// Rótulo acima da cidade (ex.: "Sua localização").
    var locationLabel: String
    /// Nome da cidade exibida em destaque.
    var city: String
    /// Label do VoiceOver para o botão de avatar.
    var avatarAccessibilityLabel: String
    /// Ação executada ao tocar no avatar.
    var onAvatarTap: () -> Void

    @Environment(\.dsTheme) private var theme

    /// Cria um `DSHeaderView`.
    /// - Parameters:
    ///   - locationLabel: Rótulo acima da cidade. Padrão: string localizada `"headerLocationLabel"`.
    ///   - city: Nome da cidade exibida no cabeçalho (obrigatório).
    ///   - avatarAccessibilityLabel: Label do VoiceOver para o avatar. Padrão: `"headerAvatarAccessibility"`.
    ///   - onAvatarTap: Closure chamada ao tocar no botão de avatar.
    public init(
        locationLabel: String? = nil,
        city: String,
        avatarAccessibilityLabel: String? = nil,
        onAvatarTap: @escaping () -> Void = {}
    ) {
        self.locationLabel = locationLabel ?? String(localized: "headerLocationLabel", bundle: .module)
        self.city = city
        self.avatarAccessibilityLabel = avatarAccessibilityLabel ?? String(localized: "headerAvatarAccessibility", bundle: .module)
        self.onAvatarTap = onAvatarTap
    }

    public var body: some View {
        HStack {
            locationSection
            Spacer()
            avatarButton
        }
        .padding(.horizontal, DSSpacing.lg)
        .padding(.top, DSSpacing.lg)
        .padding(.bottom, DSSpacing.sm)
    }
}

// MARK: - Subviews

private extension DSHeaderView {

    var locationSection: some View {
        HStack(spacing: DSSpacing.sm) {
            Image(systemName: "mappin.circle.fill")
                .foregroundStyle(theme.brandColor)
                .font(theme.feedbackFont)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: DSSpacing.xs / 2) {
                Text(locationLabel)
                    .font(theme.captionFont)
                    .foregroundStyle(.secondary)
                Text(city)
                    .font(theme.labelFont)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(locationLabel): \(city)")
    }

    var avatarButton: some View {
        Button(action: onAvatarTap) {
            Image(systemName: "person.circle.fill")
                .font(.title2)
                .foregroundStyle(theme.brandColor)
        }
        .accessibilityLabel(avatarAccessibilityLabel)
    }
}
