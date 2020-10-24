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

/**
 A FITS (ASCII) Table Extension
 
 
 The ASCII-table extension provides a means of storing catalogs and tables of astronomical data in FITS format. Each row of the table consists of a fixed-length sequence of ASCII characters divided into fields that correspond to the columns in the table. The first keyword record in an ASCII-table extension shall be XTENSION=␣'TABLE␣␣␣'.
 */
public final class TableHDU : AnyTableHDU<TFIELD> {
    
    /// initializes the a new HDU with all default headers
    public required init() {
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
        
        // fill with blanks instead of zeros
        self.pad(&to, by: CARD_LENGTH*BLOCK_LENGTH, with: 32)
    }
    
}
