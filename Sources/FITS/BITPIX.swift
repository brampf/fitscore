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
 Bytes are in big-endian order of decreasing significance. The byte that includes the sign bit shall be first, and the byte that has the ones bit shall be last.
 
 -   8       Character or unsigned binary integer
 -  16      16-bit two’s complement binary integer
 -  32      32-bit two’s complement binary integer
 -  64      64-bit two’s complement binary integer
 - -32      IEEE single-precision floating point
 - -64      IEEE double-precision floating point
 
 */
public protocol BITPIX : Equatable {
    static var bytes : Int {get}
    static var bits : Int {get}
}

typealias BITPIX_8 = UInt8
extension BITPIX_8 : BITPIX {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 8
}

typealias BITPIX_16 = Int16
extension BITPIX_16 : BITPIX {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 16
}

typealias BITPIX_32 = Int32
extension BITPIX_32 : BITPIX {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 32
}

typealias BITPIX_F = Float
extension BITPIX_F : BITPIX {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 32
}

typealias BITPIX_D = Double
extension BITPIX_D : BITPIX {
    public static var bytes: Int = MemoryLayout<Self>.size
    public static var bits: Int = 64
}
