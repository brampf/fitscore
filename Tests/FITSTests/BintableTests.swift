
import XCTest
@testable import FITS

func XCTAssertIdent<B: BField & BFIELD>(_ field: B, file: StaticString = #file, line: UInt = #line) {
    
    var data = Data()
    field.write(to: &data)
    
    let new = BFIELD.parse(data: data, type: field.form)
    
    XCTAssertEqual(field.form, new.form, file: file, line: line)
    XCTAssertEqual(field, new, file: file, line: line)
}

func XCTAssertLength<B: BField>(_ field: B, _ expectedLenght: Int, file: StaticString = #file, line: UInt = #line) {
    
    var data = Data()
    field.write(to: &data)
    
    let count = field.val?.count ?? 0
    
    XCTAssertEqual(data.count, count * MemoryLayout<B.ValueType>.size, file: file, line: line)
    XCTAssertEqual(data.count, expectedLenght, file: file, line: line)
}

func XCTAssertLength<V: VarArray>(_ field: V, _ expectedLenght: Int, file: StaticString = #file, line: UInt = #line) {
    
    var data = Data()
    var heap = Data()
    field.write(to: &data, heap: &heap)
    
    let count = field.val?.count ?? 0
    
    XCTAssertEqual(data.count, 8, file: file, line: line)
    //XCTAssertEqual(Array(data), [UInt8](arrayLiteral: 0,0,0,UInt8(count),0,0,0,0), file: file, line: line)
    XCTAssertEqual(heap.count, count * MemoryLayout<V.ValueType>.size, file: file, line: line)
    XCTAssertEqual(heap.count, expectedLenght, file: file, line: line)
}

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
        XCTAssertEqual(a.form, BFORM.A(r: 11))
        XCTAssertLength(a, 11)
        XCTAssertIdent(a)
        
        let l = BFIELD.L(val: [true])
        XCTAssertEqual(l.form, BFORM.L(r: 1))
        XCTAssertLength(l, 1)
        XCTAssertIdent(l)
        
        let x = BFIELD.X(val: Data(repeating: 0b00000100, count: 1))
        XCTAssertEqual(x.form, BFORM.X(r: 1))
        XCTAssertLength(x,1)
        XCTAssertIdent(x)
        
        let b = BFIELD.B(val: [UInt8.max, 42, 23, UInt8.min])
        XCTAssertEqual(b.form, BFORM.B(r: 4))
        XCTAssertLength(b, 4)
        XCTAssertIdent(b)
        
        let i = BFIELD.I(val: [Int16.max, 0, Int16.min])
        XCTAssertEqual(i.form, BFORM.I(r: 3))
        XCTAssertLength(i, 6)
        XCTAssertIdent(i)
        
        let j = BFIELD.J(val: [Int32.max, 0, Int32.min])
        XCTAssertEqual(j.form, BFORM.J(r: 3))
        XCTAssertLength(j, 12)
        XCTAssertIdent(j)
        
        let k = BFIELD.K(val: [Int64.max, 0, Int64.min])
        XCTAssertEqual(k.form, BFORM.K(r: 3))
        XCTAssertLength(k, 24)
        XCTAssertIdent(k)
        
        let e = BFIELD.E(val: [Float.max, 0.0 , Float.min])
        XCTAssertEqual(e.form, BFORM.E(r: 3))
        XCTAssertLength(e, 12)
        XCTAssertIdent(e)
        
        let d = BFIELD.D(val: [Double.max, 0.0, Double.min])
        XCTAssertEqual(d.form, BFORM.D(r: 3))
        XCTAssertLength(d, 24)
        XCTAssertIdent(d)
        
        let c = BFIELD.C(val:  nil)
        XCTAssertEqual(c.form, BFORM.C(r: 0))
        
        let m = BFIELD.M(val:  nil)
        XCTAssertEqual(m.form, BFORM.M(r: 0))
        
        let pa = BFIELD.PA(val:  "Hello World!")
        XCTAssertEqual(pa.form, BFORM.PA(r: 12))
        XCTAssertLength(pa, 12)
        XCTAssertIdent(pa)
        
        let pl = BFIELD.PL(val:  [true,false,true,false,true])
        XCTAssertEqual(pl.form, BFORM.PL(r: 5))
        XCTAssertLength(pl, 5)
        XCTAssertIdent(pl)
        
        let pb = BFIELD.PB(val:  [0,1,2,3,4,5,6,7,8,9,255])
        XCTAssertEqual(pb.form, BFORM.PB(r: 11))
        XCTAssertLength(pb, 11)
        XCTAssertIdent(pb)
        
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
        XCTAssertEqual(thdu.gcount, 1)
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
    
    func testWriteVarArray() {
        
        let prime = PrimaryHDU()
        prime.hasExtensions = true
        
        let bintable = BintableHDU()
        _ = bintable.addColumn(TFORM: BFORM.I(r: 1), TDISP: BDISP.I(w: 5, m: 1), TUNIT: "", TTYPE: "Index", BFIELD.I(val: [1]), BFIELD.I(val: [2]))
        _ = bintable.addColumn(TFORM: BFORM.PA(r: 25), TDISP: BDISP.A(w: 5), TUNIT: "", TTYPE: "Characters", BFIELD.PA(val: "HELLO WORLD UPPERCASE"), BFIELD.PA(val: "hello world lowercase"))
        _ = bintable.addColumn(TFORM: BFORM.PL(r: 10), TDISP: BDISP.L(w: 1), TUNIT: "",TTYPE: "Logical", BFIELD.PL(val: [true,false,true,false,true,false,true,false]), BFIELD.PL(val: [false,true]))
        _ = bintable.addColumn(TFORM: BFORM.PB(r: 10), TDISP: BDISP.B(w: 5, m: 2), TUNIT: "", TTYPE: "Integer", BFIELD.PB(val: [0,1,23,42,128,255]), BFIELD.PB(val: []))
        _ = bintable.addColumn(TFORM: BFORM.PJ(r: 10), TDISP: BDISP.E(w: 10, d: 4, e: nil), TUNIT: "", TTYPE: "Integer", BFIELD.PJ(val: [0,1,23,42,128,255]), BFIELD.PJ(val: []))
        
        let file = FitsFile(prime: prime)
        file.HDUs.append(bintable)
        
        let rowSize = bintable.columns.reduce(into: 0) { size, col in
            size += col.TFORM?.length ?? 0
        }
        
        let heapSize = bintable.columns.reduce(into: 0) { size, col in
            if col.TFORM?.isVarArray ?? false {
                size += col.values.count  * (col.TFORM?.heapSize ?? 0)
            }
        }
        
        XCTAssertTrue(file.HDUs[0] is BintableHDU)
        XCTAssertEqual(bintable.naxis, 2)
        XCTAssertEqual(bintable.bitpix, BITPIX.UINT8)
        XCTAssertEqual(bintable.naxis(1), rowSize)
        XCTAssertEqual(bintable.naxis(2), 2)
        XCTAssertEqual(bintable.pcount, 0)
        XCTAssertEqual(bintable.gcount, 1)

        XCTAssertEqual(bintable.dataArraySize, 68)
        XCTAssertEqual(bintable.dataSize, 68)
        XCTAssertEqual(bintable.dataUnit, nil)
        
        _ = bintable.validate()
        
        XCTAssertEqual(bintable.pcount, rowSize * bintable.rows.count + heapSize)
        XCTAssertEqual(bintable.theap, rowSize * bintable.rows.count)
        
        //let desktop = try! FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        //let url = desktop.appendingPathComponent("FitsCore.fits")
        
        print(bintable.description)
        
        var data = Data()
        try! file.write(to: &data)
        
        
        // -----------------------------------
        
        let new = try! FitsFile.read(from: &data)
        
        new.validate { msg in
            print(msg)
        }
        
        XCTAssertTrue(new.HDUs[0] is BintableHDU)
        guard let btable = new.HDUs[0] as? BintableHDU else {
            XCTFail("Expected bintable")
            return
        }
        
        XCTAssertEqual(btable.dataArraySize, 68)
        XCTAssertEqual(btable.dataSize, 150)
        
        XCTAssertEqual(btable.pcount, 82)
        XCTAssertEqual(btable.theap, 68)
        
        XCTAssertEqual(btable.columns.count, 5)
        XCTAssertEqual(btable.rows.count, 2)
        
        XCTAssertEqual(btable.columns[0].TDISP, bintable.columns[0].TDISP)
        XCTAssertEqual(btable.columns[0].TFORM, bintable.columns[0].TFORM)
        XCTAssertEqual(btable.columns[0].values, bintable.columns[0].values)
        
        XCTAssertEqual(btable.columns[1].TDISP, bintable.columns[1].TDISP)
        XCTAssertEqual(btable.columns[1].TFORM, bintable.columns[1].TFORM)
        XCTAssertEqual(btable.columns[1].values, bintable.columns[1].values)
        
        XCTAssertEqual(btable.columns[2].TDISP, bintable.columns[2].TDISP)
        XCTAssertEqual(btable.columns[2].TFORM, bintable.columns[2].TFORM)
        XCTAssertEqual(btable.columns[2].values,bintable.columns[2].values)
        
        XCTAssertEqual(btable.columns[3].TDISP, bintable.columns[3].TDISP)
        XCTAssertEqual(btable.columns[3].TFORM, bintable.columns[3].TFORM)
        XCTAssertEqual(btable.columns[3].values, bintable.columns[3].values)
        
        XCTAssertEqual(btable.columns[4].TDISP, bintable.columns[4].TDISP)
        XCTAssertEqual(btable.columns[4].TFORM, bintable.columns[4].TFORM)
        XCTAssertEqual(btable.columns[4].values, bintable.columns[4].values)
        
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
