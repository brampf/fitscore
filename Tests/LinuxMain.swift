import XCTest

import FITSTests

var tests = [XCTestCaseEntry]()
tests += FITSTests.allTests()
tests += TypeTests.allTests()
tests += ParserTests.allTests()
tests += WriterTests.allTests()
XCTMain(tests)
