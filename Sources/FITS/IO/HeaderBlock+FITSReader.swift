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

extension HeaderBlock : FITSReader {
    
    static func read(_ data: UnsafeRawBufferPointer, context: inout ReaderContext) -> HeaderBlock? {
        
        return data[context.offset..<context.offset+CARD_LENGTH].withUnsafeBytes {  mptr in
            
            guard let raw = String(bytes: mptr, encoding: .ascii) else {
                return nil
            }
            
            let keyword : HDUKeyword = HDUKeyword(rawValue: raw.prefix(KEYWORD_LENGTH).trimmingCharacters(in: CharacterSet.whitespaces))
            let block = HeaderBlock(keyword: keyword, raw: raw)
            
            let remainer = raw.dropFirst(9).trimmingCharacters(in: CharacterSet.whitespaces)
            
            var isString = false
            var value = ""
            let comment = remainer.drop { char in
                if char == "'" {
                    isString.toggle()
                } else if char == "/" {
                    if !isString {return false} // end of sequence
                }
                value.append(char)
                return true
            }

            switch keyword {
                
            case .COMMENT, .HISTORY :
                block.comment = value
                
            default :
                // default behavior : split value and comment
                if isString {
                    block.value = value.trimmingCharacters(in: CharacterSet.init(arrayLiteral: "'").union(CharacterSet.whitespaces))
                } else {
                    block.value = AnyHDUValue.parse(value,for: keyword, context: context.currentHDU) as? HDUValue
                }
                block.comment = comment.trimmingCharacters(in: CharacterSet.whitespaces.union(.init(arrayLiteral: "/")))
            }
            
            return block
            
        }
        
    }
    
}
