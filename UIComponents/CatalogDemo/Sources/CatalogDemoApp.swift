import SwiftUI
import UIComponents

@main
struct CatalogDemoApp: App {
    var body: some Scene {
        WindowGroup {
            CatalogDemoRootView()
                .preferredColorScheme(.light)
        }
    }
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
    private let items: [CatalogDemoItem] = [
        CatalogDemoItem(id: "primaryButton", title: "DSPrimaryButton", summary: "Main Button — states and colors", content: AnyView(DSButtonShowcase())),
        CatalogDemoItem(id: "formTextField", title: "DSTextField", summary: "Text field custom", content: AnyView(DSTextFieldShowcase())),
        CatalogDemoItem(id: "filterChips", title: "DSStatusBadge", summary: "Booking status badge", content: AnyView(DSStatusBadgeShowcase()))
        
//        CatalogDemoItem(id: "formSecureField", title: "DSFormSecureField", summary: "Campo seguro + força de senha", content: AnyView(FormSecureFieldShowcase())),
//        CatalogDemoItem(id: "otpField", title: "DSOTPField", summary: "Código de verificação", content: AnyView(OTPFieldShowcase())),
//        CatalogDemoItem(id: "checkbox", title: "DSCheckbox", summary: "Caixa de seleção com rótulo (ex.: aceite de termos)", content: AnyView(CheckboxShowcase())),
//        CatalogDemoItem(id: "resend", title: "DSResendButton", summary: "Reenviar código com espera entre tentativas", content: AnyView(ResendButtonShowcase())),
//        CatalogDemoItem(id: "iconlabel", title: "DSIconLabel + DSTag", summary: "Informações de apoio e etiquetas de atributo", content: AnyView(IconLabelAndTagShowcase())),
//
//        CatalogDemoItem(id: "header", title: "DSHeaderView", summary: "Cabeçalho com localização e avatar", content: AnyView(DSHeaderView(city: "São Paulo"))),
//        CatalogDemoItem(id: "distanceView", title: "DSDistanceView", summary: "Distância até a profissional", content: AnyView(DistanceShowcase())),
//        CatalogDemoItem(id: "statusBadgeView", title: "DSStatusBadgeView", summary: "Badge de status", content: AnyView(StatusBadgeViewShowcase())),
//        CatalogDemoItem(id: "manicuristPhotoView", title: "DSManicuristPhotoView", summary: "Avatar de profissional", content: AnyView(ManicuristPhotoShowcase())),
//        CatalogDemoItem(id: "feedbackLabel", title: "DSFeedback / Error / Success", summary: "Mensagens de validação", content: AnyView(FeedbackLabelShowcase())),
//        CatalogDemoItem(id: "loadingView", title: "DSLoadingView", summary: "Indicador de carregamento", content: AnyView(DSLoadingView(message: "Buscando horários disponíveis")))
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
        }
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

private struct DSButtonShowcase: View {
    @State private var tapCount = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {

            DSButton(title: "Continuar") { tapCount += 1 }
            DSButton(title: "Já tenho conta", style: .secondary) { tapCount += 1 }
            DSButton(title: "Como chegar", style: .secondary, tone: .neutral) { tapCount += 1 }
            DSButton(title: "Cancelar agendamento", style: .secondary, tone: .destructive) { tapCount += 1 }
            DSButton(title: "Enviando...", isLoading: true) {}
            DSButton(title: "Escolha uma opção", isEnabled: false) {}

            Text("Touch: \(tapCount)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}
private struct DSTextFieldShowcase: View {
    @State private var custom = ""
    @State private var email = ""
    @State private var address = ""
    @State private var wrongEmail = ""
    @State private var hasValidated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VariantRow(label: "Name") {
                DSTextField(
                    label: "Name".uppercased(),
                    placeholder: "James Hetfield",
                    text: $custom,
                    kind: .name,
                    errorMessage: hasValidated && custom.isEmpty ? "Please enter your email to continue." : nil
                )
            }
            VariantRow(label: "Email") {
                DSTextField(label: "E-mail",
                            placeholder: "insert your email here",
                            text: $email,
                            kind: .email)
            }
            VariantRow(label: "Address") {
                DSTextField(label: "Address",
                                placeholder: "742 Evergreen Terrace",
                                text: $address,
                            kind: .address)
            }
        }
    }
}

private struct DSStatusBadgeShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            DSStatusBadge(title: "Aguardando o salão", status: .requested)
            DSStatusBadge(title: "Confirmado", status: .confirmed)
            DSStatusBadge(title: "Finzalizado", status: .finished)
            DSStatusBadge(title: "Você desistiu", status: .withdrawn)
            DSStatusBadge(title: "Pedido recusado", status: .declined)
            DSStatusBadge(title: "Cancelado por você", status: .cancelled(by: .customer))
            DSStatusBadge(title: "Cancelado pelo salão", status: .cancelled(by: .salon))
        }
        .padding(DSSpacing.lg)
        .background(Color.papel)
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
            Button("Validar") { hasValidated = true }.buttonStyle(.bordered)
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

private struct CheckboxShowcase: View {
    @State private var newsletter = true
    @State private var terms = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VariantRow(label: "Rótulo simples") {
                DSCheckbox(isChecked: $newsletter) {
                    Text("Quero receber novidades por e-mail.")
                        .font(.subheadline)
                }
            }
            VariantRow(label: "Rótulo estilizado (aceite de termos)") {
                DSCheckbox(isChecked: $terms) {
                    (
                        Text("Li e aceito os ")
                        + Text("Termos de Uso").foregroundColor(.accentColor)
                        + Text(" e a ")
                        + Text("Política de Privacidade").foregroundColor(.accentColor)
                        + Text(".")
                    )
                    .font(.footnote)
                }
            }
        }
    }
}

