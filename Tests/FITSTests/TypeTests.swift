
import XCTest
@testable import FITS


final class TypeTests: XCTestCase {
    
    static var allTests = [
        ("testTFIELD", testTFIELD),
        ("testBFIELD_A", testBFIELD_A),
        ("testBFIELD_VarArray", testBFIELD_VarArray),
        ("testKeyword",testKeyword)
]
    
    func testTFIELD() {
     
        let ta_0 = TFIELD.A(val: nil)
        let ti_0 = TFIELD.I(val: nil)
 
        let ta_1 : TFIELD.A = "Hello World"
        let ta_2 : TFIELD.A = TFIELD.A(val: "Hello World")
        
        XCTAssertNotEqual(ta_0, ti_0)
        XCTAssertNotEqual(ta_0, ta_1)
        XCTAssertEqual(ta_1, ta_2)
        
        let tf_1 = TFIELD.F(val: 32.0)
        let tf_2 : TFIELD.E = 2.0
        let tf_3 = TFIELD.F(val: 32.0)
        let tf_4 : TFIELD.F = 64.0
        
        XCTAssertNotEqual(tf_1, tf_2)
        XCTAssertNotEqual(tf_1, tf_4)
        XCTAssertEqual(tf_1, tf_3)
        
        let x : TFIELD = TFIELD.I(val: 23)
        let y : TFIELD.I = TFIELD.I(val: 23)
        let z : TFIELD.I = TFIELD.I(val: 11)
        
        XCTAssertEqual(x, y)
        XCTAssertNotEqual(y, z)
        XCTAssertNotEqual(x, z)
        
    }
    
    func testBFIELD_A() {
     
        let ta_0 = BFIELD.A(val: nil)
        let ti_0 = BFIELD.I(val: nil)
 
        let ta_1 : BFIELD.A = "Hello World"
        let ta_2 : BFIELD.A = BFIELD.A(val: "Hello World")
        
        XCTAssertNotEqual(ta_0, ti_0)
        XCTAssertNotEqual(ta_0, ta_1)
        XCTAssertEqual(ta_1, ta_2)
        
        let tf_1 = BFIELD.E(arrayLiteral: 32.0)
        let tf_2 : BFIELD.E = [2.0]
        let tf_3 = BFIELD.E(arrayLiteral: 32.0)
        let tf_4 : BFIELD.E = [64.0]
        
        XCTAssertNotEqual(tf_1, tf_2)
        XCTAssertNotEqual(tf_1, tf_4)
        XCTAssertEqual(tf_1, tf_3)
        
        let x : BFIELD = BFIELD.I(arrayLiteral: 12,13,14)
        let y : BFIELD.I = BFIELD.I(val: [12,13,14])
        let z : BFIELD.I = BFIELD.I(arrayLiteral: 11)
        
        XCTAssertEqual(x, y)
        XCTAssertNotEqual(y, z)
        XCTAssertNotEqual(x, z)
        
    }
    
    func testBFIELD_VarArray() {
     
        let ta_0 = BFIELD.PA(val: nil)
        let ti_0 = BFIELD.PI(val: nil)
 
        let ta_1 : BFIELD.PA = "Hello World"
        let ta_2 : BFIELD.PA = BFIELD.PA(val: "Hello World")
        
        XCTAssertNotEqual(ta_0, ti_0)
        XCTAssertNotEqual(ta_0, ta_1)
        XCTAssertEqual(ta_1, ta_2)
        
        let tf_1 = BFIELD.PE(arrayLiteral: 32.0)
        let tf_2 : BFIELD.PE = [2.0]
        let tf_3 = BFIELD.PE(arrayLiteral: 32.0)
        let tf_4 : BFIELD.PE = [64.0]
        
        XCTAssertNotEqual(tf_1, tf_2)
        XCTAssertNotEqual(tf_1, tf_4)
        XCTAssertEqual(tf_1, tf_3)
        
        
        let x : BFIELD = BFIELD.PI(arrayLiteral: 12,13,14)
        let y : BFIELD.PI = BFIELD.PI(val: [12,13,14])
        let z : BFIELD.PI = BFIELD.PI(arrayLiteral: 11)
        
        XCTAssertEqual(x, y)
        XCTAssertNotEqual(y, z)
        XCTAssertNotEqual(x, z)
    }
    
    func testKeyword() {
        
        let hdu = DemoHDU()
        hdu.test = "Hello World"
        hdu.form = .I(w: 3)
        
        XCTAssertEqual(hdu.headerUnit.count, 2)
        XCTAssertEqual(hdu.headerUnit.first?.keyword, "TEST")
        XCTAssertTrue(hdu.headerUnit.first?.value == "Hello World", "Value: \(String(describing: hdu.headerUnit.first?.value))")
        
    
        
        
        print(hdu.headerUnit)
    }
    
}

class DemoHDU : AnyHDU {
    
    @Keyword("TEST") var test : String?
    
    @Keyword("TFORM") var form : TFORM?
    
    required init() {
        super.init()
        self._test.initialize(self.headerUnit)
        self._form.initialize(self.headerUnit)
    }
    
    required init(with data: inout Data) throws {
        fatalError("init(with:) has not been implemented")
    }
    
}
