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

public struct Checksum : HDUValue, FITSSTRING {
    
    private(set) var complement : UInt32
    
    init(_ datasum: UInt32){
        complement = ~datasum
    }
    
    init(_ ascii : String){
        
        if let data = ascii.data(using: .ascii){
            
            // subtract the hex 30 offset from each character
            var arr : [UInt8] = data.map{$0 - 0x30}
            // cyclically shift the 16 char- acters in the encoded string one place to the left
            arr.append(arr.removeFirst())
            
            complement = arr.crc
        } else {
            complement = 0
        }
        
    }
    
    /**
     - ToDo: translate standard implementation into swift

     let mask : [UInt32] = [0xff000000, 0xff0000, 0xff00, 0xff]
     for i in 0..<4 {
         var ch : [UInt8] = .init(repeating: 0, count: 4)
         /* each byte becomes four */
         let byte : UInt8 = UInt8(self & mask[i] >> ((3 - i) * 8))
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
    public var toString: String {
        
        let exclude : [UInt8] = [0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f, 0x40, 0x5b, 0x5c, 0x5d, 0x5e, 0x5f, 0x60]
        var ascii = [UInt8](repeating: 0, count: 16) /* Output 16-character encoded string */
        let offset : UInt8 = 0x30; /* ASCII 0 (zero) */

        for idx in stride(from: 0, through: 24, by: 8) {
            
            let val = UInt8((complement << idx) >> 24)
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
        return String(bytes: ascii, encoding: .ascii) ?? "0000000000000000"
        
    }
    
    public var description: String {
        self.toString
    }
    
    public var hashable: AnyHashable {
        return complement
    }
    
}

extension DataProtocol where Self : ContiguousBytes, Index == Int {
    
    internal var crc : UInt32 {
        
        guard self.count % 4 == 0 else {
            return 0
        }
        
        var hi : UInt32 = (0 >> 16);
        var lo : UInt32 = 0 & 0xFFFF;
        
        for idx in stride(from: 0, to: self.count, by: 4) {
            hi &+= (UInt32(self[idx]) << 8) + UInt32(self[idx+1])
            lo &+= (UInt32(self[idx+2]) << 8) + UInt32(self[idx+3])
        }
        
        var hicarry = hi >> 16;
        var locarry = lo >> 16;
        
        while (hicarry != 0 || locarry != 0) {
            hi = (hi & 0xFFFF) + locarry;
            lo = (lo & 0xFFFF) + hicarry;
            hicarry = hi >> 16;
            locarry = lo >> 16;
        }
        
        return (hi << 16) + lo;
    }
}
