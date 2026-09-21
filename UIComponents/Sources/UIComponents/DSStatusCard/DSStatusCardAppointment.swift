import SwiftUI

// MARK: - Example model

/// Example appointment model used to showcase ``DSStatusCardAppointment``.
///
/// It is not part of the design system's public API — it stands in for the
/// host app's own domain type so the card has something concrete to render.
struct Appointment {
    enum Status {
        case confirmed,
             pending,
             cancelledBySalon,
             finished
    }

    let status: Status
    /// e.g. "SEU PRÓXIMO HORÁRIO"
    let eyebrowText: String
    /// e.g. "Sexta, 28/08 · 14:00"
    let formattedTitle: String
    /// e.g. ["Studio Ana Lima · Mãos · R$ 35"]
    let detailLines: [String]
}

// MARK: - Appointment card

/// Maps an ``Appointment`` onto a ``DSStatusCard``, resolving the status badge
/// from the appointment's status.
///
/// The action buttons are left entirely to the caller through the `actions`
/// builder — the card decides *what* the status is, the caller decides *what
/// can be done about it*.
struct DSStatusCardAppointment<Actions: View>: View {
    let appointment: Appointment
    private let actions: Actions

    init(appointment: Appointment,
         @ViewBuilder actions: () -> Actions) {
        self.appointment = appointment
        self.actions = actions()
    }

    var body: some View {
        let status = appointment.bookingStatus

        DSStatusCard(
            eyebrow: appointment.eyebrowText,
            title: appointment.formattedTitle,
            details: appointment.detailLines,
            status: DSStatusBadge(title: status.localizedLabel, status: status)
        ) {
            actions
        }
    }
}

// Convenience for an appointment card without actions.
extension DSStatusCardAppointment where Actions == EmptyView {
    init(appointment: Appointment) {
        self.init(appointment: appointment) { EmptyView() }
    }
}

extension Appointment {
    /// Maps the app's appointment status onto the design system's
    /// ``DSBookingStatusBadge``. The visible wording then comes from the
    /// badge's localized label, not from this layer.
    var bookingStatus: DSBookingStatusBadge {
        switch status {
        case .confirmed:        .confirmed
        case .pending:          .requested
        case .cancelledBySalon: .cancelled(by: .salon)
        case .finished:         .finished
        }
    }
}
