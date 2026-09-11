import SwiftUI

/// Defines the input style and keyboard type used by `DSTextField`.
///
/// Use `DSTextFieldStyle` to specify the expected type of content for a text field.
/// The style automatically determines the appropriate `UIKeyboardType` for the
/// given input.
///
/// Example:
///
/// ```swift
/// DSTextField(
///     label: "Email",
///     placeholder: "Enter your email",
///     text: $email,
///     kind: .email
/// )
/// ```
///
/// - Note: The keyboard configuration is intended to improve the typing experience
///   based on the expected content of the field.
public enum DSTextFieldStyle {
    
    /// A field intended for entering a physical or mailing address.
    ///
    /// Uses the default keyboard.
    case address
    
    /// A field intended for entering a telephone number.
    ///
    /// Uses the numeric keyboard.
    case telephone
    
    /// A field intended for entering an email address.
    ///
    /// Uses the email keyboard, which provides convenient access to characters
    /// commonly used in email addresses.
    case email
    
    /// A field intended for entering a person's name.
    ///
    /// Uses the default keyboard.
    case name
    
    /// The keyboard type associated with the field style.
    ///
    /// This value is used by `DSTextField` to configure the keyboard presented
    /// when the field receives focus.
    public var keyboardType: UIKeyboardType {
        switch self {
        case .address, .name:
            return .default
            
        case .telephone:
            return .numberPad
            
        case .email:
            return .emailAddress
        }
    }
}
