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

/// Ability to display a value
protocol Displayable {
    associatedtype DISP : FITS.DISP
    associatedtype FORM : FITS.FORM
    
    /**
        Creates a string representation of the value
     
     - Parameter disp: `DISP` value display style
     - Parameter form: `FORM` value format
     - Parameter null: `TNULL` value to use
     */
    func format(_ disp: DISP?, _ form: FORM?, _ null: String?) -> String
}

extension Displayable {
    
    /// compute a string for a missing value
    func empty(_ form: FORM?, _ null: String?, _ fallback: String) -> String {

        return null != nil ? null! : (form != nil ? String(repeating: " ", count: form!.length) : fallback)
    }
}

//MARK:- Optional (Null Value)
extension Optional : Displayable where Wrapped : Displayable {
    typealias DISP = Wrapped.DISP
    typealias FORM = Wrapped.FORM
    
    func format(_ disp: DISP?, _ form: FORM?, _ null: String?) -> String {
        
        if let value = self {
            return value.format(disp, form, null)
        } else {
            return null ?? ""
        }
        
    }
}


//MARK:- Integer
protocol DisplayableInteger : Displayable, BinaryInteger {

}

extension DisplayableInteger where FORM == BFORM, DISP == BDISP {
    
    func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        switch disp {
        case .I(let w, let m):
            return String(self, radix: 10, min: m ?? 1, max: w)
        case .O(let w, let m):
            return String(self, radix: 8, min: m ?? 1, max: w)
        case .Z(let w, let m):
            return String(self, radix: 16, min: m ?? 1, max: w)
        case .G(let w,_,_):
            return String(self, radix: 10, min: 1, max: w)
        default:
            return empty(form, null, String(self))
        }
    }
}

//MARK:- FloatingPoint
protocol DisplayableFloatingPoint : Displayable, BinaryFloatingPoint {
    
}

extension DisplayableFloatingPoint where FORM == BFORM, DISP == BDISP, Self : CVarArg & LosslessStringConvertible {
    
    func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        //let formatter = NumberFormatter()
        
        switch disp {
        case .F(let w, let d):
            return String(format: "%\(w-d).\(d)F", self)
        case .E(let w, let d, _):
            return String(format: "%\(w-d).\(d)E", self)
        case .EN(let w, let d):
            return String(format: "%\(w-d).\(d)E", self)
        case .ES(let w, let d):
            return String(format: "%\(w-d).\(d)A", self)
        case .G(let w, let d, _):
            return String(format: "%\(w-d).\(d)G", self)
        default:
            return empty(form, null, String(self))
        }
    }
}

protocol DisplayableCharacter : Displayable, LosslessStringConvertible {
    
}

extension DisplayableCharacter where FORM == BFORM, DISP == BDISP {
    
    func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        switch disp {
        case .A(let w), .G(let w,_,_):
            return String(self).padPrefix(toSize: w, char: " ")
        default:
            return empty(form, null, String(self))
        }
    }
}
