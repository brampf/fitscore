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
 Supertype to all Bintable Types
 */
public protocol BField : FIELD where FORM == BFORM, DISP == BDISP {
    
    //subscript(_ index: Int) -> Displayable
    
}

protocol _BField: _FIELD {


    
}

extension _BField {

}

//MARK:- PrefixType
/**
  THE TFIELD data structure as specified for the Bintable extensions
 
 The TFORMn keywords must be present for all values n = 1, ..., TFIELDS and for no other values of n. The value field of this indexed keyword shall contain a char- acter string of the form rTa. The repeat count r is the ASCII representation of a non-negative integer specifying the number of elements in Field n. The default value of r is 1; the repeat count need not be present if it has the default value. A zero el- ement count, indicating an empty field, is permitted. The data type T specifies the data type of the contents of Field n. Only the data types in Table 18 are permitted. The format codes must be specified in upper case. For fields of type P or Q, the only per- mitted repeat counts are 0 and 1. The additional characters a are optional and are not further defined in this Standard. Table 18 lists the number of bytes each data type occupies in a table row. The first field of a row is numbered 1.
 */
public class BFIELD: BField, _BField {
    public typealias FORM = BFORM
    public typealias DISP = BDISP
    
    #if DEBUG
    var raw : Data?
    #endif
    
    public var description: String {
        return "BFIELD"
    }
    
    public var debugDescription: String {
        return "BFIELD"
    }

    func write(_ form: BFORM) -> String {
        fatalError("Not implemented in BFIELD")
    }
    
    func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        fatalError("Not implemented in BFIELD")
    }
    
    var form: BFORM {
        fatalError("Not implemented in BFIELD")
    }
    
    public static func == (lhs: BFIELD, rhs: BFIELD) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(UUID())
    }
}

extension BFIELD {
    
