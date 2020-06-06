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

let KEYWORD_LENGTH = 8
let CARD_LENGTH = 80
let BLOCK_LENGTH = 36

public typealias Naxis = Int

/**
 Bytes are in big-endian order of decreasing significance. The byte that includes the sign bit shall be first, and the byte that has the ones bit shall be last.
 
 -   8       Character or unsigned binary integer
 -  16      16-bit two’s complement binary integer
 -  32      32-bit two’s complement binary integer
 -  64      64-bit two’s complement binary integer
 - -32      IEEE single-precision floating point
 - -64      IEEE double-precision floating point
 
 */
public enum BITPIX_ENUM : Int {
    
    /// `UInt8`
    ///
    /// Eight-bit integers shall be unsigned binary integers, contained in one byte with decimal values ranging from 0 to 255.
    case UINT8 = 8
    
    /// `Int16`
    ///
    /// Sixteen-bit integers shall be two’s complement signed binary in- tegers, contained in two bytes with decimal values ranging from −32768 to +32767.
    case INT16 = 16
    
    /// `Int32`
    ///
    /// Thirty-two-bit integers shall be two’s complement signed binary integers, contained in four bytes with decimal values ranging from −2147483648 to +2147483647.
    case INT32 = 32
    
    /// `Float`
    ///
    /// Transmission of 32- and 64-bit floating-point data within the FITS format shall use the ANSI/IEEE-754 standard (IEEE 1985). BITPIX = -32 and BITPIX = -64 signify 32- and 64-bit IEEE floating-point numbers, respectively; the absolute value of BITPIX is used for computing the sizes of data structures. The full IEEE set of number forms is allowed for FITS interchange, including all special values.
    case FLOAT32 = -32
    
    /// `Double`
    ///
    /// Transmission of 32- and 64-bit floating-point data within the FITS format shall use the ANSI/IEEE-754 standard (IEEE 1985). BITPIX = -32 and BITPIX = -64 signify 32- and 64-bit IEEE floating-point numbers, respectively; the absolute value of BITPIX is used for computing the sizes of data structures. The full IEEE set of number forms is allowed for FITS interchange, including all special values.
    case FLOAT64 = -64
    
    public var bits : Int {
        switch self {
        case .UINT8: return 8
        case .INT16: return 16
        case .INT32: return 32
        case .FLOAT32: return 32
        case .FLOAT64: return 64
        }
    }
    
    public var size : Int {
        switch self {
        case .UINT8: return MemoryLayout<UInt8>.size
        case .INT16: return MemoryLayout<Int16>.size
        case .INT32: return MemoryLayout<UInt32>.size
        case .FLOAT32: return MemoryLayout<Float>.size
        case .FLOAT64: return MemoryLayout<Double>.size
        }
    }
}


/**
 Representation of a complex number as this is totally missing in the Swift Foundation package
 
 Maps to `Complex`
 */
public protocol ComplexNumber: Hashable {
    
    init(_ real: Double, _ imaginary: Double)
}

#if os(Linux)
import ComplexModule

public typealias FITSComplex = ComplexModule.Complex<Double>

extension ComplexModule.Complex : ComplexNumber where RealType == Double {
    
    
}
#else
import Accelerate

public typealias FITSComplex = Accelerate.DSPDoubleComplex

extension Accelerate.DSPDoubleComplex : ComplexNumber {
    
    public init(_ real: Double, _ imaginary: Double){
        self.init(real: real, imag: imaginary)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(real)
        hasher.combine(imag)
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
#endif

public struct BINTABLE {
    
}

public struct TABLE {
    
}
