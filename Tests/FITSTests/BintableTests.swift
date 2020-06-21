
import XCTest
@testable import FITS


final class BintableTests: XCTestCase {
    
    static var allTests = [
        ("testTField",testBField),
        ("testReadTable",testReadTable),
        ("testCreateTable",testCreateTable),
        ("testModifyTable",testModifyTable),
        ("testWriteTable",testWriteTable)
    ]
    
    func testBField() {
        
        let a = BFIELD.A(val: "Hello World")
        let l = BFIELD.L(val: [true])
        let x = BFIELD.X(val: Data(repeating: 0b00000100, count: 1))
        let b = BFIELD.B(val: [UInt8.max, 42, 23, UInt8.min])
        let i = BFIELD.I(val: [Int16.max, 0, Int16.min])
        let j = BFIELD.J(val: [Int32.max, 0, Int32.min])
        let k = BFIELD.K(val: [Int64.max, 0, Int64.min])
        let e = BFIELD.E(val: [Float.max, 0.0 , Float.min])
        let d = BFIELD.D(val: [Double.max, 0.0, Double.min])
        let c = BFIELD.C(val:  nil)
        let m = BFIELD.M(val:  nil)
        
        //let p = BFIELD.P(val:  nil)
        //let q = BFIELD.Q(val:  nil)
        
        XCTAssertEqual(a.form, BFORM.A(r: 11))
        XCTAssertEqual(l.form, BFORM.L(r: 1))
        XCTAssertEqual(i.form, BFORM.I(r: 3))
        XCTAssertEqual(x.form, BFORM.X(r: 1))
        XCTAssertEqual(b.form, BFORM.B(r: 4))
        XCTAssertEqual(i.form, BFORM.I(r: 3))
        XCTAssertEqual(j.form, BFORM.J(r: 3))
        XCTAssertEqual(k.form, BFORM.K(r: 3))
        XCTAssertEqual(e.form, BFORM.E(r: 3))
        XCTAssertEqual(d.form, BFORM.D(r: 3))
        
        XCTAssertEqual(c.form, BFORM.C(r: 0))
        XCTAssertEqual(m.form, BFORM.M(r: 0))
        
        //XCTAssertEqual(p.form, BFORM.P(r: 0))
        //XCTAssertEqual(q.form, BFORM.Q(r: 0))
    }
    
    
    func testReadTable() {
        
        guard var data = Data(base64Encoded: Bintable) else {
            return XCTFail("Unable to read sample")
        }
        
        guard let hdu = try? BintableHDU(with: &data) else {
            XCTFail("HDU must not be null")
            return
        }
        
        XCTAssertEqual(hdu.modified, false)
        XCTAssertEqual(hdu.tfields, 9)
        XCTAssertEqual(hdu.naxis, 2)
        XCTAssertEqual(hdu.naxis(1), 11535)
        XCTAssertEqual(hdu.naxis(2), 1)
        XCTAssertEqual(hdu.lookup("TFORM1"), BFORM.A(r: 5))
        XCTAssertEqual(hdu.lookup("TFORM2"), BFORM.I(r: 1))
        XCTAssertEqual(hdu.lookup("TFORM3"), BFORM.E(r: 1))
        XCTAssertEqual(hdu.lookup("TFORM4"), BFORM.E(r: 1))
        XCTAssertEqual(hdu.lookup("TFORM5"), BFORM.E(r: 640))
        XCTAssertEqual(hdu.lookup("TFORM6"), BFORM.E(r: 640))
        XCTAssertEqual(hdu.lookup("TFORM7"), BFORM.E(r: 640))
        XCTAssertEqual(hdu.lookup("TFORM8"), BFORM.I(r: 640))
        XCTAssertEqual(hdu.lookup("TFORM9"), BFORM.E(r: 640))
        XCTAssertEqual(hdu.columns.count, hdu.tfields)
        XCTAssertEqual(hdu.rows.count, hdu.naxis(2))
        XCTAssertEqual(hdu.columns.first?.values.count, hdu.naxis(2))
        
        XCTAssertEqual(hdu.rows[0][3], BFIELD.E(val: [2.6627994]))
        
        //plotTable(hdu)
        
    }
    
