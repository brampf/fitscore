
import Foundation
@testable import FITS
import XCTest

//MARK:- Bintable specifics

func XCTAssertIdent<B: ValueBField>(_ field: B, file: StaticString = #file, line: UInt = #line) where B.FORM == BFORM {
    
    var data = Data()
    field.write(to: &data)
    
    if let new = BFIELD.parse(data: data, type: field.form) as? B {
    
        XCTAssertEqual(field.form, new.form, file: (file), line: line)
        XCTAssertEqual(field, new, file: (file), line: line)
    } else {
        XCTFail()
    }
}

func XCTAssertLength<B: ValueBField>(_ field: B, _ expectedLenght: Int, file: StaticString = #file, line: UInt = #line) {
    
    var data = Data()
    field.write(to: &data)
    
    let count = field.val?.count ?? 0
    
    XCTAssertEqual(data.count, count * MemoryLayout<B.BaseType>.size, file: (file), line: line)
    XCTAssertEqual(data.count, expectedLenght, file: (file), line: line)
}

func XCTAssertLength<V: VarArray>(_ field: V, _ expectedLenght: Int, file: StaticString = #file, line: UInt = #line) {
    
    var data = Data()
    var heap = Data()
    field.write(to: &data, heap: &heap)
    
    let count = field.val?.count ?? 0
    
    XCTAssertEqual(data.count, 8, file: (file), line: line)
    //XCTAssertEqual(Array(data), [UInt8](arrayLiteral: 0,0,0,UInt8(count),0,0,0,0), file: file, line: line)
    XCTAssertEqual(heap.count, count * MemoryLayout<V.BaseType>.size, file: (file), line: line)
    XCTAssertEqual(heap.count, expectedLenght, file: (file), line: line)
}

// MARK:- Signature specifics

func XCSignature<A,B>(_ signature : (A) -> (B), file: StaticString = #file, line: UInt = #line) {
    // true
}

func XCSignature<B>(_ signature : () -> (B), file: StaticString = #file, line: UInt = #line) {
    // true
}

func XCSignature<A>(_ signature : (A) -> (Void), file: StaticString = #file, line: UInt = #line) {
    // true
}

func XCSignature(_ signature : () -> (Void), file: StaticString = #file, line: UInt = #line) {
    // true
}

func XCSignatureThrows<X,Y>(_ signature : (X) -> (Y), file: StaticString = #file, line: UInt = #line) throws {
    // true
}

func XCSignatureThrows<X,Y>(_ signature : (inout X) throws -> (Y) , file: StaticString = #file, line: UInt = #line) {
    // true
}

func XCSignature<A1,A2,B>(_ signature : (A1,A2) -> (B), file: StaticString = #file, line: UInt = #line) {
    // true
}

func XCSignature<A1,A2,A3,B>(_ signature : (A1,A2,A3) -> (B), file: StaticString = #file, line: UInt = #line) {
    // true
}

func XCSignature<A1,A2,A3,B>(_ signature : (A1,A2,A3...) throws -> (B), file: StaticString = #file, line: UInt = #line) {
    // true
}

func XCProperty<P,V>(_ property: KeyPath<P,V>, file: StaticString = #file, line: UInt = #line){
    // true
}
