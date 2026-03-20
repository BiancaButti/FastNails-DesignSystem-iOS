enum CatalogComponentName: String, CaseIterable, Identifiable {
    case feedbackLabel = "FeedbackLabel"
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

    var id: String { rawValue }

    var defaultSummary: String {
        switch self {
        case .feedbackLabel:
            return "Mensagens visuais de sucesso e fracasso"
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
            return "Badge de status com estados configuráveis"
        }
    }
}

struct CatalogComponentTexts {
    var label: String?
    var placeholder: String?
    var message: String?
    var successMessage: String?
    var failureMessage: String?
    var primaryActionTitle: String?
    var secondaryMessage: String?

    init(
        label: String? = nil,
        placeholder: String? = nil,
        message: String? = nil,
        successMessage: String? = nil,
        failureMessage: String? = nil,
        primaryActionTitle: String? = nil,
        secondaryMessage: String? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self.message = message
        self.successMessage = successMessage
        self.failureMessage = failureMessage
        self.primaryActionTitle = primaryActionTitle
        self.secondaryMessage = secondaryMessage
    }
}

struct CatalogComponentItem: Identifiable {
    let name: CatalogComponentName
    var title: String?
    var summary: String?
    var texts: CatalogComponentTexts

    var id: String { name.id }

    init(
        name: CatalogComponentName,
        title: String? = nil,
        summary: String? = nil,
        texts: CatalogComponentTexts = .init()
    ) {
        self.name = name
        self.title = title
        self.summary = summary
        self.texts = texts
    }
}