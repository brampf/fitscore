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

public enum TFORM : FORM {
    
    /// Character
    case A(w: Int)
    
    /// Integer
    case I(w: Int)
    
    /// Floating-point, fixed decimal notation
    case F(w: Int, d: Int)
    
    /// Floating-point, exponential notation
    case E(w: Int, d: Int)
    
    /// Floating-point, exponential notation
    case D(w: Int, d: Int)
    
    public static  func parse(_ string: String) -> TFORM? {
        
        var trimmed = string.trimmingCharacters(in: CharacterSet.whitespaces.union(CharacterSet(arrayLiteral: "'")))
        guard !trimmed.isEmpty else {
            return nil
        }
        
        let head = trimmed.removeFirst()
        var w = ""
        var d = ""
        var digits = false
        trimmed.forEach { char in
            if char == "." {
                digits  = true
            } else if digits {
                d.append(char)
            } else  {
                w.append(char)
            }
        }
        
        switch head {
        case "A":
            return TFORM.A(w: Int(w) ?? 0)
        case "I":
            return TFORM.I(w: Int(w) ?? 0)
        case "F":
            return TFORM.F(w: Int(w) ?? 0, d: Int(d) ?? 0)
        case "E":
            return TFORM.E(w: Int(w) ?? 0, d: Int(d) ?? 0)
        case "D":
            return TFORM.D(w: Int(w) ?? 0, d: Int(d) ?? 0)
        default:
            return nil
        }
    }
    
    public var length : Int {
        
        switch self {
        case .A(let width):
            return width
        case .I(let width):
            return width
        case .F(let width, _):
            return width
        case .E(let width, _):
            return width
        case .D(let width, _):
            return width
        }
    }
    
    public var FITSString : String {
        switch self {
        case .A(let width):
            return "A\(width)"
        case .I(let width):
            return "I\(width)"
        case .F(let width, let digits):
            return "F\(width).\(digits)"
        case .E(let width, let digits):
            return "E\(width).\(digits)"
        case .D(let width, let digits):
            return "D\(width).\(digits)"
        }
    }
}
