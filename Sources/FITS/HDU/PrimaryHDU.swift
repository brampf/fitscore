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
        self.headerUnit.append(HeaderBlock(keyword: HDUKeyword.BITPIX, value: BITPIX.UINT8,  comment: "Size of data structures"))
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
        

        var dataSize = 1
        for naxis in 2...axis {
            dataSize *= (self.naxis(naxis) ?? 1)
        }
        var groupSize = dataSize
        groupSize += pcount
        groupSize *= gcount
        groupSize *= bitpix.size
        
        print("Group Size \(groupSize)")
        
        /*
        for groupIndex in 0..<gcount{
            
            let ptype: String? = self.lookup("PTYPE\(groupIndex+1)")
            let pscal: Float? = self.lookup("PSCAL\(groupIndex+1)")
            let pzero: Float? = self.lookup("PZERO\(groupIndex+1)")
            
            for naxis in 2...axis {
                let offset = naxis-2 * dataSize + pcount
                var sub = data.subdata(in: offset..<offset+axis)
                let values = sub.withUnsafeBytes { ptr in
                    Array(arrayLiteral: ptr.baseAddress)
                }
            }
            
            //let group = Group(self, groupIndex)
        }
        */
        
        
        /// just move the parser for now
        /// - TODO: read the group
        
        let paddy = padded(value: groupSize,to: CARD_LENGTH*BLOCK_LENGTH)
        if paddy == data.count {
            data = Data()
        } else {
            data = data.advanced(by: paddy)
        }
    }
    
}
