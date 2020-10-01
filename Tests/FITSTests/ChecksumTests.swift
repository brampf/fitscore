
import XCTest
@testable import FITS

final class ChecksumTests: XCTestCase {
    
    static var allTests = [
        ("testChecksumASCII",testChecksumASCII),
        ("testVerifyChecksum", testVerifyChecksum),
        ("testCalculateChecksum", testCalculateChecksum),
        ("testWriteChecksum", testWriteChecksum),
        ("testWriteVarArray", testEmptyDataUnit),
        ("testWriteVarArray", testEmptyDataUnit),
    ]

    /// Test computation and reversal of ASCII representation of the Checksum according to Standard 4.0 documentation, Appendix J
    func testChecksumASCII() {
        
        /// checksum according zu standard document Appendix J
        let complement = Checksum(868229149)
        XCTAssertEqual(complement.toString, "hcHjjc9ghcEghc9g")
        
        let reverse = Checksum("hcHjjc9ghcEghc9g")
        
        XCTAssertEqual(reverse.complement, 3426738146)
    }
    
    /// Test processing and validation of a checksum form an parsed file
    func testVerifyChecksum() {
        
        // read file
        let url = Bundle.module.url(forResource: "aeff_P6_v1_diff_back", withExtension: "fits")!
        let file = try! FitsFile.read(from: url)
        
       
        XCTAssertEqual(file.prime.lookup(HDUKeyword.CHECKSUM), "3cMdAZKb3aKbAYKb")
        XCTAssertEqual(file.prime.lookup(HDUKeyword.DATASUM), "         0")
        
        var dat = Data()
        file.prime.headerUnit.forEach{ block in
            if let raw = block.raw {
                block.write(string: raw, to: &dat)
            }
        }
        file.prime.pad(&dat, by: CARD_LENGTH*BLOCK_LENGTH, with: 32)
        
        XCTAssertEqual(dat.datasum, ~0, "checksum is supposed to be 0 for an undamaged HDU")
  
        guard let bintable = file.HDUs[0] as? BintableHDU else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(bintable.lookup(HDUKeyword.CHECKSUM), "IpAMIo5LIoALIo5L")
        XCTAssertEqual(bintable.lookup(HDUKeyword.DATASUM), "340004495")
        
        var data = Data()
        try? bintable.writeData(to: &data)
        
        XCTAssertEqual(data.datasum, 340004495)
        
        dat = Data()
        bintable.headerUnit.forEach{ block in
            if let raw = block.raw {
                block.write(string: raw, to: &dat)
            }
        }
        bintable.pad(&dat, by: CARD_LENGTH*BLOCK_LENGTH, with: 32)
        
        let total = dat.datasum &+ 340004495
   
        XCTAssertEqual(total, ~0, "checksum is supposed to be 0 for an undamaged HDU")
    }
    
    /// tests computation and validation of a checksum for a generated file
    func testCalculateChecksum() {

        let sample = Sample().rgb(FITSByte_F.self)
        sample.validate{ msg in
            print(msg)
        }
        
        let date = "2020-07-31 20:28:30 +0000"
        
        
        var dataUnit = Data()
        try! sample.prime.writeData(to: &dataUnit)
        let datasum = dataUnit.datasum
        
        XCTAssertEqual(datasum, 134142435)
        
        sample.prime.header(HDUKeyword.DATASUM, value: String(datasum), comment: "Datasum \(date)")
        sample.prime.header(HDUKeyword.CHECKSUM, value: "0000000000000000", comment: "Checksum \(date)")
        
        XCTAssertTrue(sample.prime.validate())
        
        var headerUnit = Data()
        try! sample.prime.writeHeader(to: &headerUnit)
        let headersum = headerUnit.datasum
        
        XCTAssertEqual(headersum, 4244216108)
        
        var fullHDU = Data()
        try! sample.prime.write(to: &fullHDU)
        let checksum = fullHDU.datasum
        
        XCTAssertEqual(checksum, 83391248)
        //XCTAssertEqual(checksum, headersum &+ datasum)
        
        sample.prime.header(HDUKeyword.CHECKSUM, value: Checksum(checksum).toString, comment: "Checksum \(date)")
        
        XCTAssertEqual(sample.prime.headerUnit.count, 10)
        XCTAssertEqual(sample.prime.lookup(HDUKeyword.DATASUM), "134142435")
        XCTAssertEqual(sample.prime.lookup(HDUKeyword.CHECKSUM), "kq4Snn1Skn1Skn1S")
        
        var complete = Data()
        try! sample.prime.write(to: &complete)
        
        XCTAssertEqual(complete.datasum, ~0,  "checksum is supposed to be 0 for an undamaged HDU")
    }
    
