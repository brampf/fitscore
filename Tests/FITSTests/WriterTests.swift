
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
    
    func testEmpty() {
        
        let file = FitsFile(prime: PrimaryHDU())
        file.HDUs.append(ImageHDU())
        file.HDUs.append(TableHDU())
        file.HDUs.append(BintableHDU())
        
        file.prime.header(HDUKeyword.COMMENT, comment: "Written by FITSCore")
        
        self.write(file: file, name: "Empty.fits" )
        
    }
    
    func testMinimal() {
        
        let file = FitsFile(prime: PrimaryHDU(width: 3, height: 3, vectors: [FITSByte_8](arrayLiteral: 1,2,3,4,5,6,7,8,9)))
        file.prime.header(HDUKeyword.COMMENT, comment: "Written by FITSCore")
        
        self.write(file: file, name: "Minimal.fits" )
        
        var data = Data()
        try? file.write(to: &data)
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
        
        self.write(file: sample8, name: "sample8.fits")
        
        #if !os(Linux)
        self.add(XCTAttachment(data: data))
        #endif
        
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
        
        #if !os(Linux)
        self.add(XCTAttachment(data: data))
        #endif
        
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
        
        #if !os(Linux)
        self.add(XCTAttachment(data: data))
        #endif
        
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
        
        #if !os(Linux)
        self.add(XCTAttachment(data: data))
        #endif
        
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
        
        #if !os(Linux)
        self.add(XCTAttachment(data: data))
        #endif
        
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
        
        #if !os(Linux)
        self.add(XCTAttachment(data: data))
        #endif
        
        XCTAssertEqual(data.count, 2162880)
    }
    
     func testWriteFile() {
        
        let prime = PrimaryHDU()
        let red: [FITSByte_32] = Sample().imageData(.red)
        let green: [FITSByte_32] = Sample().imageData(.green)
        let blue: [FITSByte_32] = Sample().imageData(.blue)
        
        prime.set(width: 300, height: 300, vectors: red, green,blue)
        prime.hasExtensions = true
        
        let gray : [FITSByte_F] = Sample().imageData(.green)
        let image = ImageHDU(width: 300, height: 300, vectors: gray)
        
        let table = TableHDU()
        _ = table.addColumn(TFORM: TFORM.A(w: 5), TDISP: TDISP.A(w: 10), TUNIT: "", TTYPE: "Sample", TFIELD.A(val: "World"), TFIELD.A(val: "Hello"))
        _ = table.addColumn(TFORM: TFORM.I(w: 2), TDISP: TDISP.B(w: 2, m: 2), TUNIT: "", TTYPE: "Ints", TFIELD.I(val: 32), TFIELD.I(val: 64))
        _ = table.addColumn(TFORM: TFORM.F(w: 46, d: 6), TDISP: TDISP.E(w: 46, d: 6, e: nil), TUNIT: "", TTYPE: "Floats", TFIELD.F(val: Float.min), TFIELD.F(val: Float.max))

        
        let bintable = BintableHDU()
        _ = bintable.addColumn(TFORM: BFORM.A(r: 5), TDISP: BDISP.A(w: 5), TUNIT: "", TTYPE: "Characters", BFIELD.A(val: "Hello"), BFIELD.A(val: "World"))
        _ = bintable.addColumn(TFORM: BFORM.L(r: 2), TDISP: BDISP.L(w: 1), TUNIT: "",TTYPE: "Logical", BFIELD.L(val: [true,false]), BFIELD.L(val: [false,true]))
        _ = bintable.addColumn(TFORM: BFORM.B(r: 1), TDISP: BDISP.B(w: 5, m: 2), TUNIT: "", TTYPE: "Integer", BFIELD.B(val: [23]), BFIELD.B(val: [42]))
        _ = bintable.addColumn(TFORM: BFORM.PI(r: 20), TDISP: BDISP.B(w: 5, m: 2), TUNIT: "", TTYPE: "Var_Int", BFIELD.PI(val: [0,1,2,3,4,5,6,7,8,9,32,64,128,256,512,1024,2048]), BFIELD.PI(val: [42]))
        
        let file = FitsFile(prime: prime)
        file.HDUs.append(image)
        file.HDUs.append(table)
        file.HDUs.append(bintable)
        
        XCTAssertTrue(file.HDUs[0] is ImageHDU)
        XCTAssertTrue(file.HDUs[1] is TableHDU)
        XCTAssertTrue(file.HDUs[2] is BintableHDU)
        
        file.validate { msg in
            print(msg)
        }
        
        let desktop = try! FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let url = desktop.appendingPathComponent("FitsCore.fits")
        
        var data = Data()
        try! file.write(to: &data)
        
        file.write(to: url, onError: { err in
            print(err)
        }) {
            // done
        }
        
        let new = try! FitsFile.read(from: &data)
        
        new.validate { msg in
            print(msg)
        }
        
        XCTAssertTrue(new.HDUs[0] is ImageHDU)
        XCTAssertTrue(new.HDUs[1] is TableHDU)
        XCTAssertTrue(new.HDUs[2] is BintableHDU)
        
        print(file.prime.debugDescription)
        for hdu in new.HDUs {
            print(hdu.debugDescription)
        }

    }
    
    func write(file: FitsFile, name: String){
        
        let desktop = try! FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let url = desktop.appendingPathComponent(name)
        
        file.write(to: url, onError: { err in
            print(err)
        }) {
            // done
        }
        
        #if !os(Linux)
            self.add(XCTAttachment(contentsOfFile: url))
        #endif
    }
}
