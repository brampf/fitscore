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

protocol FITSReader {
    
    static func read(_ data: UnsafeRawBufferPointer, context: inout ReaderContext) -> Self?
    
}

struct ReaderContext {
    
    let dataLenght : Int
    var offset : Int
    var primaryHeader : HeaderUnit?
    var currentHeader : HeaderUnit?
    var currentHDU : HDU.Type?
    
    var msg : [String] = []
    
    mutating func move2CardEnd() {
        
        let factor : Double = Double(offset) / Double(DATA_BLOCK_LENGTH)
        self.offset = DATA_BLOCK_LENGTH * Int(factor.rounded(.up))
    }
    
    var hasBytes : Bool {
        return offset < dataLenght
    }

}
