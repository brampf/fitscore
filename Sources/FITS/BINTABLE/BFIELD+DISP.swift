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


//MARK:- BFIELD.A
extension BFIELD.A.ValueType : DisplayableCharacter {

}

//MARK:- BFIELD.L
extension BFIELD.L.ValueType : Displayable {

    public func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        switch disp {
        case .L(let w), .G(let w,_,_):
            return self ? String("T", padded: w) : String("F", padded: w)
        default:
            return empty(form, null, String(self))
        }
    }
    
}

//MARK:- BFIELD.X
extension BFIELD.X.ValueType : Displayable {


    public func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        switch disp {
        default:
            return empty(form, null, String(self.rawValue, radix: 2))
        }
    }
    
}


//MARK:- BFIELD.B
extension BFIELD.B.ValueType : DisplayableInteger {


}


//MARK:- BFIELD.I
extension BFIELD.I.ValueType : DisplayableInteger {


}

//MARK:- BFIELD.J
extension BFIELD.J.ValueType : DisplayableInteger {

}

//MARK:- BFIELD.K
extension BFIELD.K.ValueType : DisplayableInteger {

}

//MARK:- BFIELD.E
extension BFIELD.E.ValueType : DisplayableFloatingPoint {

}


//MARK:- BFIELD.D
extension BFIELD.D.ValueType : DisplayableFloatingPoint {

    
}

//MARK:- BFIELD.C
extension BFIELD.C.ValueType : Displayable {
    
    public func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        switch disp {
        default:
            return empty(form, null, self.description)
        }
    }
    
}

//MARK:- BFIELD.M
extension BFIELD.M.ValueType : Displayable {
    
    public func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        switch disp {
        default:
            return empty(form, null, self.description)
        }
    }
    
}

//MARK:- BFIELD.PL
extension BFIELD.PL.ValueType {

}

//MARK:- BFIELD.PX
extension BFIELD.PX.ValueType : Displayable {

    
}

//MARK:- BFIELD.PI
extension BFIELD.PI.ValueType : Displayable {

}

//MARK:- BFIELD.PJ
extension BFIELD.PJ.ValueType : Displayable {
  
}

//MARK:- BFIELD.PK
extension BFIELD.PK.ValueType : Displayable {

}

//MARK:- BFIELD.PA
extension BFIELD.PA.ValueType : Displayable {
    
}

//MARK:- BFIELD.PE
extension BFIELD.PE.ValueType : Displayable {

    public func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        //let formatter = NumberFormatter()
        
        switch disp {
        default:
            return empty(form, null, String(self))
        }
    }
    
}

//MARK:- BFIELD.PC
extension BFIELD.PC.ValueType {

}

//MARK:- BFIELD.QD
extension BFIELD.QD.ValueType : Displayable {
    
}

//MARK:- BFIELD.QM
extension BFIELD.QM.ValueType {
    
}
