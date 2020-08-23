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
    
    //MARK:- PA
    /// Array Descriptor (32-bit)
    final public class PA : BFIELD, VarArray, ExpressibleByArrayLiteral, ExpressibleByStringLiteral {
        typealias ArrayType = Int32
        typealias ValueType = CharacterValue
        typealias BaseType = UInt8

        let name = "PA"
        
        var val: [ValueType]?
        
        init(val: [ValueType]?){
            self.val = val
        }
        
        init(val: [UInt8]){
            self.val = val.map{CharacterValue(integerLiteral: $0)}
        }
        
        init(val: String){
            self.val = Array(val)
        }
        
        public init(arrayLiteral : CharacterValue...){
            self.val = arrayLiteral
        }
        
        public init(stringLiteral: String){
            self.val = stringLiteral.map{CharacterValue($0) ?? CharacterValue("_")!}
        }
        
        override public var form: BFORM {
            return BFORM.PA(r: val?.count ?? 0)
        }

        public var debugDesc: String {
            return "BFIELD.\(name)(\(String(val) ?? "-/-"))"
        }
        
        override public func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
            
            guard let val = self.val else {
                return empty(form, null, "")
            }
            
            switch disp {
            case .A(let w), .G(let w,_,_):
                return String(val).padPrefix(toSize: w, char: " ")
            default:
                return format(form, null ?? "")
            }
        }
        
        func format(_ form : BFORM?, _ null : String) -> String {
            
            guard let val = self.val else {
                return empty(form, null, "")
            }
            
            switch form {
            case .A(let r):
                return String(val).padPrefix(toSize: r, char: " ")
            default :
                return null
            }
            
        }
        
        override public var description: String {
            String(self.val) ?? "-/-"
        }
        
        override public var debugDescription: String {
            self.debugDesc
        }
        
        override public func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(val)
        }
        
        override public subscript(_ index: Int) -> BFIELD.VALUE? {
            get {
                return val?[index]
            }
            set {
                if let new = newValue as? ValueType {
                    val?.insert(new, at: index)
                }
            }
        }
        
    }
    
}
