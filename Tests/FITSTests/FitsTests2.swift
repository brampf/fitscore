
import XCTest
@testable import FITS


final class FitsTests2: XCTestCase {

 
    func testRead() {
        
        let url = Bundle.module.url(forResource: "tst0012", withExtension: "fits")!
        
        //let old = try! FitsFile.read(from: url)
        
        let _ = try! FitsFile.read(contentsOf: url)
        
    }
    
    
    func testMetrics() {
        
        let url = Bundle.module.url(forResource: "tst0012", withExtension: "fits")!
        
        let options = XCTMeasureOptions()
        options.iterationCount = 100
        
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()], options: options) {
            let _ = try? FitsFile.read(contentsOf: url)
        }
    }
    
}
