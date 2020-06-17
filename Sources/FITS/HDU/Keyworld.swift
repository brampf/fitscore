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

protocol Initializable {
    
    func initialize(_ hdu: AnyHDU)
}

@propertyWrapper
public class Keyword<Value : HDUValue> : Initializable{
 
    private var hdu : AnyHDU?
    
    let keyword : HDUKeyword
    
    var comment : String? = nil
    
    public var wrappedValue : Value? {
        get {
            //print("GET \(keyword)")
            
            return hdu?.headerUnit.first(where: {$0.keyword == keyword})?.value as? Value
        }
        set {
            //print("SET \(keyword) to \(newValue)")
            
            if var block = hdu?.headerUnit.first(where: {$0.keyword == keyword}) {
                block.value = newValue
            } else {
                hdu?.headerUnit.append(HeaderBlock(keyword: keyword, value: newValue, comment: comment))
            }
        }
    }
    
    init(_ keyword : HDUKeyword){
        self.keyword = keyword
    }
    
    init(wrappedValue: Value?, _ keyword : HDUKeyword){
        self.keyword = keyword
        self.wrappedValue = wrappedValue
    }
    
    init(wrappedValue: Value?, _ keyword : HDUKeyword, _ comment: String){
        self.keyword = keyword
        self.comment = comment
        self.wrappedValue = wrappedValue
    }
    
    init(wrappedValue: Value?, _ keyword : HDUKeyword, _ hdu: AnyHDU){
        self.hdu = hdu
        self.keyword = keyword
        self.wrappedValue = wrappedValue
    }
    
    init(_ keyword : HDUKeyword, _ hdu: AnyHDU){
        self.hdu = hdu
        self.keyword = keyword
    }
    
    func initialize(_ hdu: AnyHDU){
        self.hdu = hdu
    }
}

struct test {
    
    @Keyword(HDUKeyword.SIMPLE) var sim : Bool? = false
    
    @Keyword(HDUKeyword.SIMPLE, "Simply FITS") var simple : Bool? = true

}
