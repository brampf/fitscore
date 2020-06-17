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
    A header data unit according to the FITS format specification.
 */
open class AnyHDU : HDU, Reader, CustomStringConvertible {
    
    public internal(set) var  headerUnit: [HeaderBlock] = []
    public internal(set) var dataUnit: Data?
    
    public required init() {
        // initilize keyword wrapper
        self.initializeWrapper()
    }
    
    /// The value field shall contain an integer rang- ing from 1 to 999, representing one more than the number of axes in each data array.
    @Keyword(HDUKeyword.NAXIS) public var naxis : Int?
    
    @Keyword(HDUKeyword.BITPIX) public var bitpix : BITPIX?
    
    /// The value field shall contain an integer equal to the number of parameters preceding each array in a group
    @Keyword(HDUKeyword.PCOUNT) public var pcount : Int?
    
    /// This keyword shall be used, along with the BZERO keyword, to linearly scale the array pixel values (i.e., the actual values stored in the FITS file) to transform them into the physical values that they represent
    @Keyword(HDUKeyword.BSCALE) public var bscale : Float? = 1.0
    
    /// This keyword shall be used, along with the BSCALE keyword, to linearly scale the array pixel values (i.e., the actual values stored in the FITS file) to transform them into the physical values that they represent
    @Keyword(HDUKeyword.BZERO) public var bzero : Float? = 0.0
    
    /// The value field shall contain a character string describing the physical units in which the quantities in the ar- ray, after application of BSCALE and BZERO, are expressed.
    @Keyword(HDUKeyword.BUNIT) public var bunit : String?
    
    public func naxis(_ dimension: Naxis) -> Int? {
        return self.lookup("NAXIS\(dimension)")
    }
    
    /// initilaize the keyword wrapper
    internal func initializeWrapper() {
        self._naxis.initialize(self)
        self._bitpix.initialize(self)
        self._pcount.initialize(self)
        self._bscale.initialize(self)
        self._bzero.initialize(self)
        self._bunit.initialize(self)
    }
    
    var dataSize : Int {
        
        let axis = self.naxis ?? 0
        
        if axis > 0 {
            /// - ToDo: figure out if this is really the proper way to deal with data alignments
            var size = (bitpix?.bits ?? 0) / 8 // DEFAULT Data type is is UInt8
            for naxis in 1...axis {
                size = size * (self.naxis(naxis) ?? 1)
            }
            return size
        } else {
            return 0
        }
    }
    
    public func validate(onMessage:((String) -> Void)? = nil) -> Bool {

        defer {
            // always move the end to the end
            self.headerUnit.removeAll { $0.keyword == HDUKeyword.END }
            headerUnit.append(HeaderBlock(keyword: HDUKeyword.END))
        }
        
        let size = self.dataUnit?.count ?? 0
        
        guard size == dataSize else  {
            onMessage?("Data contains \(size) bytes but supposed to be \(dataSize)")
            return false
        }
        
        guard let dimensions = self.naxis else {
            onMessage?("Missing NAXIS header")
            return false
        }
        
        for dimension in 1..<dimensions {
            guard self.naxis(dimension) != nil else {
                onMessage?("Missing naxis \(dimension)")
                return false
            }
        }
        
        guard self.bitpix != nil else {
            onMessage?("Missing BITPIX header") 
            return false
        }
        
        return true
    }
    
    /// sets value and comment for `HDUKeyworld`
    public func header<Value: HDUValue>(_ keyword: HDUKeyword, value: Value, comment: String?) {
        
        print("SET> \(keyword): \(value.description)")
        
        if var block = headerUnit.first(where: {$0.keyword == keyword}) {
            // modify existing header if present
            block.value = value
            block.comment = comment
        } else {
            // add keyworld otherwise
            headerUnit.append(HeaderBlock(keyword: keyword, value: value, comment: comment))
        }
    }
    
    /// sets value and comment for `HDUKeyworld`
    public func header(_ keyword: HDUKeyword, comment: String?) {
        
        if var block = headerUnit.first(where: {$0.keyword == keyword}) {
            // modify existing header if present
            block.value = nil
            block.comment = comment
        } else {
            // add keyworld otherwise
            headerUnit.append(HeaderBlock(keyword: keyword, value: nil, comment: comment))
        }
    }
    
    //MARK:- Reader
    
    
    /**
     Initializes the element form the data provided
     
     - Parameter data: sequential data to read from
     
     - Throws: `FitsFail` unrecoverable errror
     */
    required public init(with data: inout Data) throws {
        
        // read header block
        while readHeader(data: &data) {
            data = data.advanced(by: CARD_LENGTH * BLOCK_LENGTH)
        }
        data = data.advanced(by: CARD_LENGTH * BLOCK_LENGTH)
        
        #if DEBUG
        print("Expected: \(self.dataSize); Padded: \(self.padded(value: self.dataSize,to: CARD_LENGTH*BLOCK_LENGTH)) Found: \(data.count)")
        #endif
        
        // initilize the wrappers
        self.initializeWrapper()
        
        // read the data block
        self.readData(data: &data)
        
        let paddy = padded(value: self.dataSize,to: CARD_LENGTH*BLOCK_LENGTH)
        if paddy == data.count {
            data = Data()
        } else {
            data = data.advanced(by: paddy)
        }
    }
    
    /**
     - Returns:  `false` if the header unit completed with `Keyworld.END`, true otherwise
     */
    internal final func readHeader(data: inout Data) -> Bool{
        
        for index in stride(from: 0, to: (BLOCK_LENGTH * CARD_LENGTH) - 1, by: CARD_LENGTH) {
            
            let card = data.subdata(in: index..<CARD_LENGTH+index)
            if let string = String(data: card, encoding: .ascii){

                // read the card
                let header = HeaderBlock.parse(form: string, context: Self.self)
                // store the card
                self.headerUnit.append(header)
                
                // end of header
                if header.isEnd {
                    return false
                }
            } else {
                print("Unable to read header")
                // throw FitsFail.malformattedHeader
            }
        }
        if data.count == 2880 {
            return false
        }
        // whole block read
        return true
    }
    
    internal final func readData(data: inout Data) {
        
        self.dataUnit = data.subdata(in: 0..<self.dataSize)
    }
    
}

//MARK:- Writer
extension AnyHDU : Writer {
    
    public func write(to: inout Data) throws {

        self.headerUnit.forEach { block in
            try? block.write(to: &to)
        }
         
        // fill with zeros
        self.pad(&to, by: CARD_LENGTH*BLOCK_LENGTH)
        
        if let unit = dataUnit {
            to.append(unit)
        }
        // fill with zeros
        self.pad(&to, by: CARD_LENGTH*BLOCK_LENGTH)
    }
    
    func padded(value: Int, to: Int) -> Int {
        
        let factor : Double = Double(value) / Double(to)
        return to * Int(factor.rounded(.up))
    }
    
    final internal func pad(_ dat: inout Data, by: Int) {
        
        while dat.count % by != 0 {
            dat.append(0)
        }
    }
}

extension AnyHDU : Hashable {
    
    public static func == (lhs: AnyHDU, rhs: AnyHDU) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.headerUnit)
        hasher.combine(self.dataUnit)
    }
    
}
