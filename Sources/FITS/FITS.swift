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
