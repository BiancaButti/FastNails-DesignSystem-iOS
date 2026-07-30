import SwiftUI
import UIComponents

@main
struct CatalogDemoApp: App {
    var body: some Scene {
        WindowGroup {
            CatalogDemoRootView()
        }
    }
}

// MARK: - Tema do catálogo

/// Coral da marca (aprox. #D9856A) para testar o rebrand ao vivo no catálogo.
private let fastNailsCoral = Color(red: 0.851, green: 0.522, blue: 0.416)

private enum CatalogBrand: String, CaseIterable, Identifiable {
    case pink = "appPink"
    case coral = "Coral"
    var id: String { rawValue }
    var color: Color? { self == .coral ? fastNailsCoral : nil }
}

// MARK: - Item

private struct CatalogDemoItem: Identifiable {
    let id: String
    let title: String
    let summary: String
    let content: AnyView
}

// MARK: - Root

private struct CatalogDemoRootView: View {
    @State private var brand: CatalogBrand = .pink

    private let items: [CatalogDemoItem] = [
        CatalogDemoItem(id: "primaryButton", title: "DSPrimaryButton", summary: "Botão principal — estados e cores", content: AnyView(PrimaryButtonShowcase())),
        CatalogDemoItem(id: "socialButton", title: "DSSocialButton", summary: "Login social Apple/Google (claro e escuro)", content: AnyView(SocialButtonShowcase())),
        CatalogDemoItem(id: "formTextField", title: "DSFormTextField", summary: "Campo de texto (custom e nativo)", content: AnyView(FormTextFieldShowcase())),
        CatalogDemoItem(id: "formSecureField", title: "DSFormSecureField", summary: "Campo seguro + força de senha", content: AnyView(FormSecureFieldShowcase())),
        CatalogDemoItem(id: "otpField", title: "DSOTPField", summary: "Código de verificação", content: AnyView(OTPFieldShowcase())),
        CatalogDemoItem(id: "passwordStrengthBar", title: "DSPasswordStrengthBar", summary: "Força da senha", content: AnyView(PasswordStrengthBarShowcase())),
        CatalogDemoItem(id: "searchField", title: "DSSearchFieldView", summary: "Campo de busca", content: AnyView(SearchFieldShowcase())),
        CatalogDemoItem(id: "filterChips", title: "DSFilterChips", summary: "Chip e seção de filtros", content: AnyView(FilterChipsShowcase())),
        CatalogDemoItem(id: "categories", title: "DSCategoriesSection", summary: "Grade de categorias", content: AnyView(CategoriesShowcase())),
        CatalogDemoItem(id: "priceSlider", title: "DSPriceSliderRow", summary: "Slider de orçamento", content: AnyView(PriceSliderShowcase())),
        CatalogDemoItem(id: "header", title: "DSHeaderView", summary: "Cabeçalho com localização e avatar", content: AnyView(DSHeaderView(city: "São Paulo"))),
        CatalogDemoItem(id: "ratingView", title: "DSRatingView", summary: "Avaliação (compacta e expandida)", content: AnyView(RatingViewShowcase())),
        CatalogDemoItem(id: "distanceView", title: "DSDistanceView", summary: "Distância até a profissional", content: AnyView(DistanceShowcase())),
        CatalogDemoItem(id: "statusBadgeView", title: "DSStatusBadgeView", summary: "Badge de status", content: AnyView(StatusBadgeViewShowcase())),
        CatalogDemoItem(id: "manicuristPhotoView", title: "DSManicuristPhotoView", summary: "Avatar de profissional", content: AnyView(ManicuristPhotoShowcase())),
        CatalogDemoItem(id: "orDivider", title: "DSOrDivider", summary: "Divisor com texto", content: AnyView(DSOrDivider(label: "ou"))),
        CatalogDemoItem(id: "feedbackLabel", title: "DSFeedback / Error / Success", summary: "Mensagens de validação", content: AnyView(FeedbackLabelShowcase())),
        CatalogDemoItem(id: "loadingView", title: "DSLoadingView", summary: "Indicador de carregamento", content: AnyView(DSLoadingView(message: "Buscando horários disponíveis"))),
        CatalogDemoItem(id: "searchEmptyState", title: "DSSearchEmptyStateView", summary: "Estado vazio de busca", content: AnyView(DSSearchEmptyStateView()))
    ]