    func testCreateTable() {
        
        let hdu = BintableHDU()
        let col1 = hdu.addColumn(TFORM: BFORM.A(r: 4), TDISP: BDISP.A(w: 8), TTYPE: "Numbers" , BFIELD.A(val: "EINS"), BFIELD.A(val: "Zwei"), BFIELD.A(val: nil), BFIELD.A(val: "Vier"))
        let _ = hdu.addColumn(TFORM: BFORM.L(r: 4), TDISP: BDISP.L(w: 2), TTYPE: "Logic" , BFIELD.L(val: [true,false,true]), BFIELD.L(val: [true,false,true]), BFIELD.L(val: [true,false,true]), BFIELD.L(val: [true,false,true]))
        
        XCTAssertEqual(hdu.lookup("TFIELDS"),  2)
        XCTAssertEqual(hdu.lookup("NAXIS1"),  8)
        XCTAssertEqual(hdu.lookup("NAXIS2"), 4)
        
        let _ = hdu.addColumn(TFORM: BFORM.I(r: 8), TDISP: BDISP.I(w: 4, m: 6), .I(val: [4123]),.I(val: [1234]),.I(val: [8977]),.I(val: [5434]))
        
        XCTAssertEqual(hdu.columns.count, 3)
        XCTAssertEqual(hdu.columns[0].values.count, 4)
        XCTAssertEqual(hdu.columns[1].values.count, 4)
        XCTAssertEqual(col1.TFORM, BFORM.A(r: 4))
        XCTAssertEqual(hdu.lookup("TFORM1"), BFORM.A(r: 4))
        XCTAssertEqual(hdu.lookup("TFIELDS"),  3)
        XCTAssertEqual(hdu.lookup("NAXIS1"),  24)
        XCTAssertEqual(hdu.lookup("NAXIS2"), 4)
        
        
        _ = hdu.validate()
        
        hdu.headerUnit.forEach { block in
            print(block)
        }
        
        //plotTable(hdu)
        
    }
    
    func testModifyTable(){
        
        let hdu = BintableHDU()
        
        let col1 = hdu.addColumn(TFORM: BFORM.I(r: 3), TTYPE: "Numbers", BFIELD.I(val: [3]),BFIELD.I(val: [3]),BFIELD.I(val: [3]))
        let col2 = hdu.addColumn(TFORM: BFORM.A(r: 9), TTYPE: "Text", BFIELD.A(val: "Hello"),BFIELD.A(val: "World"),BFIELD.A(val: "AGAIN"))
        let row1 = hdu.rows[0]
        let row3 = hdu.rows[2]
        
        // possible
        col1[2] = BFIELD.I(val: [2])
        // not possible
        col2[1] = BFIELD.I(val: [4])
        
        // not possible
        row1[1] = BFIELD.I(val: [42])
        // possible
        row3[1] = BFIELD.A(val: "REDACTED!")
        
        self.plotTable(hdu)
        
        XCTAssertEqual(hdu.columns[0].values[0], BFIELD.I(val: [3]))
        XCTAssertEqual(hdu.columns[0].values[1], BFIELD.I(val: [3]))
        XCTAssertEqual(hdu.columns[0].values[2], BFIELD.I(val: [2]))
        
        XCTAssertEqual(hdu.columns[1].values[0], BFIELD.A(val: "Hello"))
        XCTAssertEqual(hdu.columns[1].values[1], BFIELD.A(val: "World"))
        XCTAssertEqual(hdu.columns[1].values[2], BFIELD.A(val: "REDACTED!"))
    }
    
