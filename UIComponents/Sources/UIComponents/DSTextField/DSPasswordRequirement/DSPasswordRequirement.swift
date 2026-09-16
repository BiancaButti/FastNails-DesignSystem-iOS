import SwiftUI

// MARK: - Requirement

/// One line in a password requirement list.
///
/// The rule that decides `isMet` lives in the app, not here — what counts as
/// a strong password is a product decision.
public struct DSPasswordRequirement: Identifiable {

    public let id: String
    public let text: String
    public let isMet: Bool

    /// Whether the person is blocked until this is satisfied.
    ///
    /// A suggestion that reads like a requirement makes people think the
    /// password was rejected when it was only a nudge.
    public let isRequired: Bool

    public init(id: String, text: String, isMet: Bool, isRequired: Bool) {
        self.id = id
        self.text = text
        self.isMet = isMet
        self.isRequired = isRequired
    }
}

// MARK: - List

/// Live password requirement list, shown under a password field.
///
/// ```swift
/// DSPasswordRequirements(requirements: [
///     .init(id: "length", text: "Pelo menos 8 caracteres",
///           isMet: password.count >= 8, isRequired: true),
///     .init(id: "strong", text: "12 ou mais deixa sua conta mais segura",
///           isMet: password.count >= 12, isRequired: false)
/// ])
/// ```
///
/// ## Why a list and not a strength bar
/// A coloured bar carries its meaning in colour alone, and says nothing about
/// **what to change**. A list states the rule and marks it as met or not — so
/// it works in greyscale and with a screen reader.
///
/// ## Accessibility
/// Each line is announced with its state spelled out, and required lines say
/// so. The tick is decoration.
public struct DSPasswordRequirements: View {

    let requirements: [DSPasswordRequirement]

    @Environment(\.dsTheme) private var theme

    public init(requirements: [DSPasswordRequirement]) {
        self.requirements = requirements
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            ForEach(requirements) { requirement in
                line(for: requirement)
            }
        }
    }

    private func line(for requirement: DSPasswordRequirement) -> some View {
        HStack(spacing: DSSpacing.sm) {
            Image(systemName: requirement.isMet ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(
                    requirement.isMet ? theme.successColor : theme.borderColor
                )
                .accessibilityHidden(true)

            Text(requirement.text)
                .font(theme.feedbackFont)
                .foregroundStyle(
                    requirement.isMet ? theme.titleColor : theme.secondaryColor
                )
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(spokenLabel(for: requirement))
    }

    private func spokenLabel(for requirement: DSPasswordRequirement) -> String {
        let state = requirement.isMet
            ? String(localized: "passwordRequirementMet", bundle: .module)
            : (requirement.isRequired
                ? String(localized: "passwordRequirementMissing", bundle: .module)
                : String(localized: "passwordRequirementSuggestion", bundle: .module))

        return "\(requirement.text), \(state)"
    }
}
