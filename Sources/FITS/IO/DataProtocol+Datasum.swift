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

extension DataProtocol where Self : ContiguousBytes {
    
    public var datasum : UInt32 {
        
        guard self.count % 2880 == 0 else {
            return 0
        }
        
        var sum32 : UInt32 = 0

        for block in 0..<(self.count / 2880){
            
            self.withUnsafeBytes { ptr in
                // For some reason, LLVM does a better job in optimizing if folded in a functions instead of using the code directly here
                self.sum(ptr.bindMemory(to: UInt8.self).baseAddress!.advanced(by: block * 2880), size: 2880, sum32: &sum32)
            }
        }
        return sum32
    }
    
    private func sum(_ buf: UnsafePointer<UInt8>, size: Int, sum32: inout UInt32) {
        
        var hi : UInt32 = (sum32 >> 16);
        var lo : UInt32 = sum32 & 0xFFFF;
        
        for idx in stride(from: 0, to: size, by: 4) {
            hi &+= (UInt32(buf[idx]) << 8) + UInt32(buf[idx+1])
            lo &+= (UInt32(buf[idx+2]) << 8) + UInt32(buf[idx+3])
        }
        
        var hicarry = hi >> 16;
        var locarry = lo >> 16;
        
        while (hicarry != 0 || locarry != 0) {
            hi = (hi & 0xFFFF) + locarry;
            lo = (lo & 0xFFFF) + hicarry;
            hicarry = hi >> 16;
            locarry = lo >> 16;
        }
        
        sum32 = (hi << 16) + lo;
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

extension DataProtocol where Self : ContiguousBytes, Index == Int {
    
    internal func crcsum(sum: inout UInt32) {
        
        guard self.count % 4 == 0 else {
            return
        }
        
        var hi : UInt32 = (sum >> 16);
        var lo : UInt32 = sum & 0xFFFF;
        
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
        
        sum = (hi << 16) + lo;
    }
}
