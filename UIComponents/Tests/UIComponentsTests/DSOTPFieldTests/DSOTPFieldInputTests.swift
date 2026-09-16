import Testing
@testable import UIComponents

struct DSOTPFieldSanitizeTests {

    @Test("Keeps only digits")
    func stripsNonDigits() {
        #expect(DSOTPFieldInput.sanitize("1a2b3c", length: 6) == "123")
    }

    @Test("Clamps to length")
    func clampsToLength() {
        #expect(DSOTPFieldInput.sanitize("1234567890", length: 6) == "123456")
    }

    @Test("Empty stays empty")
    func emptyStaysEmpty() {
        #expect(DSOTPFieldInput.sanitize("", length: 6) == "")
    }

    @Test("Letters only become empty")
    func lettersBecomeEmpty() {
        #expect(DSOTPFieldInput.sanitize("abc", length: 6) == "")
    }
}

struct DSOTPFieldCompletionTrackerTests {

    @Test("Does not complete while below length")
    func incompleteDoesNotFire() {
        var tracker = DSOTPFieldCompletionTracker()
        #expect(tracker.shouldComplete("123", length: 6) == false)
    }

    @Test("Completes when it reaches length")
    func completesAtLength() {
        var tracker = DSOTPFieldCompletionTracker()
        #expect(tracker.shouldComplete("123456", length: 6) == true)
    }

    @Test("Fires only once for the same code")
    func firesOnce() {
        var tracker = DSOTPFieldCompletionTracker()
        #expect(tracker.shouldComplete("123456", length: 6) == true)
        #expect(tracker.shouldComplete("123456", length: 6) == false)
    }

    @Test("Deleting rearms for the next complete code")
    func deletingRearms() {
        var tracker = DSOTPFieldCompletionTracker()
        #expect(tracker.shouldComplete("123456", length: 6) == true)
        #expect(tracker.shouldComplete("12345", length: 6) == false)
        #expect(tracker.shouldComplete("123456", length: 6) == true)
    }

    @Test("A different complete code fires")
    func differentCodeFires() {
        var tracker = DSOTPFieldCompletionTracker()
        #expect(tracker.shouldComplete("123456", length: 6) == true)
        #expect(tracker.shouldComplete("654321", length: 6) == true)
    }
}
