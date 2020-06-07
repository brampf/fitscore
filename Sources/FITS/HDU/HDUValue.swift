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

public enum HDUValue : Equatable, Hashable, CustomStringConvertible {
    
    // explicit specified types
    case INTEGER(Int)
    case FLOAT(Float)
    case COMPLEX(FITSComplex)
    case STRING(String)
    case BOOLEAN(Bool)
    
    // implicit specified types
    case DATE(Date)
    
    // special types
    case BITPIX(BITPIX)
    case TFORM(TFORM)
    case TDISP(TDISP)
    case BFORM(BFORM)
    case BDISP(BDISP)
    
    public static func parse(_ string: String, toType: HDUValue? = nil) -> HDUValue?{

        let trimmed = string.trimmingCharacters(in: CharacterSet.whitespaces)
        
        
        switch toType {
        case .BITPIX:
            if let raw = Int(trimmed), let bitpix = FITS.BITPIX(rawValue: raw) {
                return .BITPIX(bitpix)
            }
        case .TFORM:
            if let tform = FITS.TFORM.parse(trimmed) {
                return .TFORM(tform)
            }
        case .TDISP:
            if let tdisp = FITS.TDISP.parse(trimmed) {
                return .TDISP(tdisp)
            }
        case .BFORM:
            if let tform = FITS.BFORM.parse(trimmed) {
                return .BFORM(tform)
            }
        case .BDISP:
            if let tdisp = FITS.BDISP.parse(trimmed) {
                return .BDISP(tdisp)
            }
        default:
            // autodetect explicit specified types
            if trimmed == "T" { return .BOOLEAN(true)}
            if trimmed == "F" { return .BOOLEAN(false)}
            if let integer = Int(trimmed) { return .INTEGER(integer)}
            if let float = Float(trimmed) { return .FLOAT(float)}
            if trimmed.starts(with: "'") {return .STRING(trimmed.trimmingCharacters(in: CharacterSet.init(arrayLiteral: "'")))}
            
            let split = trimmed.split(separator: " ")
            if split.count == 2, let real = Double(split[0]), let imaginary = Double(split[1]){
                return .COMPLEX(FITSComplex(real, imaginary))
            }
        }

        //not found
        return nil
    }
    
    public var description: String {
        switch self {
        case .BOOLEAN(let value): return value ? "T" : "F"
        case .STRING(let value): return "'\(value)'"
        case .FLOAT(let value): return "\(value)"
        case .INTEGER(let value): return "\(value)"
        case .COMPLEX(let value): return "\(value)"
            
        case .DATE(let value): return "\(value)"
            
        case .BITPIX(let value): return "\(value.rawValue)"
        case .TFORM(let value): return "\(value)"
        case .TDISP(let value): return "\(value)"
        case .BFORM(let value): return "\(value)"
        case .BDISP(let value): return "\(value)"
        }
    }
}
