import SwiftUI

public struct ComponentsCatalogView: View {
    private let items: [CatalogComponentItem]

    public init(items: [CatalogComponentItem]? = nil) {
        self.items = items ?? CatalogComponentName.allCases.map { CatalogComponentItem(name: $0) }
    }

    public var body: some View {
        NavigationStack {
            List(items) { item in
                NavigationLink {
                    ComponentDetailView(item: item)
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.resolvedTitle)
                            .font(.body.weight(.medium))
                        Text(item.resolvedSummary)
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

private extension CatalogComponentItem {
    var resolvedTitle: String {
        title ?? name.rawValue
    }

    var resolvedSummary: String {
        summary ?? name.defaultSummary
    }
}

private struct ComponentDetailView: View {
    let item: CatalogComponentItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.resolvedTitle)
                        .font(.title2.weight(.semibold))
                    Text(item.resolvedSummary)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                showcase
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
        .navigationTitle(item.resolvedTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var showcase: some View {
        switch item.name {
        case .feedbackLabel:
            FeedbackLabelDemo(texts: item.texts)
        case .formSecureField:
            FormSecureFieldDemo(texts: item.texts)
        case .formTextField:
            FormTextFieldDemo(texts: item.texts)
        case .loadingView:
            LoadingView(message: item.texts.message ?? "Buscando horários disponíveis")
        case .manicuristPhotoView:
            ManicuristPhotoView(size: 96)
        case .otpField:
            OTPFieldDemo(texts: item.texts)
        case .orDivider:
            OrDivider(label: item.texts.message ?? String(localized: "dividerOr"))
        case .passwordStrengthBar:
            PasswordStrengthBarDemo()
        case .primaryButton:
            PrimaryButtonDemo(texts: item.texts)
        case .ratingView:
            RatingViewDemo()
        case .statusBadgeView:
            StatusBadgeViewDemo(texts: item.texts)
        }
    }
}

private struct FeedbackLabelDemo: View {
    let texts: CatalogComponentTexts

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ErrorLabel(message: texts.failureMessage ?? "Este campo é obrigatório.")
            SuccessLabel(message: texts.successMessage ?? "Dados validados com sucesso.")
        }
    }
}

private struct FormTextFieldDemo: View {
    let texts: CatalogComponentTexts
    @State private var name = ""
    @State private var hasValidated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            FormTextField(
                label: texts.label ?? "Nome",
                placeholder: texts.placeholder ?? "Digite o nome completo",
                text: $name,
                errorMessage: hasValidated && name.isEmpty ? (texts.failureMessage ?? "Preencha o nome para continuar.") : nil,
                successMessage: hasValidated && !name.isEmpty ? (texts.successMessage ?? "Nome preenchido corretamente.") : nil
            )

            Button(texts.primaryActionTitle ?? "Validar") {
                hasValidated = true
            }
            .buttonStyle(.bordered)
        }
    }
}

private struct FormSecureFieldDemo: View {
    let texts: CatalogComponentTexts
    @State private var password = ""
    @State private var isVisible = false
    @State private var hasValidated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            FormSecureField(
                label: texts.label ?? "Senha",
                placeholder: texts.placeholder ?? "Digite sua senha",
                text: $password,
                isVisible: $isVisible,
                errorMessage: hasValidated && !password.isEmpty && password.count < 6 ? (texts.failureMessage ?? "A senha deve ter ao menos 6 caracteres.") : nil,
                successMessage: hasValidated && password.count >= 6 ? (texts.successMessage ?? "Senha válida.") : nil
            )

            PasswordStrengthBar(strength: strength)

            Button(texts.primaryActionTitle ?? "Validar") {
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

private struct OTPFieldDemo: View {
    let texts: CatalogComponentTexts
    @State private var code = ""
    @State private var hasValidated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            OTPField(
                label: texts.label ?? "Código de verificação",
                code: $code,
                errorMessage: hasValidated && !code.isEmpty && code.count < 6 ? (texts.failureMessage ?? "Digite os 6 números enviados.") : nil,
                successMessage: hasValidated && code.count == 6 ? (texts.successMessage ?? "Código preenchido corretamente.") : nil
            )

            Button(texts.primaryActionTitle ?? "Validar") {
                hasValidated = true
            }
            .buttonStyle(.bordered)
        }
    }
}

private struct PasswordStrengthBarDemo: View {
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

private struct PrimaryButtonDemo: View {
    let texts: CatalogComponentTexts
    @State private var tapCount = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            PrimaryButton(title: texts.primaryActionTitle ?? "Continuar") {
                tapCount += 1
            }

            Text("Toques: \(tapCount)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

private struct RatingViewDemo: View {
    @State private var rating = 4.5

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            RatingView(rating: rating, style: .expanded)
            RatingView(rating: rating, style: .compact)

            Slider(value: $rating, in: 0...5, step: 0.5)
        }
    }
}

private struct StatusBadgeViewDemo: View {
    let texts: CatalogComponentTexts
    @State private var isOpen = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            StatusBadgeView(isOpen: isOpen)
            HStack(spacing: 12) {
                StatusBadgeView(text: texts.successMessage ?? "Sucesso", tone: .success)
                StatusBadgeView(text: texts.failureMessage ?? "Fracasso", tone: .failure)
            }

            Toggle(texts.label ?? "Estabelecimento aberto", isOn: $isOpen)
        }
    }
}