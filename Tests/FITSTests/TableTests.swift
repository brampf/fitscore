
import XCTest
@testable import FITS


final class TableTests: XCTestCase {

    static var allTests = [
        ("testTField",testTField)
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
        
    }
    
    
    func testReadTable() {
        
        guard var data = Data(base64Encoded: Table) else {
            return XCTFail("Unable to read sample")
        }
        
        guard let hdu = try? TableHDU(with: &data) else {
            XCTFail("HDU must not be null")
            return
        }
        
        XCTAssertEqual(hdu.modified, false)
        XCTAssertEqual(hdu.lookup("TFORM1"), TFORM.E(w: 15, d: 7))
        XCTAssertEqual(hdu.columns.count, hdu.tfields)
        XCTAssertEqual(hdu.columns.first?.values.count, hdu.naxis(2))
        
        for _ in 0..<(hdu.tfields ?? 0) {
            let dat = hdu.dataUnit!.subdata(in: 0..<(hdu.naxis(1) ?? 0))
            let row = String(data: dat, encoding: .ascii)
            print(row)
        }
        
        plotTable(hdu)
        
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
        let _ = hdu.addColumn(TFORM: TFORM.I(w: 3), TDISP: TDISP.I(w: 5, m: 3), TTYPE: "Numbers", TFIELD.I(val: 3),TFIELD.I(val: 333),TFIELD.I(val: 3))
        let _ = hdu.addColumn(TFORM: TFORM.A(w: 12), TDISP: TDISP.A(w: 10),  TTYPE: "Text", TFIELD.A(val: "Hello"),TFIELD.A(val: "World"),TFIELD.A(val: "AGAIN"))
        let _ = hdu.addColumn(TFORM: TFORM.E(w: 20, d: 4), TDISP: TDISP.E(w: 24, d: 4, e: 2), TTYPE: "Exponentials", TFIELD.E(val: 20392.232234),TFIELD.E(val: 3939.333222),TFIELD.E(val: 9393.2232342342342))
        
        self.plotTable(hdu)
        
        for row in hdu.rows {
            var out = ""
            for index in 0..<row.values.count{
                let field = row[index]
                let form = row.tform(index)!
                out.append(field.write(form))
            }
            print(out)
        }
        
        let prime = PrimaryHDU()

        prime.set(width: 300, height: 300, vectors: [FITSByte_8](repeating: 0, count: 300*300))
                prime.hasExtensions = true
        
        let file = FitsFile.init(prime: prime)
        file.HDUs.append(hdu)
        
        var test = file.validate { message in
            print("VAL: \(message)")
        }
        
        let desktop = try! FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let url = desktop.appendingPathComponent("Table.fits")
        
        file.write(to: url, onError: { error in
            print(error)
        }) {
            // done
        }
    }
    
    
    
    
    
    
    
    
    
    //MARK:-
    
    func plotTable<Field: FIELD>(_ hdu: AnyTableHDU<Field>){
        
        let maxCellWidth = hdu.columns.reduce(into: 0){ m, col in
            m = max(m, max(col.TFORM?.length ?? 0, col.TTYPE?.count ?? 0))
        }
        let dashWidth = (4 + maxCellWidth) * (hdu.tfields ?? 0)
        let dashes = String(repeating: "-", count: dashWidth-1)
        //String(repeating: "-", count: hdu.naxis(1) ?? 0)
        
        print(dashes)
        var out = ""
        for col in 0..<(hdu.tfields ?? 0) {
            let ttype = hdu.columns[col].TTYPE ?? "N/A"
            if col == 0 {
                out.append("|")
            }
            out.append(" ")
            out.append(ttype.padPrefix(minSize: maxCellWidth, char: " "))
            out.append(" |")
        }
        print(out)
        print(dashes)
        for row in 0..<(hdu.naxis(2) ?? 0) {
            var out = ""
            for col in 0..<(hdu.tfields ?? 0) {
                let disp = hdu.columns[col].TDISP
                let field = hdu.columns[col].values[row]
                let value = field.format(disp) ?? ""
                if col == 0 {
                    out.append("|")
                }
                out.append(" ")
                out.append(value.padPrefix(minSize: maxCellWidth, char: " "))
                out.append(" |")
            }
            print(out)
        }
        print(dashes)
    }
    
}
