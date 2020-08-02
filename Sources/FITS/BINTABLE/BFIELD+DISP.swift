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

//MARK:- BFIELD.A
extension BFIELD.A : Displayable {
    
    public func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
    
        guard let val = self.val else {
            return ""
        }
        
        switch disp {
        case .A(let w):
            return String(bytes: val, encoding: .ascii)?.padPrefix(toSize: w, char: " ") ?? empty(form, null, "")
        default:
            return empty(form, null, "")
        }
        
    }
}

extension BFIELD.A.ValueType : Displayable {

    public func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        switch disp {
        case .A(let w):
            return String(self).padPrefix(toSize: w, char: " ")
        default:
            return empty(form, null, String(self))
        }
    }
}

//MARK:- BFIELD.L
/*
extension BFIELD.L : Displayable {
    
    public func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        guard let val = self.val else {
            return ""
        }
        
        switch disp {
        case .L(let w):
            return val.map{$0.fomat(disp, form, null)}
        default:
            return empty(form, null, "")
        }
        
    }
}
 */

extension BFIELD.L.ValueType : Displayable {

    public func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        switch disp {
        case .L(let w):
            return self ? String("T", padded: w) : String("F", padded: w)
        default:
            return empty(form, null, String(self))
        }
    }
}

//MARK:- BFIELD.X

//MARK:- BFIELD.B

//MARK:- FIELD.I
extension BFIELD.I.ValueType : Displayable {

    public func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        switch disp {
        case .I(let w, let m):
            return String(self, radix: 10, min: m ?? 0, max: w)
        case .O(let w, let m):
            return String(self, radix: 8, min: m ?? 0, max: w)
        case .Z(let w, let m):
            return String(self, radix: 16, min: m ?? 0, max: w)
        default:
            return empty(form, null, String(self))
        }
    }
}

//MARK:- BFIELD.J
extension BFIELD.J.ValueType : Displayable {

    public func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        switch disp {
        case .I(let w, let m):
            return String(self, radix: 10, min: m ?? 0, max: w)
        case .O(let w, let m):
            return String(self, radix: 8, min: m ?? 0, max: w)
        case .Z(let w, let m):
            return String(self, radix: 16, min: m ?? 0, max: w)
        default:
            return empty(form, null, String(self))
        }
    }
}

//MARK:- BFIELD.K
extension BFIELD.K.ValueType : Displayable {

    public func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        switch disp {
        case .I(let w, let m):
            return String(self, radix: 10, min: m ?? 0, max: w)
        case .O(let w, let m):
            return String(self, radix: 8, min: m ?? 0, max: w)
        case .Z(let w, let m):
            return String(self, radix: 16, min: m ?? 0, max: w)
        default:
            return empty(form, null, String(self))
        }
    }
}

//MARK:- BFIELD.E

//MARK:- BFIELD.D

//MARK:- BFIELD.C

//MARK:- BFIELD.M

//MARK:- BFIELD.P

//MARK:- BFIELD.Q


//MARK:- BFIELD.PL

//MARK:- BFIELD.PX

//MARK:- BFIELD.PI

//MARK:- BFIELD.PJ

//MARK:- BFIELD.PK

//MARK:- BFIELD.PA

//MARK:- BFIELD.PE

//MARK:- BFIELD.PC

//MARK:- BFIELD.QD

//MARK:- BFIELD.QM
