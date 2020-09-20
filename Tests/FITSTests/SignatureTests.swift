
/**
 Regression Tests to validate the public signature
 */

import XCTest
import FITS // no @testable (!)


final class SignatureTests: XCTestCase {
    
    static var allTests = [
        ("testFitsFile",testFitsFile),
        ("testPrimaryHDU",testPrimaryHDU),
        ("testTableHDU",testTableHDU),
    ]

    /// Public signature of `FitsFile`
    func testFitsFile(){
    
        // Creation
        XCSignature(FitsFile.init(prime:))
        XCSignatureThrows(FitsFile.init(with:))
        
        // Parsing
        XCSignatureThrows(FitsFile.read(from: ))
        XCSignature(FitsFile.read(from:onError:onCompletion:))
        
        // Validation
        XCSignature(FitsFile.validate(onMessage:))
        
        // Writing
        XCSignature(FitsFile.write(to:))
        XCSignature(FitsFile.write(to:onError:onCompleation:))
    }
    
    /// Public signature of `PrimaryHDU`
    func testPrimaryHDU(){
        
        // Creation
        XCSignatureThrows(PrimaryHDU.init(with:))
        //XCSignature(signature: PrimaryHDU.init(width:height:vectors:))
        
        // Accessors
        XCSignature(PrimaryHDU.header(_:comment:))
        XCSignature(PrimaryHDU.naxis(_:))
        //XCSignature(signature: PrimaryHDU.lookup(_:))
        
        // Properties
        XCProperty(\PrimaryHDU.isSimple)
        XCProperty(\PrimaryHDU.bitpix)
        XCProperty(\PrimaryHDU.hasExtensions)
        XCProperty(\PrimaryHDU.naxis)
        XCProperty(\PrimaryHDU.bscale)
        XCProperty(\PrimaryHDU.bunit)
        XCProperty(\PrimaryHDU.pcount)
        XCProperty(\PrimaryHDU.gcount)
        
        XCProperty(\PrimaryHDU.modified)
        
        XCProperty(\PrimaryHDU.headerUnit)
        XCProperty(\PrimaryHDU.dataUnit)
        
        // Traits
        XCSignature(PrimaryHDU.hash(into:))
        
        // Writing
        XCSignature(PrimaryHDU.write(to:))
    }
    
    /// Public signature of `TableHDU`
    func testTableHDU(){
        
        // Creation
        XCSignatureThrows(TableHDU.init(with:))
        
        // Accessors
        XCSignature(TableHDU.header(_:comment:))
        XCSignature(TableHDU.naxis(_:))
        
        // Properties
        XCProperty(\TableHDU.extname)
        XCProperty(\TableHDU.bitpix)
        XCProperty(\TableHDU.bzero)
        XCProperty(\TableHDU.bscale)
        XCProperty(\TableHDU.gcount)
        XCProperty(\TableHDU.pcount)
        
        // Traits
        XCSignature(TableHDU.hash(into:))
        
        // Writing
        XCSignature(TableHDU.write(to:))
    }
    
}
