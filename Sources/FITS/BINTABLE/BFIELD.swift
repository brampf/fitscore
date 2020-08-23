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
 Supertype to all Bintable Types
 */
public protocol BField : FIELD where FORM == BFORM, DISP == BDISP {
    
    subscript(_ index: Int) -> BFIELD.VALUE? { get set }
    
    var all : [BFIELD.VALUE] { get }
}

/// internal representation of 'BField'
protocol _BField: _FIELD {

}

//MARK:- PrefixType
/**
  THE TFIELD data structure as specified for the Bintable extensions
 
 The TFORMn keywords must be present for all values n = 1, ..., TFIELDS and for no other values of n. The value field of this indexed keyword shall contain a char- acter string of the form rTa. The repeat count r is the ASCII representation of a non-negative integer specifying the number of elements in Field n. The default value of r is 1; the repeat count need not be present if it has the default value. A zero el- ement count, indicating an empty field, is permitted. The data type T specifies the data type of the contents of Field n. Only the data types in Table 18 are permitted. The format codes must be specified in upper case. For fields of type P or Q, the only per- mitted repeat counts are 0 and 1. The additional characters a are optional and are not further defined in this Standard. Table 18 lists the number of bytes each data type occupies in a table row. The first field of a row is numbered 1.
 */
public class BFIELD: BField, _BField {
    
    public typealias FORM = BFORM
    public typealias DISP = BDISP
    
    #if DEBUG
    var raw : Data?
    #endif
    
    public var description: String {
        return "BFIELD"
    }
    
    public var debugDescription: String {
        return "BFIELD"
    }

    func write(_ form: BFORM) -> String {
        fatalError("Not implemented in BFIELD")
    }
    
    func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        fatalError("Not implemented in BFIELD")
    }
    
    var form: BFORM {
        fatalError("Not implemented in BFIELD")
    }
    
    public subscript(index: Int) -> BFIELD.VALUE? {
        get {
            return nil
        }
        set {
            //
        }
    }
    
    public var all: [VALUE] {
        return []
    }
    
    public static func == (lhs: BFIELD, rhs: BFIELD) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(UUID())
    }
}

protocol ValueBField : _BField, WritableBField {
    associatedtype ValueType : BFIELD.VALUE
    associatedtype BaseType : Any
    
    var name : String {get}
    var val : [ValueType]? { get set }
    
    func form(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String
 
    var debugDesc : String {get}
    var desc : String {get}
}

extension ValueBField {
    
    var debugDesc: String {
        return "BFIELD.\(name)(\(val?.description ?? "-/-"))"
    }

    var desc: String {
        return val != nil ? "\(val!)" : "-/-"
    }
}

extension ValueBField where Self : _Displayable {
    
    func form(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        var ret = "["
        if (val?.forEach({ value in
            ret.append(value.string(disp, form) ?? "")
            ret.append(",")
        })) != nil {
            ret.removeLast()
        }
        ret.append("]")
        
        return ret
    }
}

protocol VarArray : ValueBField, WritableVarBField {
    associatedtype ArrayType : FixedWidthInteger
    

}