    var body: some View {
        NavigationStack {
            List(items) { item in
                NavigationLink {
                    CatalogDemoDetailView(item: item)
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title).font(.body.weight(.medium))
                        Text(item.summary).font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Componentes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("Tema", selection: $brand) {
                        ForEach(CatalogBrand.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
        .dsTheme(DSTheme(brandColor: brand.color))
    }
}

// MARK: - Detail

private struct CatalogDemoDetailView: View {
    let item: CatalogDemoItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title).font(.title2.weight(.semibold))
                    Text(item.summary).font(.subheadline).foregroundStyle(.secondary)
                }

                item.content
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20).stroke(Color(.systemGray5), lineWidth: 1)
                    }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Helper de rótulo de variação

private struct VariantRow<Content: View>: View {
    let label: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.caption).foregroundStyle(.secondary)
            content
        }
    }
}

// MARK: - Showcases

private struct PrimaryButtonShowcase: View {
    @State private var tapCount = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VariantRow(label: "Padrão (ativo)") {
                DSPrimaryButton(title: "Entrar") { tapCount += 1 }
            }
            VariantRow(label: "Desabilitado") {
                DSPrimaryButton(title: "Entrar", isEnabled: false) {}
            }
            VariantRow(label: "Carregando") {
                DSPrimaryButton(title: "Entrar", isLoading: true) {}
            }
            VariantRow(label: "Cor custom (verde)") {
                DSPrimaryButton(title: "Confirmar", color: .green) { tapCount += 1 }
            }
            Text("Toques: \(tapCount)").font(.footnote).foregroundStyle(.secondary)
        }
    }
}

private struct SocialButtonShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            themeBlock("Modo claro", scheme: .light, background: Color.white)
            themeBlock("Modo escuro", scheme: .dark, background: Color(red: 0.11, green: 0.11, blue: 0.12))
            Text("O logo do Google aqui é placeholder — usar o \"G\" oficial de 4 cores.")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private func themeBlock(_ name: String, scheme: ColorScheme, background: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name).font(.caption).foregroundStyle(.secondary)
            VStack(spacing: 10) {
                DSSocialButton(style: .apple, title: "Continuar com a Apple", logo: Image(systemName: "apple.logo")) {}
                DSSocialButton(style: .google, title: "Continuar com o Google", logo: Image(systemName: "g.circle.fill")) {}
            }
            .padding(14)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .environment(\.colorScheme, scheme)
        }
    }
}

private struct FormTextFieldShowcase: View {
    @State private var custom = ""
    @State private var system = ""
    @State private var hasValidated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VariantRow(label: "Estilo custom com ícone (design system)") {
                DSFormTextField(
                    label: "E-mail", placeholder: "seu@email.com", text: $custom,
                    errorMessage: hasValidated && custom.isEmpty ? "Preencha o e-mail para continuar." : nil,
                    successMessage: hasValidated && !custom.isEmpty ? "E-mail preenchido corretamente." : nil,
                    icon: "envelope"
                )
            }
            VariantRow(label: "Estilo nativo (systemStyle)") {
                DSFormTextField(label: "E-mail", placeholder: "seu@email.com", text: $system, systemStyle: true)
            }
            Button("Validar") { hasValidated = true }.buttonStyle(.bordered)
        }
    }
}

private struct FormSecureFieldShowcase: View {
    @State private var password = ""
    @State private var hasValidated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DSFormSecureField(
                label: "Senha", placeholder: "Digite sua senha", text: $password,
                errorMessage: hasValidated && !password.isEmpty && password.count < 6 ? "A senha deve ter ao menos 6 caracteres." : nil,
                successMessage: hasValidated && password.count >= 6 ? "Senha válida." : nil,
                icon: "lock"
            )
            DSPasswordStrengthBar(strength: strength)
            Button("Validar") { hasValidated = true }.buttonStyle(.bordered)
        }
    }

    private var strength: DSPasswordStrength {
        switch password.count {
        case 0: return .empty
        case 1...5: return .weak
        case 6...9: return .medium
        default: return .strong
        }
    }
}

