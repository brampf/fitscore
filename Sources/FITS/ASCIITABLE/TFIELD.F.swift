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
extension TFIELD {
    
    //MARK:- TFIELD.F
    final public class F : TFIELD, ExpressibleByFloatLiteral {
        var val: Float?
        
        init(val: Float?){
            self.val = val
        }
        
        public init(floatLiteral: Float){
            self.val = floatLiteral
        }
        
        public override var form: TFORM {
            let string = String(format: "%f",val ?? 0)
            return TFORM.F(w: string.count, d: string.drop(while: {$0 != "."}).count-1)
        }
        
        override public func write(_ form: TFORM) -> String {
            switch form {
            case .F(let w, let d):
               return String(format: "%\(w).\(d)f", val ?? 0)
            default:
                return ""
            }
        }
        
        override public func format(_ disp: TDISP?, _ form: TFORM?, _ null: String?) -> String {
            
            guard let val = self.val else {
                return empty(form, null, "")
            }
            
            switch disp {
            case .F(let w, let d):
                return String(format: "%\(w).\(d)f", val)
            default:
                return self.description
            }
        }
        
        override public var debugDescription: String {
            return "TFIELD.F(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("F")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
}
