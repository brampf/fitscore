
import XCTest
@testable import FITS


final class TableTests: XCTestCase {

    static var allTests = [
        ("testTField",testTField),
        ("testCreateTable",testCreateTable),
        ("testModifyTable",testModifyTable),
        ("testWriteTable",testWriteTable)
    ]
    
    func testTField() {
        
        let a = TFIELD.A(val: "Hello World")
        let i = TFIELD.I(val: 23)
        let f = TFIELD.F(val: 42.48)
        let e = TFIELD.E(val: -6.11104586446241e-01)
        let d = TFIELD.D(val: 4.99471371062592860e+08)
        
        XCTAssertEqual(a.form, TFORM.A(w: 11))
        XCTAssertEqual(i.form, TFORM.I(w: 2))
        XCTAssertEqual(String(format: "%f", f.val ??  0), "42.480000")
        XCTAssertEqual(f.form, TFORM.F(w: 9, d: 6))
        XCTAssertEqual(String(format: "%e", e.val ??  0), "-6.111046e-01")
        XCTAssertEqual(e.form, TFORM.E(w: 13, d: 10))
        XCTAssertEqual(String(format: "%e", d.val ??  0), "4.994714e+08")
        XCTAssertEqual(d.form, TFORM.D(w: 12, d: 10))
        
        let e1 = TFIELD.E(val: 20392.232234)
        let e2 = TFIELD.E(val: 3939.333222)
        let e3 = TFIELD.E(val: 9393.2232342342342)
        
        XCTAssertEqual(e1.form, TFORM.E(w: 12, d: 10))
        XCTAssertEqual(e2.form, TFORM.E(w: 12, d: 10))
        XCTAssertEqual(e3.form, TFORM.E(w: 12, d: 10))
     
        let et = TFORM.E(w: 15, d: 5)
        
        XCTAssertEqual(e1.write(et), "    2.03922E+04")
        XCTAssertEqual(e2.write(et), "    3.93933E+03")
        XCTAssertEqual(e3.write(et), "    9.39322E+03")
    }
    
    func testCreateTable() {
        
        let hdu = TableHDU()
        let col1 = hdu.addColumn(TFORM: TFORM.A(w: 4), TDISP: TDISP.A(w: 8), TTYPE: "Numbers" , TFIELD.A(val: "EINS"), TFIELD.A(val: "Zwei"),TFIELD.A(val: nil), TFIELD.A(val: "Vier"))
        
        XCTAssertEqual(hdu.lookup("TFIELDS"),  1)
        XCTAssertEqual(hdu.lookup("NAXIS1"),  4)
        XCTAssertEqual(hdu.lookup("NAXIS2"), 4)
        
        let _ = hdu.addColumn(TFORM: TFORM.I(w: 8), TDISP: TDISP.I(w: 4, m: 6), .I(val: 4123),.I(val: 1234),.I(val: 8977),.I(val: 5434))
        
        XCTAssertEqual(hdu.columns.count, 2)
        XCTAssertEqual(hdu.columns[0].values.count, 4)
        XCTAssertEqual(hdu.columns[1].values.count, 4)
        XCTAssertEqual(col1.TFORM, TFORM.A(w: 4))
        XCTAssertEqual(hdu.lookup("TFORM1"), TFORM.A(w: 4))
        XCTAssertEqual(hdu.lookup("TFIELDS"),  2)
        XCTAssertEqual(hdu.lookup("NAXIS1"),  12)
        XCTAssertEqual(hdu.lookup("NAXIS2"), 4)

        
        _ = hdu.validate()
        
        hdu.headerUnit.forEach { block in
            print(block)
        }
        
        //plotTable(hdu)
        
    }
    
    func testModifyTable(){
        
        let hdu = TableHDU()
        
        let col1 = hdu.addColumn(TFORM: TFORM.I(w: 3), TTYPE: "Numbers", TFIELD.I(val: 3),TFIELD.I(val: 3),TFIELD.I(val: 3))
        let col2 = hdu.addColumn(TFORM: TFORM.A(w: 12), TTYPE: "Text", TFIELD.A(val: "Hello"),TFIELD.A(val: "World"),TFIELD.A(val: "AGAIN"))
        let row1 = hdu.rows[0]
        let row3 = hdu.rows[2]
        
        // possible
        col1[2] = TFIELD.I(val: 2)
        // not possible
        col2[1] = TFIELD.I(val: 4)
        
        // not possible
        row1[1] = TFIELD.I(val: 42)
        // possible
        row3[1] = TFIELD.A(val: "REDACTED!")
        
        self.plotTable(hdu)
        
        XCTAssertEqual(hdu.columns[0].values[0], TFIELD.I(val: 3))
        XCTAssertEqual(hdu.columns[0].values[1], TFIELD.I(val: 3))
        XCTAssertEqual(hdu.columns[0].values[2], TFIELD.I(val: 2))
        
        XCTAssertEqual(hdu.columns[1].values[0], TFIELD.A(val: "Hello"))
        XCTAssertEqual(hdu.columns[1].values[1], TFIELD.A(val: "World"))
        XCTAssertEqual(hdu.columns[1].values[2], TFIELD.A(val: "REDACTED!"))
    }
    
