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

extension AnyHDU : FITSReader {
    
     static func read(_ data: UnsafeRawBufferPointer, context: inout ReaderContext) -> Self? {
        
        // set the context to the current HDU
        context.currentHDU = Self.self
        
        #if DEBUG
        let start = context.offset
        #endif
        let new = Self.init()
        
        // read header block
        guard let head = HeaderUnit.read(data, context: &context) else {
            print("Header Unit broken")
            return nil
        }
        new.headerUnit = head
        #if DEBUG
        let headEnd = context.offset
        #endif
        context.move2CardEnd()
        #if DEBUG
        let headEndPadded = context.offset
        #endif
        
        // initialize the keyword wrappers
        new.initializeWrapper()
        
        // read data block
        context.currentHeader = head
        new.dataUnit = self.readData(data, context: &context)
        
        #if DEBUG
        let dataEnd = context.offset
        #endif
        context.move2CardEnd()
        #if DEBUG
        let dataEndPadded = context.offset
        #endif

        #if DEBUG
        print("--- \(Self.self) : \(head.dataSize) ------------------------ ")
        print("Header:  \(start) - \(headEnd) padded to \(headEndPadded)")
        print("Data:    \(headEndPadded) - \(dataEnd) padded to \(dataEndPadded)")
        #endif
        
        return new
    }
    
    internal static func readData(_ data: UnsafeRawBufferPointer, context: inout ReaderContext) -> DataUnit? {
        
        let endIndex = context.currentHeader?.dataSize ?? 0
        
        // most privitive DataUnit there is
        let du = Data(data[context.offset..<context.offset+endIndex])
        
        // move offset to end of dataUnit
        context.offset += endIndex
        
        return du
    }
    
}

extension TableHDU {
    
    /**
        Reads the table structure from raw data
     
        Reads the `dataUnit` according to the header files
     */
    internal func readTable(_ data: UnsafeRawBufferPointer, context: inout ReaderContext) {
        
        let fieldCount = context.currentHeader?[HDUKeyword.TFIELDS] ?? 0
        let rowLength = context.currentHeader?["NAXIS1"] ?? 1
        let rows = context.currentHeader?["NAXIS2"] ?? 0
        
        for columnIndex in 0..<fieldCount {
            
            if let tform : TFORM  = context.currentHeader?["TFORM\(columnIndex+1)"] {
                let ttype : String? = context.currentHeader?["TTYPE\(columnIndex+1)"]
                let tdisp : TDISP? = context.currentHeader?["TDISP\(columnIndex+1)"]
                let tunit : String? = context.currentHeader?["TUNIT\(columnIndex+1)"]
                let tbcol = context.currentHeader?["TBCOL\(columnIndex+1)"] ?? 1
            
                let column = TableColumn<TFIELD>(context.currentHeader!, (columnIndex+1), TDISP: tdisp, TFORM: tform, TUNIT: tunit, TTYPE: ttype ?? "")
                self.columns.append(column)
                
                for rowIndex in 0..<rows {
                    let start = context.offset+(rowIndex*rowLength)+tbcol-1
                    let end = start+tform.length
                    
                    //print("\(rowIndex): \(column.TTYPE ?? "N/A"): \(column.TFORM) \(start)...\(end)")
                    let bytes = data[start..<end]
                    
                    let value = TFIELD.read(bytes, type: tform)
                    #if DEBUG
                    value.raw = String(bytes: bytes, encoding: .ascii) ?? ""
                    #endif
                    column.values.append(value)
                }
            }
        }
    }
}


extension BintableHDU {
    
    /**
        Reads the table structure from raw data
     
        Reads the `dataUnit` according to the header files
     */
    internal func readTable(_ data: UnsafeRawBufferPointer, context: inout ReaderContext) {
        
        let fieldCount = self.headerUnit[HDUKeyword.TFIELDS] ?? 0
        // The value field shall contain a non-negative integer, giving the number of eight-bit bytes in each row of the table.
        let rowLength = self.naxis(1) ?? 1
        // The value field shall contain a non-negative integer, giving the number of rows in the table
        let rows = self.naxis(2) ?? 0
        
        let theap = self.headerUnit["THEAP"] ?? 0
        let heapStart = context.offset + theap
        
        var columnOffset : Int = 0
        
        for columnIndex in 0..<fieldCount {
            
            if let tform : BFORM = self.headerUnit["TFORM\(columnIndex+1)"] {
                
                let rawTDISP : BDISP? = self.headerUnit["TDISP\(columnIndex+1)"]
                let rawTTYPE : String? = self.headerUnit["TTYPE\(columnIndex+1)"]
                let rawTUNIT : String? = self.headerUnit["TUNIT\(columnIndex+1)"]
                //let rawTSCAL : String? = self.headerUnit["TSCAL\(col+1)"]
                
                let column = TableColumn<BFIELD>(self.headerUnit, (columnIndex+1), TDISP: rawTDISP, TFORM: tform, TUNIT: rawTUNIT, TTYPE: rawTTYPE ?? "")
                self.columns.append(column)
                
                for rowIndex in 0..<rows {
                    
                    let start = context.offset+(rowIndex*rowLength)+columnOffset
                    let end = start+tform.length
                    
                    //print("\(rowIndex): \(column.TTYPE ?? "N/A"): \(column.TFORM) \(start)...\(end)")
                    let val = data[start..<end]
                    
                    if tform.heapLength > 0 {
                        // Special treatment for varialbe arrays
                        let desc = tform.varArray(val)
                        
                        let first = heapStart + desc.offset
                        let last = first + desc.nelem * tform.heapSize
                        
                        //print("HEAP:\(rowIndex): \(tform): \(first)...\(last)")
                        let dat = data[first..<last]
                        
                        let value = BFIELD.read(dat, type: tform)
                        column.values.append(value)
                        #if DEBUG
                        value.raw = Data(val)
                        #endif
                        
                    } else {
                        let value = BFIELD.read(val, type: tform)
                        column.values.append(value)
                        #if DEBUG
                        value.raw = Data(val)
                        #endif
                    }
                }
                columnOffset += tform.length
            }
            
        }
    }
}
