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
    
    //MARK:- TFIELD.I
    final public class I : TFIELD, ExpressibleByIntegerLiteral {
        var val: Int?
        
        init(val: Int?){
            self.val = val
        }
        
        public init(integerLiteral : Int){
            self.val = integerLiteral
        }
        
        public override var form: TFORM {
            let string = String(format: "%d", val ?? 0)
            return TFORM.I(w: string.count)
        }
        
        override public func write(_ form: TFORM) -> String {
            switch form {
            case .I(let w):
                return String(format: "%\(w)d", val ?? 0)
            default:
                return ""
            }
        }
        
        override public func format(_ disp: TDISP?, _ form: TFORM?, _ null: String?) -> String {
            
            guard let val = self.val else {
                return empty(form, null, "")
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
                return self.description
            }
        }
        
        override public var debugDescription: String {
            return "TFIELD.I(\(val?.description ?? "-/-"))"
        }
        
        public override func hash(into hasher: inout Hasher) {
            hasher.combine("I")
            hasher.combine(val)
        }
        
        public override var description: String {
            return val != nil ? "\(val!)" : "-/-"
        }
    }
}