private struct OTPFieldShowcase: View {
    @State private var code = ""
    @State private var hasValidated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DSOTPField(
                label: "Código de verificação", code: $code,
                errorMessage: hasValidated && !code.isEmpty && code.count < 6 ? "Digite os 6 números enviados." : nil,
                successMessage: hasValidated && code.count == 6 ? "Código preenchido corretamente." : nil
            )
            Button("Validar") { hasValidated = true }.buttonStyle(.bordered)
        }
    }
}

private struct PasswordStrengthBarShowcase: View {
    @State private var strength: DSPasswordStrength = .medium

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DSPasswordStrengthBar(strength: strength)
            Picker("Força", selection: $strength) {
                Text("Vazia").tag(DSPasswordStrength.empty)
                Text("Fraca").tag(DSPasswordStrength.weak)
                Text("Média").tag(DSPasswordStrength.medium)
                Text("Forte").tag(DSPasswordStrength.strong)
            }
            .pickerStyle(.segmented)
        }
    }
}

private struct SearchFieldShowcase: View {
    @State private var query = ""
    var body: some View {
        DSSearchFieldView(text: $query)
    }
}

private struct FilterChipsShowcase: View {
    @State private var active: Set<String> = ["perto"]

    private var items: [DSFilterChipItem] {
        [("perto", "Perto de mim"), ("aberto", "Aberto agora"), ("promo", "Promoção"), ("top", "Bem avaliadas")]
            .map { id, label in
                DSFilterChipItem(id: id, label: label, isActive: active.contains(id)) {
                    if active.contains(id) { active.remove(id) } else { active.insert(id) }
                }
            }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VariantRow(label: "Chip individual (ativo / inativo)") {
                HStack {
                    DSFilterChipView(label: "Ativo", isActive: true) {}
                    DSFilterChipView(label: "Inativo", isActive: false) {}
                }
            }
            VariantRow(label: "Seção rolável (toque para alternar)") {
                DSFilterChipsSection(items: items)
            }
        }
    }
}

private struct CategoriesShowcase: View {
    private var items: [DSCategoryItem] {
        [("maos", "Mãos", "hand.raised.fill"), ("pes", "Pés", "shoeprints.fill"),
         ("nailart", "Nail art", "paintbrush.fill"), ("along", "Alongamento", "sparkles")]
            .map { id, label, icon in DSCategoryItem(id: id, label: label, systemIcon: icon, onTap: {}) }
    }

    var body: some View {
        DSCategoriesSection(items: items)
    }
}

private struct PriceSliderShowcase: View {
    @State private var value: Double = 75

    var body: some View {
        DSPriceSliderRow(title: "Orçamento", value: $value, range: 25...200, step: 5)
    }
}

private struct RatingViewShowcase: View {
    @State private var rating = 4.5

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DSRatingView(rating: rating, style: .expanded)
            DSRatingView(rating: rating, style: .compact)
            Slider(value: $rating, in: 0...5, step: 0.5)
        }
    }
}

private struct DistanceShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DSDistanceView(distance: "1,2 km")
            DSDistanceView(distance: "850 m")
        }
    }
}

private struct StatusBadgeViewShowcase: View {
    @State private var isOpen = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DSStatusBadgeView(isOpen: isOpen)
            HStack(spacing: 12) {
                DSStatusBadgeView(text: "Sucesso", tone: .success)
                DSStatusBadgeView(text: "Fracasso", tone: .failure)
            }
            Toggle("Estabelecimento aberto", isOn: $isOpen)
        }
    }
}

private struct ManicuristPhotoShowcase: View {
    var body: some View {
        HStack(spacing: 16) {
            DSManicuristPhotoView(size: 64)
            DSManicuristPhotoView(size: 96)
        }
    }
}

private struct FeedbackLabelShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DSErrorLabel(message: "Este campo é obrigatório.")
            DSSuccessLabel(message: "Dados validados com sucesso.")
        }
    }
}
