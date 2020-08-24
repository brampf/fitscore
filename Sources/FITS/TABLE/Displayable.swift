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

/// Ability to display a value
public protocol Displayable: Hashable {

    func string<DISP: FITS.DISP, FORM: FITS.FORM>(_ disp: DISP?, _ form: FORM?) -> String?
}

protocol _Displayable : Displayable {
    associatedtype DISP : FITS.DISP
    associatedtype FORM : FITS.FORM
    
    /**
        Creates a string representation of the value
     
     - Parameter disp: `DISP` value display style
     - Parameter form: `FORM` value format
     - Parameter null: `TNULL` value to use
     */
    func format(_ disp: DISP?, _ form: FORM?, _ null: String?) -> String

}

extension _Displayable {
    
    public func string<DISP: FITS.DISP, FORM: FITS.FORM>(_ disp: DISP?,_ form: FORM?) -> String? {
        
        if let thisForm = form as? Self.FORM?, let thisDisp = disp as? Self.DISP? {
            return self.format(thisDisp, thisForm, "")
        } else {
            return nil
        }
    }
    
    /// compute a string for a missing value
    func empty(_ form: FORM?, _ null: String?, _ fallback: String) -> String {

        return null != nil ? null! : (form != nil ? String(repeating: " ", count: form!.length) : fallback)
    }
}

//MARK:- Optional (Null Value)
extension Optional : _Displayable, Displayable where Wrapped : _Displayable {
    typealias DISP = Wrapped.DISP
    typealias FORM = Wrapped.FORM
    
    func format(_ disp: DISP?, _ form: FORM?, _ null: String?) -> String {
        
        if let value = self {
            return value.format(disp, form, null)
        } else {
            return null ?? ""
        }
        
    }
}
