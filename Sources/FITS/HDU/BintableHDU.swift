/*
 
 Copyright (c) <2020>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 */

import Foundation

public final class BintableHDU : AnyTableHDU<BFIELD> {
    
    public var heap: Data? {
        
        let size = self.dataSize
        let theap = self.lookup(HDUKeyword.THEAP) ?? 0
        let offset = size - theap
        
        return self.dataUnit?.subdata(in: offset..<size)
    }
    
    public required init(with data: inout Data) throws {
        try super.init(with: &data)
        
        self.buildTable()
    }
    
    /// initializes the a new HDU with all default headers
    required init() {
        super.init()
        // The value field shall contain the integer 2, de- noting that the included data array is two-dimensional: rows and columns.
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.XTENSION, value: "BINTABLE", comment: "Table extension"))
        // The value field shall contain the integer 8, denoting that the array contains ASCII characters.
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.BITPIX, value: BITPIX.UINT8,  comment: "Only Chars in Table"))
        // The value field shall contain the integer 2, de- noting that the included data array is two-dimensional: rows and columns.
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.NAXIS, value: 2, comment: "Two dimensional table"))
        // The value field shall contain a non-negative integer, giving the number of eight-bit bytes in each row of the table.
        self.headerUnit.append(HeaderBlock(keyword: "NAXIS1", value: 0, comment: "Number of bytes per row"))
        // The value field shall contain a non-negative integer, giving the number of rows in the table.
        self.headerUnit.append(HeaderBlock(keyword: "NAXIS2", value: 0, comment: "Number of rows"))
        // The value field shall contain the number of bytes that follow the table in the supplemental data area called the heap.
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.PCOUNT, value: 0, comment: "No random parameter"))
        // The value field shall contain the integer 1; the data blocks contain a single table.
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.GCOUNT, value: 1, comment: "One Group"))
        // The value field shall contain a non-negative integer representing the number of fields in each row. 
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.TFIELDS, value: 0, comment: "Number of fields in each row"))
    }
    
    /**
        Reads the table structure from raw data
     
        Reads the `dataUnit` according to the header files
     */
    public func buildTable() {
        
        let fieldCount = self.lookup(HDUKeyword.TFIELDS) ?? 0
        // The value field shall contain a non-negative integer, giving the number of eight-bit bytes in each row of the table.
        let rowLength = self.naxis(1) ?? 1
        // The value field shall contain a non-negative integer, giving the number of rows in the table
        let rows = self.naxis(2) ?? 0
        
        var format : [Int:(Int,Int)] = [:]
        var offset : Int = 0
        
        // pre-fetch field properties
        for col in 0..<fieldCount {
            let rawTDISP : BDISP? = self.lookup("TDISP\(col+1)")
            let rawTTYPE : String? = self.lookup("TTYPE\(col+1)")
            let rawTUNIT : String? = self.lookup("TUNIT\(col+1)")
            let rawTFORM : BFORM? = self.lookup("TFORM\(col+1)")
            let rawTSCAL : String? = self.lookup("TSCAL\(col+1)")
            
            if let tform = rawTFORM {
                self.columns.append(TableColumn(self, (col+1), TDISP: rawTDISP, TFORM: tform, TUNIT: rawTUNIT, TTYPE: rawTTYPE ?? ""))
                format[col]  = (offset,tform.length)
                offset = offset + tform.length
            }
        }
        
        guard var data = self.dataUnit, data.count >= rows * rowLength else {
            print("Invalid data size \(dataUnit?.count ?? 0); Expected \(rows * rowLength)")
            return
        }
        
        for _ in 0..<rows {
            let row = data.subdata(in: 0..<rowLength)
            for columnIndex in 0..<columns.count {
                let column = columns[columnIndex]
                if let tfrom  = format[columnIndex] {
                    //print("\(rowIndex): \(column.TTYPE ?? "N/A"): \(column.TFORM) \(tfrom.0)...\(tfrom.0+tfrom.1)")
                    let val = row.subdata(in: tfrom.0..<tfrom.0+tfrom.1)
                    if let tform = column.TFORM {
                        if tform.isVarArray {
                            // Special treatment
                            let desc = tform.varArray(data: val)
                            //print("\(rowIndex): HEAP: \(column.TFORM) \(desc)")
                            //print("H\(rowIndex): \(column.TFORM): \(desc.offset)...\(desc.offset+desc.nelem)")
                            //let dat = self.heap?.subdata(in: desc.offset..<desc.offset+tform.length)
                            
                            //let value = BFIELD.parse(data: dat, type: tform)
                            //column.values.append(value)
                            #if DEBUG
                            //value.raw = val
                            #endif
                            
                        } else {
                            let value = BFIELD.parse(data: val, type: tform)
                            column.values.append(value)
                            #if DEBUG
                            value.raw = val
                            #endif
                        }
                    }
                }
            
            }
            if data.count > rowLength {
                data = data.advanced(by: rowLength)
            } else {
                data = Data()
            }
        }
        
        /// - TODO: Read Varargs
    }
    
    override internal func writeData(to: inout Data) throws {
        
        for row in self.rows {
            for index in 0..<row.values.count{
                let field = row[index]
                //let form = row.TFORM(index)!
                field.write(to: &to)
            }
        }
        
        // fill with zeros
        self.pad(&to, by: CARD_LENGTH*BLOCK_LENGTH)
    }
    
    public override var description: String {
        return super.description.appending(" + \(self.heap?.count ?? 0) HEAP")
    }
}
