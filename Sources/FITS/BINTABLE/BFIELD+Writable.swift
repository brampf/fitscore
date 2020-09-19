//
//  File.swift
//  
//
//  Created by May on 22.08.20.
//

import Foundation

protocol WritableBField {
    
    func write(to: inout Data)
}

extension ValueBField where ValueType == EightBitValue {
    
    func write(to: inout Data) {
        if let arr = val {
            let raw = arr.map{$0.rawValue}
            var dat = raw.withUnsafeBytes{ $0.bindMemory(to: UInt8.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<UInt8>.size * arr.count))
        }
    }
}


extension ValueBField where ValueType == CharacterValue {
    
    func write(to: inout Data) {
        if let arr = val {
            let chr = arr.map{$0.rawValue}
            var dat = chr.withUnsafeBytes{ $0.bindMemory(to: UInt8.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<UInt8>.size * arr.count))
        }
    }
}

extension ValueBField where ValueType == SingleComplexValue {
    
    func write(to: inout Data) {
        if let arr = val {
            let raw = arr.map{$0.rawValue}
            var dat = raw.withUnsafeBytes{ $0.bindMemory(to: Float.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<Float>.size * arr.count))
        }
    }
}

extension ValueBField where ValueType == DoubleComplexValue {
    
    func write(to: inout Data) {
        if let arr = val {
            let raw = arr.map{$0.rawValue}
            var dat = raw.withUnsafeBytes{ $0.bindMemory(to: Double.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<Double>.size * arr.count))
        }
    }
}

extension ValueBField where ValueType : UInt8Value {
    
    func write(to: inout Data) {
        if let arr = val {
            let raw = arr.map{$0.rawValue}
            var dat = raw.withUnsafeBytes{ $0.bindMemory(to: UInt8.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<UInt8>.size * arr.count))
        }
    }
}

extension ValueBField where ValueType : Int16Value {
    
    func write(to: inout Data) {
        if let arr = val {
            let raw = arr.map{$0.rawValue}
            var dat = raw.withUnsafeBytes{ $0.bindMemory(to: Int16.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<Int16>.size * arr.count))
        }
    }
}

extension ValueBField where ValueType : Int32Value {
    
    func write(to: inout Data) {
        if let arr = val {
            let raw = arr.map{$0.rawValue}
            var dat = raw.withUnsafeBytes{ $0.bindMemory(to: Int32.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<Int32>.size * arr.count))
        }
    }
}

extension ValueBField where ValueType : Int64Value {
    
    func write(to: inout Data) {
        if let arr = val {
            let raw = arr.map{$0.rawValue}
            var dat = raw.withUnsafeBytes{ $0.bindMemory(to: Int64.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<Int64>.size * arr.count))
        }
    }
}

extension ValueBField where ValueType == FloatValue {
    
    func write(to: inout Data) {
        if let arr = val {
            let raw = arr.map{$0.rawValue}
            var dat = raw.withUnsafeBytes{ $0.bindMemory(to: Float.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<Float>.size * arr.count))
        }
    }
}


extension ValueBField where ValueType == DoubleValue {
    
    func write(to: inout Data) {
        if let arr = val {
            let raw = arr.map{$0.rawValue}
            var dat = raw.withUnsafeBytes{ $0.bindMemory(to: Double.self).map{$0.bigEndian} }
            to.append(Data(bytes: &dat, count: MemoryLayout<Double>.size * arr.count))
        }
    }
}


//Mark:- VarArgs
protocol WritableVarBField {
    
    func write(to dataUnit: inout Data, heap: inout Data)
}

extension VarArray {
    
    public func write(to dataUnit: inout Data, heap: inout Data) {
        
        // array descriptor consists of (nelem, offset)
        let desc = [ArrayType(val?.count ?? 0).bigEndian, ArrayType(heap.count).bigEndian]
        //print("VarArray \((type(of: self))) -> \(ArrayType(heap.count))...\(ArrayType((val?.count ?? 0) * MemoryLayout<ValueType>.size + heap.count))")
        
        // write descriptor to data array
        desc.withUnsafeBytes{ ptr in
            dataUnit.append(ptr.bindMemory(to: BaseType.self))
        }
        
        // write array to heap
        self.write(to: &heap)
        
    }
    
}
