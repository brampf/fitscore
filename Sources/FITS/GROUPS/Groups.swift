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

public protocol RandomGroup {
    associatedtype BITPIX : FITSByte
    
    var ptype : String? {get set}
    var pscal : Float? {get}
    var pzero : Float? {get}
    
    var array : [BITPIX] {get set}
    
}

public struct Group<Bitpix: FITSByte> : RandomGroup {
    public typealias BITPIX = Bitpix
    
    // The value field shall contain a character string giving the name of Parameter n. If the PTYPEn keywords for more than one value of n have the same associated name in the value field, then the data value for the parameter of that name is to be obtained by adding the derived data values of the corre- sponding parameters.
    @Keyword("PTYPE") public var ptype : String?
    
    // The value field shall contain a floating-point number representing the coefficient of the linear term
    @Keyword("PSCAL") public var pscal : Float?
    
    // The value field shall contain a floating-point number, representing the true value correspond- ing to a group parameter value of zero. The default value for this keyword is 0.0.
    @Keyword("PZERO") public var pzero : Float? = 0.0
    
    public var array : [Bitpix] = []
}
