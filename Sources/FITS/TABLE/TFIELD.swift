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

open class TFIELD : Hashable, Equatable, CustomDebugStringConvertible {
    
    
    public static func == (lhs: TFIELD, rhs: TFIELD) -> Bool {
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
        return "TFIELD"
    }
    
    public static func parse(string: String?, type: TFORM) -> TFIELD {
        
        switch type {
        case .A:
            return TFIELD.A(val: string)
        case .I:
            let intValue = Int(string ?? "")
            return TFIELD.I(val: intValue)
        case .F:
            let floatValue = Float(string ?? "")
            return TFIELD.F(val: floatValue)
        case .E:
            let floatValue = Float(string ?? "")
            return TFIELD.E(val: floatValue)
        case .D:
            let doubleValue = Double(string?.replacingOccurrences(of: "D", with: "E") ?? "")
            return TFIELD.D(val: doubleValue)
        }
    }
    
    public func format(_ disp: TDISP) -> String? {
        return TFIELD.ERR
    }
    
    final public class A : TFIELD {
        var val: String?
        
        init(val: String?){
            self.val = val
        }
        
        override public func format(_ disp: TDISP) -> String? {
            
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
    
    final public class I : TFIELD {
        var val: Int?
        
        init(val: Int?){
            self.val = val
        }
        
        override public func format(_ disp: TDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            case .I( _, let m):
                return String(val).padPrefix(minSize: m ?? 0, char: "0")
            case .B( _, let m):
                return String(val, radix: 2).padPrefix(minSize: m ?? 0, char: "0")
            case .O( _, let m):
                return String(val, radix: 8).padPrefix(minSize: m ?? 0, char: "0")
            case .Z( _, let m):
                return String(val, radix: 16).padPrefix(minSize: m ?? 0, char: "0")
            default:
                return "ERR"
            }
        }
        
        override public var debugDescription: String {
            return "TFIELD.I(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("I")
            hasher.combine(val)
        }
    }
    
    final public class F : TFIELD {
        var val: Float?
        
        init(val: Float?){
            self.val = val
        }
        
        override public func format(_ disp: TDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            switch disp {
            case .F( _, let d):
                return String(format: "%f.\(d)", val)
            default:
                return "ERR"
            }
        }
        
        override public var debugDescription: String {
            return "TFIELD.F(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("F")
            hasher.combine(val)
        }
    }
    
    final public class E : TFIELD {
        var val: Float?
        
        init(val: Float?){
            self.val = val
        }
        
        override public func format(_ disp: TDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            return String(val)
        }
        
        override public var debugDescription: String {
            return "TFIELD.E(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("E")
            hasher.combine(val)
        }
    }
    
    final public  class D : TFIELD {
        var val: Double?
        
        init(val: Double?){
            self.val = val
        }
        
        override public func format(_ disp: TDISP) -> String? {
            
            guard let val = self.val else {
                return nil
            }
            
            return String(val)
        }
        
        override public var debugDescription: String {
            return "TFIELD.D(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("D")
            hasher.combine(val)
        }
    }
    
}

extension TFIELD : Writer {
    
    func write(to: inout Data) throws {
        /// - Todo: implement me!
    }
}
