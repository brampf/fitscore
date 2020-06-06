

import XCTest
@testable import FITS


final class TypeTests: XCTestCase {
    
    static var allTests = [
        ("testTFIELD", testTFIELD),
]
    
    func testTFIELD() {
     
        let ta_0 = TFIELD.A(val: nil)
        let ti_0 = TFIELD.I(val: nil)
 
        let ta_1 = TFIELD.A(val: "Hello World")
        let ta_2 = TFIELD.A(val: "Hello World")
        
        XCTAssertNotEqual(ta_0, ti_0)
        XCTAssertNotEqual(ta_0, ta_1)
        XCTAssertEqual(ta_1, ta_2)
        
        let tf_1 = TFIELD.F(val: 32.0)
        let tf_2 = TFIELD.E(val: 32.0)
        let tf_3 = TFIELD.F(val: 32.0)
        let tf_4 = TFIELD.F(val: 64)
        
        XCTAssertNotEqual(tf_1, tf_2)
        XCTAssertNotEqual(tf_1, tf_4)
        
        XCTAssertEqual(tf_1, tf_3)
        
    }
}
