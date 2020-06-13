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
 Bype representation of the data structures according to the FITS Standard
 
 Allowed values for the `BITPIX` keyword are:
 -   8       Character or unsigned binary integer
 -  16      16-bit two’s complement binary integer
 -  32      32-bit two’s complement binary integer
 -  64      64-bit two’s complement binary integer
 - -32      IEEE single-precision floating point
 - -64      IEEE double-precision floating point
 
 */
public protocol FITSByte : Equatable {
    static var bytes : Int {get}
    static var bits : Int {get}
    static var bitpix : BITPIX {get}
    
    static var max : Self {get}
    static var min : Self {get}
    var littleEndian : Self {get}
    var bigEndian : Self {get}
}

/**
 Character or unsigned binary integer
 
 Bytes are in big-endian order of decreasing significance. The byte that includes the sign bit shall be first, and the byte that has the ones bit shall be last.
 */
public typealias FITSByte_8 = UInt8
extension FITSByte_8 : FITSByte {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 8
    public static var bitpix: BITPIX = .UINT8
}

/**
 16-bit two’s complement binary integer
 
 Bytes are in big-endian order of decreasing significance. The byte that includes the sign bit shall be first, and the byte that has the ones bit shall be last.
 */
public typealias FITSByte_16 = Int16
extension FITSByte_16 : FITSByte {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 16
    public static var bitpix: BITPIX = .INT16
}

/**
 32-bit two’s complement binary integer
 
 Bytes are in big-endian order of decreasing significance. The byte that includes the sign bit shall be first, and the byte that has the ones bit shall be last.
 */
public typealias FITSByte_32 = Int32
extension FITSByte_32 : FITSByte {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 32
    public static var bitpix: BITPIX = .INT32
}

/**
 64-bit two’s complement binary integer
 
 Bytes are in big-endian order of decreasing significance. The byte that includes the sign bit shall be first, and the byte that has the ones bit shall be last.
 */
public typealias FITSByte_64 = Int64
extension FITSByte_64 : FITSByte {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 64
    public static var bitpix: BITPIX = .INT64
}

/**
 IEEE single-precision floating point
 
 Bytes are in big-endian order of decreasing significance. The byte that includes the sign bit shall be first, and the byte that has the ones bit shall be last.
 */
public typealias FITSByte_F = Float32
extension FITSByte_F : FITSByte {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 32
    public static var bitpix: BITPIX = .FLOAT32
    
    public static var max : FITSByte_F {
        return Float.greatestFiniteMagnitude
    }
    
    public static var min : FITSByte_F {
        return Float.zero
    }
    
    public var littleEndian : FITSByte_F {
        return Float(bitPattern: self.bitPattern.littleEndian)
    }
    
    public var bigEndian : FITSByte_F {
        return Float(bitPattern: self.bitPattern.bigEndian)
    }
}

/**
 IEEE double-precision floating point
 
 Bytes are in big-endian order of decreasing significance. The byte that includes the sign bit shall be first, and the byte that has the ones bit shall be last.
 */
public typealias FITSByte_D = Double
extension FITSByte_D : FITSByte {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 64
    public static var bitpix: BITPIX = .FLOAT64
    
    public static var max : FITSByte_D {
        return Double.greatestFiniteMagnitude
    }
    
    public static var min : FITSByte_D {
        return Double.zero
    }
    
    public var littleEndian : FITSByte_D {
        return Double(bitPattern: self.bitPattern.littleEndian)
    }
    
    public var bigEndian : FITSByte_D {
        return Double(bitPattern: self.bitPattern.bigEndian)
    }
}
