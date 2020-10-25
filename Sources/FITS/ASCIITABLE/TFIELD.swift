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
 Supertype to all ASCII Table Types
 */
public protocol TField : FIELD where Self.FORM == TFORM, Self.DISP == TDISP{

}


//MARK:- Internal Type
protocol _TField : _FIELD {
    
}

extension _TField {
    
}

//MARK:- PrefixType
public class TFIELD : TField, _TField {
    public typealias FORM = TFORM
    public typealias DISP = TDISP
    
    #if DEBUG
    public var raw : String = ""
    #endif
    
    public var description: String {
        return "TFIELD"
    }
    
    public var debugDescription: String {
        return "TFIELD"
    }
    
    func write(_ form: TFORM) -> String {
        fatalError("Not implemented in TFIELD")
    }
    
    func format(_ disp: TDISP?, _ form: TFORM?, _ null: String?) -> String {
        fatalError("Not implemented in TFIELD")
    }
    
    var form: TFORM {
        fatalError("Not implemented in TFIELD")
    }
    
    public static func == (lhs: TFIELD, rhs: TFIELD) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(UUID())
    }
}

extension TFIELD {
    
    static func parse(string: String, type: TFORM) -> TFIELD {
        
        string.data(using: .ascii)?.withUnsafeBytes{ ptr in
            self.read(ptr[0..<string.count], type: type)
        } ?? TFIELD()
    }
    
    static func read(_ data: UnsafeRawBufferPointer.SubSequence?, type: TFORM) -> TFIELD {
        
        let string : String?
        if let data = data, let bytes = String(bytes: data, encoding: .ascii){
            string = bytes.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            string = nil
        }
        
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
    
}
