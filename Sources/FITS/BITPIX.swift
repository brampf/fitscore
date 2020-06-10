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
 BITPIX  represetns the byte layout of the data unit
 
 Bytes are in big-endian order of decreasing significance. The byte that includes the sign bit shall be first, and the byte that has the ones bit shall be last.
 
 -   8       Character or unsigned binary integer
 -  16      16-bit two’s complement binary integer
 -  32      32-bit two’s complement binary integer
 -  64      64-bit two’s complement binary integer
 - -32      IEEE single-precision floating point
 - -64      IEEE double-precision floating point
 
 */
public enum BITPIX : Int {
    
    /// `UInt8` Byte Format
    ///
    /// Eight-bit integers shall be unsigned binary integers, contained in one byte with decimal values ranging from 0 to 255.
    case UINT8 = 8
    
    /// `Int16` Byte Format
    ///
    /// Sixteen-bit integers shall be two’s complement signed binary in- tegers, contained in two bytes with decimal values ranging from −32768 to +32767.
    case INT16 = 16
    
    /// `Int32` Byte Format
    ///
    /// Thirty-two-bit integers shall be two’s complement signed binary integers, contained in four bytes with decimal values ranging from −2147483648 to +2147483647.
    case INT32 = 32
    
    /// `Int64` Byte format
    ///
    /// Sixty-four-bit integers shall be two’s complement signed binary integers, contained in eight bytes with decimal values ranging from −9223372036854775808 to +9223372036854775807.
    case INT64 = 64
    
    /// `Float` Byte Format
    ///
    /// Transmission of 32- and 64-bit floating-point data within the FITS format shall use the ANSI/IEEE-754 standard (IEEE 1985). BITPIX = -32 and BITPIX = -64 signify 32- and 64-bit IEEE floating-point numbers, respectively; the absolute value of BITPIX is used for computing the sizes of data structures. The full IEEE set of number forms is allowed for FITS interchange, including all special values.
    case FLOAT32 = -32
    
    /// `Double` Byte Format
    ///
    /// Transmission of 32- and 64-bit floating-point data within the FITS format shall use the ANSI/IEEE-754 standard (IEEE 1985). BITPIX = -32 and BITPIX = -64 signify 32- and 64-bit IEEE floating-point numbers, respectively; the absolute value of BITPIX is used for computing the sizes of data structures. The full IEEE set of number forms is allowed for FITS interchange, including all special values.
    case FLOAT64 = -64
    
    public var bits : Int {
        switch self {
        case .UINT8: return 8
        case .INT16: return 16
        case .INT32: return 32
        case .INT64: return 64
        case .FLOAT32: return 32
        case .FLOAT64: return 64
        }
    }
    
    public var size : Int {
        switch self {
        case .UINT8: return MemoryLayout<UInt8>.size
        case .INT16: return MemoryLayout<Int16>.size
        case .INT32: return MemoryLayout<Int32>.size
        case .INT64: return MemoryLayout<Int64>.size
        case .FLOAT32: return MemoryLayout<Float>.size
        case .FLOAT64: return MemoryLayout<Double>.size
        }
    }
}

/**
 Bytes are in big-endian order of decreasing significance. The byte that includes the sign bit shall be first, and the byte that has the ones bit shall be last.
 
 -   8       Character or unsigned binary integer
 -  16      16-bit two’s complement binary integer
 -  32      32-bit two’s complement binary integer
 -  64      64-bit two’s complement binary integer
 - -32      IEEE single-precision floating point
 - -64      IEEE double-precision floating point
 
 */
public protocol DataLayout : Equatable {
    static var bytes : Int {get}
    static var bits : Int {get}
    static var bitpix : BITPIX {get}
    
    static var max : Self {get}
    static var min : Self {get}
    var littleEndian : Self {get}
    var bigEndian : Self {get}
}

public typealias BITPIX_8 = UInt8
extension BITPIX_8 : DataLayout {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 8
    public static var bitpix: BITPIX = .UINT8
}

public typealias BITPIX_16 = Int16
extension BITPIX_16 : DataLayout {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 16
    public static var bitpix: BITPIX = .INT16
}

public typealias BITPIX_32 = Int32
extension BITPIX_32 : DataLayout {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 32
    public static var bitpix: BITPIX = .INT32
}

public typealias BITPIX_64 = Int64
extension BITPIX_64 : DataLayout {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 64
    public static var bitpix: BITPIX = .INT64
}

public typealias BITPIX_F = Float
extension BITPIX_F : DataLayout {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 32
    public static var bitpix: BITPIX = .FLOAT32
    
    public static var max : BITPIX_F {
        return Float.greatestFiniteMagnitude
    }
    
    public static var min : BITPIX_F {
        return Float.zero
    }
    
    public var littleEndian : BITPIX_F {
        return Float(bitPattern: self.bitPattern.littleEndian)
    }
    
    public var bigEndian : BITPIX_F {
        return Float(bitPattern: self.bitPattern.bigEndian)
    }
}

public typealias BITPIX_D = Double
extension BITPIX_D : DataLayout {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 64
    public static var bitpix: BITPIX = .FLOAT64
    
    public static var max : BITPIX_D {
        return Double.greatestFiniteMagnitude
    }
    
    public static var min : BITPIX_D {
        return Double.zero
    }
    
    public var littleEndian : BITPIX_D {
        return Double(bitPattern: self.bitPattern.littleEndian)
    }
    
    public var bigEndian : BITPIX_D {
        return Double(bitPattern: self.bitPattern.bigEndian)
    }
}
