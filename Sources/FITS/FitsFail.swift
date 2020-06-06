//
//  File.swift
//  
//
//  Created by May on 01.06.20.
//

import Foundation

public enum FitsFail : LocalizedError {
    
    case missingPermssions
    case parserError
    case validationError
    case malformattedFile
    case malformattedHDU
    case malformattedHeader
    
}
