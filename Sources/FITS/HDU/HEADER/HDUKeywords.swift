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
 Each 80-character header keyword record shall consist of a key- word name, a value indicator (only required if a value is present), an optional value, and an optional comment. Keywords may ap- pear in any order except where specifically stated otherwise in this Standard. It is recommended that the order of the keywords in FITS files be preserved during data processing operations because the designers of the FITS file may have used conven- tions that attach particular significance to the order of certain keywords (e.g., by grouping sequences of COMMENT keywords at specific locations in the header, or appending HISTORY key- words in chronological order of the data processing steps or us- ing CONTINUE keywords to generate long-string keyword val- ues).
 */
public struct HDUKeyword : ExpressibleByStringLiteral, ExpressibleByStringInterpolation, CustomStringConvertible, LosslessStringConvertible, RawRepresentable, Hashable {
    
    public typealias StringLiteralType = String
    
    public struct StringInterpolation: StringInterpolationProtocol {
        // start with an empty string
        var output = ""
        
        public init(literalCapacity: Int, interpolationCount: Int) {
            output.reserveCapacity(literalCapacity+interpolationCount)
        }
        
        public mutating func appendLiteral(_ literal: String) {
            output.append(literal)
        }
        
        public mutating func appendInterpolation(_ dimension: Int){
            output.append(String(dimension))
        }
    }
    
    public typealias RawValue = String
    
    private var name : String
    
    public var rawValue: String {
        return name
    }
    public var description: String {
        return name
    }
    
    public init(){
        self.name = ""
    }
    
    public init?(_ description: String) {
        self.name = description
    }
    
    public init(rawValue name: String) {
        self.name = name
    }

    public init(stringLiteral value: String) {
        self.name = value
    }
    
    public init(stringInterpolation: StringInterpolation) {
        self.name = stringInterpolation.output
    }
    
    public static func ==(rhs: Self, lhs: String) -> Bool {
        return rhs.rawValue.elementsEqual(lhs)
    }
    
    public static func ==(rhs: String, lhs: Self) -> Bool {
        return rhs.elementsEqual(lhs.rawValue)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
    
    public var isEmpty : Bool {
        return self.name.isEmpty
    }
}



/**
 Reserved Keywords
 
 Descriptions according to FITS Standard Document:  https://fits.gsfc.nasa.gov/fits_standard.html
 */
public extension HDUKeyword {
    
    /**
     The value field shall contain a logical constant with the value T if the file conforms to this Standard.
     
     This keyword is mandatory for the primary header and must not appear in extension headers. A value of F signifies that the file does not conform to this Standard.
     */
    static let SIMPLE : HDUKeyword = "SIMPLE"
    
    /**
     The value field shall contain an integer.
     
     The absolute value is used in computing the sizes of data structures. It shall specify the number of bits that represent a data value in the associated data array. The only valid values of BITPIX are given in Table 8 (see `BITPIX`). Writers of FITS arrays should select a BITPIX data type appropriate to the form, range of values, and accuracy of the data in the array.
     
     - SeeAlso: `BITPIX`
     */
    static let BITPIX : HDUKeyword = "BITPIX"
    
    /**
     The value field shall contain a non-negative integer no greater than 999 representing the number of axes in the associated data array. A value of zero signifies that no data follow the header in the HDU.
     */
    static let NAXIS : HDUKeyword = "NAXIS"
    
    /**
     This keyword has no associated value.
     
     Bytes 9 through 80 shall be filled with ASCII spaces (decimal 32 or hex- adecimal 20). The END keyword marks the logical end of the header and must occur in the last 2880-byte FITS block of the header.
     */
    static let END : HDUKeyword = "END"
    
    /**
     The value field shall contain an integer that shall be used in any way appropriate to define the data structure
     
      In IMAGE (Sect. 7.1) and TABLE (Sect. 7.2) extensions this keyword must have the value 0; in BINTABLE extensions (Sect. 7.3) it is used to specify the number of bytes that follow the main data table in the supplemental data area called the heap. This keyword is also used in the random-groups structure (Sect. 6) to specify the number of parameters preceding each array in a group.
     */
    static let PCOUNT : HDUKeyword = "PCOUNT"
    
    /**
     The value field shall contain an integer that shall be used in any way appropriate to define the data struc- ture,
     
     This keyword must have the value 1 in the IMAGE, TABLE, and BINTABLE standard extensions defined in Sect. 7. This keyword is also used in the random-groups struc- ture (Sect. 6) to specify the number of random groups present.
     The total number of bits in the extension data array (exclu- sive of fill that is needed after the data to complete the last 2880- byte data block) is given by the following expression:

     N_bits = |BITPIX| × GCOUNT ×
            (PCOUNT + NAXIS1 × NAXIS2 × · · · × NAXISm),
     
     where Nbits must be non-negative and is the number of bits ex- cluding fill; m is the value of NAXIS; and BITPIX, GCOUNT, PCOUNT, and the NAXISn represent the values associated with those keywords. If Nbits > 0, then the data array shall be con- tained in an integral number of 2880-byte FITS data blocks. The header of the next FITS extension in the file, if any, shall start with the first FITS block following the data block that contains the last bit of the current extension data array.
     
     */
    static let GCOUNT : HDUKeyword = "GCOUNT"
    
    
    //MARK:- Keywords that describe arrays
    
