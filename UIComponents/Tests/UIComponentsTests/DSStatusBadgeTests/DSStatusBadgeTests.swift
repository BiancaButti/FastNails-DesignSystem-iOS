import Testing
@testable import UIComponents

struct DSBookingStatusTests {

    @Test("Cancelled by customer is different from cancelled by salon")
    func cancelledByCustomerIsDifferentFromSalon() {
        #expect(
            DSBookingStatusBadge.cancelled(by: .customer)
                != DSBookingStatusBadge.cancelled(by: .salon)
        )
    }

    @Test("Same cancellation reason is equal")
    func sameCancellationReasonIsEqual() {
        #expect(
            DSBookingStatusBadge.cancelled(by: .customer)
                == DSBookingStatusBadge.cancelled(by: .customer)
        )
    }
    
}
