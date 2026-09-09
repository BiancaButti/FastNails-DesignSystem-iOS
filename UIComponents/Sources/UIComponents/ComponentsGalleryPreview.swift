#if DEBUG
import SwiftUI

/// Galeria de preview reunindo os principais componentes do design system.
///
/// Serve apenas para visualização no canvas do Xcode (compilada só em `DEBUG`).
/// Abra este arquivo e ative o preview para navegar pelos componentes.
private struct ComponentsGalleryPreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {
                section("Botões") {
                    DSPrimaryButton(title: "Continuar") {}
                    DSResendButton(secondsRemaining: 0) {}
                }

                section("Feedback") {
                    DSSuccessLabel(message: "Dados validados com sucesso.")
                    DSErrorLabel(message: "Este campo é obrigatório.")
                    DSFeedbackLabel(message: "Atenção ao preencher.", tone: .failure)
                }

                section("Campos") {
                    DSFormTextField(
                        label: "Nome",
                        placeholder: "Digite o nome completo",
                        text: .constant("")
                    )
                    DSFormSecureField(
                        label: "Senha",
                        placeholder: "Digite sua senha",
                        text: .constant("")
                    )
                    DSOTPField(label: "Código de verificação", code: .constant("123"))
                }

                section("Etiquetas e status") {
                    HStack(spacing: DSSpacing.sm) {
                        DSStatusBadgeView(isOpen: true)
                        DSStatusBadgeView(text: "Fechado", tone: .failure)
                    }
                    HStack(spacing: DSSpacing.sm) {
                        DSTag(systemImage: "sparkles", text: "Novo")
                        DSTag(text: "Promoção")
                    }
                    DSIconLabel(systemImage: "clock", text: "Aberto até 20h")
                    DSDistanceView(distance: "2,5 km")
                }

                section("Seleção") {
                    DSCheckbox(isChecked: .constant(true)) {
                        Text("Aceito os termos de uso")
                    }
                    HStack(spacing: DSSpacing.sm) {
                        DSFilterChipView(label: "Ativo", isActive: true) {}
                        DSFilterChipView(label: "Inativo", isActive: false) {}
                    }
                }

                section("Cabeçalhos") {
                    DSScreenHeader(
                        systemImage: "sparkles",
                        title: "Bem-vinda",
                        subtitle: "Encontre a manicure ideal"
                    )
                    DSHeaderView(city: "São Paulo")
                }

                section("Superfícies") {
                    DSCard {
                        DSManicuristPhotoView(size: 64)
                        Text("Cartão de exemplo")
                            .font(.headline)
                    }
                    DSLoadingView(message: "Buscando horários disponíveis")
                }
            }
            .padding(DSSpacing.lg)
        }
        .background(Color.papel)
    }

    @ViewBuilder
    private func section<Content: View>(
        _ title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            content()
        }
    }
}

#Preview {
    ComponentsGalleryPreview()
}
#endif
