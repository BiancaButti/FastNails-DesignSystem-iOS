public enum CatalogComponentName: String, CaseIterable, Identifiable {
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

    public var id: String { rawValue }

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

public struct CatalogComponentTexts {
    public var label: String?
    public var placeholder: String?
    public var message: String?
    public var successMessage: String?
    public var failureMessage: String?
    public var primaryActionTitle: String?
    public var secondaryMessage: String?

    public init(
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

public struct CatalogComponentItem: Identifiable {
    public let name: CatalogComponentName
    public var title: String?
    public var summary: String?
    public var texts: CatalogComponentTexts

    public var id: String { name.id }

    public init(
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