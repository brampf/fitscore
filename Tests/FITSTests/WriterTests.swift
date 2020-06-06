
import XCTest
@testable import FITS


final class WriterTests: XCTestCase {
    
    static var allTests = [
        ("testWriteHeaderBlock", testWriteHeaderBlock),
]
 
    func testWriteHeaderBlock() {
        
        let block = HeaderBlock(keyword: "WALDI", value: .STRING("Hello World"), comment: "Test")
        
        var data = Data()
        try? block.write(to: &data)
        
        XCTAssertEqual(data.count, 80)
        print(block)
        print(String(data: data, encoding: .ascii) ?? "")
    }
    
    func testWriteSimple() {
        
        let block = HeaderBlock(keyword: HDUKeyword.SIMPLE, value: .BOOLEAN(true), comment: "This is simple")
        
        var data = Data()
        try? block.write(to: &data)
        
        XCTAssertEqual(data.count, 80)
        print(block)
        print(String(data: data, encoding: .ascii) ?? "")
    }
    
    func testWriteComment() {
        
        let block = HeaderBlock(keyword: HDUKeyword.COMMENT, value: nil, comment: "This is simply a very long comment - for real!")
        
        var data = Data()
        try? block.write(to: &data)
        
        XCTAssertEqual(data.count, 80)
        print(block)
        print(String(data: data, encoding: .ascii) ?? "")
    }
    
    func testWriteBitpix() {
        
        let block = HeaderBlock(keyword: HDUKeyword.BITPIX, value: .INTEGER(8), comment: "Standard 8-bit image")
        
        var data = Data()
        try? block.write(to: &data)
        
        XCTAssertEqual(data.count, 80)
        print(block)
        print(String(data: data, encoding: .ascii) ?? "")
    }
    
}
