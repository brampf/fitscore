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

public final class PrimaryHDU : AnyHDU {
    
    public var simple : Bool {
        return self.lookup(HDUKeyword.SIMPLE) ?? false
    }
    
}

extension PrimaryHDU {
    
    public var debugDescription: String {

        var result = ""
        result.append("-PRIME-------------------------------------\n")
        result.append("SIMPLE: \(simple)\n")
        result.append("BITPIX: \(bitpix.debugDescription)\n")
        if naxis ?? 0 > 1 {
            result.append("NAXIS: \(naxis ?? 0)\n")
            for i in 1...naxis! {
                result.append("NAXIS\(i): \(naxis(i) ?? 0)\n")
            }
        }
        result.append("-------------------------------------------\n")
        result.append("\(dataUnit.debugDescription)\n")
        result.append("-------------------------------------------\n")
        
        return result
    }
    
}



open class AnyImageHDU : AnyHDU {
 
    public func set<ByteFormat: BITPIX>(width: Int, height: Int, vectors: [ByteFormat]...){
        
        self.dataUnit = Data()
        vectors.forEach { vector in
            let data = vector.withUnsafeBytes { ptr in
                Data(buffer: ptr.bindMemory(to: ByteFormat.self))
            }
            self.dataUnit?.append(data)
        }
        
    }
    
    public func add<ByteFormat: BITPIX>(vector: [ByteFormat]) {
        
    }
    
}
