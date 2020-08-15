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
 Valid TDISPn format values in TABLE extensions.
 
 w is the width in characters of displayed values, m is the minimum number of digits displayed, d is the number of digits to right of decimal, and e is number of digits in exponent. The .m and Ee fields are optional.
 */
public enum TDISP : DISP {
    
    /// Character
    case A(w: Int)
    
    /// Integer
    case I(w: Int, m: Int?)
    
    /// Binary, integers only
    case B(w: Int, m: Int?)
    
    /// Octal, integers only
    case O(w: Int, m: Int?)
    
    /// Hexadecimal, integers only
    case Z(w: Int, m: Int?)
    
    /// Floating-point, fixed decimal notation
    case F(w: Int, d: Int)
    
    /// Floating-point, exponential notation
    case E(w: Int, d: Int, e: Int?)
    
    /// Engineering; E format with exponent multiple of three
    case EN(w: Int, d: Int)
    
    /// Scientific; same as EN but non-zero leading digit if not zero
    case ES(w: Int, d: Int)
    
    /// General; appears as F if significance not lost, else E.
    case G(w: Int, d: Int, e: Int?)
    
    /// Floating-point, exponential notation
    case D(w: Int, d: Int, e: Int?)
    
    public static  func parse(_ string: String) -> TDISP? {
        var trimmed = string.trimmingCharacters(in: CharacterSet.whitespaces.union(CharacterSet(arrayLiteral: "'")))
        guard !trimmed.isEmpty else {
            return nil
        }
        
        var head : String = String(trimmed.removeFirst())
        if trimmed.starts(with: "N"){ head += String(trimmed.removeFirst()) }
        if trimmed.starts(with: "S"){ head += String(trimmed.removeFirst()) }
        var w = ""
        var md = ""
        var e = ""
        var mindigit = false
        var exponent = false
        trimmed.forEach { char in
            if char == "." {
                mindigit  = true
            } else if char.lowercased() == "e" {
                exponent = true
            } else if exponent {
                e.append(char)
            } else if mindigit {
                md.append(char)
            } else  {
                w.append(char)
            }
        }
        
        switch head {
        case "A":
            return TDISP.A(w: Int(w) ?? 0)
        case "I":
            return TDISP.I(w: Int(w) ?? 0, m: Int(md))
        case "B":
            return TDISP.B(w: Int(w) ?? 0, m: Int(md))
        case "O":
            return TDISP.O(w: Int(w) ?? 0, m: Int(md))
        case "Z":
            return TDISP.Z(w: Int(w) ?? 0, m: Int(md))
        case "F":
            return TDISP.F(w: Int(w) ?? 0, d: Int(md) ?? 0)
        case "E":
            return TDISP.E(w: Int(w) ?? 0, d: Int(md) ?? 0, e: Int(e))
        case "EN":
            return TDISP.EN(w: Int(w) ?? 0, d: Int(md) ?? 0)
        case "ES":
            return TDISP.ES(w: Int(w) ?? 0, d: Int(md) ?? 0)
        case "G":
            return TDISP.G(w: Int(w) ?? 0, d: Int(md) ?? 0, e: Int(e))
        case "D":
            return TDISP.D(w: Int(w) ?? 0, d: Int(md) ?? 0, e: Int(e))
        default:
            return nil
        }
    }
    
    public var length : Int {
        switch self {
        case .A(let w):
            return w
        case .I(let w, _):
            return w
        case .B(let w, _):
            return w
        case .O(let w, _):
            return w
        case .Z(let w, _):
            return w
        case .F(let w, _):
            return w
        case .E(let w, _, _):
            return w
        case .ES(let w, _):
            return w
        case .EN(let w, _):
            return w
        case .G(let w, _, _):
            return w
        case .D(let w, _, _):
            return w
        }
    }
    
    public var description : String {
        switch self {
        case .A(let w):
            return "A\(w)"
        case .I(let w, let m):
            return "I\(w)" + ((m != nil) ? ".\(m!)" : "")
        case .B(let w, let m):
            return "B\(w)" + ((m != nil) ? ".\(m!)" : "")
        case .O(let w, let m):
            return "O\(w)" + ((m != nil) ? ".\(m!)" : "")
        case .Z(let w, let m):
            return "Z\(w)" + ((m != nil) ? ".\(m!)" : "")
        case .F(let w, let d):
            return "F\(w).\(d)"
        case .E(let w, let d, let e):
            return "E\(w).\(d)" + ((e != nil) ? "e\(e!)" : "")
        case .ES(let w, let d):
            return "ES\(w).\(d)"
        case .EN(let w, let d):
            return "EN\(w).\(d)"
        case .G(let w, let d, let e):
            return "G\(w).\(d)" + ((e != nil) ? "e\(e!)" : "")
        case .D(let w, let d, let e):
            return "D\(w).\(d)" + ((e != nil) ? "e\(e!)" : "")
        }
    }
}

