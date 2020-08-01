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

struct SevereCondition : Condition {
    
    var description: String
    let severity: Severiy = .SEVERE
    
    var precondition: Criterion
    var check: Criterion
}

/// END header keyword is not present
let noend : Condition = SevereCondition(description: "END header keyword is not present", precondition:
{ hdu in
    return true
}) { hdu in
    return hdu.headerUnit.contains(where: {$0.keyword == HDUKeyword.END})
}

/// Sum of table column widths is inconsistent with NAXIS1 value
let badnaxis1 : Condition = SevereCondition(description: "Sum of table column widths is inconsistent with NAXIS1 value", precondition:
{ hdu in
    return hdu is TableHDU || hdu is BintableHDU
}) { hdu in
    
    if let table = hdu as? TableHDU {
        return table.columns.reduce(into: 0) { sum, column in
            sum += column.TFORM?.length ?? 0
        } == hdu.naxis(1)
    }
    if let table = hdu as? BintableHDU {
        return table.columns.reduce(into: 0) { sum, column in
            sum += column.TFORM?.length ?? 0
        } == hdu.naxis(1)
    }
    return false
}

/// BLANK keyword present in image with floating-point datatype
let badblank : Condition = SevereCondition(description: "BLANK keyword present in image with floating-point datatype" , precondition:
{ hdu in
    return hdu is AnyImageHDU && (hdu.bitpix == BITPIX.FLOAT32 || hdu.bitpix == BITPIX.FLOAT64)
}) { hdu in
    return !hdu.headerUnit.contains(where: {$0.keyword == HDUKeyword.BLANK})
}

/// TNULLn keyword present for floating-point binary table column
let badtnull : Condition = SevereCondition(description: "TNULLn keyword present for floating-point binary table column")
{ hdu in
    return hdu is BintableHDU && (hdu.bitpix == BITPIX.FLOAT32 || hdu.bitpix == BITPIX.FLOAT64)
} check: { hdu in
    return !hdu.headerUnit.contains(where: {$0.keyword.starts(with: "TNULL")})
}

