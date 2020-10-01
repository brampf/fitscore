//
//  File.swift
//  
//
//  Created by May on 10.06.20.
//
import FITS
import Foundation

public struct Sample {
    
    enum Channel : Int {
        case red = 0
        case green = 1
        case blue = 2
    }
    
    func rgb<D: FITSByte>(_ bitpix : D.Type, blocksize: Int = 100) -> FitsFile {
        
        let red : [D] = imageData(.red, size: blocksize)
        let green : [D] = imageData(.green, size: blocksize)
        let blue : [D] = imageData(.blue, size: blocksize)
        
        let prime = PrimaryHDU(width: 3*blocksize, height: 3*blocksize, vectors: red, green, blue)
        prime.header(HDUKeyword.COMMENT, comment: "FITSKit \(D.bitpix) SAMPLE")
        
        return FitsFile(prime: prime)
    }
    
    func imageData<F: FITSByte>(_ channel: Channel, size: Int = 100) -> [F] {
        
        let min = F.min.bigEndian
        let max = F.max.bigEndian
        //let size = 100
        
        var array : [F] = .init()
        let one : [F] = .init(repeating: max, count: size)
        let zero : [F] = .init(repeating: min, count: 2*size)
        
        var partial : [F] = .init()
        partial.append(contentsOf: one)
        partial.append(contentsOf: zero)
        let filled : [F] = .init(repeating: max, count: 3*size)
        
        for _ in 0..<size{
            if channel == .red {
                array.append(contentsOf: filled)
            } else {
                array.append(contentsOf: partial)
            }
        }
        for _ in 0..<size{
            if channel == .blue {
                array.append(contentsOf: filled)
            } else {
                array.append(contentsOf: partial)
            }
        }
        for _ in 0..<size{
            if channel == .green {
                array.append(contentsOf: filled)
            } else {
                array.append(contentsOf: partial)
            }
        }
        return array
    }
    
}
