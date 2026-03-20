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
            id: "feedbackLabel",
            title: "FeedbackLabel",
            summary: "Mensagens visuais de sucesso e fracasso",
            content: AnyView(FeedbackLabelShowcase())
        ),
        CatalogDemoItem(
            id: "formTextField",
            title: "FormTextField",
            summary: "Campo de texto reutilizável",
            content: AnyView(FormTextFieldShowcase())
        ),
        CatalogDemoItem(
            id: "formSecureField",
            title: "FormSecureField",
            summary: "Campo seguro com opção de mostrar senha",
            content: AnyView(FormSecureFieldShowcase())
        ),
        CatalogDemoItem(
            id: "loadingView",
            title: "LoadingView",
            summary: "Indicador de carregamento",
            content: AnyView(LoadingView(message: "Buscando horários disponíveis"))
        ),
        CatalogDemoItem(
            id: "manicuristPhotoView",
            title: "ManicuristPhotoView",
            summary: "Avatar genérico de profissional",
            content: AnyView(ManicuristPhotoView(size: 96))
        ),
        CatalogDemoItem(
            id: "otpField",
            title: "OTPField",
            summary: "Campo para código de verificação",
            content: AnyView(OTPFieldShowcase())
        ),
        CatalogDemoItem(
            id: "orDivider",
            title: "OrDivider",
            summary: "Divisor visual com texto",
            content: AnyView(OrDivider(label: String(localized: "dividerOr")))
        ),
        CatalogDemoItem(
            id: "passwordStrengthBar",
            title: "PasswordStrengthBar",
            summary: "Indicador de força da senha",
            content: AnyView(PasswordStrengthBarShowcase())
        ),
        CatalogDemoItem(
            id: "primaryButton",
            title: "PrimaryButton",
            summary: "Botão principal de ação",
            content: AnyView(PrimaryButtonShowcase())
        ),
        CatalogDemoItem(
            id: "ratingView",
            title: "RatingView",
            summary: "Exibição de avaliação",
            content: AnyView(RatingViewShowcase())
        ),
        CatalogDemoItem(
            id: "statusBadgeView",
            title: "StatusBadgeView",
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
            ErrorLabel(message: "Este campo é obrigatório.")
            SuccessLabel(message: "Dados validados com sucesso.")
        }
    }
}

private struct FormTextFieldShowcase: View {
    @State private var name = ""
    @State private var hasValidated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            FormTextField(
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
    @State private var isVisible = false
    @State private var hasValidated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            FormSecureField(
                label: "Senha",
                placeholder: "Digite sua senha",
                text: $password,
                isVisible: $isVisible,
                errorMessage: hasValidated && !password.isEmpty && password.count < 6 ? "A senha deve ter ao menos 6 caracteres." : nil,
                successMessage: hasValidated && password.count >= 6 ? "Senha válida." : nil
            )

            PasswordStrengthBar(strength: strength)

            Button("Validar") {
                hasValidated = true
            }
            .buttonStyle(.bordered)
        }
    }

    private var strength: PasswordStrength {
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
            OTPField(
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
    @State private var strength: PasswordStrength = .medium

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PasswordStrengthBar(strength: strength)

            Picker("Força", selection: $strength) {
                Text("Vazia").tag(PasswordStrength.empty)
                Text("Fraca").tag(PasswordStrength.weak)
                Text("Média").tag(PasswordStrength.medium)
                Text("Forte").tag(PasswordStrength.strong)
            }
            .pickerStyle(.segmented)
        }
    }
}

private struct PrimaryButtonShowcase: View {
    @State private var tapCount = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            PrimaryButton(title: "Continuar") {
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
            RatingView(rating: rating, style: .expanded)
            RatingView(rating: rating, style: .compact)

            Slider(value: $rating, in: 0...5, step: 0.5)
        }
    }
}

private struct StatusBadgeViewShowcase: View {
    @State private var isOpen = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            StatusBadgeView(isOpen: isOpen)
            HStack(spacing: 12) {
                StatusBadgeView(text: "Sucesso", tone: .success)
                StatusBadgeView(text: "Fracasso", tone: .failure)
            }

            Toggle("Estabelecimento aberto", isOn: $isOpen)
        }
    }
}