    /// tests computation of a checksum for an file written to I/O in order to validate via external tool
    func testWriteChecksum() {
        
        let sample = Sample().rgb(FITSByte_16.self, blocksize: 200)
        sample.validate{ msg in
            print(msg)
        }
        
        var dataUnit = Data()
        try? sample.prime.writeData(to: &dataUnit)
        let datasum : UInt32 = dataUnit.datasum
        
        XCTAssertEqual(dataUnit.count, 2160000)
        
        XCTAssertEqual(sample.prime.dataSize, 2160000)
        XCTAssertEqual(sample.prime.dataUnit!.count, 2160000)
            
        XCTAssertEqual(sample.prime.dataUnit?.datasum, 2328857295)
        XCTAssertEqual(datasum, 2328857295)
        
        sample.prime.header(HDUKeyword.DATASUM, value: String(datasum))
        sample.prime.header(HDUKeyword.CHECKSUM, value: "0000000000000000")
        
        var headerUnit = Data()
        try? sample.prime.writeHeader(to: &headerUnit)
        
        XCTAssertEqual(headerUnit.datasum, 2489681364)
        
        var hdu = Data()
        try? sample.write(to: &hdu)
        let hdusum = hdu.datasum
        
        XCTAssertEqual(hdusum, 523571364)
        //XCTAssertEqual(hdusum, headerUnit.datasum &+ dataUnit.datasum)
        
        sample.prime.header(HDUKeyword.CHECKSUM, value: Checksum(hdusum).toString)
        
        XCTAssertEqual(sample.prime.lookup(HDUKeyword.DATASUM), "2328857295")
        XCTAssertEqual(sample.prime.lookup(HDUKeyword.CHECKSUM), "FhdnIhbkFhbkFhbk")
        
        
        let desktop = try! FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let url = desktop.appendingPathComponent("FitsChecksum.fits")
        
        var data = Data()
        try! sample.prime.write(to: &data)
        
        XCTAssertEqual(data.datasum, ~0, "checksum is supposed to be 0 for an undamaged HDU")
        
        sample.write(to: url, onError: { err in
            print(err)
        }) {
            // done
        }
        
        let raw = try! Data(contentsOf: url)
        XCTAssertEqual(raw.datasum, ~0, "checksum is supposed to be 0 for an undamaged HDU")
    }
    
    /// Tests computation and validation of the checksum for a HDU with empty data Unit
    func testEmptyDataUnit() {
        
        let date = "2020-09-06 10:45:30 +0000"
     
        /// datasum  for emtpy dataUnit shall be "0"
        XCTAssertEqual(Data().datasum, 0)
        
        let prime = PrimaryHDU()
        
        prime.header(HDUKeyword.DATASUM, value: "0", comment: "\(date)")
        prime.header(HDUKeyword.CHECKSUM, value: "0000000000000000", comment: "\(date)")
        
        prime.header(HDUKeyword.COMMENT, comment: "This is a test for Checksum computation")
        _ = prime.validate()
        
        var data = Data()
        try? prime.write(to: &data)
        
        prime.header(HDUKeyword.CHECKSUM, value: Checksum(data.datasum).toString, comment: "\(date)")
        
        prime.headerUnit.forEach{ block in
            print(block.description)
        }
        
        data = Data()
        try? prime.write(to: &data)
        
        XCTAssertEqual(data.datasum, ~0, "checksum is supposed to be 0 for an undamaged HDU")
        
    }
    
}