    func testWriteTable() {
        
        let hdu = BintableHDU()
        let _ = hdu.addColumn(TFORM: BFORM.I(r: 1), TDISP: BDISP.I(w: 5, m: 3), TTYPE: "Numbers", BFIELD.I(val: [3]),BFIELD.I(val: [333]),BFIELD.I(val: [3]))
        let _ = hdu.addColumn(TFORM: BFORM.A(r: 5), TDISP: BDISP.A(w: 10),  TTYPE: "Text", BFIELD.A(val: "Hello"),BFIELD.A(val: "World"),BFIELD.A(val: "AGAIN"))
        let _ = hdu.addColumn(TFORM: BFORM.E(r: 1), TDISP: BDISP.E(w: 30, d: 10, e: nil), TTYPE: "Exponentials", BFIELD.E(val: [20392.232234]),BFIELD.E(val: [3939.333222]),BFIELD.E(val: [9393.2232342342342]))
        let _ = hdu.addColumn(TFORM: BFORM.L(r: 3), TDISP: BDISP.L(w: 2), TTYPE: "Logic" , BFIELD.L(val: [true,false,true]), BFIELD.L(val: [false,false,true]), BFIELD.L(val: [true,false,true]))
        let _ = hdu.addColumn(TFORM: BFORM.D(r: 3), TDISP: BDISP.D(w: 10, d:2, e: 3), TTYPE: "Double" , BFIELD.D(val: [Double.max, 0, Double.min]), BFIELD.D(val: [Double.max, Double.max, Double.max]), BFIELD.D(val: [Double.min, Double.min, Double.min]))
        
        let prime = PrimaryHDU()
        prime.hasExtensions = true
        
        let file = FitsFile.init(prime: prime)
        file.HDUs.append(hdu)
        
        XCTAssertEqual(hdu.naxis, 2)
        XCTAssertEqual(hdu.bitpix, BITPIX.UINT8)
        XCTAssertEqual(hdu.naxis(1), 38)
        XCTAssertEqual(hdu.naxis(2), 3)
        XCTAssertEqual(hdu.pcount, 0)
        XCTAssertEqual(hdu.lookup(HDUKeyword.GCOUNT), 1)
        XCTAssertEqual(hdu.dataSize, 114)
        XCTAssertEqual(hdu.dataUnit, nil)
        
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
        
        guard let thdu  = parsed.HDUs.first as? BintableHDU else {
            XCTFail("There must be a table HDU")
            return
        }
        
        XCTAssertEqual(thdu.naxis, 2)
        XCTAssertEqual(thdu.bitpix, BITPIX.UINT8)
        XCTAssertEqual(thdu.naxis(1), 38)
        XCTAssertEqual(thdu.naxis(2), 3)
        XCTAssertEqual(thdu.pcount, 0)
        XCTAssertEqual(thdu.lookup(HDUKeyword.GCOUNT), 1)
        XCTAssertEqual(thdu.dataSize, 114)
        XCTAssertEqual(thdu.dataUnit?.count, 114)
        
        
        XCTAssertEqual(thdu.columns[0].TFORM, hdu.columns[0].TFORM)
        XCTAssertEqual(thdu.columns[0][0], hdu.columns[0][0])
        XCTAssertEqual(thdu.columns[1][1], hdu.columns[1][1])
        XCTAssertEqual(thdu.columns[2][2], hdu.columns[2][2])
        XCTAssertEqual(thdu.columns[3][0], hdu.columns[3][0])
        XCTAssertEqual(thdu.columns[3][1], hdu.columns[3][1])
        XCTAssertEqual(thdu.columns[3][2], hdu.columns[3][2])
        XCTAssertEqual(thdu.columns[4][0], hdu.columns[4][0])
        XCTAssertEqual(thdu.columns[4][1], hdu.columns[4][1])
        XCTAssertEqual(thdu.columns[4][2], hdu.columns[4][2])
        
        if let thdu = parsed.HDUs.first as? AnyTableHDU<BFIELD> {
            self.plotTable(thdu)
        }
        
    }
    
    
    
    
    
    
    
    
    
    //MARK:-
    
    func plotTable<Field: FIELD>(_ hdu: AnyTableHDU<Field>){
        var data = Data()
        hdu.plot(data: &data)
        if let out = String(data: data, encoding: .ascii) {
            print(out)
        }
    }
    
}
