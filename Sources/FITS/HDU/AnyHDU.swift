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
open class AnyHDU : HDU, Reader {
    
    public internal(set) var  headerUnit: [HeaderBlock] = []
    public internal(set) var dataUnit: Data?
    
    public internal(set) var modified : Bool = false
    
    public required init() {
        // initilize keyword wrapper
        self.initializeWrapper()
    }
    
    /// The value field shall contain a character string to be used to distinguish among different extensions of the same type
    @Keyword(.EXTNAME) public var extname : String?
    
    /// The value field shall contain an integer rang- ing from 1 to 999, representing one more than the number of axes in each data array.
    @Keyword(.NAXIS) public var naxis : Int?
    
    @Keyword(.BITPIX) public var bitpix : BITPIX?
    
    /// The value field shall contain an integer equal to the number of parameters preceding each array in a group
    @Keyword(.PCOUNT) public var pcount : Int? = 0
    
    /// The value field shall contain an integer equal to the number of parameters preceding each array in a group
    @Keyword(.GCOUNT) public var gcount : Int? = 1
    
    /// This keyword shall be used, along with the BZERO keyword, to linearly scale the array pixel values (i.e., the actual values stored in the FITS file) to transform them into the physical values that they represent
    @Keyword(.BSCALE) public var bscale : Float? = 1.0
    
    /// This keyword shall be used, along with the BSCALE keyword, to linearly scale the array pixel values (i.e., the actual values stored in the FITS file) to transform them into the physical values that they represent
    @Keyword(.BZERO) public var bzero : Float? = 0.0
    
    /// The value field shall contain a character string describing the physical units in which the quantities in the ar- ray, after application of BSCALE and BZERO, are expressed.
    @Keyword(.BUNIT) public var bunit : String?
    
    public func naxis(_ dimension: Naxis) -> Int? {
        return self.lookup("NAXIS\(dimension)")
    }
    
    /// initilaize the keyword wrapper
    internal func initializeWrapper() {
        self._naxis.initialize(self)
        self._bitpix.initialize(self)
        self._pcount.initialize(self)
        self._gcount.initialize(self)
        self._bscale.initialize(self)
        self._bzero.initialize(self)
        self._bunit.initialize(self)
    }
    
    var dataArraySize : Int {
        
        let axis = self.lookup(HDUKeyword.NAXIS) ?? 0
        
        var size = 0
        if axis > 0 {
            size = 1
            for naxis in 1...axis {
                size = size * (self.naxis(naxis) ?? 1)
            }
            
        }
        size *= abs(self.bitpix?.size ?? 1)
        
        return size
    }
    
    var dataSize : Int {
        
        let axis = self.lookup(HDUKeyword.NAXIS) ?? 0
        
        var size = 0
        if axis > 0 {
            size = 1
            for naxis in 1...axis {
                size = size * (self.naxis(naxis) ?? 1)
            }
            
        }
        size += self.pcount ?? 0
        size *= self.gcount ?? 1
        size *= abs(self.bitpix?.size ?? 1)
        
        return size
    }
    
    public func validate(onMessage:((String) -> Void)? = nil) -> Bool {

        var result = true
        
        defer {
            // always move the end to the end
            self.headerUnit.removeAll { $0.keyword == HDUKeyword.END }
            headerUnit.append(HeaderBlock(keyword: HDUKeyword.END))
        }
        
        if self.bitpix == nil {
            onMessage?("Missing BITPIX header")
            result = false
        }
        
        if self.naxis == nil  {
            onMessage?("Missing NAXIS header")
            result = false
        }
        
        for dimension in 1..<(self.naxis ?? 0)+1 {
            if self.naxis(dimension) == nil {
                onMessage?("Missing naxis \(dimension)")
                result = false
            }
        }
        
        var data = Data()
        try? self.writeHeader(to: &data)
        data.forEach { element in
            if element < 32 || element > 126 {
                onMessage?("Invalid Character \(element)")
                result = false
            }
        }
        
        if data.count < self.headerUnit.count * CARD_LENGTH {
            onMessage?("Invalid Header Size \(data.count)")
            result = false
        }
        
        if let size = dataUnit?.count, modified == false && size < dataSize  {
            onMessage?("Data contains \(size) bytes but supposed to be \(dataSize) bytes")
            result = false
        }
        
        data = Data()
        try? self.writeData(to: &data)
        if data.count < dataSize {
            onMessage?("Data contains \(data.count) bytes but supposed to be \(dataSize) bytes")
            result = false
        }
        
        return result
    }
    
    /// sets value and comment for `HDUKeyworld`
    public func header<Value: HDUValue>(_ keyword: HDUKeyword, value: Value, comment: String?) {
        
        //print("SET> \(keyword): \(value.description)")
        
        if let block = headerUnit.first(where: {$0.keyword == keyword}) {
            // modify existing header if present
            block.value = value
            block.comment = comment
        } else {
            // add keyworld otherwise
            headerUnit.append(HeaderBlock(keyword: keyword, value: value, comment: comment))
        }
        self.modified = true
    }
    
    /// sets value and comment for `HDUKeyworld`
    public func header(_ keyword: HDUKeyword, comment: String? = nil) {
        
        if let block = headerUnit.first(where: {$0.keyword == keyword}) {
            // modify existing header if present
            block.value = nil
            block.comment = comment
        } else {
            // add keyworld otherwise
            headerUnit.append(HeaderBlock(keyword: keyword, value: nil, comment: comment))
        }
        self.modified = true
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
                
                // end of heade
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
    
    internal func readData(data: inout Data) {
        
        self.dataUnit = data.subdata(in: 0..<self.dataSize)
    }
    
//MARK:- Writer
    
    public func write(to: inout Data) throws {

        try self.writeHeader(to: &to)
        
        try self.writeData(to: &to)
        
        //print("POSITION: \(to.count) (\(to.count / 2880))")
    }
    
    internal func writeHeader(to: inout Data) throws {
        
        self.headerUnit.forEach { block in
            try? block.write(to: &to)
        }
        
        // fill with blanks
        self.pad(&to, by: CARD_LENGTH*BLOCK_LENGTH, with: 32)
    }
    
    internal func writeData(to: inout Data) throws {
        
        if let unit = dataUnit {
            to.append(unit)
        }
        
        // fill with zeros
        self.pad(&to, by: CARD_LENGTH*BLOCK_LENGTH, with: 0)
    }
    
    func padded(value: Int, to: Int) -> Int {
        
        let factor : Double = Double(value) / Double(to)
        return to * Int(factor.rounded(.up))
    }
    
    final internal func pad(_ dat: inout Data, by: Int, with: UInt8) {
        
        while dat.count % by != 0 {
            //dat.append(0)
            dat.append(with)
        }
    }
    
    
    public var description: String {
        
        var result = "-\(type(of: self)): \(self.extname ?? "")".padSuffix(toSize: 80, char: "-")+"\n"
        for index in 1..<(lookup(HDUKeyword.NAXIS) ?? 0) + 1 {
            result.append("\(lookup("NAXIS\(index)") ?? 0) x ")
        }
        result.append("\(lookup(HDUKeyword.BITPIX) ?? BITPIX.UINT8)-bit")
        result.append(" \(self.dataUnit?.count ?? 0) bytes")
        
        return result
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
