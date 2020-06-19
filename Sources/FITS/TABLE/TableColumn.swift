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


public class TableColumn<Field> : Identifiable where Field: FIELD {
    
    public var id = UUID()
    
    // Raw data layout for this value
    @Keyword("TFORM") public var TFORM: Field.TFORM?
    
    // Data display style
    @Keyword("TDISP") public var TDISP: Field.TDISP?
    @Keyword("TUNIT") public var TUNIT: String?
    @Keyword("TTYPE") public var TTYPE: String?
    @Keyword("TBCOL") public var TBCOL: Int?
    
    //private var hdu : AnyTableHDU<Field>
    
    public internal(set) var values : [Field] = []
    
    /// Internal initializer which does not override the header values
    init<F: FIELD>(_ hdu: AnyTableHDU<F>, _ col: Int, TDISP: Field.TDISP?, TFORM: Field.TFORM, TUNIT: String?, TTYPE: String?) where F.TFORM == Field.TFORM {
        
        //print("Column \(col): TDISP\(col): \(TDISP) - TFORM\(col): \(TFORM)")
        self._TFORM = Keyword<Field.TFORM>("TFORM\(col)", hdu)
        self._TDISP = Keyword<Field.TDISP>("TDISP\(col)", hdu)
        self._TUNIT = Keyword<String>("TUNIT\(col)", hdu)
        self._TTYPE = Keyword<String>( "TTYPE\(col)", hdu)
        self._TTYPE = Keyword<String>( "TBCOL\(col)", hdu)
    }
    
    init<F: FIELD>(_ hdu: AnyTableHDU<F>, _ col: Int, TDISP: Field.TDISP?, TFORM: Field.TFORM, TUNIT: String?, TTYPE: String?, fields: [Field]) where F.TFORM == Field.TFORM  {
        
        //print("Column \(col): TDISP\(col): \(TDISP) - TFORM\(col): \(TFORM)")
        self._TFORM = Keyword<Field.TFORM>(wrappedValue: TFORM, "TFORM\(col)", hdu)
        self._TDISP = Keyword<Field.TDISP>(wrappedValue: TDISP, "TDISP\(col)", hdu)
        self._TUNIT = Keyword<String>(wrappedValue: TUNIT, "TUNIT\(col)", hdu)
        self._TTYPE = Keyword<String>(wrappedValue: TTYPE, "TTYPE\(col)", hdu)
        self._TTYPE = Keyword<String>(wrappedValue: TTYPE, "TBCOL\(col)", hdu)
        
        self.values = fields
    }
    
    subscript(_ row: Int) -> Field {
        get {
            return values[row]
        }
        set {
            guard self.TFORM?.fieldType == newValue.form.fieldType else {
                print("Field does not match \(TFORM.debugDescription)")
                return
            }
            values[row] = newValue
        }
    }
}

extension TableColumn : CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "Col: \(values.debugDescription)"
    }
}
