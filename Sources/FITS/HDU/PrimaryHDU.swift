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

public final class PrimaryHDU : AnyImageHDU {
    
    /// Valid FITS file
    public var isSimple : Bool {
        return self.lookup(HDUKeyword.SIMPLE) ?? false
    }
    
    /// Containts the Random Groups data
    public var hasGroups : Bool? {
        return self.lookup(HDUKeyword.GROUPS)
    }
    
    public var hasExtensions : Bool? {
        return self.lookup(HDUKeyword.EXTEND)
    }
    
    public required init(with data: inout Data) throws {
        try super.init(with: &data)
        
        if self.lookup(HDUKeyword.GROUPS) == true {
            try readGroups(from: &data)
        }
    }
    
    required init() {
        super.init()
        //fatalError("init() has not been implemented")
    }
    
    func readGroups(from data: inout Data) throws {
        
        guard
            let axis = self.naxis,
            let gcount : Int = self.lookup(HDUKeyword.GCOUNT),
            let pcount : Int = self.lookup(HDUKeyword.PCOUNT),
            let bitpix = self.bitpix
            else {
                print("Empty group, nothing to do")
                return
        }
        
        var size = 1
        for naxis in 2...axis {
            size *= (self.naxis(naxis) ?? 1)
        }
        print(size)
        size += pcount
        size *= gcount
        size *= bitpix.size
        
        print("Group Size \(size)")
        
        /// just move the parser for now
        /// - TODO: read the group
        
        let paddy = padded(value: size,to: CARD_LENGTH*BLOCK_LENGTH)
        if paddy == data.count {
            data = Data()
        } else {
            data = data.advanced(by: paddy)
        }
    }
    
}

extension PrimaryHDU {
    
    public var debugDescription: String {

        var result = ""
        result.append("-PRIME-------------------------------------\n")
        result.append("SIMPLE: \(isSimple)\n")
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