    static func parse(data: Data?, type: BFORM) -> BFIELD {
        
        //print("PARSE \(type): \(data?.base64EncodedString() ?? "NIL")")
        
        switch type {
        case .L:
            if let data = data, !data.isEmpty {
                var string = String(data: data, encoding: .ascii)
                string = string?.trimmingCharacters(in: .whitespacesAndNewlines)
                let arr = string?.reduce(into: [Bool](), { arr, char in
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
            return BFIELD.X(val: data)
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
            if let data = data, !data.isEmpty {
                var string = String(data: data, encoding: .ascii)
                string = string?.trimmingCharacters(in: .whitespacesAndNewlines)
                let arr = string?.reduce(into: [Bool](), { arr, char in
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
            return BFIELD.PX(val: data)
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

protocol ValueBField : _BField, WritableBField {
    associatedtype ValueType : Displayable & Hashable
    
    var name : String {get}
    var val : [ValueType]? { get set }
    
    func form(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String

    var debugDesc : String {get}
    var desc : String {get}
}

protocol WritableBField {
    
    func write(to: inout Data)
    
}

extension ValueBField {
    
    var debugDesc: String {
        return "BFIELD.\(name)(\(val?.description ?? "-/-"))"
    }

    var desc: String {
        return val != nil ? "\(val!)" : "-/-"
    }
}

extension ValueBField where Self : Displayable, ValueType.DISP == BDISP, ValueType.FORM == BFORM {
    
    func form(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
        
        var ret = "["
        if (val?.forEach({ value in
            ret.append(value.format(disp, form, null))
            ret.append(",")
        })) != nil {
            ret.removeLast()
        }
        ret.append("]")
        
        return ret
    }
    
}

extension ValueBField where ValueType == EightBitValue {
    
    func write(to: inout Data) {
        if let arr = val {
            let chr = arr.map{$0.rawValue}
            var dat = chr.withUnsafeBytes{ $0.bindMemory(to: UInt8.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<ValueType>.size * arr.count))
        }
    }
}


extension ValueBField where ValueType == CharacterValue {
    
    func write(to: inout Data) {
        if let arr = val {
            let chr = arr.map{$0.rawValue}
            var dat = chr.withUnsafeBytes{ $0.bindMemory(to: UInt8.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<ValueType>.size * arr.count))
        }
    }
}

extension ValueBField where ValueType == SingleComplexValue {
    
    func write(to: inout Data) {
        if let arr = val {
            var dat = arr.withUnsafeBytes{ $0.bindMemory(to: Float.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<ValueType>.size * arr.count))
        }
    }
}

extension ValueBField where ValueType == DoubleComplexValue {
    
    func write(to: inout Data) {
        if let arr = val {
            var dat = arr.withUnsafeBytes{ $0.bindMemory(to: Double.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<ValueType>.size * arr.count))
        }
    }
}

extension ValueBField where ValueType : FixedWidthInteger {
    
    func write(to: inout Data) {
        if let arr = val {
            var dat = arr.withUnsafeBytes{ $0.bindMemory(to: ValueType.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<ValueType>.size * arr.count))
        }
    }
}

extension ValueBField where ValueType == Float {
    
    func write(to: inout Data) {
        if let arr = val {
            var dat = arr.withUnsafeBytes{ $0.bindMemory(to: ValueType.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<ValueType>.size * arr.count))
        }
    }
}

extension ValueBField where ValueType == Double {
    
    func write(to: inout Data) {
        if let arr = val {
            var dat = arr.withUnsafeBytes{ $0.bindMemory(to: ValueType.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<ValueType>.size * arr.count))
        }
    }
}

protocol WritableVarBField {
    
    func write(to dataUnit: inout Data, heap: inout Data)
}

protocol VarArray : ValueBField, WritableVarBField {
    associatedtype ArrayType : FixedWidthInteger
    

}

extension VarArray {
    
    public func write(to dataUnit: inout Data, heap: inout Data) {
        
        // array descriptor consists of (nelem, offset)
        let desc = [ArrayType(val?.count ?? 0).bigEndian, ArrayType(heap.count).bigEndian]
        //print("VarArray \((type(of: self))) -> \(ArrayType(heap.count))...\(ArrayType((val?.count ?? 0) * MemoryLayout<ValueType>.size + heap.count))")
        
        // write descriptor to data array
        desc.withUnsafeBytes{ ptr in
            dataUnit.append(ptr.bindMemory(to: ValueType.self))
        }
        
        // write array to heap
        self.write(to: &heap)
        
    }
    
}

struct BoolenValue : Hashable, ExpressibleByBooleanLiteral, CustomStringConvertible {
    
    var rawValue : Bool
    
    public init(booleanLiteral: Bool){
        self.rawValue = booleanLiteral
    }
    
    public var description: String {
        return rawValue ? "T" : "F"
    }
}

public struct CharacterValue : Hashable, ExpressibleByIntegerLiteral, LosslessStringConvertible {
    
    var rawValue : UInt8
    
    public init?(_ description : String){
        if let first = description.first?.asciiValue{
        self.rawValue = first
        } else {
            return nil
        }
    }
    
    public init(integerLiteral: UInt8){
        self.rawValue = integerLiteral
    }
    
    init?(_ character: Character){
        if let char = character.asciiValue {
            self.rawValue = char
        } else {
            return nil
        }
    }
    
    public var description: String {
        return String(rawValue)
    }
    
    public var char : Character {
        Character(UnicodeScalar(rawValue))
    }
}

public struct EightBitValue : Hashable, ExpressibleByIntegerLiteral, CustomStringConvertible {
    
    var rawValue : UInt8
    
    public init(integerLiteral: UInt8){
        self.rawValue = integerLiteral
    }
    
    public var description: String {
        return String(self.rawValue, radix: 2).padPrefix(toSize: 8, char: "0")
    }
}


public struct SingleComplexValue : Hashable, CustomStringConvertible {
    
    var rawValue : (r: Float, i: Float)
    
    public init(r: Float, i: Float){
        self.rawValue = (r,i)
    }
    
    public var description : String {
        return "\(rawValue.0) + i\(rawValue.1)"
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue.r)
        hasher.combine(rawValue.i)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

public struct DoubleComplexValue : Hashable, CustomStringConvertible {
    
    var rawValue : (r: Double, i: Double)
    
    public init(r: Double, i: Double){
        self.rawValue = (r,i)
    }
    
    public var description : String {
        return "\(rawValue.0) + i\(rawValue.1)"
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue.r)
        hasher.combine(rawValue.i)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}


extension String {
    
    public init(_ value: CharacterValue){
        self.init(value.rawValue)
    }
    
    public init(_ values: [CharacterValue]){
        self.init(values.map{$0.char})
    }
    
    public init?(_ values: [CharacterValue]?){
        if let val = values {
            self.init(val.map{$0.char})
        } else {
            return nil
        }
    }
    
}

extension Array where Element == CharacterValue {
    
    init(_ string: String){
        self.init(string.compactMap{CharacterValue($0)})
    }
    
}

extension Array where Element == EightBitValue {
    
    public init(_ bytes : [UInt8]){
        self.init(bytes.map{EightBitValue(integerLiteral: $0)})
    }
    
    public init(_ data : Data){
        self.init(data.map{EightBitValue(integerLiteral: $0)})
    }
    
}
