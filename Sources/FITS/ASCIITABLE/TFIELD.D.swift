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
    
    //MARK:- TFIELD.D
    final public  class D : TFIELD, ExpressibleByFloatLiteral {
        var val: Double?
        
        init(val: Double?){
            self.val = val
        }
        
        public init(floatLiteral : Double){
            self.val = floatLiteral
        }
        
        override var form: TFORM {
            let string = String(format: "%e",val ?? 0)
            return TFORM.D(w: string.count, d: string.drop(while: {$0 != "."}).count-1)
        }
        
        override func write(_ form: TFORM) -> String {
            switch form {
            case .D(let w, let d):
                return String(format: "%\(w).\(d)E", val ?? 0)
            default:
                return ""
            }
        }
        
        override func format(_ disp: TDISP?, _ form: TFORM?, _ null: String?) -> String {
            
            guard let val = self.val else {
                return empty(form, null, "")
            }
            
            switch disp {
            case .D(let w, let d, _):
                return String(format: "%\(w).\(d)E", val)
            default:
                return self.description
            }
        }
        
        override public var debugDescription: String {
            return "TFIELD.D(\(val?.description ?? "-/-"))"
        }
        
        override public func hash(into hasher: inout Hasher) {
            hasher.combine("D")
            hasher.combine(val)
        }
        
        override public var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
        
    }
}
