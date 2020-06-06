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

public enum BFORM : Hashable {
    
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
        
        let trimmed = string.trimmingCharacters(in: .whitespaces)
        
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
    
    
    
    public var length : Int {
        
        switch self {
        case .L(let r):
            return r*1
        case .X(let r):
            return r*1
        case .B(let r):
            return r*1
        case .I(let r):
            return r*2
        case .J(let r):
            return r*4
        case .K(let r):
            return r*8
        case .A(let r):
            return r*1
        case .E(let r):
            return r*4
        case .D(let r):
            return r*8
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
}
