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

public final class BintableHDU : AnyHDU {
    public typealias ValueType = BField
    
    public internal(set) var table : [BField] = []
    
    public required init(with data: inout Data) throws {
        try super.init(with: &data)
        
        self.buildTable()
    }
    
    func buildTable() {
        
        let fieldCount = self.lookup(HDUKeyword.TFIELDS) ?? 0
        // The value field shall contain a non-negative integer, giving the number of eight-bit bytes in each row of the table.
        let rowLength = self.naxis(1) ?? 1
        // The value field shall contain a non-negative integer, giving the number of rows in the table
        let rows = self.naxis(2) ?? 0
        
        var format : [Int:(Int,Int)] = [:]
        var offset : Int = 0
        
        // pre-fetch field properties
        for col in 0..<fieldCount {
            let rawTDISP : String? = self.lookup("TDISP\(col+1)")
            let rawTTYPE : String? = self.lookup("TTYPE\(col+1)")
            let rawTUNIT : String? = self.lookup("TUNIT\(col+1)")
            let rawTFORM : String = self.lookup("TFORM\(col+1)") ?? ""
            let rawTSCAL : String? = self.lookup("TSCAL\(col+1)")
            
            if let tform = BFORM.parse(rawTFORM) {
                let field = BField(TFORM: tform, TUNIT: rawTUNIT, TTYPE: rawTTYPE)
                
                
                table.append(field)
                format[col]  = (offset,tform.length)
                offset = offset + tform.length
            }
        }
        
        guard var data = self.dataUnit , data.count == rows * rowLength else {
            print("Invalid data size \(dataUnit?.count ?? 0); Expected \(rows * rowLength)")
            return
        }
        
        for _ in 0..<rows {
            let row = data.subdata(in: 0..<rowLength)
            for columnIndex in 0..<table.count {
                let column = table[columnIndex]
                if let tfrom  = format[columnIndex] {
                    //print("\(rowIndex): \(column.TTYPE ?? "N/A"): \(column.TFORM) \(tfrom.0)...\(tfrom.0+tfrom.1)")
                    let val = row.subdata(in: tfrom.0..<tfrom.0+tfrom.1)
                    let value = BFIELD.parse(data: val, type: column.TFORM)
                    column.values.append(value)
                }
            
            }
        }
        if data.count > rowLength {
            data = data.advanced(by: rowLength)
        } else {
            data = Data()
        }
    }
}

public class BField : Identifiable {
    public let id = UUID()
    
    public var TDISP : BDISP?
    public var TFORM : BFORM
    public var TUNIT : String?
    public var TTYPE : String?
    public var TSCAL : Float?
    public var TZERO : Float?
    public var TDIM : Character?
    
    init(TFORM: BFORM, TUNIT: String?, TTYPE: String?){
        self.TFORM = TFORM
        self.TUNIT = TUNIT
        self.TTYPE = TTYPE
    }
    
    public var values : [BFIELD] = []
}
