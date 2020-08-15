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
    
    //MARK:- X : BIT
    /// Bit
    final public class X : BFIELD, ValueBField, ExpressibleByArrayLiteral {
        typealias ValueType = EightBitValue
        
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
        
        public init(arrayLiteral : UInt8...){
            self.val = arrayLiteral.map{EightBitValue(integerLiteral: $0)}
        }
        
        override public var form: BFORM {
            return BFORM.X(r: val?.count ?? 0 * MemoryLayout<UInt8>.size)
        }
        
        override public var description: String {
            return val != nil ? "\(val!.reduce(into: "", { $0 += "["+String($1.rawValue, radix: 2).padPrefix(toSize: 8, char: "0")+"]" }))" : "-/-"
        }
        
        override public func format(_ disp: BDISP?, _ form: BFORM?, _ null: String?) -> String {
            
            self.val?.map({ value in
                value.format(disp, form, null)
            }).description ?? empty(form, null, "")
            
        }
        
        override public var debugDescription: String {
            self.debugDesc
        }
        
        override public func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(val)
        }
        
    }
    
}
