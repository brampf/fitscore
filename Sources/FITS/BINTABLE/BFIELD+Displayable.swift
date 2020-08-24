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

//MARK:- Integer
protocol DisplayableInteger : _Displayable {
    associatedtype IntegerType : BinaryInteger
    
    var rawValue : IntegerType {get}
    

}

extension DisplayableInteger where FORM == BFORM, DISP == BDISP {
    
    func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        switch disp {
        case .I(let w, let m):
            return String(self.rawValue, radix: 10, min: m ?? 1, max: w)
        case .O(let w, let m):
            return String(self.rawValue, radix: 8, min: m ?? 1, max: w)
        case .Z(let w, let m):
            return String(self.rawValue, radix: 16, min: m ?? 1, max: w)
        case .G(let w,_,_):
            return String(self.rawValue, radix: 10, min: 1, max: w)
        default:
            return empty(form, null, String(self.rawValue))
        }
    }
}

//MARK:- FloatingPoint
protocol DisplayableFloatingPoint : _Displayable {
    associatedtype FloatType : BinaryFloatingPoint & CVarArg
    
    var rawValue : FloatType {get}
    
}

extension DisplayableFloatingPoint where FORM == BFORM, DISP == BDISP {
    
    func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        //let formatter = NumberFormatter()
        
        switch disp {
        case .F(let w, let d):
            return String(format: "%\(w-d).\(d)F", self.rawValue)
        case .E(let w, let d, _):
            return String(format: "%\(w-d).\(d)E", self.rawValue)
        case .EN(let w, let d):
            return String(format: "%\(w-d).\(d)E", self.rawValue)
        case .ES(let w, let d):
            return String(format: "%\(w-d).\(d)A", self.rawValue)
        case .G(let w, let d, _):
            return String(format: "%\(w-d).\(d)G", self.rawValue)
        default:
            return empty(form, null, String(format: "%@", self.rawValue))
        }
    }
}

//MARK:- Boolean
protocol DisplayableBoolean : _Displayable {
    
    var rawValue : Bool {get}
    
}

extension DisplayableBoolean where FORM == BFORM, DISP == BDISP {
    
    func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        switch disp {
        case .L(let w), .G(let w,_,_):
            return self.rawValue ? String("T", padded: w) : String("F", padded: w)
        default:
            return empty(form, null, String(self.rawValue))
        }
    }
}

protocol DisplayableCharacter : _Displayable, LosslessStringConvertible {
    
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

extension EightBitValue : _Displayable {
    
    func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        switch disp {
        default:
            return empty(form, null, String(self.rawValue))
        }
    }
    
}

extension SingleComplexValue : _Displayable {
    
    func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        switch disp {
        default:
            return empty(form, null, self.description)
        }
    }
}

extension DoubleComplexValue : _Displayable {
    
    func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        switch disp {
        default:
            return empty(form, null, self.description)
        }
    }
}
