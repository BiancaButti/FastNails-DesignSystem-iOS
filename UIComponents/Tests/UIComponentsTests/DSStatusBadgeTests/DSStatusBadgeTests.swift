import Testing
@testable import UIComponents

struct DSBookingStatusTests {

    @Test("Cancelled by customer is different from cancelled by salon")
    func cancelledByCustomerIsDifferentFromSalon() {
        #expect(
            DSBookingStatus.cancelled(by: .customer)
                != DSBookingStatus.cancelled(by: .salon)
        )
    }

    @Test("Same cancellation reason is equal")
    func sameCancellationReasonIsEqual() {
        #expect(
            DSBookingStatus.cancelled(by: .customer)
                == DSBookingStatus.cancelled(by: .customer)
        )
    }
    
}
