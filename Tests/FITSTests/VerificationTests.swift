
import XCTest
@testable import FITS


final class VerificationTests: XCTestCase {
    
    static var allTests = [
        ("testVerifyNoEnd", testVerifyNoEnd),
    ]
   
    func XCTAssertCondition(_ condition: Condition, _ positive: AnyHDU,_ negative: AnyHDU, file: StaticString = #file, line: UInt = #line) {
    
        XCTAssertPositive(condition, positive)
        XCTAssertNegative(condition, negative)
    }
    
    func XCTAssertNegative(_ condition: Condition,_ negative: AnyHDU, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(condition.check(negative), "False positive")
    }
    
    func XCTAssertPositive(_ condition: Condition, _ positive: AnyHDU, file: StaticString = #file, line: UInt = #line) {
        
        XCTAssertTrue(condition.check(positive), "False negative")
    }
    
    func XCTAssertApplicable(_ condition: Condition, _ hdu: AnyHDU, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(condition.precondition(hdu), "Precondtion not satisfied")
    }
    
    func XCTAssertInApplicable(_ condition: Condition, _ hdu: AnyHDU, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(condition.precondition(hdu), "Precondtion surprisingly satisfied")
    }
    
    
    
    func testVerifyNoEnd() {
        
        /// Negative case
        let bad = PrimaryHDU()
        XCTAssertNegative(noend, bad)
        
        /// Positive case
        let good = PrimaryHDU()
        good.header(HDUKeyword.END, comment: nil)
        XCTAssertPositive(noend, good)
        
        /// Ignored cases do not exist
    }
    
    func testBadNaxis1() {
        
        /// Negative case
        let bad1 = TableHDU()
        _ = bad1.addColumn(TFORM: TFORM.A(w: 4), TFIELD.A(val: "test"))
        bad1.header("NAXIS1", value: 42, comment: nil)
        XCTAssertApplicable(badnaxis1, bad1)
        XCTAssertNegative(badnaxis1, bad1)
        
        /// Positive case
        let good1 = TableHDU()
        _ = good1.addColumn(TFORM: TFORM.A(w: 4), TFIELD.A(val: "test"))
        XCTAssertApplicable(badnaxis1, good1)
        XCTAssertPositive(badnaxis1, good1)
        
        /// Ignored cases do not exist
        let irrelevant1 = PrimaryHDU()
        XCTAssertInApplicable(badnaxis1, irrelevant1)
    }
    
    func testBadBlank() {
        
        /// Negative case
        let bad1 = Sample().rgb(FITSByte_F.self).prime
        bad1.header(HDUKeyword.BLANK, comment: nil)
        XCTAssertApplicable(badblank, bad1)
        XCTAssertNegative(badblank, bad1)
        
        /// Positive case
        let good1 = Sample().rgb(FITSByte_F.self).prime
        XCTAssertApplicable(badblank, good1)
        XCTAssertPositive(badblank, good1)
        
        /// Ignored cases
        let irrelevant1 = Sample().rgb(FITSByte_8.self).prime
        XCTAssertInApplicable(badblank, irrelevant1)
    }
    
    func testBadTNull() {
        
        /// Negative case
        let bad1 = BintableHDU()
        bad1.bitpix = BITPIX.FLOAT32
        bad1.header("TNULL1", comment: nil)
        XCTAssertApplicable(badtnull, bad1)
        XCTAssertNegative(badtnull, bad1)
        
        /// Positive case
        let good1 = BintableHDU()
        good1.bitpix = BITPIX.FLOAT32
        XCTAssertApplicable(badtnull, good1)
        XCTAssertPositive(badtnull, good1)
        
        /// Ignored cases
        let irrelevant1 = BintableHDU()
        bad1.bitpix = BITPIX.INT32
        XCTAssertInApplicable(badtnull, irrelevant1)
    }
}
