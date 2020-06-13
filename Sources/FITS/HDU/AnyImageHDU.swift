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
 
 */
open class AnyImageHDU : AnyHDU {
    
    /**
     Sets the content of the data unit to the data from the vectors via memory copy
     */
    public func set<ByteFormat: FITSByte>(width: Int, height: Int, vectors: [ByteFormat]...){
        
        self.set(HDUKeyword.BITPIX, value: .BITPIX(ByteFormat.bitpix), comment: "\(ByteFormat.bitpix) Bit")
        self.set(HDUKeyword.NAXIS, value: .INTEGER(3), comment: "Two dimensional picture")
        self.set("NAXIS\(1)", value: .INTEGER(width), comment: "Width")
        self.set("NAXIS\(2)", value: .INTEGER(height), comment: "Height")
        self.set("NAXIS\(3)", value: .INTEGER(vectors.count), comment: "Channels")
        
        self.dataUnit = Data()
        vectors.forEach { vector in
            let data = vector.withUnsafeBytes { ptr in
                Data(buffer: ptr.bindMemory(to: ByteFormat.self))
            }
            self.dataUnit?.append(data)
        }
    }
    
    /**
     Sets the content of the data unit to the data from the vectors via memory copy
     */
    public func set(width: Int, height: Int, layers: Int, dataLayout: BITPIX, data: Data){
        
        self.set(HDUKeyword.BITPIX, value: .BITPIX(dataLayout), comment: "\(dataLayout) Bit")
        self.set(HDUKeyword.NAXIS, value: .INTEGER(3), comment: "Two dimensional picture")
        self.set("NAXIS\(1)", value: .INTEGER(width), comment: "Width")
        self.set("NAXIS\(2)", value: .INTEGER(height), comment: "Height")
        self.set("NAXIS\(3)", value: .INTEGER(layers), comment: "Channels")
        
        self.dataUnit = data
    }
    
    /**
     Appends the data from the  vector to the data unit  via memory copy
     */
    public func add<ByteFormat: FITSByte>(vector: [ByteFormat]) throws {
        
        guard self.bitpix == ByteFormat.bitpix else {
            throw FitsFail.validationFailed("BITPIX \(ByteFormat.bitpix) incompatible with \(self.bitpix.debugDescription)")
        }
        
        guard vector.count == self.dataSize else {
            throw FitsFail.validationFailed("Vector size \(vector.count) incompatible with image dimensions")
        }
        
        let channels = self.naxis(3) ?? 0
        self.set("NAXIS\(3)", value: .INTEGER(channels + 1), comment: nil)
        
        if var data = self.dataUnit {
            // append to data unit
            vector.withUnsafeBytes { ptr in
                data.append(ptr.bindMemory(to: ByteFormat.self))
            }
        } else {
            // set data unit
            self.dataUnit = vector.withUnsafeBytes{ ptr in
                Data(buffer: ptr.bindMemory(to: ByteFormat.self))
            }
            
        }
    }
}

extension AnyImageHDU {
    
    /**
     Sets the content of the data unit to the data at the given pointer
     */
    public func set<ByteFormat: FITSByte>(width: Int, height: Int, ptr: UnsafeBufferPointer<ByteFormat>){
        
        if var data = self.dataUnit {
            data.append(ptr)
        } else {
            self.dataUnit = Data(buffer: ptr)
        }
        
    }
}
