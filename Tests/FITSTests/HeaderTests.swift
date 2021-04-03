import XCTest
@testable import FITS


final class HeaderTests: XCTestCase {
    
    
    static var allTests = [
        ("testKeyworldWrapper", testKeyworldWrapper),
        
    ]
 
    func testKeyworldWrapper() {
        
        // very specific scenario in which value is stored as Int
        let new = AnyHDU()
        new.headerUnit.append(HeaderBlock(keyword: HDUKeyword.BZERO, value: Int(42), comment: "Integer Value"))
        
        XCTAssertEqual(new.bzero, 42)
    }
    
}
