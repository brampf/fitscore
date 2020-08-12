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

public protocol Table {
    associatedtype Field : FIELD
    
    var columns : [TableColumn<Field>] {get}
}

//MARK:- Table Data Types
public protocol FIELD : Hashable, Displayable, CustomDebugStringConvertible, CustomStringConvertible {
 
    func write(_ form: TFORM) -> String
    
    var form : TFORM {get}
}

public protocol DISP : Hashable, FITSSTRING, HDUValue {
    
    var length : Int {get}
}

public protocol FORM : Hashable, FITSSTRING, HDUValue {
    associatedtype TFIELD : FIELD
    
    var length : Int {get}
    
    var fieldType : TFIELD.Type {get}
}

public protocol UNIT {
    
}

public protocol TTYPE {
    
}

/// Ability to display a value
public protocol Displayable {
    associatedtype TDISP : DISP
    associatedtype TFORM : FORM
    
    /**
        Creates a string representation of the value
     
     - Parameter disp: `TDISP` value display style
     - Parameter form: `TFORM` value format
     - Parameter null: `TNULL` value to use
     */
    func format(_ disp: TDISP?, _ form: TFORM?, _ null: String?) -> String
}

extension Displayable {
    
    /// compute a string for a missing value
    public func empty(_ form: TFORM?, _ null: String?, _ fallback: String) -> String {

        return null != nil ? null! : (form != nil ? String(repeating: " ", count: form!.length) : fallback)
    }
}

//MARK:- Optional (Null Value)
extension Optional : Displayable where Wrapped : Displayable {
    public typealias TDISP = Wrapped.TDISP
    public typealias TFORM = Wrapped.TFORM
    
    public func format(_ disp: TDISP?, _ form: TFORM?, _ null: String?) -> String {
        
        if let value = self {
            return value.format(disp, form, null)
        } else {
            return null ?? ""
        }
        
    }
}
