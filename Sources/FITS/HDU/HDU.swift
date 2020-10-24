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

public protocol HDU : CustomDebugStringConvertible {
    
    var headerUnit : HeaderUnit {get}
    var dataUnit : DataUnit? {get}
    
    func validate(onMessage:( (String) -> Void)?) -> Bool
}

extension HDU where Self: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        var result = "-\(type(of: self))".padSuffix(toSize: 80, char: "-")+"\n"
        result.append(headerUnit.debugDescription)
        result.append(String(repeating: "-", count: 80)+"\n")
        if let data = dataUnit {
            result.append("\(data.debugDescription)\n")
        } else {
            result.append("No Data Unit!\n")
        }
        
        return result
    }
    
}
