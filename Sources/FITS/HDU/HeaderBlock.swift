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
 A card image  keyworld record according to http://archive.stsci.edu/fits/users_guide/node19.html
 */
public final class HeaderBlock {
    
    public private(set) var keyword : HDUKeyword
    public var value : HDUValue?
    public var comment : String?
    
    init(keyword: HDUKeyword, value: HDUValue? = nil, comment: String? = nil){
        self.keyword = keyword
        self.value = value
        self.comment = comment
    }
    
    #if DEBUG
    init(keyword: HDUKeyword, value: HDUValue? = nil, comment: String? = nil, raw: String? = nil){
        self.keyword = keyword
        self.value = value
        self.comment = comment
    }
    
    public var raw : String? = nil
    #endif

    /// Containts the `HDUKeyworld.END`
    var isEnd : Bool {
        return keyword == HDUKeyword.END
    }
    
    /// Containts the `HDUKeyworld.SIMPLE`
    public var isSimple : Bool {
        return keyword == HDUKeyword.SIMPLE && value as? Bool == true
    }
    
    /// Containts the `HDUKeyworld.COMMENT`
    public var isComment : Bool {
        return keyword == HDUKeyword.COMMENT
    }
    
    /// Containts no `HDUKeyworld`
    public var isEmpty : Bool {
        return keyword.isEmpty && value == nil && comment?.isEmpty ?? true
    }
    
    /// Containts only a comment but neither a keyword nor a value
    public var isHeadline : Bool {
        return keyword.isEmpty && value == nil && comment != nil
    }
    
    /// Containts the `HDUKeyworld.XTENSION`
    public var isXtension : Bool {
        return keyword == HDUKeyword.XTENSION
    }
}

extension HeaderBlock : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(keyword)
        hasher.combine(value?.hashable)
    }
    
    public static func ==(lhs : HeaderBlock, rhs : HeaderBlock) -> Bool {
        return lhs.keyword == rhs.keyword && lhs.value?.hashable == rhs.value?.hashable && lhs.comment == rhs.comment
    }
}

extension HeaderBlock : CustomStringConvertible {
    
    public var description : String {
        var data = Data()
        try? self.write(to: &data)
        if let string = String(data: data, encoding: .ascii){
            return string
        } else {
            return "\(keyword) \(value != nil ? "= "+value!.description : "") \(value != nil && comment != nil ? "/ "+comment! : comment ?? "")"
        }
    }
}

typealias Context = HDU.Type

//MARK: - Reader
extension HeaderBlock {
    
    static func parse(form raw: String, context: Context? = nil) -> HeaderBlock {
        
        let keyword = raw.prefix(KEYWORD_LENGTH).trimmingCharacters(in: CharacterSet.whitespaces)
        
        #if DEBUG
        var block = HeaderBlock(keyword: keyword, raw: raw)
        #else
        var block = HeaderBlock(keyword: keyword)
        #endif
        
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
                block.value = AnyHDUValue.parse(value,for: keyword, context: context) as? HDUValue
            }
            block.comment = comment.trimmingCharacters(in: CharacterSet.whitespaces.union(.init(arrayLiteral: "/")))
        }
        
        return block
    }
}


//MARK:- Writer
extension HeaderBlock : Writer{
    
    public func write(to: inout Data) throws {
        
        /*
        if let raw = self.raw {
            self.write(string: raw, to: &to)
            return
        }
         */
        
        var out = ""
        if !keyword.isEmpty {
            out += self.keyword
            self.pad(string: &out, toSize: 8, char: " ")
            if !isEmpty && !isComment && !isEnd{
                out += "= "
            }
        }
        out += self.value?.description ?? ""
        if let comment = self.comment {
            if !isEmpty && !isComment && !isEnd {
            out += " / "
            }
            out += comment
        }
        self.pad(string: &out, toSize: 80, char: " ")
        
        self.write(string: out, to: &to)
    }

}
