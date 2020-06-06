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

protocol Writer {
    
    func write(to: inout Data) throws
    
}

extension Writer {
    
    func pad(string : inout String, toSize: Int, char: Character){
        let space = toSize - string.count
        if space > 0 {
            string.append(contentsOf: String(repeating: char, count: space))
        }
    }
    
    func padPrefix(string : inout String, toSize: Int, char: Character){
        let space = toSize - string.count
        if space > 0 {
            string = String(repeating: char, count: space)+string
        } else {
            string = String(string.prefix(toSize))
        }
    }
    
    func padSuffix(string : inout String, toSize: Int, char: Character){
        let space = toSize - string.count
        if space > 0 {
            string = string+String(repeating: char, count: space)
        } else {
            string = String(string.suffix(toSize))
        }
    }
    
    func pad(data : inout Data, toSize: Int) {
        let space = toSize - data.count
        data.append(contentsOf: Data(repeating: 0, count: space))
    }
    
    func write(string : String, to data: inout Data){
        if let block = string.data(using: .ascii){
            data.append(block)
        }
        
    }
}

extension String {
    
    mutating func m_padPrefix(toSize: Int, char: Character){
        
        let space = toSize - self.count
        if space > 0 {
            self.insert(contentsOf: String(repeating: char, count: space), at: self.startIndex)
        } else {
            self.removeLast(abs(space))
        }
    }
    
    mutating func m_padSuffix(toSize: Int, char: Character){
        
        let space = toSize - self.count
        if space > 0 {
            self.insert(contentsOf: String(repeating: char, count: space), at: self.endIndex)
        } else {
            self.removeFirst(abs(space))
        }
    }
    
    func padPrefix(toSize: Int, char: Character) -> LosslessStringConvertible {
        
        let space = toSize - self.count
        if space > 0 {
            return String(repeating: char, count: space)+self
        } else {
            return self.prefix(toSize)
        }
    }
    
    func padSuffix(toSize: Int, char: Character) -> LosslessStringConvertible {
        
        let space = toSize - self.count
        if space > 0 {
            return self+String(repeating: char, count: space)
        } else {
            return self.suffix(toSize)
        }
    }
    
    func padPrefix(minSize: Int, char: Character) -> String {
        
        let space = minSize - self.count
        if space > 0 {
            return String(repeating: char, count: space)+self
        } else {
            return self
        }
    }
    
    func padSuffix(minSize: Int, char: Character) -> String {
        
        let space = minSize - self.count
        if space > 0 {
            return self+String(repeating: char, count: space)
        } else {
            return self
        }
    }
}
