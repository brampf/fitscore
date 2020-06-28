
import XCTest
@testable import FITS


final class TypeTests: XCTestCase {
    
    static var allTests = [
        ("testTFIELD", testTFIELD),
        ("testKeyword",testKeyword)
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
    
    func testKeyword() {
        
        let hdu = DemoHDU()
        hdu.test = "Hello World"
        hdu.form = .I(w: 3)
        
        XCTAssertEqual(hdu.headerUnit.count, 2)
        XCTAssertEqual(hdu.headerUnit.first?.keyword, "TEST")
        XCTAssertTrue(hdu.headerUnit.first?.value == "Hello World", "Value: \(hdu.headerUnit.first?.value)")
        
    
        
        
        print(hdu.headerUnit)
    }
    
}

class DemoHDU : AnyHDU {
    
    @Keyword("TEST") var test : String?
    
    @Keyword("TFORM") var form : TFORM?
    
    required init() {
        super.init()
        self._test.initialize(self)
        self._form.initialize(self)
    }
    
    required init(with data: inout Data) throws {
        fatalError("init(with:) has not been implemented")
    }
    
}
