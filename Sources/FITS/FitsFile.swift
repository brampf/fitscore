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
 Represenation of data in the FITS file format up to Version 4.0
 https://fits.gsfc.nasa.gov/fits_standard.html
 
 */
public final class FitsFile {
    
    public internal(set) var prime : PrimaryHDU
    public var HDUs : [AnyHDU] = []
    
    public init(prime: PrimaryHDU) {
        self.prime = prime
    }
    
    public func validate(onMessage:( (String) -> Void)?) {
        
        let validHDUs = self.HDUs.reduce(into: true) { result, hdu in
            result = result && hdu.validate(onMessage: onMessage)
        }
        let validPrime = prime.validate(onMessage: onMessage)
        
        prime.headerUnit.removeAll { $0.keyword == HDUKeyword.SIMPLE}
        if validPrime && validHDUs {
            onMessage?("Validation successful")
            prime.headerUnit.insert(HeaderBlock(keyword: HDUKeyword.SIMPLE, value: true, comment: "Validated by FITSCore"), at: 0)
        } else {
            onMessage?("Validation failed!")
            prime.headerUnit.insert(HeaderBlock(keyword: HDUKeyword.SIMPLE, value: false, comment: "Validated by FITSCore"), at: 0)
        }
        
    }
}

extension FitsFile : CustomDebugStringConvertible {
    
    public var debugDescription: String {

        return "\(prime.debugDescription)\n\(HDUs.reduce(into: "", { $0.append($1.debugDescription) }))"
    }
}

//MARK:- Reader
extension FitsFile : Reader {
    
    public static func read(from  url: URL, onError: ((Error) -> Void)?, onCompletion: (FitsFile) -> Void) {
        
        guard var data = try? Data(contentsOf: url) else {
            return
        }
        do{
            let file = try FitsFile(with: &data)
            onCompletion(file)
        } catch{
            onError?(error)
        }
    }
    
    public static func read(from data: inout Data) throws -> FitsFile {
      
        return try FitsFile(with: &data)
    }
    
    /**
    Parses a FITS file by sequencially reading the data provided.
     
     - Parameter data: the data sequence to read from
     - Parameter onError: (Optional) callback for error logging
     
     - Throws: `FitsFail` for unrecoverable errors during reaidng of the file
     */
    public convenience init(with data: inout Data) throws {
        
        let prime = try PrimaryHDU(with: &data)
        
        self.init(prime: prime)

        if prime.hasExtensions == true {
            // print("File has extensions")

        }
        try readExtensions(from: &data)
    }
    
    func readExtensions(from data: inout Data) throws {
        
        while data.count > 0 {
            
            guard let block = String(data: data.subdata(in: 0..<CARD_LENGTH), encoding: .ascii) else {
                // this is not supposed to happen
                throw FitsFail.malformattedHDU
            }
            
            // read the next card and check for extension
            let card = HeaderBlock.parse(form: block, context: AnyHDU.self)
            
            var newHDU : AnyHDU
            if !card.isXtension {
                // also not supposed to happen
                print("Missing extension keyword")
                throw FitsFail.malformattedHDU
            }
            
            if card.value?.description.contains("IMAGE   ") ?? false {
                newHDU = try ImageHDU(with: &data)
            } else if card.value?.description.contains("TABLE   ") ?? false {
                newHDU = try TableHDU(with: &data)
            } else if card.value?.description.contains("BINTABLE") ?? false {
                newHDU = try BintableHDU(with: &data)
            } else {
                newHDU = try AnyHDU(with: &data)
            }
            self.HDUs.append(newHDU)
        }
        
    }
    
}

//MARK:- Writer
extension FitsFile : Writer {
    
    public func write(to url: URL, onError: ((Error) -> Void)?, onCompleation: () -> Void) {
        
        do {
            var data = Data()
            try self.write(to: &data)
            
            try data.write(to: url)
            
        } catch {
            onError?(error)
        }
            
    }
    
    public func write(to: inout Data) throws {
        
        self.validate(onMessage: nil)
        
        try self.prime.write(to: &to)
        try self.HDUs.forEach { hdu in
            try hdu.write(to: &to)
        }

    }
}
