import Foundation
import XCTest

final class BaseTest: XCTestCase {
    func test_twoPlusTwo_isFour() {
        XCTAssertEqual(2+2, 4)
    }
}