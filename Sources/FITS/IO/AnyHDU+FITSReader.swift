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
    
    internal func readTable(_ data: UnsafeRawBufferPointer, context: inout ReaderContext) -> DataUnit? {
        
        let fieldCount = context.currentHeader?[HDUKeyword.TFIELDS] ?? 0
        let rowLength = context.currentHeader?["NAXIS1"] ?? 1
        let rows = context.currentHeader?["NAXIS2"] ?? 0
        
        for _ in 0..<rows {
            // let row = data[context.offset..<context.offset+rowLength]
            for columnIndex in 0..<fieldCount {
                
                if let tform : TFORM  = context.currentHeader?["TFORM\(columnIndex+1)"] {
                    let ttype : String? = context.currentHeader?["TTYPE\(columnIndex+1)"]
                    let tdisp : TDISP? = context.currentHeader?["TDISP\(columnIndex+1)"]
                    let tunit : String? = context.currentHeader?["TUNIT\(columnIndex+1)"]
                    let tbcol = context.currentHeader?["TBCOL\(columnIndex+1)"] ?? 1
                    // append the table column
                    
                    let column = TableColumn<TFIELD>(context.currentHeader!, (columnIndex+1), TDISP: tdisp, TFORM: tform, TUNIT: tunit, TTYPE: ttype ?? "")
                    self.columns.append(column)
                   
                    let start = context.offset+tbcol-1
                    let end = context.offset+tbcol+tform.length-1
                    
                    //print("\(rowIndex): \(column.TTYPE ?? "N/A"): \(column.TFORM) \(start)...\(end)")
                    let bytes = data[start..<end]
                    var string = String(bytes: bytes, encoding: .ascii) ?? ""
                    
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
            
            context.offset += rowLength
        }
        
        
        return nil
    }
    
}
