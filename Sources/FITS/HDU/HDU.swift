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

public protocol HDU : CustomDebugStringConvertible{
    
    var headerUnit : [HeaderBlock] {get}
    var dataUnit : Data? {get}
    
    
}

extension HDU where Self: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        var result = headerUnit.reduce(into: "") { result, block in
            result.append(contentsOf: block.description)
            result.append("\n")
        }
        result.append("-------------------------------------------\n")
        result.append("\(dataUnit.debugDescription)\n")
        result.append("-------------------------------------------\n")
        
        return result
    }
    
}

extension HDU where Self: CustomStringConvertible {
    
    public var description: String {
        
        var result = ""
        for index in 1..<(lookup(HDUKeyword.NAXIS) ?? 0) + 1 {
            result.append("\(lookup("NAXIS\(index)") ?? 0) x ")
        }
        result.append("\(lookup(HDUKeyword.BITPIX) ?? BITPIX.UINT8)")
        
        return result
    }
    
}

extension HDU {
    
    /// fetches concrete value for specific `HDUKeyworld`
    public func lookup<VAL>(_ keyword: HDUKeyword) -> VAL? {
        if let value = headerUnit.first(where: {$0.keyword == keyword})?.value {
            switch value {
            case .BOOLEAN(let val): return val as? VAL
            case .INTEGER(let val): return val as? VAL
            case .STRING(let val): return val as? VAL
            case .FLOAT(let val): return val as? VAL
            case .COMPLEX(let val): return val as? VAL
            case .DATE(let val): return val as? VAL
                
            case .BITPIX(let val): return val as? VAL
            case .TFORM(let val): return val as? VAL
            case .TDISP(let val): return val as? VAL
            case .BFORM(let val): return val as? VAL
            case .BDISP(let val): return val as? VAL
            }
        } else {
            print("\(keyword) not found")
            return nil
        }
    }
    
}
