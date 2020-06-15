
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
        
        let block = HeaderBlock(keyword: "WALDI", value: "Hello World", comment: "Test")
        
        var data = Data()
        try? block.write(to: &data)
        
        XCTAssertEqual(data.count, 80)
        print(block)
        print(String(data: data, encoding: .ascii) ?? "")
    }
    
    func testWriteSimple() {
        
        let block = HeaderBlock(keyword: HDUKeyword.SIMPLE, value: true, comment: "This is simple")
        
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
        
        let block = HeaderBlock(keyword: HDUKeyword.BITPIX, value: 8, comment: "Standard 8-bit image")
        
        var data = Data()
        try? block.write(to: &data)
        
        XCTAssertEqual(data.count, 80)
        print(block)
        print(String(data: data, encoding: .ascii) ?? "")
    }
    
    func testSample8() {
        
        let sample8 = Sample().rgb(FITSByte_8.self)
        sample8.validate(){ message in
            print(message)
        }
        
        sample8.prime.headerUnit.forEach { block in
            print(block.description)
        }
        
        XCTAssertEqual(sample8.prime.headerUnit.count, 8)
        XCTAssertEqual(sample8.prime.isSimple, true)
        XCTAssertEqual(sample8.prime.naxis, 3)
        XCTAssertEqual(sample8.prime.naxis(1), 300)
        XCTAssertEqual(sample8.prime.naxis(2), 300)
        XCTAssertEqual(sample8.prime.naxis(3), 3)
        XCTAssertEqual(sample8.prime.bitpix, BITPIX.UINT8)
        XCTAssertEqual(sample8.prime.dataUnit?.count, 300 * 300 * 3 * BITPIX.UINT8.size)
        
        var data = Data()
        XCTAssertNoThrow(try sample8.write(to: &data))
        
        self.add(XCTAttachment(data: data))
        
        XCTAssertEqual(data.count, 273600)
    }
    
    func testSample16() {
        
        let sample = Sample().rgb(FITSByte_16.self)
        sample.validate(){ message in
            print(message)
        }
        
        sample.prime.headerUnit.forEach { block in
            print(block.description)
        }
        
        XCTAssertEqual(sample.prime.headerUnit.count, 8)
        XCTAssertEqual(sample.prime.isSimple, true)
        XCTAssertEqual(sample.prime.naxis, 3)
        XCTAssertEqual(sample.prime.naxis(1), 300)
        XCTAssertEqual(sample.prime.naxis(2), 300)
        XCTAssertEqual(sample.prime.naxis(3), 3)
        XCTAssertEqual(sample.prime.bitpix, BITPIX.INT16)
        XCTAssertEqual(sample.prime.dataUnit?.count, 300 * 300 * 3 * BITPIX.INT16.size)
        
        var data = Data()
        XCTAssertNoThrow(try sample.write(to: &data))
        
        self.add(XCTAttachment(data: data))
        
        XCTAssertEqual(data.count, 544320)
    }
    
    func testSample32() {
        
        let sample = Sample().rgb(FITSByte_32.self)
        sample.validate(){ message in
            print(message)
        }
        
        sample.prime.headerUnit.forEach { block in
            print(block.description)
        }
        
        XCTAssertEqual(sample.prime.headerUnit.count, 8)
        XCTAssertEqual(sample.prime.isSimple, true)
        XCTAssertEqual(sample.prime.naxis, 3)
        XCTAssertEqual(sample.prime.naxis(1), 300)
        XCTAssertEqual(sample.prime.naxis(2), 300)
        XCTAssertEqual(sample.prime.naxis(3), 3)
        XCTAssertEqual(sample.prime.bitpix, BITPIX.INT32)
        XCTAssertEqual(sample.prime.dataUnit?.count, 300 * 300 * 3 * BITPIX.INT32.size)
        
        var data = Data()
        XCTAssertNoThrow(try sample.write(to: &data))
        
        self.add(XCTAttachment(data: data))
        
        XCTAssertEqual(data.count, 1082880)
    }
    
    func testSample64() {
        
        let sample = Sample().rgb(FITSByte_64.self)
        sample.validate(){ message in
            print(message)
        }
        
        sample.prime.headerUnit.forEach { block in
            print(block.description)
        }
        
        XCTAssertEqual(sample.prime.headerUnit.count, 8)
        XCTAssertEqual(sample.prime.isSimple, true)
        XCTAssertEqual(sample.prime.naxis, 3)
        XCTAssertEqual(sample.prime.naxis(1), 300)
        XCTAssertEqual(sample.prime.naxis(2), 300)
        XCTAssertEqual(sample.prime.naxis(3), 3)
        XCTAssertEqual(sample.prime.bitpix, BITPIX.INT64)
        XCTAssertEqual(sample.prime.dataUnit?.count, 300 * 300 * 3 * BITPIX.INT64.size)
        
        var data = Data()
        XCTAssertNoThrow(try sample.write(to: &data))
        
        self.add(XCTAttachment(data: data))
        
        XCTAssertEqual(data.count, 2162880)
    }
    
    func testSampleF() {
        
        let sample = Sample().rgb(FITSByte_F.self)
        sample.validate(){ message in
            print(message)
        }
        
        sample.prime.headerUnit.forEach { block in
            print(block.description)
        }
        
        XCTAssertEqual(sample.prime.headerUnit.count, 8)
        XCTAssertEqual(sample.prime.isSimple, true)
        XCTAssertEqual(sample.prime.naxis, 3)
        XCTAssertEqual(sample.prime.naxis(1), 300)
        XCTAssertEqual(sample.prime.naxis(2), 300)
        XCTAssertEqual(sample.prime.naxis(3), 3)
        XCTAssertEqual(sample.prime.bitpix, BITPIX.FLOAT32)
        XCTAssertEqual(sample.prime.dataUnit?.count, 300 * 300 * 3 * BITPIX.FLOAT32.size)
        
        var data = Data()
        XCTAssertNoThrow(try sample.write(to: &data))
        
        self.add(XCTAttachment(data: data))
        
        XCTAssertEqual(data.count, 1082880)
    }
    
    func testSampleD() {
        
        let sample = Sample().rgb(FITSByte_D.self)
        sample.validate(){ message in
            print(message)
        }
        
        sample.prime.headerUnit.forEach { block in
            print(block.description)
        }
        
        XCTAssertEqual(sample.prime.headerUnit.count, 8)
        XCTAssertEqual(sample.prime.isSimple, true)
        XCTAssertEqual(sample.prime.naxis, 3)
        XCTAssertEqual(sample.prime.naxis(1), 300)
        XCTAssertEqual(sample.prime.naxis(2), 300)
        XCTAssertEqual(sample.prime.naxis(3), 3)
        XCTAssertEqual(sample.prime.bitpix, BITPIX.FLOAT64)
        XCTAssertEqual(sample.prime.dataUnit?.count, 300 * 300 * 3 * BITPIX.FLOAT64.size)
        
        var data = Data()
        XCTAssertNoThrow(try sample.write(to: &data))
        
        self.add(XCTAttachment(data: data))
        
        XCTAssertEqual(data.count, 2162880)
    }
}
