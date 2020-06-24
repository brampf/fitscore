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

public final class TableHDU : AnyTableHDU<TFIELD> {
    
    public required init(with data: inout Data) throws {
        try super.init(with: &data)
        
        self.initializeWrapper()
        
        self.readTable()
    }
    
    /// initializes the a new HDU with all default headers
    required init() {
        super.init()
        // The value field shall contain the integer 2, de- noting that the included data array is two-dimensional: rows and columns.
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.XTENSION, value: "TABLE   ", comment: "Table extension"))
        // The value field shall contain the integer 8, denoting that the array contains ASCII characters.
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.BITPIX, value: BITPIX.UINT8,  comment: "Only Chars in Table"))
        // The value field shall contain the integer 2, de- noting that the included data array is two-dimensional: rows and columns.
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.NAXIS, value: 2, comment: "Two dimensional table"))
        //The value field shall contain a non-negative integer, giving the number of ASCII characters in each row of the table. This includes all the characters in the defined fields plus any characters that are not included in any field.
        self.headerUnit.append(HeaderBlock(keyword: "NAXIS1", value: 0, comment: "Number of characters per row"))
        // The value field shall contain a non-negative integer, giving the number of rows in the table.
        self.headerUnit.append(HeaderBlock(keyword: "NAXIS2", value: 0, comment: "Number of rows"))
        // The value field shall contain the integer 0
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.PCOUNT, value: 0, comment: "No random parameter"))
        // The value field shall contain the integer 1; the data blocks contain a single table.
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.GCOUNT, value: 1, comment: "One Group"))
        // Thevaluefieldshallcontainanon-negative integer representing the number of fields in each row. The max- imum permissible value is 999
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.TFIELDS, value: 0, comment: "Number of fields in each row"))
    }
    
    /**
     Reads the table structure from raw data
     
     Reads the `dataUnit` according to the header files
     */
    public func readTable() {
        
        let fieldCount = self.lookup(HDUKeyword.TFIELDS) ?? 0
        
        var format : [Int:(Int,Int)] = [:]
        
        // pre-fetch field properties
        for col in 0..<fieldCount {
            
            let rawTBCOL : Int = self.lookup("TBCOL\(col+1)") ?? 1
            let rawTTYPE : String? = self.lookup("TTYPE\(col+1)")
            let rawTUNIT : String? = self.lookup("TUNIT\(col+1)")
            let rawTFORM : TFORM? = self.lookup("TFORM\(col+1)")
            let rawTDISP : TDISP? = self.lookup("TDISP\(col+1)")
            
            if let tform = rawTFORM {
                self.columns.append(TableColumn(self, (col+1), TDISP: rawTDISP, TFORM: tform, TUNIT: rawTUNIT, TTYPE: rawTTYPE ?? ""))
                //_ = self.addColumnIMPL(index: col, TFORM: tform, TDISP: rawTDISP, TUNIT: rawTUNIT, TTYPE: rawTTYPE)
                format[col]  = (rawTBCOL,tform.length)
            }
        }
        
         // read actual values
        let rowLength = self.naxis(1) ?? 1
        let rows = self.naxis(2) ?? 0
        
        guard var data = self.dataUnit , data.count >= rows * rowLength else {
            //print("Invalid data size \(dataUnit?.count ?? 0); Expected \(rows * rowLength)")
            return
        }
        
        for _ in 0..<rows {
            let row = data.subdata(in: 0..<rowLength)
            for columnIndex in 0..<columns.count {
                let column = columns[columnIndex]
                if let tfrom  = format[columnIndex] {
                    //print("\(rowIndex): \(column.TTYPE ?? "N/A"): \(column.TFORM) \(tfrom.0)...\(tfrom.0+tfrom.1)")
                    let val = row.subdata(in: tfrom.0-1..<tfrom.0+tfrom.1-1)
                    var string = String(data: val, encoding: .ascii) ?? ""
                    string = string.trimmingCharacters(in: .whitespacesAndNewlines)
                    if let tform = column.TFORM {
                        let value = TFIELD.parse(string: string, type: tform)
                        #if DEBUG
                        value.raw = string
                        #endif
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

    public override func validate(onMessage: ((String) -> Void)? = nil) -> Bool {
        
        // suboptimal hack to set TBCOL
        for row in self.rows {
            var tbcol = 1
            for index in 0..<row.values.count{
                //let field = row[index]
                let form = row.TFORM(index)!
                self.header("TBCOL\(index+1)", value: tbcol, comment: nil)
                tbcol += form.length
            }
        }
        
        return super.validate(onMessage: onMessage)
    }
    
    override internal func writeData(to: inout Data) throws {
        
        for row in self.rows {
            for index in 0..<row.values.count{
                let field = row[index]
                let form = row.TFORM(index)!
                if let data = field.write(form).data(using: .ascii) {
                    to.append(data)
                }
            }
        }
        
        // fill with zeros
        self.pad(&to, by: CARD_LENGTH*BLOCK_LENGTH)
    }
    
}
