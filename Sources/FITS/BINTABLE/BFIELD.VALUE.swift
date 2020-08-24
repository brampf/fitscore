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

public protocol FieldValue {
    
}

extension BFIELD {
    
    public class VALUE : Displayable, CustomStringConvertible {
        
        public func string<DISP: FITS.DISP, FORM: FITS.FORM>(_ disp: DISP?, _ form: FORM?) -> String? {
            fatalError("Not implemented on BFIELD.VALUE")
        }
        
        public static func == (lhs: VALUE, rhs: VALUE) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(UUID())
        }
        
        public var description: String {
            return "BFIELD.VALUE"
        }
        
        public var debugDescription: String {
            return "BFIELD.VALUE"
        }

    }
}

//MARK:- 8bit Integer Value
public final class UInt8Value : BFIELD.VALUE, DisplayableInteger, ExpressibleByIntegerLiteral {
    
    var rawValue : UInt8
    
    public init(integerLiteral value: UInt8) {
        self.rawValue = value
    }
    
    override public var description: String {
        return rawValue.description
    }
    
    override public func string<DISP, FORM>(_ disp: DISP?, _ form: FORM?) -> String? {
        
        if let thisForm = form as? BFORM?, let thisDisp = disp as? BDISP? {
            return self.format(thisDisp, thisForm, "")
        } else {
            return nil
        }
        
    }
    
    override public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
    
}

//MARK:- 16bit Integer Value
public final class Int16Value : BFIELD.VALUE, DisplayableInteger, ExpressibleByIntegerLiteral {
    
    var rawValue : Int16
    
    public init(integerLiteral value: Int16) {
        self.rawValue = value
    }
    
    override public var description: String {
        return rawValue.description
    }
    
    override public func string<DISP, FORM>(_ disp: DISP?, _ form: FORM?) -> String? {
        
        if let thisForm = form as? BFORM?, let thisDisp = disp as? BDISP? {
            return self.format(thisDisp, thisForm, "")
        } else {
            return nil
        }
        
    }
    
    override public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

//MARK:- 32bit Integer Value
public final class Int32Value : BFIELD.VALUE, DisplayableInteger, ExpressibleByIntegerLiteral {
    
    var rawValue : Int32
    
    public init(integerLiteral value: Int32) {
        self.rawValue = value
    }
    
    override public var description: String {
        return rawValue.description
    }
    override public func string<DISP, FORM>(_ disp: DISP?, _ form: FORM?) -> String? {
        
        if let thisForm = form as? BFORM?, let thisDisp = disp as? BDISP? {
            return self.format(thisDisp, thisForm, "")
        } else {
            return nil
        }
        
    }
    
    override public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

//MARK:- 64bit Integer Value
public final class Int64Value : BFIELD.VALUE, DisplayableInteger, ExpressibleByIntegerLiteral {
    
    var rawValue : Int64
    
    public init(integerLiteral value: Int64) {
        self.rawValue = value
    }
    
    override public var description: String {
        return rawValue.description
    }
    
    override public func string<DISP, FORM>(_ disp: DISP?, _ form: FORM?) -> String? {
        
        if let thisForm = form as? BFORM?, let thisDisp = disp as? BDISP? {
            return self.format(thisDisp, thisForm, "")
        } else {
            return nil
        }
        
    }
    
    override public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

//MARK:- 32bit Float Value
public final class FloatValue : BFIELD.VALUE, DisplayableFloatingPoint, ExpressibleByFloatLiteral {
    
    var rawValue : Float
    
    public init(floatLiteral: Float){
        self.rawValue = floatLiteral
    }
    
    override public var description: String {
        return rawValue.description
    }
    
    override public func string<DISP, FORM>(_ disp: DISP?, _ form: FORM?) -> String? {
        
        if let thisForm = form as? BFORM?, let thisDisp = disp as? BDISP? {
            return self.format(thisDisp, thisForm, "")
        } else {
            return nil
        }
        
    }
    
    override public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

//MARK:- 64bit Float Value
public final class DoubleValue : BFIELD.VALUE, DisplayableFloatingPoint, ExpressibleByFloatLiteral {
    
    var rawValue : Double
    
    public init(floatLiteral: Double){
        self.rawValue = floatLiteral
    }
    
    override public var description: String {
        return rawValue.description
    }
    
    override public func string<DISP, FORM>(_ disp: DISP?, _ form: FORM?) -> String? {
        
        if let thisForm = form as? BFORM?, let thisDisp = disp as? BDISP? {
            return self.format(thisDisp, thisForm, "")
        } else {
            return nil
        }
        
    }
    
    override public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

//MARK:- Boolean Value
public final class BoolenValue : BFIELD.VALUE, DisplayableBoolean, ExpressibleByBooleanLiteral {
    
