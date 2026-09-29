import SwiftUI

// MARK: - Requirement

/// Describes one password requirement displayed by ``DSPasswordRequirements``.
///
/// `DSPasswordRequirement` is a presentation model. It does not evaluate the
/// password itself; the caller is responsible for determining whether the
/// requirement is satisfied and providing the resulting value through
/// ``isMet``.
///
/// This keeps password policy in the application or validation layer rather
/// than coupling the Design System component to a specific product rule.
///
/// ## Example
///
/// ```swift
/// let requirement = DSPasswordRequirement(
///     id: "length",
///     text: "Pelo menos 8 caracteres",
///     isMet: password.count >= 8,
///     isRequired: true
/// )
/// ```
///
/// ## Required vs. Suggested
///
/// A requirement can be marked as either required or optional.
///
/// Required requirements represent conditions that block the user until they
/// are satisfied. Optional requirements are presented as suggestions and do
/// not necessarily prevent the password from being accepted.
///
/// This distinction is also exposed through accessibility so that a
/// suggestion is not announced as a validation error.
///
/// - SeeAlso: ``DSPasswordRequirements``
public struct DSPasswordRequirement: Identifiable {

    /// Stable identifier used by SwiftUI to track the requirement in the list.
    public let id: String

    /// Human-readable description of the password rule.
    public let text: String

    /// Indicates whether the password currently satisfies the requirement.
    ///
    /// The value is supplied by the caller. The component does not calculate
    /// or validate the password.
    public let isMet: Bool

    /// Indicates whether the requirement is mandatory.
    ///
    /// When `false`, the requirement is treated as a suggestion rather than a
    /// blocking validation condition.
    public let isRequired: Bool

    /// Creates a password requirement.
    ///
    /// - Parameters:
    ///   - id: A stable identifier for the requirement.
    ///   - text: The human-readable rule shown to the user.
    ///   - isMet: Whether the current password satisfies the rule.
    ///   - isRequired: Whether satisfying the rule is mandatory.
    public init(
        id: String,
        text: String,
        isMet: Bool,
        isRequired: Bool
    ) {
        self.id = id
        self.text = text
        self.isMet = isMet
        self.isRequired = isRequired
    }
}

// MARK: - List

/// Displays a live list of password requirements below a password field.
///
/// `DSPasswordRequirements` presents each ``DSPasswordRequirement`` as a
/// readable status row containing a text description and a visual indicator.
///
/// The component does not validate the password. It simply reflects the
/// `requirements` provided by the caller, making it suitable for different
/// password policies without embedding product-specific validation rules.
///
/// ## Example
///
/// ```swift
/// DSPasswordRequirements(
///     requirements: [
///         .init(
///             id: "length",
///             text: "Pelo menos 8 caracteres",
///             isMet: password.count >= 8,
///             isRequired: true
///         ),
///         .init(
///             id: "strong",
///             text: "12 ou mais deixa sua conta mais segura",
///             isMet: password.count >= 12,
///             isRequired: false
///         )
///     ]
/// )
/// ```
///
/// ## Design Rationale
///
/// The component uses a list of explicit requirements instead of a
/// colour-based password strength indicator.
///
/// A strength bar can communicate state primarily through colour while
/// providing little information about what the person needs to change. A
/// requirement list exposes the actual rules and their current state, making
/// the feedback understandable without relying on colour.
///
/// ## Accessibility
///
/// Each requirement is exposed as a single accessibility element.
///
/// The visual checkmark is hidden from assistive technologies because the
/// requirement's state is included in the accessibility label. This prevents
/// VoiceOver from announcing redundant information.
///
/// Required, missing, and optional requirements use different localized
/// accessibility states so that a suggestion is not presented as a blocking
/// validation error.
///
/// - Note: The validation rules are owned by the caller. This view only
/// reflects the supplied `isMet` and `isRequired` values.
///
/// - SeeAlso: ``DSPasswordRequirement``
public struct DSPasswordRequirements: View {
    @Environment(\.dsTheme)
    private var theme

    /// The password requirements displayed by the component.
    ///
    /// The order of this array determines the order of the rows.
    let requirements: [DSPasswordRequirement]

    /// Creates a password requirement list.
    ///
    /// - Parameter requirements: The requirements to display, in presentation
    ///   order.
    public init(requirements: [DSPasswordRequirement]) {
        self.requirements = requirements
    }

    public var body: some View {
        VStack(
            alignment: .leading,
            spacing: DSSpacing.sm
        ) {
            ForEach(requirements) { requirement in
                line(for: requirement)
            }
        }
    }

    /// Builds the visual and accessibility representation of one requirement.
    ///
    /// The icon is decorative because the complete state is communicated
    /// through the accessibility label.
    private func line(
        for requirement: DSPasswordRequirement
    ) -> some View {
        HStack(spacing: DSSpacing.sm) {
            Image(
                systemName: requirement.isMet
                    ? "checkmark.circle.fill"
                    : "circle"
            )
            .foregroundStyle(
                requirement.isMet
                    ? theme.successColor
                    : theme.borderColor
            )
            .accessibilityHidden(true)

            Text(requirement.text)
                .font(theme.feedbackFont)
                .foregroundStyle(
                    requirement.isMet
                        ? theme.titleColor
                        : theme.secondaryColor
                )
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            spokenLabel(for: requirement)
        )
    }

    /// Creates the localized accessibility description for a requirement.
    ///
    /// The spoken state depends on both whether the requirement is satisfied
    /// and whether it is mandatory:
    ///
    /// - Satisfied requirements announce their completed state.
    /// - Unsatisfied required requirements announce that the requirement is
    ///   missing.
    /// - Unsatisfied optional requirements are announced as suggestions.
    ///
    /// The localized strings are resolved from the component's module bundle.
    private func spokenLabel(
        for requirement: DSPasswordRequirement
    ) -> String {
        let state = requirement.isMet
            ? String(localized: "passwordRequirementMet", bundle: .module)
            : (requirement.isRequired
                ? String(localized: "passwordRequirementMissing", bundle: .module)
                : String(localized: "passwordRequirementSuggestion", bundle: .module))

        return "\(requirement.text), \(state)"
    }
}