    /**
     The value field shall contain a floating-point number representing the coefficient of the linear term in the scaling equation, the ratio of physical value to array value at zero offset.
     
     This keyword shall be used, along with the BZERO keyword, to linearly scale the array pixel values (i.e., the actual values stored in the FITS file) to transform them into the physical values that they represent using
     
     physical value = BZERO + BSCALE × array value
     
     The default value for this keyword is 1.0. Before support for IEEE floating- point data types was added to FITS (Wells & Grosbøl 1990), this technique of linearly scaling integer values was the only way to represent the full range of floating-point values in a FITS array. This linear scaling technique is still commonly used to reduce the size of the data array by a factor of two by representing 32- bit floating-point physical values as 16-bit scaled integers.
     */
    static let BSCALE : HDUKeyword = "BSCALE"
    
    /**
     The value field shall contain a floating-point number representing the physical value corresponding to an array value of zero. The default value for this keyword is 0.0.
     
     This keyword shall be used, along with the `BSCALE` keyword, to linearly scale the array pixel values (i.e., the actual values stored in the FITS file) to transform them into the physical values that they represent using Eq. 3.
     
     Besides its use in representing floating-point values as scaled integers (see the description of the `BSCALE` keyword), the `BZERO` keyword is also used when storing unsigned-integer values in the FITS array. In this special case the `BSCALE` keyword shall have the default value of 1.0, and the `BZERO` keyword shall have one of the integer values shown in Table 11.
     Since the FITS format does not support a native unsigned integer data type (except for the unsigned eight-bit byte data type), the unsigned values are stored in the FITS array as na-
     tive signed integers with the appropriate integer offset specified by the `BZERO` keyword value shown in the table. For the byte
     data type, the converse technique can be used to store signed byte values as native unsigned values with the negative `BZERO` offset. In each case, the physical value is computed by adding the offset specified by the `BZERO` keyword to the native data type
     
     */
    static let BZERO : HDUKeyword = "BZERO"
    
    /**
     The value field shal lcontain a characterstring describing the physical units in which the quantities in the array, after application of BSCALE and BZERO, are expressed. These units must follow the prescriptions of Units
     */
    static let BUNIT : HDUKeyword = "BUNIT"
    
    /**
     This keyword shall be used only in headers with positive values of BITPIX (i.e., in arrays with integer data). Bytes 1 through 8 contain the string 􏰀BLANK␣␣␣' (ASCII spaces in Bytes 6 through 8). The value field shall contain an integer that specifies the value that is used within the integer array to represent pixels that have an undefined physical value.
     If the BSCALE and BZERO keywords do not have the default values of 1.0 and 0.0, respectively, then the value of the BLANK keyword must equal the actual value in the FITS data array that is used to represent an undefined pixel and not the corre- sponding physical value (computed from Eq. 3). To cite a spe- cific, common example, unsigned 16-bit integers are represented in a signed integer FITS array (with BITPIX = 16) by setting BZERO = 32768 and BSCALE = 1. If it is desired to use pixels that have an unsigned value (i.e., the physical value) equal to 0 to represent undefined pixels in the array, then the BLANK key- word must be set to the value -32768 because that is the actual value of the undefined pixels in the FITS array.
     */
    static let BLANK : HDUKeyword = "BLANK"
    
    /**
     The value field shall always contain a floating-point number, regardless of the value of BITPIX. This number shall give the maximum valid physical value represented by the array (from Eq. 3), exclusive of any IEEE special values.
     */
    static let DATAMAX : HDUKeyword = "DATAMAX"
    
    /**
     The value field shall always contain a floating-point number, regardless of the value of BITPIX. This number shall give the minimum valid physical value represented by the array (from Eq. 3), exclusive of any IEEE special values.
     */
    static let DATAMIN : HDUKeyword = "DATAMIN"
    
    static let DATE : HDUKeyword = "DATE"
    static let DATE_OBX : HDUKeyword = "DATE-OBX"
    static let EQUINOX : HDUKeyword = "EQUINOX"
    static let ORIGIN : HDUKeyword = "ORIGIN"
    
    //MARK:- Keywords describing observations
    
    /// The value field shall contain a character string identifying the telescope used to acquire the data associ- ated with the header.
    static let TELESCOP : HDUKeyword = "TELESCOP"
    /// The value field shall contain a character string identifying the instrument used to acquire the data associ- ated with the header.
    static let INSTRUME : HDUKeyword = "INSTRUME"
    /// The value field shall contain a charac- ter string identifying who acquired the data associated with the header.
    static let OBSERVER : HDUKeyword = "OBSERVER"
    /// The value field shall contain a character string giving a name for the object observed.
    static let OBJECT : HDUKeyword = "OBJECT"
    /// The value field shall contain a character string identifying who compiled the information in the data as- sociated with the header. This keyword is appropriate when the data originate in a published paper or are compiled from many sources.
    
    //MARK:- Bibliographic keywords
    
