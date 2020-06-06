
import XCTest
@testable import FITS


final class WriterTests: XCTestCase {
    
    static var allTests = [
        ("testPadding", testPadding),
        ("testWriteHeaderBlock", testWriteHeaderBlock),
        ("testWriteSimple", testWriteSimple),
        ("testWriteComment", testWriteComment),
        ("testWriteBitpix", testWriteBitpix),
]
 
    func testPadding() {
        
        var prefix = "Hello World"
        prefix.m_padPrefix(toSize: 22, char: "~")
        var suffix = "Hello World"
        suffix.m_padSuffix(toSize: 22, char: "~")
        
        XCTAssertEqual(prefix.count, 22)
        XCTAssertEqual(prefix, "~~~~~~~~~~~Hello World")
        XCTAssertEqual(suffix.count, 22)
        XCTAssertEqual(suffix, "Hello World~~~~~~~~~~~")
        
        prefix.m_padPrefix(toSize: 6, char: "#")
        suffix.m_padSuffix(toSize: 6, char: "#")
        
        XCTAssertEqual(prefix.count, 6)
        XCTAssertEqual(prefix, "~~~~~~")
        XCTAssertEqual(suffix.count, 6)
        XCTAssertEqual(suffix, "~~~~~~")
        
    }
    
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
