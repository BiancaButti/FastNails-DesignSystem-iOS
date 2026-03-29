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

private struct CatalogDemoItem: Identifiable {
    let id: String
    let title: String
    let summary: String
    let content: AnyView
}

private struct CatalogDemoRootView: View {
    private let items: [CatalogDemoItem] = [
        CatalogDemoItem(
            id: "errorLabel",
            title: "DSErrorLabel",
            summary: "Mensagem visual de erro",
            content: AnyView(DSErrorLabel(message: "Este campo é obrigatório."))
        ),
        CatalogDemoItem(
            id: "feedbackLabel",
            title: "DSFeedbackLabel",
            summary: "Mensagens visuais de sucesso e fracasso",
            content: AnyView(FeedbackLabelShowcase())
        ),
        CatalogDemoItem(
            id: "formTextField",
            title: "DSFormTextField",
            summary: "Campo de texto reutilizável",
            content: AnyView(FormTextFieldShowcase())
        ),
        CatalogDemoItem(
            id: "formSecureField",
            title: "DSFormSecureField",
            summary: "Campo seguro com opção de mostrar senha",
            content: AnyView(FormSecureFieldShowcase())
        ),
        CatalogDemoItem(
            id: "loadingView",
            title: "DSLoadingView",
            summary: "Indicador de carregamento",
            content: AnyView(DSLoadingView(message: "Buscando horários disponíveis"))
        ),
        CatalogDemoItem(
            id: "manicuristPhotoView",
            title: "DSManicuristPhotoView",
            summary: "Avatar genérico de profissional",
            content: AnyView(DSManicuristPhotoView(size: 96))
        ),
        CatalogDemoItem(
            id: "otpField",
            title: "DSOTPField",
            summary: "Campo para código de verificação",
            content: AnyView(OTPFieldShowcase())
        ),
        CatalogDemoItem(
            id: "orDivider",
            title: "DSOrDivider",
            summary: "Divisor visual com texto",
            content: AnyView(DSOrDivider(label: String(localized: "dividerOr")))
        ),
        CatalogDemoItem(
            id: "passwordStrengthBar",
            title: "DSPasswordStrengthBar",
            summary: "Indicador de força da senha",
            content: AnyView(PasswordStrengthBarShowcase())
        ),
        CatalogDemoItem(
            id: "primaryButton",
            title: "DSPrimaryButton",
            summary: "Botão principal de ação",
            content: AnyView(PrimaryButtonShowcase())
        ),
        CatalogDemoItem(
            id: "ratingView",
            title: "DSRatingView",
            summary: "Exibição de avaliação",
            content: AnyView(RatingViewShowcase())
        ),
        CatalogDemoItem(
            id: "successLabel",
            title: "DSSuccessLabel",
            summary: "Mensagem visual de sucesso",
            content: AnyView(DSSuccessLabel(message: "Dados validados com sucesso."))
        ),
        CatalogDemoItem(
            id: "statusBadgeView",
            title: "DSStatusBadgeView",
            summary: "Badge de status com estados configuráveis",
            content: AnyView(StatusBadgeViewShowcase())
        )
    ]

    var body: some View {
        NavigationStack {
            List(items) { item in
                NavigationLink {
                    CatalogDemoDetailView(item: item)
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(.body.weight(.medium))
                        Text(item.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Componentes")
        }
    }
}

private struct CatalogDemoDetailView: View {
    let item: CatalogDemoItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.title2.weight(.semibold))
                    Text(item.summary)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                item.content
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(.systemGray5), lineWidth: 1)
                    }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
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

private struct FormTextFieldShowcase: View {
    @State private var name = ""
    @State private var hasValidated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DSFormTextField(
                label: "Nome",
                placeholder: "Digite o nome completo",
                text: $name,
                errorMessage: hasValidated && name.isEmpty ? "Preencha o nome para continuar." : nil,
                successMessage: hasValidated && !name.isEmpty ? "Nome preenchido corretamente." : nil
            )

            Button("Validar") {
                hasValidated = true
            }
            .buttonStyle(.bordered)
        }
    }
}

private struct FormSecureFieldShowcase: View {
    @State private var password = ""
    @State private var hasValidated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DSFormSecureField(
                label: "Senha",
                placeholder: "Digite sua senha",
                text: $password,
                errorMessage: hasValidated && !password.isEmpty && password.count < 6 ? "A senha deve ter ao menos 6 caracteres." : nil,
                successMessage: hasValidated && password.count >= 6 ? "Senha válida." : nil
            )

            DSPasswordStrengthBar(strength: strength)

            Button("Validar") {
                hasValidated = true
            }
            .buttonStyle(.bordered)
        }
    }

    private var strength: DSPasswordStrength {
        switch password.count {
        case 0:
            return .empty
        case 1...5:
            return .weak
        case 6...9:
            return .medium
        default:
            return .strong
        }
    }
}

private struct OTPFieldShowcase: View {
    @State private var code = ""
    @State private var hasValidated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DSOTPField(
                label: "Código de verificação",
                code: $code,
                errorMessage: hasValidated && !code.isEmpty && code.count < 6 ? "Digite os 6 números enviados." : nil,
                successMessage: hasValidated && code.count == 6 ? "Código preenchido corretamente." : nil
            )

            Button("Validar") {
                hasValidated = true
            }
            .buttonStyle(.bordered)
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

private struct PrimaryButtonShowcase: View {
    @State private var tapCount = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DSPrimaryButton(title: "Continuar") {
                tapCount += 1
            }

            Text("Toques: \(tapCount)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
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