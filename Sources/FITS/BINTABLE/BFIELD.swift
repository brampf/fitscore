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

open class BFIELD: Hashable, Equatable, CustomDebugStringConvertible {
    
    
    public static func == (lhs: BFIELD, rhs: BFIELD) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine("ERR")
    }
    
    static let ERR = "ERR"
    
    #if DEBUG
    var raw : String?
    #endif
    
    public var debugDescription: String {
        return "BFIELD"
    }
    
    public static func parse(data: Data?, type: BFORM) -> BFIELD {
        
        //print("PARSE \(type): \(data?.base64EncodedString() ?? "NIL")")
        
        switch type {
        case .L:
            if let data = data, !data.isEmpty {
                let string = String(data: data, encoding: .ascii)
                if string == "T" {
                    return BFIELD.L(val: true)
                } else if string == "F" {
                    return BFIELD.L(val: false)
                } else {
                    return BFIELD.L(val: nil)
                }
            } else {
                return BFIELD.L(val: nil)
            }
        case .X:
            return BFIELD.X(val: data)
        case .B(let count):
            if let data = data {
                var values : [UInt8] = []
                data.copyBytes(to: &values, count: count)
                return BFIELD.B(val: values)
            } else {
                return BFIELD.B(val: nil)
            }
        case .I:
            if let data = data {
                let values : [Int16] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: Int16.self).map{$0.byteSwapped}
                }
                return BFIELD.I(val: values)
            } else {
                return BFIELD.I(val: nil)
            }
        case .J:
            if let data = data {
                let values : [Int32] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: Int32.self).map{$0.byteSwapped}
                }
                return BFIELD.J(val: values)
            } else {
                return BFIELD.J(val: nil)
            }
        case .K:
            if let data = data {
                let values : [Int64] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: Int64.self).map{$0.byteSwapped}
                }
                return BFIELD.K(val: values)
            } else {
                return BFIELD.K(val: nil)
            }
        case .A:
            if let data = data {
                let string = String(data: data, encoding: .ascii)
            return BFIELD.A(val: string)
            } else {
                return BFIELD.A(val: nil)
            }
        case .E:
            if let data = data {
                let values : [Float] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: UInt32.self).map{Float(bitPattern: $0.byteSwapped)}
                }
                return BFIELD.E(val: values)
            } else {
                return BFIELD.E(val: nil)
            }
        case .D:
            if let data = data {
                let values : [Double] = data.withUnsafeBytes { ptr in
                    ptr.bindMemory(to: UInt64.self).map{Double(bitPattern: $0.byteSwapped)}
                }
                return BFIELD.D(val: values)
            } else {
                return BFIELD.D(val: nil)
            }
        case .C:
            return BFIELD.C(val: nil)
        case .M:
            return BFIELD.M(val: nil)
        case .P:
            return BFIELD.P(val: nil)
        case .Q:
            return BFIELD.Q(val: nil)
        }
        
    }
    
    public func format(_ disp: BDISP) -> String? {
        return BFIELD.ERR
    }
    
    final public class L : BFIELD {
        var val: Bool?
        
        init(val: Bool?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return TFIELD.ERR
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.L(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("L")
            hasher.combine(val)
        }
    }
    
    final public class X : BFIELD {
        var val: Data?
        
        init(val: Data?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return TFIELD.ERR
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.X(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("X")
            hasher.combine(val)
        }
    }
    
    final public class B : BFIELD {
        var val: [UInt8]?
        
        init(val: [UInt8]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return TFIELD.ERR
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.B(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("B")
            hasher.combine(val)
        }
    }
    
    final public class I : BFIELD {
        var val: [Int16]?
        
        init(val: [Int16]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return TFIELD.ERR
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.I(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("I")
            hasher.combine(val)
        }
    }
    
    final public class J : BFIELD {
        var val: [Int32]?
        
        init(val: [Int32]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return TFIELD.ERR
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.J(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("J")
            hasher.combine(val)
        }
    }
    
    final public class K : BFIELD {
        var val: [Int64]?
        
        init(val: [Int64]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return TFIELD.ERR
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.K(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("K")
            hasher.combine(val)
        }
    }
    
    final public class A : BFIELD {
        var val: String?
        
        init(val: String?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            case .A(let w):
                return String(val.prefix(w))
            default:
                return TFIELD.ERR
            }
        }
        
        override public var debugDescription: String {
            return "TFIELD.A(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("A")
            hasher.combine(val)
        }
    }
    
    final public class E : BFIELD {
        var val: [Float]?
        
        init(val: [Float]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return TFIELD.ERR
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.E(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("E")
            hasher.combine(val)
        }
    }
    
    final public class D : BFIELD {
        var val: [Double]?
        
        init(val: [Double]?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return TFIELD.ERR
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.D(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("D")
            hasher.combine(val)
        }
    }
    
    final public class C : BFIELD {
        var val: (Float,Float)?
        
        init(val: (Float,Float)?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return TFIELD.ERR
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.C(\(val?.0.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("C")
            hasher.combine(val?.0)
            hasher.combine(val?.1)
        }
    }
    
    final public class M : BFIELD {
        var val: (Double,Double)?
        
        init(val: (Double,Double)?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return TFIELD.ERR
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.M(\(val?.0.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("M")
            hasher.combine(val?.0)
            hasher.combine(val?.1)
        }
    }
    
    final public class P : BFIELD {
        var val: Data?
        
        init(val: Data?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return TFIELD.ERR
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.P(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("P")
            hasher.combine(val)
        }
    }
    
    final public class Q : BFIELD {
        var val: Data?
        
        init(val: Data?){
            self.val = val
        }
        
        override public func format(_ disp: BDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            default:
                return TFIELD.ERR
            }
        }
        
        override public var debugDescription: String {
            return "BFIELD.Q(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("Q")
            hasher.combine(val)
        }
    }
}