private struct IconLabelAndTagShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VariantRow(label: "Apoio (ícone colorido, texto discreto)") {
                DSIconLabel(systemImage: "location.fill", text: "1,2 km")
            }
            VariantRow(label: "Destaque (texto na cor do ícone)") {
                DSIconLabel(
                    systemImage: "clock",
                    text: "Livre hoje às 16h",
                    font: .footnote.weight(.semibold),
                    textColor: .accentColor
                )
            }
            VariantRow(label: "Etiquetas informativas") {
                HStack(spacing: 6) {
                    DSTag(text: "Em casa")
                    DSTag(systemImage: "house", text: "No espaço dela")
                }
            }
            VariantRow(label: "Cartão em destaque") {
                DSCard(spacing: 4, padding: 14, cornerRadius: 18, background: .accentColor) {
                    Text("Seu próximo horário")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.85))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Juliana Lima · quinta, 14h")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

private struct ResendButtonShowcase: View {
    @State private var seconds = 0
    @State private var isSending = false
    @State private var ticker: Task<Void, Never>?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VariantRow(label: "Disponível") {
                DSResendButton(title: "Reenviar e-mail") {}
            }
            VariantRow(label: "Enviando") {
                DSResendButton(isLoading: true, title: "Reenviar e-mail") {}
            }
            VariantRow(label: "Em espera") {
                DSResendButton(secondsRemaining: 45) {}
            }
            VariantRow(label: "Interativo (toque e veja a contagem)") {
                DSResendButton(
                    secondsRemaining: seconds,
                    isLoading: isSending,
                    title: "Reenviar e-mail"
                ) {
                    startCountdown()
                }
            }
        }
        .onDisappear { ticker?.cancel() }
    }

    private func startCountdown() {
        ticker?.cancel()
        ticker = Task {
            isSending = true
            try? await Task.sleep(nanoseconds: 800_000_000)
            isSending = false
            for remaining in stride(from: 10, through: 0, by: -1) {
                guard !Task.isCancelled else { return }
                seconds = remaining
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
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
