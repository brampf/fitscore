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
 A FITS Binary Table extension
 
 The binary-table extension is similar to the ASCII table in that it provides a means of storing catalogs and tables of astronomical data in FITS format, however, it offers more features and pro- vides more-efficient data storage than ASCII tables. The numer- ical values in binary tables are stored in more-compact binary formats rather than coded into ASCII, and each field of a binary table can contain an array of values rather than a simple scalar as in ASCII tables. The first keyword record in a binary-table extension shall be XTENSION=␣'BINTABLE'.
 */
public final class BintableHDU : AnyTableHDU<BFIELD> {
    
    @Keyword(HDUKeyword.THEAP) public var theap : Int?
    
    /// initializes the a new HDU with all default headers
    public required init() {
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
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.PCOUNT, value: 0, comment: "Number of bytes in heap"))
        // The value field shall contain the integer 1; the data blocks contain a single table.
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.GCOUNT, value: 1, comment: "One Group"))
        // The value field shall contain a non-negative integer representing the number of fields in each row. 
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.TFIELDS, value: 0, comment: "Number of fields in each row"))
        // The value field of this keyword shall contain an integer providing the separation, in bytes, between the start of the main data table and the start of a supplemental data area called the heap.
        //self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.THEAP, comment: "Bytes offset of heap"))
    }
    
    override func initializeWrapper() {
        super.initializeWrapper()
        self._theap.initialize(self.headerUnit)
    }
    
    public override func validate(onMessage: ((String) -> Void)? = nil) -> Bool {
        
        
        let rowSize = self.columns.reduce(into: 0) { size, col in
            size += col.TFORM?.length ?? 0
        }
        
        let heapSize = self.columns.reduce(into: 0) { size, col in
            if let tform = col.TFORM, tform.heapSize > 0 {
                size += col.values.count * tform.heapSize
            }
        }
        
        if  heapSize > 0 {
            // if there is no heap, there is no pcount
            self.theap = headerUnit.dataArraySize
            self.pcount = rowSize * self.rows.count + heapSize
        }
        
        return super.validate(onMessage: onMessage)
    }
    
    override internal func writeData(to: inout Data) throws {

        var heap = Data()
        
        for row in self.rows {
            for index in 0..<row.values.count{
                let field = row[index]
                //let tform = row.TFORM(index)!
                
                if let field = field as? WritableVarBField {
                    field.write(to: &to, heap: &heap)
                } else if let field = field as? WritableBField {
                    field.write(to: &to)
                } else {
                    print("Not writable: \(field)")
                }

            }
        }

        to.append(heap)
        
        // fill with zeros
        self.pad(&to, by: CARD_LENGTH*BLOCK_LENGTH, with: 0)
    }
    
    public override var description: String {
        
        let theap = self.theap ?? 0
        let heap = self.dataUnit?.subdata(in: theap..<headerUnit.dataSize)
        return super.description.appending(" + \(heap?.count ?? 0) HEAP")
    }
}
