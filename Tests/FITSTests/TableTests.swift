
import XCTest
@testable import FITS


final class TableTests: XCTestCase {

    
    func testReadTable() {
        
        guard var data = Data(base64Encoded: Table) else {
            return XCTFail("Unable to read sample")
        }
        
        guard let hdu = try? TableHDU(with: &data) else {
            XCTFail("HDU must not be null")
            return
        }
        
        for header in hdu.headerUnit {
            //print("\(header.keyword.padding(toLength: 9, withPad: " ", startingAt: 0)) = \(header.value?.description ?? "nil") : \(header.value.self.debugDescription)")
           //print(header.raw ?? "")
        }
        
        XCTAssertEqual(hdu.lookup("TFORM1"), TFORM.E(w: 15, d: 7))
        XCTAssertEqual(hdu.table.count, hdu.tfields)
        XCTAssertEqual(hdu.table.first?.values.count, hdu.naxis(2))
        
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
        
        let col2 = hdu.addColumn(TFORM: TFORM.I(w: 8), TDISP: TDISP.I(w: 4, m: 6), .I(val: 4123),.I(val: 1234),.I(val: 8977),.I(val: 5434))
        
        XCTAssertEqual(hdu.table.count, 2)
        XCTAssertEqual(hdu.table[0].values.count, 4)
        XCTAssertEqual(hdu.table[1].values.count, 4)
        XCTAssertEqual(col1.TFORM, TFORM.A(w: 4))
        XCTAssertEqual(hdu.lookup("TFORM1"), TFORM.A(w: 4))
        XCTAssertEqual(hdu.lookup("TFIELDS"),  2)
        XCTAssertEqual(hdu.lookup("NAXIS1"),  12)
        XCTAssertEqual(hdu.lookup("NAXIS2"), 4)

        _ = hdu.validate()
        
        hdu.headerUnit.forEach { block in
            print(block)
        }
        
        plotTable(hdu)
        
    }
    
    func plotTable<Field: FIELD>(_ hdu: AnyTableHDU<Field>){
        
        let maxCellWidth = hdu.table.reduce(into: 0){ m, col in
            m = max(m, max(col.TFORM?.length ?? 0, col.TTYPE?.count ?? 0))
        }
        let dashWidth = (4 + maxCellWidth) * (hdu.tfields ?? 0)
        let dashes = String(repeating: "-", count: dashWidth-1)
        //String(repeating: "-", count: hdu.naxis(1) ?? 0)
        
        print(dashes)
        var out = ""
        for col in 0..<(hdu.tfields ?? 0) {
            let ttype = hdu.table[col].TTYPE ?? "N/A"
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
                let disp = hdu.table[col].TDISP
                let field = hdu.table[col].values[row]
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
