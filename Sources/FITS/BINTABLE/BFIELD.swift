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
  THE TFIELD data structure as specified for the Bintable extensions
 
 The TFORMn keywords must be present for all values n = 1, ..., TFIELDS and for no other values of n. The value field of this indexed keyword shall contain a char- acter string of the form rTa. The repeat count r is the ASCII representation of a non-negative integer specifying the number of elements in Field n. The default value of r is 1; the repeat count need not be present if it has the default value. A zero el- ement count, indicating an empty field, is permitted. The data type T specifies the data type of the contents of Field n. Only the data types in Table 18 are permitted. The format codes must be specified in upper case. For fields of type P or Q, the only per- mitted repeat counts are 0 and 1. The additional characters a are optional and are not further defined in this Standard. Table 18 lists the number of bytes each data type occupies in a table row. The first field of a row is numbered 1.
 */
open class BFIELD: FIELD {
    public typealias TDISP = BDISP
    public typealias TFORM = BFORM
    
    public static func == (lhs: BFIELD, rhs: BFIELD) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine("ERR")
    }
    
    static let ERR = "ERR"
    
    #if DEBUG
    var raw : Data?
    #endif
    
    open var description: String {
        if let me = self as? Describalbe {
            return me.desc
        } else {
            return "\(type(of: self))"
        }
    }
    
    public var debugDescription: String {
        if let me = self as? Describalbe {
            return me.debugDesc
        } else {
            return String(describing: self)
        }
    }
    
    public static func parse(data: Data?, type: BFORM) -> BFIELD {
        
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
    
    public var form: TFORM {
        fatalError("Not implemented")
    }
    
    public func format(_ using: BDISP?) -> String? {
        return BFIELD.ERR
    }
    
    public func write(_ form: BFORM) -> String {
        ""
    }

    //MARK:- L : Logical
    /// Logical
    final public class L : BFIELD, BField {
        typealias ValueType = Bool
        
        let name = "L"
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            //case .L:
            //    return val.first ? "T" : "F"
            default:
                return self.description
            }
        }
        
        public func write(to: inout Data) {
            let string = val?.reduce(into: "", { r, v in
                r.append(v ? "T" : "F")
            }) ?? ""
            to.append(string)
        }
        
        public override var form: TFORM {
            return BFORM.L(r: val?.count ?? 0)
        }
    }
    
    //MARK:- X : BIT
    /// Bit
    final public class X : BFIELD, BField {
        typealias ValueType = UInt8
        
        let name = "X"
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        init(val: Data?){
            if let val = val {
                self.val = Array(val)
            }
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return self.description
            }
        }
   
        public func write(to: inout Data) {
            if let val = val {
                to.append(contentsOf: val)
            }
        }
        
        public override var form: TFORM {
            return BFORM.X(r: val?.count ?? 0 * MemoryLayout<UInt8>.size)
        }
        
        override public var debugDescription: String {
            return "BFIELD.X(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("X")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!.reduce(into: "", { $0 += "["+String($1, radix: 2).padPrefix(toSize: 8, char: "0")+"]" }))" : "-/-"
        }
    }
    
     //MARK:- B : (U)Byte
    /// Unsigned byte
    final public class B : BFIELD, BField {
        typealias ValueType = UInt8
        
        let name = "B"
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                /// - ToDo: format `val`
                return nil
            }
            
            switch disp {
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.B(r: val?.count ?? 0)
        }
    }
    
     //MARK:- I : Int16
    /// 16-bit integer
    final public class I : BFIELD, BField {
        typealias ValueType = Int16
        
        let name = "I"
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
                /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.I(r: val?.count ?? 0)
        }
    }
    
     //MARK:- J : Int32
    /// 32-bit integer
    final public class J : BFIELD, BField {
        typealias ValueType = Int32
        
        let name = "J"
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
                /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.J(r: val?.count ?? 0)
        }
    }
    
     //MARK:- K : Int64
    /// 64-bit integer
    final public class K : BFIELD, BField {
        typealias ValueType = Int64
        
        let name = "K"
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
                /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.K(r: val?.count ?? 0)
        }
    }
    
     //MARK:- A : Character
    // Character
    final public class A : BFIELD, BField {
        typealias ValueType = String.UTF8View.Element
        
        let name = "A"
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        init(val: String){
            self.val = Array(val.utf8)
        }
        
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            case .A(let w):
                return String(bytes: val, encoding: .ascii)//.prefix(w))
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.A(r: val?.count ?? 0)
        }

        public var debugDesc: String {
            return "BFIELD.\(name)(\(String(bytes: val ?? [], encoding: .ascii) ?? "-/-"))"
        }
    }
    
     //MARK:- E : Single-precision floating point
    /// Single-precision floating point
    final public class E : BFIELD, BField {
        typealias ValueType = Float32
        
        let name = "E"
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
                /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.E(r: val?.count ?? 0)
        }
    }
    
    //MARK:- D : Double-precision floating point
    /// Double-precision floating point
    final public class D : BFIELD, BField{
        typealias ValueType = Float64
        
        let name = "D"
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.D(r: val?.count ?? 0)
        }
    }
    
    //MARK:- C : Single-precision complex
    /// Single-precision complex
    final public class C : BFIELD {
        var val: [(Float,Float)]?
        
        init(val: [(Float,Float)]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.C(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.C(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("C")
            val?.forEach({ f1,f2 in
                hasher.combine(f1)
                hasher.combine(f2)
            })
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    //MARK:- M : Single-precision floating point
    /// Double-precision complex
    final public class M : BFIELD {
        var val: [(Double,Double)]?
        
        init(val: [(Double,Double)]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
                /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.M(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.M(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("M")
            val?.forEach({ f1,f2 in
                hasher.combine(f1)
                hasher.combine(f2)
            })
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
    
    //MARK:- PL : Array Descriptor (32-bit)
    /// Array Descriptor (32-bit)
    final public class PL : BFIELD, BField, VarArray {
        
        typealias ArrayType = Int32
        typealias ValueType = Bool
        
        let name = "PL"
        
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
                /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public func write(to: inout Data) {
            val?.forEach{ v in
                to.append(v ? "T" : "F")
            }
        }
        
        public override var form: TFORM {
            return BFORM.PL(r: val?.count ?? 0)
        }
    }
    
    //MARK:- PX
    /// Array Descriptor (32-bit)
    final public class PX : BFIELD, VarArray {
        typealias ArrayType = Int32
        typealias ValueType = UInt8
        
        let name = "PX"
        
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        init(val: Data?){
            if let val = val {
                self.val = Array(val)
            }
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public func write(to: inout Data) {
            if let arr = val {
                to.append(contentsOf: arr)
            }
        }
        
        public override var form: TFORM {
            return BFORM.PX(r: val?.count ?? 0)
        }
    }
    
    //MARK:- PB
    /// Array Descriptor (32-bit)
    final public class PB : BFIELD, BField, VarArray {
        typealias ArrayType = Int32
        typealias ValueType = UInt8
        
        let name = "PB"
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        public override var form: TFORM {
            return BFORM.PB(r: val?.count ?? 0)
        }
        
        override public var debugDescription: String {
            return "BFIELD.PB(\(val?.description ?? "-/-"))"
        }
    }
    
    //MARK:- PI
    /// Array Descriptor (32-bit)
    final public class PI : BFIELD, VarArray {
        typealias ArrayType = Int32
        typealias ValueType = Int16
        
        let name = "PI"
        
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.PI(r: val?.count ?? 0)
        }
    }
    
    //MARK:- PJ
    /// Array Descriptor (32-bit)
    final public class PJ : BFIELD, VarArray {
        
        typealias ArrayType = Int32
        typealias ValueType = Int32
        
        let name = "PJ"
        
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.PJ(r: val?.count ?? 0)
        }
    }
    
    //MARK:- PK
    /// Array Descriptor (32-bit)
    final public class PK : BFIELD, VarArray {
        typealias ArrayType = Int32
        typealias ValueType = Int64
        
        let name = "PK"
        
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.PK(r: val?.count ?? 0)
        }
    }
    
    //MARK:- PA
    /// Array Descriptor (32-bit)
    final public class PA : BFIELD, VarArray {
        typealias ArrayType = Int32
        typealias ValueType = String.UTF8View.Element

        
        let name = "PA"
        
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        init(val: String){
            self.val = Array(val.utf8)
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }

        public override var form: TFORM {
            return BFORM.PA(r: val?.count ?? 0)
        }

        public var debugDesc: String {
            return "BFIELD.\(name)(\(String(bytes: val ?? [], encoding: .ascii) ?? "-/-"))"
        }
        
    }
    
    //MARK:- PE
    /// Array Descriptor (32-bit)
    final public class PE : BFIELD, VarArray {
        typealias ArrayType = Int32
        typealias ValueType = Float32
        
        let name = "PE"
        
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.PE(r: val?.count ?? 0)
        }
    }
    
    //MARK:- PC
    /// Array Descriptor (32-bit)
    final public class PC : BFIELD, VarArray {
        typealias ArrayType = Int32
        typealias ValueType = (Float, Float)
        
        let name = "PC"
        
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.PC(r: val?.count ?? 0)
        }
    
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("PC")
            val?.forEach{ v in
                hasher.combine(v.0)
                hasher.combine(v.1)
            }
        }
        
        func write(to: inout Data) {
            //
        }
    }
    
    
    //MARK:- Q : Array Descriptor (64-bit)
    /// Array Descriptor (64-bit)
    final public class QD : BFIELD, VarArray {
        typealias ArrayType = Int64
        typealias ValueType = Double
        
        let name = "QD"
        
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
                /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.QD(r: val?.count ?? 0)
        }
    }
    
    /// Array Descriptor (64-bit)
    final public class QM : BFIELD, VarArray {
        
        typealias ArrayType = Int64
        typealias ValueType = (Double,Double)
        
        let name = "QM"
        
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP?) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            /// - ToDo: format `val`
            default:
                return self.description
            }
        }
        
        public override var form: TFORM {
            return BFORM.QM(r: val?.count ?? 0)
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("QM")
            val?.forEach({ v in
                hasher.combine(v.0)
                hasher.combine(v.1)
            })
        }
        
        
        func write(to: inout Data) {
            //
        }
    }
}