    func testWriteTable() {
        
        let hdu = TableHDU()
        let _ = hdu.addColumn(TFORM: TFORM.I(w: 5), TDISP: TDISP.I(w: 5, m: 3), TTYPE: "Numbers", TFIELD.I(val: 3),TFIELD.I(val: 333),TFIELD.I(val: 3))
        let _ = hdu.addColumn(TFORM: TFORM.A(w: 12), TDISP: TDISP.A(w: 10),  TTYPE: "Text", TFIELD.A(val: "Hello"),TFIELD.A(val: "World"),TFIELD.A(val: "AGAIN"))
        let _ = hdu.addColumn(TFORM: TFORM.E(w: 20, d: 5), TDISP: TDISP.E(w: 30, d: 5, e: nil), TTYPE: "Exponentials", TFIELD.E(val: 20392.232234),TFIELD.E(val: 3939.333222),TFIELD.E(val: -6.9393e+03))
        
        let prime = PrimaryHDU()
        prime.hasExtensions = true
        
        let file = FitsFile.init(prime: prime)
        file.HDUs.append(hdu)
        
        XCTAssertEqual(hdu.naxis, 2)
        XCTAssertEqual(hdu.bitpix, BITPIX.UINT8)
        XCTAssertEqual(hdu.naxis(1), 37)
        XCTAssertEqual(hdu.naxis(2), 3)
        XCTAssertEqual(hdu.pcount, 0)
        XCTAssertEqual(hdu.lookup(HDUKeyword.GCOUNT), 1)
        XCTAssertEqual(hdu.dataSize, 111)
        XCTAssertEqual(hdu.dataUnit, nil)
        
        XCTAssertEqual(hdu.columns[0][1], TFIELD.I(val: 333))
        XCTAssertEqual(hdu.rows[1][2], TFIELD.E(val: 3939.3333))
        
        file.validate { message in
            print("VAL: \(message)")
        }
        
        XCTAssertEqual(file.prime.isSimple, true)
        XCTAssertEqual(file.HDUs.count, 1)
        
        var data = Data()
        XCTAssertNoThrow(try file.write(to: &data))
        
        var new : FitsFile? = nil
        XCTAssertNoThrow(new = try FitsFile.read(from: &data))
        
        guard let parsed = new else {
            XCTFail("There must be a file")
            return
        }
        
        XCTAssertEqual(parsed.prime.isSimple, true)
        XCTAssertEqual(parsed.HDUs.count, 1)
        
        guard let thdu  = parsed.HDUs.first as? TableHDU else {
            XCTFail("There must be a table HDU")
            return
        }
        
        XCTAssertEqual(thdu.naxis, 2)
        XCTAssertEqual(thdu.bitpix, BITPIX.UINT8)
        XCTAssertEqual(thdu.naxis(1), 37)
        XCTAssertEqual(thdu.naxis(2), 3)
        XCTAssertEqual(thdu.pcount, 0)
        XCTAssertEqual(thdu.lookup(HDUKeyword.GCOUNT), 1)
        XCTAssertEqual(thdu.dataSize, 111)
        XCTAssertEqual(thdu.dataUnit?.count, 111)
        
        XCTAssertEqual(thdu.columns[0][0], hdu.columns[0][0])
        XCTAssertEqual(thdu.columns[1][1], hdu.columns[1][1])
        XCTAssertEqual(thdu.columns[2][2], hdu.columns[2][2])
        
        if let thdu = parsed.HDUs.first as? AnyTableHDU<TFIELD> {
            self.plotTable(thdu)
        }
        
    }
    
    
    
    
    
    
    
    
    
    //MARK:-
    
    func plotTable<Field: FIELD>(_ hdu: AnyTableHDU<Field>) where Field : Displayable {
        var data = Data()
        hdu.plot(data: &data)
        if let out = String(data: data, encoding: .ascii) {
            print(out)
        }
    }
    
}
