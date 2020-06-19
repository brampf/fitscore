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

public class TableRow<Field> : Identifiable where Field: FIELD {
    
    public let id = UUID()
    
    private let table: AnyTableHDU<Field>
    private let rowIndex : Int
    
    init(_ table: AnyTableHDU<Field>, _ index: Int){
        self.table = table
        self.rowIndex = index
    }
    
    public var values : [Field] {
        table.columns.reduce(into: [Field]()) { array, column in
            array.append(column[rowIndex])
        }
    }
    
    subscript(_ col: Int) -> Field {
        get{
            table.columns[col][rowIndex]
        }
        set {
            table.columns[col][rowIndex] = newValue
        }
    }
    
    func TFORM(_ col: Int) -> Field.TFORM? {
        return table.columns[col].TFORM
    }
    
    func TDISP(_ col: Int) -> Field.TDISP? {
        return table.columns[col].TDISP
    }
    
}

extension TableRow : CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "Row: \(values.debugDescription)"
    }
}
