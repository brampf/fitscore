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

@propertyWrapper
public class Keyword<Value : HDUValue> : CustomStringConvertible{
 
    private var header : HeaderUnit?
    
    let keyword : HDUKeyword
    
    var comment : String? = nil
    
    public var wrappedValue : Value? {
        get {
            //print("GET \(keyword)")
            return header?[keyword]
        }
        set {
            header?[keyword] = newValue
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
    
    init(wrappedValue: Value?, _ keyword : HDUKeyword, _ header: HeaderUnit){
        self.header = header
        self.keyword = keyword
        self.wrappedValue = wrappedValue
    }
    
    init(_ keyword : HDUKeyword, _ header: HeaderUnit){
        self.header = header
        self.keyword = keyword
    }
    
    func initialize(_ header: HeaderUnit){
        self.header = header
    }
    
    public var description: String {
        return "\(self.keyword.rawValue.padSuffix(toSize: 8, char: " ")) = \(self.wrappedValue.debugDescription)"
    }
}
