import XCTest
@testable import Chronology

class ChronologyTests: XCTestCase {
    func testExample() {
        let c = Clock.system
        let today = c.thisNanosecond()
        let v = today + .nanoseconds(2)
        XCTAssertNotNil(v)
    }

    func testComparisons() {
        let c = Clock.system
        let nanoNow = c.thisNanosecond()
        let nanoFuture = nanoNow + .nanoseconds(10)
//        XCTAssertThrowsError(nanoFuture > nanoNow)
        XCTAssertNotNil(nanoFuture)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
