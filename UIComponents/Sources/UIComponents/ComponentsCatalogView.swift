import SwiftUI

public struct ComponentsCatalogView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            List(ComponentCatalogItem.sortedItems) { item in
                NavigationLink {
                    ComponentDetailView(item: item)
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

private struct ComponentCatalogItem: Identifiable {
    let kind: Kind

    var id: String { title }
    var title: String { kind.rawValue }

    var summary: String {
        switch kind {
        case .errorLabel:
            return "Mensagem visual de erro"
        case .formSecureField:
            return "Campo seguro com opção de mostrar senha"
        case .formTextField:
            return "Campo de texto reutilizável"
        case .loadingView:
            return "Indicador de carregamento"
        case .manicuristPhotoView:
            return "Avatar genérico de profissional"
        case .otpField:
            return "Campo para código de verificação"
        case .orDivider:
            return "Divisor visual com texto"
        case .passwordStrengthBar:
            return "Indicador de força da senha"
        case .primaryButton:
            return "Botão principal de ação"
        case .ratingView:
            return "Exibição de avaliação"
        case .statusBadgeView:
            return "Badge de status aberto ou fechado"
        }
    }

    static var sortedItems: [ComponentCatalogItem] {
        Kind.allCases
            .map(ComponentCatalogItem.init(kind:))
            .sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }

    enum Kind: String, CaseIterable {
        case errorLabel = "ErrorLabel"
        case formSecureField = "FormSecureField"
        case formTextField = "FormTextField"
        case loadingView = "LoadingView"
        case manicuristPhotoView = "ManicuristPhotoView"
        case otpField = "OTPField"
        case orDivider = "OrDivider"
        case passwordStrengthBar = "PasswordStrengthBar"
        case primaryButton = "PrimaryButton"
        case ratingView = "RatingView"
        case statusBadgeView = "StatusBadgeView"
    }
}

private struct ComponentDetailView: View {
    let item: ComponentCatalogItem

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
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var showcase: some View {
        switch item.kind {
        case .errorLabel:
            ErrorLabelDemo()
        case .formSecureField:
            FormSecureFieldDemo()
        case .formTextField:
            FormTextFieldDemo()
        case .loadingView:
            LoadingView(message: "Buscando horários disponíveis")
        case .manicuristPhotoView:
            ManicuristPhotoView(size: 96)
        case .otpField:
            OTPFieldDemo()
        case .orDivider:
            OrDivider()
        case .passwordStrengthBar:
            PasswordStrengthBarDemo()
        case .primaryButton:
            PrimaryButtonDemo()
        case .ratingView:
            RatingViewDemo()
        case .statusBadgeView:
            StatusBadgeViewDemo()
        }
    }
}

private struct ErrorLabelDemo: View {
    var body: some View {
        ErrorLabel(message: "Este campo é obrigatório.")
    }
}

private struct FormTextFieldDemo: View {
    @State private var name = ""

    var body: some View {
        FormTextField(
            label: "Nome",
            placeholder: "Digite o nome completo",
            text: $name,
            errorMessage: name.isEmpty ? "Preencha o nome para continuar." : nil
        )
    }
}

private struct FormSecureFieldDemo: View {
    @State private var password = ""
    @State private var isVisible = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            FormSecureField(
                label: "Senha",
                placeholder: "Digite sua senha",
                text: $password,
                isVisible: $isVisible,
                errorMessage: password.count >= 6 || password.isEmpty ? nil : "A senha deve ter ao menos 6 caracteres."
            )

            PasswordStrengthBar(strength: strength)
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
    @State private var code = ""

    var body: some View {
        OTPField(
            label: "Código de verificação",
            code: $code,
            errorMessage: code.count == 6 || code.isEmpty ? nil : "Digite os 6 números enviados."
        )
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
    @State private var isOpen = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            StatusBadgeView(isOpen: isOpen)

            Toggle("Estabelecimento aberto", isOn: $isOpen)
        }
    }
}