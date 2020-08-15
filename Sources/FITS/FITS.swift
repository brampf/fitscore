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

/// Indicator that values are to  be treated like strings when reading / writing
public protocol FITSSTRING {
    
}

//MARK:- Extensions
import Foundation

extension Data {
    
    mutating func append(_ ascii : String){
        if let data =  ascii.data(using: .ascii) {
            self.append(contentsOf: data)
        }
    }
    
}

typealias DATASUM = UInt32

extension Data {
    
    /**
     Checksum computation according to Appendix J
    
     The ones’ complement checksum is simple and fast to com- pute. This routine assumes that the input records are a multi- ple of four bytes long (as is the case for FITS logical records), but it is not difficult to allow for odd length records if neces- sary. To use this routine, first initialize the CHECKSUM keyword to ’0000000000000000’ and initialize sum32 = 0, then step through all the FITS logical records in the FITS HDU.
    
     */
    func check(_ sum32: UInt32) -> UInt32 {
        
        guard self.count % 4 == 0 else {
            return 0
        }
        
        /* Accumulate the sum of the high-order 16 bits and the */
        /* low-order 16 bits of each 32-bit word, separately. */
        /* The first byte in each pair is the most significant. */
        /* This algorithm works on both big and little endian machines.*/
        var hi : UInt32 = sum32 >> 16
        var lo : UInt32 = sum32 & 0xFFFF
        for idx in stride(from: 0, to: self.count, by: 4){
            hi += (UInt32(self[idx]) << 8) + UInt32(self[idx+1])
            lo += (UInt32(self[idx+2]) << 8) + UInt32(self[idx+3])
        }
        
        /* fold carry bits from each 16 bit sum into the other sum */
        var hicarry = hi >> 16
        var locarry = lo >> 16
        while ((hicarry != 0) || locarry != 0){
            hi = (hi & 0xFFFF) + locarry
            lo = (lo & 0xFFFF) + hicarry
            hicarry = hi >> 16
            locarry = lo >> 16
        }
        
        /* concatenate the full 32-bit value from the 2 halves */
        return (hi << 16) + lo
    }
    
}

extension DATASUM {
    
    /**
     Checksum ASCII encoding
     
     */
    var ascii : String {
        
        let exclude : [UInt8] = [0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f, 0x40, 0x5b, 0x5c, 0x5d, 0x5e, 0x5f, 0x60]
        
        var ascii = [UInt8](repeating: 0, count: 16) /* Output 16-character encoded string */
        
        let offset : UInt8 = 0x30; /* ASCII 0 (zero) */
        
        /// - ToDo: translate standard implementation into swift
        /*
        let mask : [UInt32] = [0xff000000, 0xff0000, 0xff00, 0xff]
        for i in 0..<4 {
            var ch : [UInt8] = .init(repeating: 0, count: 4)
            /* each byte becomes four */
            let byte : UInt8 = UInt8(self & mask[i]) >> ((3 - i) * 8)
            let quotient = byte / 4 + offset
            let remainder = byte % 4
            for j in 0..<4 {
                ch[j] = quotient
            }
            ch[0] += remainder
        
            var check = 1
            while (check > 0 ){
                check = 0
                for k in 0..<13 {
                    for j in stride(from:0, to: 4, by: 2){
                        if ch[j]==exclude[k] || ch[j+1]==exclude[k] {
                            ch[j] = ch[j] + 1
                            ch[j+1] = ch[j+1] - 1
                            check += 1
                        }
                    }
                }
            }
            
            for j in 0..<4 {
                ascii[4*j+i] = ch[j]
            }

        }
    
        */
        for idx in stride(from: 0, through: 24, by: 8) {
            
            let val = UInt8((~self << idx) >> 24)
            var val1 = val / 4 + val % 4 + offset
            var val2 = val / 4 + offset
            
            while exclude.contains(val1) || exclude.contains(val2){
                val1 += 1
                val2 -= 1
            }
            
            var val3 = val / 4 + offset
            var val4 = val / 4 + offset
            
            while exclude.contains(val3) || exclude.contains(val4){
                val3 += 1
                val4 -= 1
            }
            
            ascii[idx / 8] = val1
            ascii[idx / 8 + 4] =  val2
            ascii[idx / 8 + 8] =  val3
            ascii[idx / 8 + 12] =  val4
        }
        
        ascii.insert(ascii.removeLast(), at: 0)
        return String(bytes: ascii, encoding: .ascii) ?? ""
    }
    
}
