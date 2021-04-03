
import XCTest
@testable import FITS


final class NRAOTests: XCTestCase {

    
    static var allTests = [
        ("testSWP05569", testSWP05569),
        
    ]
    
    func testSWP05569() {
        
        let url = Bundle.module.url(forResource: "swp05569slg", withExtension: "fits")
        guard let file = try! FitsFile.read(contentsOf: url!) else {
            XCTFail("FitsFile must not be null")
            return
        }

        XCTAssertEqual(file.prime.isSimple, true)
        XCTAssertEqual(file.prime.bitpix, BITPIX.INT16)
        XCTAssertEqual(file.prime.naxis, 2)
        XCTAssertEqual(file.prime.naxis(1), 831)
        XCTAssertEqual(file.prime.naxis(2), 110)
        XCTAssertEqual(file.prime.naxis(3), nil)
        
        XCTAssertEqual(file.prime.bzero, 12678.9)
        XCTAssertEqual(file.prime.bscale, 0.432251)
        
    }
    
}
