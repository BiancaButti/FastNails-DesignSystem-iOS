import SwiftUI
import UIComponents

@main
struct CatalogDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ComponentsCatalogView(items: demoItems)
        }
    }

    private var demoItems: [CatalogComponentItem] {
        [
            CatalogComponentItem(
                name: .feedbackLabel,
                texts: CatalogComponentTexts(
                    successMessage: "Dados validados com sucesso.",
                    failureMessage: "Este campo é obrigatório."
                )
            ),
            CatalogComponentItem(
                name: .formTextField,
                texts: CatalogComponentTexts(
                    label: "Nome",
                    placeholder: "Digite o nome completo",
                    successMessage: "Nome preenchido corretamente.",
                    failureMessage: "Preencha o nome para continuar.",
                    primaryActionTitle: "Validar"
                )
            ),
            CatalogComponentItem(
                name: .formSecureField,
                texts: CatalogComponentTexts(
                    label: "Senha",
                    placeholder: "Digite sua senha",
                    successMessage: "Senha válida.",
                    failureMessage: "A senha deve ter ao menos 6 caracteres.",
                    primaryActionTitle: "Validar"
                )
            ),
            CatalogComponentItem(
                name: .loadingView,
                texts: CatalogComponentTexts(message: "Buscando horários disponíveis")
            ),
            CatalogComponentItem(name: .manicuristPhotoView),
            CatalogComponentItem(
                name: .otpField,
                texts: CatalogComponentTexts(
                    label: "Código de verificação",
                    successMessage: "Código preenchido corretamente.",
                    failureMessage: "Digite os 6 números enviados.",
                    primaryActionTitle: "Validar"
                )
            ),
            CatalogComponentItem(
                name: .orDivider,
                texts: CatalogComponentTexts(message: String(localized: "dividerOr"))
            ),
            CatalogComponentItem(name: .passwordStrengthBar),
            CatalogComponentItem(
                name: .primaryButton,
                texts: CatalogComponentTexts(primaryActionTitle: "Continuar")
            ),
            CatalogComponentItem(name: .ratingView),
            CatalogComponentItem(
                name: .statusBadgeView,
                texts: CatalogComponentTexts(
                    label: "Estabelecimento aberto",
                    successMessage: "Sucesso",
                    failureMessage: "Fracasso"
                )
            )
        ]
    }
}