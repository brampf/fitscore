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

enum Severiy {
    case SEVERE
    case ERROR
    case WARNING
}

/**
 Programatically notation of a criterion to check for verification of a HDU
 
 - Parameter hdu: the Header Data Unit to verify
 
 - Returns: `true` if the condition holds (positive result) or `false` if the condition is not satisfied (negative result)
 */
typealias Criterion = (_ hdu: AnyHDU) -> Bool

/// A condition to verfiy
protocol Condition {
    
    /// description of the condition
    var description : String {get}
    
    /// severity of the condition
    var severity : Severiy {get}

    /**
    Implementation of the `Criterion` to check as a precondtion
     
     - SeeAlso: `Criterion`
     */
    var precondition: Criterion {get}
    
    /**
    Implementation of the `Criterion` to check if the precondtion is satisfied
     
     - SeeAlso: `Criterion`
     */
    var check : Criterion {get}
}
