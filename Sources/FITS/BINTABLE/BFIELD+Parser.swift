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

extension BFIELD {
    
    static func parse(data: Data, type: BFORM) -> BFIELD {
        
        //print("PARSE \(type): \(data?.base64EncodedString() ?? "NIL")")
        
        data.withUnsafeBytes{ ptr in
            self.read(ptr[0..<data.count], type: type)
        }
    }
    
    
    static func read(_ data: UnsafeRawBufferPointer.SubSequence?, type: BFORM) -> BFIELD {
        
        //print("PARSE \(type): \(data?.base64EncodedString() ?? "NIL")")
        
        switch type {
        case .L:
            if let data = data, !data.isEmpty, var string = String(bytes: data, encoding: .ascii) {
                string = string.trimmingCharacters(in: .whitespacesAndNewlines)
                let arr = string.reduce(into: [Bool](), { arr, char in
                    if char == "T" {
                        arr.append(true)
                    } else if char == "F" {
                        arr.append(false)
                    }
                })
                return BFIELD.L(val: arr)
            } else {
                return BFIELD.L(val: nil)
            }
        case .X:
            if let data = data {
                return BFIELD.X(val: Data(data))
            } else {
                return BFIELD.X(val: Data())
            }
        case .B:
            if let data = data {
                let values : [UInt8] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: UInt8.self).map{UInt8.init(bigEndian: $0)}
                }
                return BFIELD.B(val: values)
            } else {
                return BFIELD.B(val: nil)
            }
        case .I:
            if let data = data {
                let values : [Int16] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: Int16.self).map{Int16.init(bigEndian: $0)}
                }
                return BFIELD.I(val: values)
            } else {
                return BFIELD.I(val: nil)
            }
        case .J:
            if let data = data {
                let values : [Int32] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: Int32.self).map{Int32.init(bigEndian: $0)}
                }
                return BFIELD.J(val: values)
            } else {
                return BFIELD.J(val: nil)
            }
        case .K:
            if let data = data {
                let values : [Int64] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: Int64.self).map{Int64.init(bigEndian: $0)}
                }
                return BFIELD.K(val: values)
            } else {
                return BFIELD.K(val: nil)
            }
        case .A:
            if let data = data {
                let values : [UInt8] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: UInt8.self).map{$0}
                }
                return BFIELD.A(val: values)
            } else {
                return BFIELD.A(val: nil)
            }
        case .E:
            if let data = data {
                let values : [Float] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: UInt32.self).map{Float(bitPattern: $0.bigEndian)}
                }
                return BFIELD.E(val: values)
            } else {
                return BFIELD.E(val: nil)
            }
        case .D:
            if let data = data {
                let values : [Double] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: UInt64.self).map{Double(bitPattern: $0.bigEndian)}
                }
                return BFIELD.D(val: values)
            } else {
                return BFIELD.D(val: nil)
            }
        case .C:
            return BFIELD.C(val: nil)
        case .M:
            return BFIELD.M(val: nil)
            
            // variable length array
        case .PL:
            if let data = data, !data.isEmpty, var string = String(bytes: data, encoding: .ascii) {
                string = string.trimmingCharacters(in: .whitespacesAndNewlines)
                let arr = string.reduce(into: [Bool](), { arr, char in
                    if char == "T" {
                        arr.append(true)
                    } else if char == "F" {
                        arr.append(false)
                    }
                })
                return BFIELD.PL(val: arr)
            } else {
                return BFIELD.PL(val: nil)
            }
        case .PX:
            if let data = data {
                return BFIELD.PX(val: Data(data))
            } else {
                return BFIELD.PX(val: Data())
            }
        case .PB:
            if let data = data {
                let values : [UInt8] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: UInt8.self).map{UInt8.init(bigEndian: $0)}
                }
                return BFIELD.PB(val: values)
            } else {
                return BFIELD.PB(val: nil)
            }
        case .PI:
            if let data = data {
                let values : [Int16] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: Int16.self).map{Int16.init(bigEndian: $0)}
                }
                return BFIELD.PI(val: values)
            } else {
                return BFIELD.PI(val: nil)
            }
        case .PJ:
            if let data = data {
                let values : [Int32] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: Int32.self).map{Int32.init(bigEndian: $0)}
                }
                return BFIELD.PJ(val: values)
            } else {
                return BFIELD.PJ(val: nil)
            }
        case .PK:
            if let data = data {
                let values : [Int64] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: Int64.self).map{Int64.init(bigEndian: $0)}
                }
                return BFIELD.PK(val: values)
            } else {
                return BFIELD.PK(val: nil)
            }
        case .PA:
            if let data = data {
                let values : [UInt8] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: UInt8.self).map{$0}
                }
                return BFIELD.PA(val: values)
            } else {
                return BFIELD.PA(val: nil)
            }
        case .PE:
            if let data = data {
                let values : [Float32] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: UInt32.self).map{Float32(bitPattern: $0)}
                }
                return BFIELD.PE(val: values)
            } else {
                return BFIELD.PE(val: nil)
            }
        case .PC:
            return BFIELD.PC(val: nil)

            
        case .QD:
            if let data = data {
                let values : [Double] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: UInt64.self).map{Double(bitPattern: $0)}
                }
                return BFIELD.QD(val: values)
            } else {
                return BFIELD.QD(val: nil)
            }
        case .QM:
            return BFIELD.QM(val: nil)
        }
    }
}
