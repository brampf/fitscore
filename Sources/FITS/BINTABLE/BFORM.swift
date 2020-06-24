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
    
    case PL(r: Int)
    case PX(r: Int)
    case PB(r: Int)
    case PI(r: Int)
    case PJ(r: Int)
    case PK(r: Int)
    case PA(r: Int)
    case PE(r: Int)
    case PC(r: Int)

    case QD(r: Int)
    case QM(r: Int)

    public static  func parse(_ string: String) -> Self? {
        
        let trimmed = string.trimmingCharacters(in: CharacterSet.whitespaces.union(CharacterSet(arrayLiteral: "'")))
        
        var prefix = ""
        var type = ""
        var suffix = ""
        var varArr = false
        trimmed.forEach { char in
            if char.isNumber {
                prefix.append(char)
            } else if char == "P" {
                varArr = true
                type.append(char)
            } else if varArr == true && type.count < 2 {
                type.append(char)
            } else if varArr == false && type.count < 1 {
                type.append(char)
            } else if varArr == true && char == "(" || char == ")" {
                // ignore
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
        case "PL":
            return PL(r: r)
        case "PX":
            return PX(r: r)
        case "PB":
            return PB(r: r)
        case "PI":
            return PI(r: r)
        case "PJ":
            return PJ(r: r)
        case "PK":
            return PK(r: r)
        case "PA":
            return PA(r: r)
        case "PE":
            return PE(r: r)
        case "PC":
            return PC(r: r)
        case "QD":
            return QD(r: r)
        case "QM":
            return QM(r: r)
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
            
        case .PL:
            return BFIELD.PL.self
        case .PX:
            return BFIELD.PX.self
        case .PB:
            return BFIELD.PB.self
        case .PI:
            return BFIELD.PI.self
        case .PJ:
            return BFIELD.PJ.self
        case .PK:
            return BFIELD.PK.self
        case .PA:
            return BFIELD.PA.self
        case .PE:
            return BFIELD.PE.self
        case .PC:
            return BFIELD.PC.self
            
        case .QD:
            return BFIELD.QD.self
        case .QM:
            return BFIELD.QM.self
        }
    }
    
    
    
    public var length : Int {
        
        switch self {
        case .L(let r):
            return r*MemoryLayout<UInt8>.size
        case .X(let r):
            return Int((Float(r) / 8.0).rounded(.up))
            //return r*MemoryLayout<UInt8>.size
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
            return r*2*MemoryLayout<Float32>.size
        case .M(let r):
            return r*2*MemoryLayout<Float64>.size
            
        case .PL(let r):
            return 2*MemoryLayout<Float32>.size
        case .PX(let r):
            return 2*MemoryLayout<Float32>.size
        case .PB(let r):
            return 2*MemoryLayout<Float32>.size
        case .PI(let r):
            return 2*MemoryLayout<Float32>.size
        case .PJ(let r):
            return 2*MemoryLayout<Float32>.size
        case .PK(let r):
            return 2*MemoryLayout<Float32>.size
        case .PA(let r):
            return 2*MemoryLayout<Float32>.size
        case .PE(let r):
            return 2*MemoryLayout<Float32>.size
        case .PC(let r):
            return 2*MemoryLayout<Float32>.size
            
        case .QD(let r):
            return 2*MemoryLayout<Float64>.size
        case .QM(let r):
            return 2*MemoryLayout<Float64>.size
        }
        
    }
    
    public var description : String {
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
            
        case .PL(let r):
            return "PL(\(r))"
        case .PX(let r):
            return "PX(\(r))"
        case .PB(let r):
            return "PB(\(r))"
        case .PI(let r):
            return "PI(\(r))"
        case .PJ(let r):
            return "PJ(\(r))"
        case .PK(let r):
            return "PK(\(r))"
        case .PA(let r):
            return "PA(\(r))"
        case .PE(let r):
            return "PE(\(r))"
        case .PC(let r):
            return "PC(\(r))"
            
        case .QD(let r):
            return "QD(\(r))"
        case .QM(let r):
            return "QM(\(r))"
        }

    }
    
    var isVarArray : Bool {
        switch self {
        case .PL, .PX, .PB, .PI, .PJ, .PK, .PA, .PE, .PC, .QD, .QM:
            return true
        default:
            return false
        }
    }
    
    func varArray(data: Data) -> (nelem: Int,offset: Int) {
        
        var nelem: Int = 0 // the number of elements (array length) of the stored array
        var offset: Int = 0 // followed by the zero-indexed byte offset of the first element of the array, measured from the start of the heap area.
        
        switch self {
        case .PL, .PX, .PB, .PI, .PJ, .PK, .PA, .PE, .PC:
            let desc = data.withUnsafeBytes { ptr in
                ptr.bindMemory(to: Int32.self).map{Int32.init(bigEndian: $0)}
            }
            nelem = Int(desc[0])
            offset = Int(desc[1])
        case .QD, .QM :
            let desc = data.withUnsafeBytes { ptr in
                ptr.bindMemory(to: Int64.self).map{Int64.init(bigEndian: $0)}
            }
            nelem = Int(desc[0])
            offset = Int(desc[1])
        default:
            // nothing
            break
        }
        return (nelem, offset)
    }
}
