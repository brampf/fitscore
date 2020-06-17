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


open class AnyTableHDU<Field> : AnyHDU where Field: FIELD  {
    public typealias Column = TableColumn<Field>
    
    public internal(set) var table : [Column] = []
    
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
    
    func row(_ index: Int) -> ProxyCollection<Field> {
        return ProxyCollection(id: index, end: {
            self.tfields ?? 0
        }) { column in
            self.table[column].values[index]
        }
    }
    
    public var rows : ProxyCollection<ProxyCollection<Field>> {
        return ProxyCollection(id: UUID(), end: {
            self.naxis(2) ?? 0
        }) { row in
            self.row(row)
        }
    }
    
    public func addColumn(index: Int? = nil, TFORM: Field.TFORM, TDISP: Field.TDISP? = nil, TUNIT: String? = nil, TTYPE: String? = nil, _ fields: Field...) -> Column {
    
        let column = Column(self, (index ?? table.count)+1, TDISP: TDISP, TFORM: TFORM, TUNIT: TUNIT, TTYPE: TTYPE, fields: fields)
        
        if let index = index {
            self.table.insert(column, at: index)
        } else{
            self.table.append(column)
        }
        
        // fix header
        let fields = self.table.count
        
        self.header("TFIELDS", value: fields, comment: "Number of fields per row")
        self.header("NAXIS1", value: self.table.reduce(into: 0, { m, col in
            m += col.TFORM?.length ?? 0
        }), comment: "Characters per row")
        self.header("NAXIS2", value: self.table.reduce(into: 0, { m, col in
            m = max(m,col.values.count)
        }), comment: "Number of rows")
        
        return column
    }
}

// MARK:- Table Structure
public struct ProxyCollection<Value> : RandomAccessCollection, Identifiable, Hashable {
    
    public typealias Element = Value
    public typealias Index = Int
    
    public var id: AnyHashable
    
    var end : () -> Int
    var value : (Int) -> Value
    
    public subscript(position: Int) -> Value {
        return value(position)
    }
    
    public var startIndex: Int = 0
    
    public var endIndex: Int {
        return end()
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: ProxyCollection<Value>, rhs: ProxyCollection<Value>) -> Bool {
        return rhs.id == lhs.id
    }
}


public class TableColumn<Field> : Identifiable where Field: FIELD  {
    
    public var id = UUID()
    
    // Raw data layout for this value
    @Keyword("TFORM") public var TFORM: Field.TFORM?
    
    // Data display style
    @Keyword("TDISP") public var TDISP: Field.TDISP?
    @Keyword("TUNIT") public var TUNIT: String?
    @Keyword("TTYPE") public var TTYPE: String?
    
    //private var hdu : AnyTableHDU<Field>
    
    public var values : [Field] = []
    
    /// Internal initializer which does not override the header values
    init(_ hdu: AnyTableHDU<Field>, _ col: Int, TDISP: Field.TDISP?, TFORM: Field.TFORM, TUNIT: String?, TTYPE: String?){
        
        //print("Column \(col): TDISP\(col): \(TDISP) - TFORM\(col): \(TFORM)")
        self._TFORM = Keyword<Field.TFORM>("TFORM\(col)", hdu)
        self._TDISP = Keyword<Field.TDISP>("TDISP\(col)", hdu)
        self._TUNIT = Keyword<String>("TUNIT\(col)", hdu)
        self._TTYPE = Keyword<String>( "TTYPE\(col)", hdu)
    }
    
    init(_ hdu: AnyTableHDU<Field>, _ col: Int, TDISP: Field.TDISP?, TFORM: Field.TFORM, TUNIT: String?, TTYPE: String?, fields: [Field] ){
        
        //print("Column \(col): TDISP\(col): \(TDISP) - TFORM\(col): \(TFORM)")
        self._TFORM = Keyword<Field.TFORM>(wrappedValue: TFORM, "TFORM\(col)", hdu)
        self._TDISP = Keyword<Field.TDISP>(wrappedValue: TDISP, "TDISP\(col)", hdu)
        self._TUNIT = Keyword<String>(wrappedValue: TUNIT, "TUNIT\(col)", hdu)
        self._TTYPE = Keyword<String>(wrappedValue: TTYPE, "TTYPE\(col)", hdu)
        
        self.values = fields
    }
}


//MARK:- Table Data Types
public protocol FIELD : Hashable, CustomDebugStringConvertible, CustomStringConvertible {
    associatedtype TDISP : DISP
    associatedtype TFORM : FORM
    
    func format(_ using: TDISP?) -> String?
    
}

public protocol DISP : Hashable, HDUValue {
    
}

public protocol FORM : Hashable, HDUValue {
    
    var length : Int {get}
}

public protocol UNIT {
    
}

public protocol TTYPE {
    
}
