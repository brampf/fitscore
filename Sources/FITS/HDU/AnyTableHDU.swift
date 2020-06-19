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

open class AnyTableHDU<F: FIELD> : AnyHDU, Table  {
    public typealias Field = F
    
    public internal(set) var columns: [TableColumn<Field>] = []

    @Keyword(HDUKeyword.TFIELDS) public var tfields : Int?
    
    public required init() {
        super.init()
        
        self.initializeWrapper()
        
    }
    
    required public init(with data: inout Data) throws {
        try super.init(with: &data)
        
        self.initializeWrapper()
    }
    
    override func initializeWrapper() {
        super.initializeWrapper()
        self._tfields.initialize(self)
    }
    
}

// MARK:- Table structures
extension AnyTableHDU {
    public typealias Column = TableColumn<Field>
    public typealias Row = TableRow<Field>
    
    public var rows : [Row] {
        var arr = [TableRow<Field>]()
        for row in 0..<(self.naxis(2) ?? 0) {
            arr.append(TableRow<Field>(self, row))
        }
        return arr
    }
    
    /// adds a new column to the table
    public func addColumn(index: Int? = nil, TFORM: Field.TFORM, TDISP: Field.TDISP? = nil, TUNIT: String? = nil, TTYPE: String? = nil, _ fields: Field...) -> Column {
        
        let column = Column(self, (index ?? columns.count)+1, TDISP: TDISP, TFORM: TFORM, TUNIT: TUNIT, TTYPE: TTYPE, fields: fields)
    
        if let index = index {
            self.columns.insert(column, at: index)
        } else{
            self.columns.append(column)
        }
        
        // fix header
        let fields = self.columns.count
        
        self.header("TFIELDS", value: fields, comment: "Number of fields per row")
        self.header("NAXIS1", value: self.columns.reduce(into: 0, { m, col in
            m += col.TFORM?.length ?? 0
        }), comment: "Characters per row")
        self.header("NAXIS2", value: self.columns.reduce(into: 0, { m, col in
            m = max(m,col.values.count)
        }), comment: "Number of rows")
        
        return column
    }
    
    public func removeColum(index: Int) {
        self.columns.remove(at: index)
    }
}

extension AnyTableHDU {
        
    func plot(data: inout Data){
        
        var dashWidth =  0
        let maxWidths = self.columns.reduce(into: [Int]()) { me, col in
            var length = max(col.TDISP?.length ?? 0 , col.TFORM?.length ?? 0)
            length = max(length, col.TTYPE?.count ?? 0)
            me.append(length)
            dashWidth += length + 4
        }
        
        let dashes = String(repeating: "-", count: max(0 ,dashWidth-1))
        //String(repeating: "-", count: hdu.naxis(1) ?? 0)
        
        data.append(dashes)
        data.append("\n")
        var out = ""
        for col in 0..<(self.tfields ?? 0) {
            let ttype = self.columns[col].TTYPE ?? "N/A"
            if col == 0 {
                out.append("|")
            }
            out.append(" ")
            out.append(ttype.padPrefix(minSize: maxWidths[col], char: " "))
            out.append(" |")
        }
        data.append(out)
        data.append("\n")
        data.append(dashes)
        data.append("\n")
        for row in 0..<(self.naxis(2) ?? 0) {
            var out = ""
            for col in 0..<(self.tfields ?? 0) {
                let disp = self.columns[col].TDISP
                let field = self.columns[col].values[row]
                let value = field.format(disp) ?? ""
                if col == 0 {
                    out.append("|")
                }
                out.append(" ")
                out.append(value.padPrefix(minSize: maxWidths[col], char: " "))
                out.append(" |")
            }
            data.append(out)
            data.append("\n")
        }
        data.append(dashes)
        data.append("\n")
    }
}
