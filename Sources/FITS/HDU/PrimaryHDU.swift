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
    @Keyword(HDUKeyword.SIMPLE) public var isSimple : Bool? = false
    
    /// Containts the Random Groups data
    @Keyword(HDUKeyword.GROUPS) public var hasGroups: Bool?
    
    @Keyword(HDUKeyword.EXTEND) public var hasExtensions: Bool?
    
    public required init(with data: inout Data) throws {
        try super.init(with: &data)
        
        self.initializeWrapper()
        
        if self.lookup(HDUKeyword.GROUPS) == true {
            try readGroups(from: &data)
        }
    }
    
    required init() {
        super.init()
        // The value field shall contain a logical constant with the value T if the file conforms to this Standard
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.SIMPLE, value: true, comment: "Simply FitsCore"))
        // The value field shall contain an integer. The absolute value is used in computing the sizes of data structures
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.BITPIX, value: BITPIX.UINT8,  comment: "Only Chars in Table"))
        //  The value field shall contain a non-negative integer no greater than 999 representing the number of axes in the associated data array. A value of zero signifies that no data follow the header in the HDU.
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.NAXIS, value: 0, comment: "Number of dimensions"))
        
        self.initializeWrapper()
    }
    
    override func initializeWrapper() {
        super.initializeWrapper()
        
        self._isSimple.initialize(self)
        self._hasGroups.initialize(self)
        self._hasExtensions.initialize(self)
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
