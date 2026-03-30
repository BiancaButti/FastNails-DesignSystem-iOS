import SwiftUI

// MARK: - DSFilterChipItem

/// Modelo de dados para um chip de filtro.
///
/// Construa um array de `DSFilterChipItem` a partir do seu enum de filtros e
/// passe-o para `DSFilterChipsSection`.
///
/// ```swift
/// let chips = SearchFilter.allCases.map { filter in
///     DSFilterChipItem(
///         id: filter.rawValue,
///         label: filter.label,
///         isActive: viewModel.isActive(filter),
///         onTap: { viewModel.toggleFilter(filter) }
///     )
/// }
/// ```
public struct DSFilterChipItem: Identifiable {
    public let id: String
    /// Texto exibido no chip.
    public let label: String
    /// Se `true`, o chip é renderizado no estado ativo (fundo colorido).
    public let isActive: Bool
    /// Ação executada ao tocar no chip.
    public let onTap: () -> Void

    public init(id: String, label: String, isActive: Bool, onTap: @escaping () -> Void) {
        self.id = id
        self.label = label
        self.isActive = isActive
        self.onTap = onTap
    }
}

// MARK: - DSFilterChipView

/// Chip de filtro individual com dois estados visuais: ativo e inativo.
///
/// - Ativo: fundo `theme.brandColor`, texto branco.
/// - Inativo: fundo `systemGray6`, texto primário.
///
/// ```swift
/// DSFilterChipView(label: "Rating", isActive: true)  { toggle() }
/// DSFilterChipView(label: "Preço",  isActive: false) { toggle() }
/// ```
///
/// ## Acessibilidade
/// O chip é um botão com label legível pelo VoiceOver e o trait
/// `.isSelected` reflete o estado ativo.
///
/// - SeeAlso: `DSFilterChipsSection`, `DSFilterChipItem`
public struct DSFilterChipView: View {

    /// Texto exibido no chip.
    let label: String
    /// Estado ativo do chip.
    let isActive: Bool
    /// Ação executada ao tocar.
    let action: () -> Void

    @Environment(\.dsTheme) private var theme

    /// Cria um `DSFilterChipView`.
    /// - Parameters:
    ///   - label: Texto do chip.
    ///   - isActive: `true` para estado selecionado.
    ///   - action: Closure chamada ao tocar.
    public init(label: String, isActive: Bool, action: @escaping () -> Void) {
        self.label = label
        self.isActive = isActive
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(label)
                .font(theme.feedbackFont)
                .fontWeight(isActive ? .semibold : .regular)
                .foregroundStyle(isActive ? .white : Color.primary)
                .padding(.horizontal, DSSpacing.md)
                .padding(.vertical, DSSpacing.sm)
                .background(isActive ? theme.brandColor : Color(.systemGray6))
                .clipShape(Capsule())
        }
        .accessibilityLabel(label)
        .accessibilityAddTraits(isActive ? [.isSelected] : [])
        .animation(.easeInOut(duration: 0.15), value: isActive)
    }
}
