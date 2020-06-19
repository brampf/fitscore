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

/**
 Typed value strucutes for HeaderBlocks
 */
public protocol HDUValue : CustomStringConvertible {
    
    var hashable : AnyHashable { get }
    
    var toString : String { get }
}

struct AnyHDUValue {
    
    public static func parse(_ string: String, for keyword: HDUKeyword, context: Context?) -> Any? {
        
        let trimmed = string.trimmingCharacters(in: CharacterSet.whitespaces)
        
        switch keyword {
        case HDUKeyword.BITPIX:
            if let raw = Int(trimmed) {
                return FITS.BITPIX(rawValue: raw)
            }
        case HDUKeyword.DATE:
            let plainString = trimmed.trimmingCharacters(in: CharacterSet.init(arrayLiteral: "'"))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = dateFormatter.date(from: plainString ) {
                return date
            } else {
                return plainString
            }
        case _ where keyword.starts(with: "TFORM"):
            if context is BintableHDU.Type {
                return FITS.BFORM.parse(trimmed)
            } else {
                return FITS.TFORM.parse(trimmed)
            }
        case _ where keyword.starts(with: "TDISP"):
            if context is BintableHDU.Type {
                return FITS.BDISP.parse(trimmed)
            } else {
                return FITS.TDISP.parse(trimmed)
            }
        default:
            // autodetect explicit specified types
            if trimmed == "T" { return true}
            if trimmed == "F" { return false}
            if let integer = Int(trimmed) { return integer}
            if let float = Float(trimmed) { return float}
            if trimmed.starts(with: "'") {return trimmed.trimmingCharacters(in: CharacterSet.init(arrayLiteral: "'"))}
            
            let split = trimmed.split(separator: " ")
            if split.count == 2, let real = Double(split[0]), let imaginary = Double(split[1]){
                return FITSComplex(real, imaginary)
            }
        }
        
        //not found
        return nil
    }
    
}

extension HDUValue {
    
    public static func ==(lhs: HDUValue?, rhs: Self) -> Bool {
        if let left = lhs {
            return left.hashable == rhs.hashable
        } else {
            return false
        }
    }
    
    public static func ==(lhs: Self, rhs: HDUValue?) -> Bool {
        if let right = rhs {
            return lhs.hashable == right.hashable
        } else {
            return false
        }
    }
    
    public static func ==<T: HDUValue>(lhs: HDUValue, rhs: T?) -> Bool {
        guard type(of: lhs) == T.self else { return false }
        if let right = rhs {
            return lhs.hashable == right.hashable
        } else {
            return false
        }
    }
    
    public static func ==<T: HDUValue>(lhs: T?, rhs: HDUValue) -> Bool {
        guard T.self == type(of: rhs) else { return false }
        if let left = lhs {
            return left.hashable == rhs.hashable
        } else {
            return false
        }
    }

    public static func ==(lhs: HDUValue, rhs: HDUValue) -> Bool {
        guard type(of: lhs) == type(of: rhs) else { return false }
        return lhs.hashable == rhs.hashable
    }

    public static func !=(lhs: HDUValue, rhs: HDUValue) -> Bool {
        guard type(of: lhs) == type(of: rhs) else { return false }
        return lhs.hashable != rhs.hashable
    }
}

extension HDUValue where Self : Hashable {
    
    public func hash(hasher: inout Hasher){
        hasher.combine(self)
    }
    
    public var hashable : AnyHashable {
        AnyHashable(self)
    }
}

extension HDUValue where Self : Equatable {
    


}

extension String : HDUValue {
    
    public var description: String {
        return "'\(self)'"
    }
    
    public var toString : String {
        return "'\(self)'"
    }
}

extension Bool : HDUValue {
    
    public var description: String {
        return self ? "T" : "F"
    }
    
    public var toString : String {
        return self ? "T" : "F"
    }
}

extension Float : HDUValue {
    
    public var description: String {
        "\(self)"
    }
    
    public var toString : String {
        return "\(self)"
    }
    
}

extension Int : HDUValue {
    
    public var description: String {
        "\(self)"
    }
    
    public var toString : String {
        return "\(self)"
    }
}

extension FITSComplex : HDUValue {
    
    public var description: String {
        "\(self)"
    }
    
    public var toString : String {
        return "\(self)"
    }
}

extension BITPIX : HDUValue {
    
    public var description: String {
        "\(self.rawValue)"
    }
    
    public var toString : String {
        return "\(self)"
    }
}

extension Date : HDUValue {
    
    public var description: String {
        "\(self)"
    }
    
    public var toString : String {
        return "\(self)"
    }
}

extension BFORM : HDUValue {
    
    public var description: String {
        "\(self.FITSString)"
    }
    
    public var toString : String {
        return self.FITSString
    }
}

extension TFORM : HDUValue {
    
    public var description: String {
        "\(self.FITSString)"
    }
    
    public var toString : String {
        return self.FITSString
    }
}

extension BDISP : HDUValue {
    
    public var description: String {
        "\(self.FITSString)"
    }
    
    public var toString : String {
        return self.FITSString
    }
}

extension TDISP : HDUValue {
    
    public var description: String {
        "\(self.FITSString)"
    }
    
    public var toString : String {
        return self.FITSString
    }
}
