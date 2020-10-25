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
        
        self._isSimple.initialize(self.headerUnit)
        self._hasGroups.initialize(self.headerUnit)
        self._hasExtensions.initialize(self.headerUnit)
    }

}
