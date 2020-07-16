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

public protocol RandomGroup {
    
}

public struct Group : RandomGroup {

    public var hdu = PrimaryHDU()
    
    /// 
    init(_ hdu: PrimaryHDU){
        self.hdu = hdu
    }
    
    public subscript<Byte: FITSByte>(_ group: Int) -> [Byte] {
        
        guard let axis = hdu.naxis, group < axis-1 && group > 0 else {
            return []
        }
        
        guard let data = hdu.dataUnit else {
            return []
        }
        
        let offset = hdu.dataArraySize + (hdu.pcount ?? 0)
        
        let groupSize = hdu.naxis(group+2) ?? 0 * (hdu.bitpix?.size ?? 0)
        
        let start = offset
        let stop = hdu.pcount ?? 0 + groupSize * group
        var sub = data.subdata(in: start..<stop)
        return sub.withUnsafeMutableBytes { mptr8 in
            mptr8.bindMemory(to: Byte.self).map{$0.littleEndian}
        }
        
    }
}
