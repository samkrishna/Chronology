import XCTest
@testable import Chronology

class MarsChronologyTests: XCTestCase {
    public var marsCalendar : Calendar! = Calendar(identifier: .gregorian)
    let SISecondsPerEarthDay : Double = 86400.0
    let MarsSISecondsPerSolarDay : Double = 88775.24

    override func setUp() {
        // Using Mars solar day of 24h 39m 35.24s (88,775.24 SI seconds) as basis for creating test cases.
        marsCalendar.SISecondsPerSecond = MarsSISecondsPerSolarDay / SISecondsPerEarthDay
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMarsSecondToSISecond() {
        let result = MarsSISecondsPerSolarDay / SISecondsPerEarthDay
        XCTAssertNotNil(marsCalendar)
        XCTAssert(marsCalendar.SISecondsPerSecond == result)
    }
}
