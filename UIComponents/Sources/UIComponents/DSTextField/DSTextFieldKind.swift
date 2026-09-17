import SwiftUI
// MARK: - Kind

/// What the field expects, which decides keyboard, autofill and capitalisation.
///
/// One parameter instead of four: passing `.email` and then having to remember
/// `.emailAddress`, `.never` and autocorrection off is how fields end up
/// inconsistent between screens.
public enum DSTextFieldKind: Equatable {

   case name
   case email
   case telephone
   case address
   case postalCode

   /// Password field. Masked, with a reveal toggle.
   case password(DSPasswordMode)

   var keyboardType: UIKeyboardType {
       switch self {
       case .name, .address, .password: .default
       case .email: .emailAddress
       case .telephone, .postalCode: .numberPad
       }
   }

   var contentType: UITextContentType? {
       switch self {
       case .name: .name
       case .email: .emailAddress
       case .telephone: .telephoneNumber
       case .address: .fullStreetAddress
       case .postalCode: .postalCode
       // `.newPassword` is what makes iOS offer to generate and save a
       // strong password; `.password` is what makes it offer the saved one.
       case .password(let mode): mode == .new ? .newPassword : .password
       }
   }

   var capitalisation: TextInputAutocapitalization {
       switch self {
       case .name: .words
       case .address: .sentences
       case .email, .telephone, .postalCode, .password: .never
       }
   }

   var disablesAutocorrection: Bool {
       switch self {
       case .name, .address: false
       case .email, .telephone, .postalCode, .password: true
       }
   }

   var isSecure: Bool {
       if case .password = self { return true }
       return false
   }
}

public enum DSPasswordMode: Equatable {
   /// Signing in with an existing password.
   case current
   /// Creating or changing a password.
   case new
}
