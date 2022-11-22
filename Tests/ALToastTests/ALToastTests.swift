import XCTest
@testable import ALToast

final class ALToastTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
    }
    
    func testOriginSide() throws {
        
        let origin = OriginSide.bottom(offsetFromBottom: 70)
        let origin2 = OriginSide.center(offset: 70)
        
        XCTAssertNotEqual(origin.originStart, origin2.originStart)
    }
}
