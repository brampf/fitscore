import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FitsTests.allTests),
        testCase(TypeTests.allTests),
        testCase(ParserTests.allTests),
        testCase(WriterTests.allTests),
    ]
}
#endif
