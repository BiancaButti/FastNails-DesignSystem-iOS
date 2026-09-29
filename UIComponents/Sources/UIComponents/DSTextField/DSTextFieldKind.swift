import SwiftUI

// MARK: - Kind

/// Describes the type of data expected by a ``DSTextField``.
///
/// `DSTextFieldKind` centralizes the input configuration associated with each
/// type of value. The selected kind determines the keyboard type, text content
/// type used by iOS for autofill, capitalization behavior, autocorrection, and
/// whether the field should use secure text entry.
///
/// Using a single kind instead of configuring these properties independently
/// helps keep text fields consistent across the application.
///
/// ## Example
///
/// ```swift
/// DSTextField(
///     label: "E-mail",
///     placeholder: "Digite seu e-mail",
///     text: $email,
///     kind: .email
/// )
/// ```
///
/// ## Passwords
///
/// Password fields use ``DSPasswordMode`` to distinguish between an existing
/// password and a password being created or changed.
///
/// ```swift
/// DSTextField(
///     label: "Senha",
///     placeholder: "Digite sua senha",
///     text: $password,
///     kind: .password(.current)
/// )
/// ```
///
/// For a new password, use `.new`:
///
/// ```swift
/// DSTextField(
///     label: "Nova senha",
///     text: $password,
///     kind: .password(.new)
/// )
/// ```
///
/// This allows iOS to distinguish between entering an existing password and
/// creating a new one when configuring password autofill.
///
/// - SeeAlso: ``DSPasswordMode``
/// - SeeAlso: ``DSTextField``
public enum DSTextFieldKind: Equatable {

    /// A person's name.
    ///
    /// Uses word capitalization and allows autocorrection.
    case name

    /// An e-mail address.
    ///
    /// Uses the e-mail keyboard, disables autocorrection, and disables
    /// automatic capitalization.
    case email

    /// A telephone number.
    ///
    /// Uses the numeric keyboard and disables autocorrection.
    case telephone

    /// A street or postal address.
    ///
    /// Uses sentence capitalization and allows autocorrection.
    case address

    /// A postal or ZIP code.
    ///
    /// Uses the numeric keyboard and disables autocorrection and capitalization.
    case postalCode

    /// A password field.
    ///
    /// The associated ``DSPasswordMode`` determines whether the field
    /// represents an existing password or a password being created or changed.
    case password(DSPasswordMode)

    /// The keyboard configuration associated with the field kind.
    ///
    /// Numeric input types use `numberPad`, e-mail addresses use
    /// `emailAddress`, and the remaining fields use the default keyboard.
    var keyboardType: UIKeyboardType {
        switch self {
        case .name, .address, .password:
            .default

        case .email:
            .emailAddress

        case .telephone, .postalCode:
            .numberPad
        }
    }

    /// The content type used by iOS for text autofill and related input
    /// assistance.
    ///
    /// Password fields use `.newPassword` when creating or changing a password
    /// and `.password` when entering an existing password.
    var contentType: UITextContentType? {
        switch self {
        case .name:
            .name

        case .email:
            .emailAddress

        case .telephone:
            .telephoneNumber

        case .address:
            .fullStreetAddress

        case .postalCode:
            .postalCode

        case .password(let mode):
            mode == .new ? .newPassword : .password
        }
    }

    /// The capitalization behavior applied while entering text.
    ///
    /// Names capitalize words, addresses capitalize sentences, and values such
    /// as e-mail addresses, telephone numbers, postal codes, and passwords do
    /// not use automatic capitalization.
    var capitalisation: TextInputAutocapitalization {
        switch self {
        case .name:
            .words

        case .address:
            .sentences

        case .email, .telephone, .postalCode, .password:
            .never
        }
    }

    /// Whether autocorrection should be disabled for this field.
    ///
    /// Autocorrection remains enabled for natural-language input such as names
    /// and addresses. Structured values disable it to avoid modifying user
    /// input.
    var disablesAutocorrection: Bool {
        switch self {
        case .name, .address:
            false

        case .email, .telephone, .postalCode, .password:
            true
        }
    }

    /// Whether the field should use secure text entry.
    ///
    /// Returns `true` only for ``password(_:)`` values.
    var isSecure: Bool {
        if case .password = self {
            return true
        }

        return false
    }
}

// MARK: - Password Mode

/// Describes how a password field is being used.
///
/// The mode allows ``DSTextFieldKind`` to provide the appropriate
/// `UITextContentType` to iOS, improving password autofill and password
/// generation behavior.
///
/// - SeeAlso: ``DSTextFieldKind/password(_:)``
public enum DSPasswordMode: Equatable {

    /// Entering an existing password, such as during sign-in.
    ///
    /// Maps to `UITextContentType.password`.
    case current

    /// Creating or changing a password.
    ///
    /// Maps to `UITextContentType.newPassword`, allowing iOS to offer
    /// password generation and storage where supported.
    case new
}
