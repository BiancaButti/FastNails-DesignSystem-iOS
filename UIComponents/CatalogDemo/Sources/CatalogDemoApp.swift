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
        CatalogDemoItem(id: "statusBadge", title: "DSStatusBadge", summary: "Booking status badge", content: AnyView(DSStatusBadgeShowcase())),
        CatalogDemoItem(id: "filterChip", title: "DSFilterChip", summary: "Filter chips for quickly viewing and updating the active filters.", content: AnyView(DSFilterChipsSectionShowcase())),
        CatalogDemoItem(id: "selectableOption", title: "DSSelectableOption", summary: "Multiple-choice selectable cards", content: AnyView(DSSelectableOptionShowcase())),
        CatalogDemoItem(id: "salonCard", title: "DSSalonCard", summary: "Salon listing card — thumbnail, price, distance and accessibility tags", content: AnyView(DSSalonCardShowcase())),
        CatalogDemoItem(id: "card", title: "DSCard", summary: "Generic elevated container — background, border and elevation", content: AnyView(DSCardShowcase())),
        CatalogDemoItem(id: "link", title: "DSLink", summary: "Generic link", content: AnyView(DSLinkShowcase())),
        CatalogDemoItem(id: "otp field", title: "DSOTPField", summary: "OTP Field", content: AnyView(DSOTPFieldShowcase()))
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
    @State private var password = ""
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
            VariantRow(label: "Password") {
                DSTextField(
                    label: "Nova senha",
                    placeholder: "",
                    text: $password,
                    kind: .password(.new)
                )
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
        .background(Color.paper)
    }
}

struct DSFilterChipsSectionShowcase: View {

    var body: some View {
        DSFilterChipsSection(title: "FILTRO", 
            description: "Editável no topo da lista. Mostra por que a lista tem aquele tamanho e permite corrigir sem voltar quatro telas.",
            items: [
                DSFilterChipItem(
                    id: "hands",
                    label: "Mãos",
                    isActive: true,
                    onTap: {}
                ),
                DSFilterChipItem(
                    id: "salon",
                    label: "Salão",
                    isActive: true,
                    onTap: {}
                ),
                DSFilterChipItem(
                    id: "price",
                    label: "Até R$ 90",
                    isActive: false,
                    onTap: {}
                ),
                DSFilterChipItem(
                    id: "accessible",
                    label: "Acessível",
                    isActive: true,
                    systemImage: "accessibility",
                    onTap: {}
                )
            ]
        )
    }
}

private struct DSSelectableOptionShowcase: View {
    @State private var selection: Set<String> = ["hands"]

    var body: some View {
        DSSelectableOptionList(
            title: "Selectable Options",
            options: [
                .init(id: "hands", title: "Hands", description: "Manicure, from 30 min"),
                .init(id: "feet", title: "Feet", description: "Pedicure, from 45 min")
            ],
            selection: $selection
        )
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.paper)
    }
}
 
private struct DSSalonCardShowcase: View {
    @State private var tapped = "—"

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VariantRow(label: "Básico") {
                DSSalonCard(
                    name: "Studio Ana Lima",
                    price: 35
                ) { tapped = "Studio Ana Lima" }
            }

            VariantRow(label: "Com distância e disponibilidade") {
                DSSalonCard(
                    name: "Espaço Belle",
                    price: 89.90,
                    distanceInMeters: 300,
                    availability: "vagas hoje até 19h"
                ) { tapped = "Espaço Belle" }
            }

            VariantRow(label: "Com selos de acessibilidade") {
                DSSalonCard(
                    name: "Salão Aurora",
                    price: 120,
                    distanceInMeters: 1500,
                    availability: "próxima vaga amanhã",
                    accessibilityFeatures: [.semDegrau, .atendimentoEmLibras]
                ) { tapped = "Salão Aurora" }
            }

            VariantRow(label: "Miniatura personalizada") {
                DSSalonCard(
                    name: "Nails & Co.",
                    price: 60,
                    distanceInMeters: 850,
                    accessibilityFeatures: [.banheiroAdaptado],
                    action: { tapped = "Nails & Co." }
                ) {
                    DSSalonCardThumbnail(systemImage: "sparkles")
                }
            }

            VariantRow(label: "Não interativo (sem ação)") {
                DSSalonCard(
                    name: "Beleza Natural",
                    price: 45,
                    distanceInMeters: 200,
                    availability: "sem vagas hoje"
                )
            }

            Text("Último toque: \(tapped)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.paper)
    }
}

private struct DSCardShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VariantRow(label: "Estado vazio (conteúdo centralizado)") {
                DSCard {
                    Text("Nenhum salão até R$60")
                        .font(.headline)
                        .foregroundStyle(Color.ink)
                        .multilineTextAlignment(.center)

                    Text("O filtro de orçamento está segurando o resultado. Com até R$90 aparecem 14 salões")
                        .font(.subheadline)
                        .foregroundStyle(Color.ink60)
                        .multilineTextAlignment(.center)

                    DSButton(title: "Aumentar para R$90", style: .secondary) {}
                }
                
                DSCard(borderColor: Color.line) {
                    Text("Sem internet")
                        .font(.headline)
                        .foregroundStyle(Color.ink)
                        .multilineTextAlignment(.center)

                    Text("Seu agendamento continua marcado. A lista atualiza quando a conexão voltar")
                        .font(.subheadline)
                        .foregroundStyle(Color.ink60)
                        .multilineTextAlignment(.center)

                    DSButton(title: "Tentar novamente", style: .secondary, tone: .neutral) {}
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.paper)
    }
}

private struct DSLinkShowcase: View {
    var body: some View {
        VStack(spacing: 16) {
                DSLinkNote(link: DSLink("Esqueci minha senha") {
                    print("Abrir recuperação de senha")
                })
         
                DSLinkNote(
                    "Ao criar conta você concorda com os %@ e a %@.",
                    links: DSLink("Termos de uso", url: URL(string: "https://exemplo.com/termos")!),
                           DSLink("Política de privacidade") { print("Abrir privacidade") }
                )
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(white: 0.08))
        }
}

private struct DSOTPFieldShowcase: View {
    var body: some View {
        VStack(spacing: 40) {
                DSOTPField(
                    label: "Estado Inicial / Digitando",
                    code: .constant("123")
                )
                
                DSOTPField(
                    label: "Estado de Erro",
                    code: .constant("123456"),
                    errorMessage: "Código expirado. Solicite um novo."
                )
                
                DSOTPField(
                    label: "Estado de Sucesso",
                    code: .constant("123456"),
                    successMessage: "Sucesso!"
                )
            }
            .padding()
            .environment(\.dsTheme, DSTheme())
    }
}