    var rawValue : Bool
    
    public init(booleanLiteral: Bool){
        self.rawValue = booleanLiteral
    }
    
    override public var description: String {
        return rawValue ? "T" : "F"
    }
    
    override public func string<DISP, FORM>(_ disp: DISP?, _ form: FORM?) -> String? {
        
        if let thisForm = form as? BFORM?, let thisDisp = disp as? BDISP? {
            return self.format(thisDisp, thisForm, "")
        } else {
            return nil
        }
        
    }
    
    override public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

//MARK:- Character Value
public final class CharacterValue : BFIELD.VALUE, DisplayableCharacter, ExpressibleByIntegerLiteral, LosslessStringConvertible {
    
    var rawValue : UInt8
    
    public init?(_ description : String){
        if let first = description.first?.asciiValue{
        self.rawValue = first
        } else {
            return nil
        }
    }
    
    public init(integerLiteral: UInt8){
        self.rawValue = integerLiteral
    }
    
    public init?(_ character: Character){
        if let char = character.asciiValue {
            self.rawValue = char
        } else {
            return nil
        }
    }
    
    override public var description: String {
        return String(rawValue)
    }
    
    public var char : Character {
        Character(UnicodeScalar(rawValue))
    }
    
    override public func string<DISP, FORM>(_ disp: DISP?, _ form: FORM?) -> String? {
        
        if let thisForm = form as? BFORM?, let thisDisp = disp as? BDISP? {
            return self.format(thisDisp, thisForm, "")
        } else {
            return nil
        }
        
    }
    
    override public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

//MARK:- Bit Value
public final class EightBitValue : BFIELD.VALUE, ExpressibleByIntegerLiteral {
    
    var rawValue : UInt8
    
    public init(integerLiteral: UInt8){
        self.rawValue = integerLiteral
    }
    
    override public var description: String {
        return String(self.rawValue, radix: 2).padPrefix(toSize: 8, char: "0")
    }
    
    override public func string<DISP, FORM>(_ disp: DISP?, _ form: FORM?) -> String? {
        
        if let thisForm = form as? BFORM?, let thisDisp = disp as? BDISP? {
            return self.format(thisDisp, thisForm, "")
        } else {
            return nil
        }
    }
    
    override public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

//MARK:- 32bit Complex Value
public final class SingleComplexValue : BFIELD.VALUE {
    
    var rawValue : (r: Float, i: Float)
    
    public init(r: Float, i: Float){
        self.rawValue = (r,i)
    }
    
    override public var description : String {
        return "\(rawValue.0) + i\(rawValue.1)"
    }
    
    override public func string<DISP, FORM>(_ disp: DISP?, _ form: FORM?) -> String? {
        
        if let thisForm = form as? BFORM?, let thisDisp = disp as? BDISP? {
            return self.format(thisDisp, thisForm, "")
        } else {
            return nil
        }
        
    }
    
    override public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue.r)
        hasher.combine(rawValue.i)
    }
}

//MARK:- 64bit Complex Value
public final class DoubleComplexValue : BFIELD.VALUE {
    
    var rawValue : (r: Double, i: Double)
    
    public init(r: Double, i: Double){
        self.rawValue = (r,i)
    }
    
    override public var description : String {
        return "\(rawValue.0) + i\(rawValue.1)"
    }
    
    override public func string<DISP, FORM>(_ disp: DISP?, _ form: FORM?) -> String? {
        
        if let thisForm = form as? BFORM?, let thisDisp = disp as? BDISP? {
            return self.format(thisDisp, thisForm, "")
        } else {
            return nil
        }
        
    }
    
    override public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue.r)
        hasher.combine(rawValue.i)
    }
    
}


extension String {
    
    public init(_ value: CharacterValue){
        self.init(value.rawValue)
    }
    
    public init(_ values: [CharacterValue]){
        self.init(values.map{$0.char})
    }
    
    public init?(_ values: [CharacterValue]?){
        if let val = values {
            self.init(val.map{$0.char})
        } else {
            return nil
        }
    }
    
}

extension Array where Element == CharacterValue {
    
    init(_ string: String){
        self.init(string.compactMap{CharacterValue($0)})
    }
    
}

extension Array where Element == EightBitValue {
    
    public init(_ bytes : [UInt8]){
        self.init(bytes.map{EightBitValue(integerLiteral: $0)})
    }
    
    public init(_ data : Data){
        self.init(data.map{EightBitValue(integerLiteral: $0)})
    }
    
}

extension Array where Element == UInt8Value {
    
    public init(_ bytes : [UInt8]){
        self.init(bytes.map{UInt8Value(integerLiteral: $0)})
    }
    
    public init(_ data : Data){
        self.init(data.map{UInt8Value(integerLiteral: $0)})
    }
    
}
