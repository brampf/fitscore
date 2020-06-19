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

public enum BFORM : FORM {

    case L(r: Int)
    case X(r: Int)
    case B(r: Int)
    case I(r: Int)
    case J(r: Int)
    case K(r: Int)
    case A(r: Int)
    case E(r: Int)
    case D(r: Int)
    case C(r: Int)
    case M(r: Int)
    case P(r: Int)
    case Q(r: Int)
    
    public static  func parse(_ string: String) -> Self? {
        
        let trimmed = string.trimmingCharacters(in: CharacterSet.whitespaces.union(CharacterSet(arrayLiteral: "'")))
        
        var prefix = ""
        var type = ""
        var suffix = ""
        trimmed.forEach { char in
            if char.isNumber {
                prefix.append(char)
            } else if type.count < 1 {
                type.append(char)
            } else {
                suffix.append(char)
            }
        }
        
        let r = Int(prefix) ?? 1
        
        switch type {
        case "L":
            return L(r: r)
        case "X":
            return X(r: r)
        case "B":
            return B(r: r)
        case "I":
            return I(r: r)
        case "J":
            return J(r: r)
        case "K":
            return K(r: r)
        case "A":
            return A(r: r)
        case "E":
            return E(r: r)
        case "D":
            return D(r: r)
        case "C":
            return C(r: r)
        case "M":
            return M(r: r)
        case "P":
            return P(r: r)
        case "Q":
            return Q(r: r)
        default:
            return nil
        }
    }
    
    public var fieldType: BFIELD.Type {
        
        switch self {
        case .L:
            return BFIELD.L.self
        case .X:
            return BFIELD.X.self
        case .B:
            return BFIELD.B.self
        case .I:
            return BFIELD.I.self
        case .J:
            return BFIELD.J.self
        case .K:
            return BFIELD.K.self
        case .A:
            return BFIELD.A.self
        case .E:
            return BFIELD.E.self
        case .D:
            return BFIELD.D.self
        case .C:
            return BFIELD.C.self
        case .M:
            return BFIELD.M.self
        case .P:
            return BFIELD.P.self
        case .Q:
            return BFIELD.Q.self
        }
        
    }
    
    
    
    public var length : Int {
        
        switch self {
        case .L(let r):
            return r*MemoryLayout<UInt8>.size
        case .X(let r):
            return r*MemoryLayout<UInt8>.size
        case .B(let r):
            return r*MemoryLayout<UInt8>.size
        case .I(let r):
            return r*MemoryLayout<Int16>.size
        case .J(let r):
            return r*MemoryLayout<Int32>.size
        case .K(let r):
            return r*MemoryLayout<Int64>.size
        case .A(let r):
            return r*MemoryLayout<UInt8>.size
        case .E(let r):
            return r*MemoryLayout<Float>.size
        case .D(let r):
            return r*MemoryLayout<Double>.size
        case .C(let r):
            return r*8
        case .M(let r):
            return r*16
        case .P(let r):
            return r*8
        case .Q(let r):
            return r*16
        }
        
    }
    
    public var FITSString : String {
        switch self {
        case .L(let r):
            return "\(r)L"
        case .X(let r):
            return "\(r)X"
        case .B(let r):
            return "\(r)B"
        case .I(let r):
            return "\(r)I"
        case .J(let r):
            return "\(r)J"
        case .K(let r):
            return "\(r)K"
        case .A(let r):
            return "\(r)A"
        case .E(let r):
            return "\(r)E"
        case .D(let r):
            return "\(r)D"
        case .C(let r):
            return "\(r)C"
        case .M(let r):
            return "\(r)M"
        case .P(let r):
            return "\(r)P"
        case .Q(let r):
            return "\(r)Q"
        }
    }
}