protocol Describalbe {
    
    var desc: String {get}
    
    var debugDesc: String {get}
    
}

protocol WritableBField {
    
    func write(to: inout Data)
}

protocol BField : FIELD, WritableBField, Describalbe where  TFORM == BFORM {
    associatedtype ValueType
    
    var name : String {get}
    var val : [ValueType]? { get set }
    
    init(val: [ValueType]?)
    
}

extension BField {
    
    init(val: ValueType){
        self.init(val: [val])
    }
    
     public var debugDesc: String {
        return "BFIELD.\(name)(\(val?.description ?? "-/-"))"
    }

    public  var desc: String {
        return val != nil ? "\(val!)" : "-/-"
    }
}

extension BField where ValueType : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(val)
    }
}

extension BField where ValueType : FixedWidthInteger {
    
    func write(to: inout Data) {
        if let arr = val {
            var dat = arr.withUnsafeBytes{ $0.bindMemory(to: ValueType.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<ValueType>.size * arr.count))
        }
    }
}

extension BField where ValueType == Float {
    
    func write(to: inout Data) {
        if let arr = val {
            var dat = arr.withUnsafeBytes{ $0.bindMemory(to: ValueType.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<ValueType>.size * arr.count))
        }
    }
}

extension BField where ValueType == Double {
    
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

protocol VarArray : BField, WritableVarBField {
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
