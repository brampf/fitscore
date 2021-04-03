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

public final class HeaderUnit : RandomAccessCollection {

    public init() {
        
    }
    
    private var  records: [HeaderBlock] = []
    
    public var startIndex: Int = 0
    
    public var endIndex: Int {
        records.count
    }
    
    public subscript(position: Int) -> HeaderBlock {
        records[position]
    }
    
    public subscript(range: Range<Int>) -> Slice<HeaderUnit> {
        Slice<HeaderUnit>(base: self, bounds: range)
    }
    
    public subscript<Value: HDUValue>(_ keyword: HDUKeyword) -> Value? {
        get {
            if let value = records.first(where: {$0.keyword == keyword})?.value {
                //print("\(value) (\(type(of: value))) as \(Value.self)")
                if let intval = value as? Int {
                    return Value.init(i: intval)
                } else {
                    return value as? Value
                }
            } else {
                //print("\(keyword) not found")
                return nil
            }
        }
        set {
            if let block = records.first(where: {$0.keyword == keyword}) {
                block.value = newValue
            } else {
                records.append(HeaderBlock(keyword: keyword, value: newValue))
            }
        }
    }
    
    public subscript(_ keyword: HDUKeyword) -> HeaderBlock? {
        get {
            return records.first(where: {$0.keyword == keyword})
        }
        set {
            if let block = records.first(where: {$0.keyword == keyword}) {
                block.value = newValue?.value
                block.comment = newValue?.comment
            } else if let new = newValue {
                records.append(new)
            } else {
                // nothing to do
            }
        }
    }
}

extension HeaderUnit {
    
    var dataArraySize : Int {
        
        let axis = self[HDUKeyword.NAXIS] ?? 0
        let bitpix : BITPIX? = self[HDUKeyword.BITPIX]
        
        var size = 0
        if axis > 0 {
            size = 1
            for naxis in 1...axis {
                size = size * (self["NAXIS\(naxis)"] ?? 1)
            }
            
        }
        size *= abs(bitpix?.size ?? 1)
        
        return size
    }
    
    public var dataSize : Int {
        
        let axis = self[HDUKeyword.NAXIS] ?? 0
        let bitpix : BITPIX? = self[HDUKeyword.BITPIX]
        let pcount = self[HDUKeyword.PCOUNT] ?? 0
        let gcount = self[HDUKeyword.GCOUNT] ?? 1
        
        if self[HDUKeyword.GROUPS] ?? false {
            
            var groupSize = 0
            if axis > 0 {
                groupSize = 1
                for naxis in 2...axis {
                    groupSize = groupSize * (self["NAXIS\(naxis)"] ?? 1)
                }
                
            }
            groupSize += pcount
            groupSize *= gcount
            groupSize *= abs(bitpix?.size ?? 1)
            
            return groupSize
        } else {
            
            var size = 0
            if axis > 0 {
                size = 1
                for naxis in 1...axis {
                    size = size * (self["NAXIS\(naxis)"] ?? 1)
                }
                
            }
            size += pcount
            size *= gcount
            size *= abs(bitpix?.size ?? 1)
            
            return size
        }
    
    }
    
    public var paddeddataSize : Int {
        
        let factor : Double = Double(dataSize) / Double(DATA_BLOCK_LENGTH)
        return DATA_BLOCK_LENGTH * Int(factor.rounded(.up))
        
    }
    
    public var headerSize : Int {
        
        return records.count * CARD_LENGTH
        
    }
    
    public var hashValue : Int {
        return records.hashValue
    }
    
}

extension HeaderUnit : RangeReplaceableCollection {

    public func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, C.Element == HeaderBlock {
        records.replaceSubrange(subrange, with: newElements)
    }
}

extension HeaderUnit : CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var sb = ""
        for record in records {
            sb.append(record.description)
            sb.append("\n")
        }
        return sb
    }
}