    static let AUTHOR : HDUKeyword = "AUTHOR"
    /// The value field shall contain a char- acter string citing a reference where the data associ- ated with the header are published. It is recommended that either the 19-digit bibliographic identifier8 used in the Astrophysics Data System bibliographic databases (http://adswww.harvard.edu/) or the Digital Object Identifier (http://doi.org) be included in the value string, when available (e.g., ’1994A&AS..103..135A’ or ’doi:10.1006/jmbi.1998.2354’).
    static let REFERENC : HDUKeyword = "REFERENC"
    
    //MARK:- Commentary keywords
    
    /// This keyword may be used to supply any comments regarding the FITS file.
    static let COMMENT : HDUKeyword = "COMMENT"
    /// This keyword should be used to describe the history of steps and procedures associated with the process- ing of the associated data.
    static let HISTORY : HDUKeyword = "HISTORY"
    
    //MARK:- Random Groups keywords
    
    /// The value field shall contain the logical con- stant T. The value T associated with this keyword implies that random-groups records are present.
    static let GROUPS : HDUKeyword = "GROUPS"
    
    //MARK:- Extension keywords
  
    /**
     The value field shall contain a logical value indicating whether the FITS file is allowed to contain conforming extensions following the primary HDU. This keyword may only appear in the primary header and must not appear in an ex- tension header. If the value field is T then there may be conform- ing extensions in the FITS file following the primary HDU. This keyword is only advisory, so its presence with a value T does not require that the FITS file contains extensions, nor does the absence of this keyword necessarily imply that the file does not contain extensions. Earlier versions of this Standard stated that the EXTEND keyword must be present in the primary header if the file contained extensions, but this is no longer required
     */
    static let EXTEND : HDUKeyword = "EXTEND"
    
    /**
     The value field shall contain a character string giving the name of the extension type.
     
     This keyword is mandatory for an extension header and must not appear in the primary header.7 To preclude conflict, extension type names must be registered with the IAUFWG. The current list of reg- istered extensions is given in Appendix F. An up-to-date list is also maintained on the FITS Support Office website.
     */
    static let XTENSION : HDUKeyword = "XTENSION"
    
    /**
     The value field shall contain a character string to be used to distinguish among different extensions of the same type, i.e., with the same value of XTENSION, in a FITS file. Within this context, the primary array should be considered as equivalent to an IMAGE extension.
     */
    static let EXTNAME : HDUKeyword = "EXTNAME"
    
    /**
     Thevaluefieldshallcontainanintegertobe used to distinguish among different extensions in a FITS file with the same type and name, i.e., the same values for XTENSION and EXTNAME. The values need not start with 1 for the first extension with a particular value of EXTNAME and need not be in sequence for subsequent values. If the EXTVER keyword is absent, the file should be treated as if the value were 1.
     */
    static let EXTVER : HDUKeyword = "EXTVER"
    
    /**
     The value field shall contain an integer specifying the level in a hierarchy of extension levels of the ex- tension header containing it. The value shall be 1 for the highest level; levels with a higher value of this keyword shall be subor- dinate to levels with a lower value. If the EXTLEVEL keyword is absent, the file should be treated as if the value were 1.
     */
    static let EXTLEVEL : HDUKeyword = "EXTLEVEL"
    
    /**
     The value field shall contain a logical value of T or F to indicate whether or not the current extension should inherit the keywords in the primary header of the FITS file.
     */
    static let INHERIT : HDUKeyword = "INHERIT"
   
    //MARK:- Bintable extension
    
    static let THEAP : HDUKeyword = "THEAP"
    
    //MARK:- ASCII Table extension
    
    /**
     The value field shall contain a non-negative integer representing the number of fields in each row. The max- imum permissible value is 999.
     */
    static let TFIELDS : HDUKeyword = "TFIELDS"
    
    //MARK:- Data-integrity keywords
    
    /**
     The value field of the DATASUM keyword shall consist of a character string that should contain the unsigned-integer value of the 32-bit ones’ complement check- sum of the data records in the HDU
     */
    static let DATASUM : HDUKeyword = "DATASUM"
    
    /**
     The value field of the CHECKSUM keyword shall consist of an ASCII character string whose value forces the 32-bit ones’ complement checksum accumulated over the entire FITS HDU to equal negative 0. (Note that ones’s complement arithmetic has both positive and negative zero elements). It is recommended that the particular 16-character string generated by the algorithm described in Appendix J be used. A string con- taining only one or more consecutive ASCII blanks may be used to represent an undefined or unknown value for the CHECKSUM keyword.
     */
    static let CHECKSUM : HDUKeyword = "CHECKSUM"
    
    //MARK:- Obsolete Keywords
    
    /**
     This keyword is deprecated and should not be used in new FITS files. It is reserved primarily to prevent its use with other meanings. As previously defined, this keyword, if used, was required to appear only within the first 36 keywords in the primary header. Its presence with the required logical value of T advised that the physical block size of the FITS file on which it appears may be an integral multiple of the FITS block length and not necessarily equal to it.
     */
    static let BLOCKED : HDUKeyword = "BLOCKED"
}
