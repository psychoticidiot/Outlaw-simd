//
//  matrix_double2x3+Outlaw.swift
//  OutlawSimd
//
//  Created by Brian Mullen on 12/11/16.
//  Copyright © 2016 Molbie LLC. All rights reserved.
//

import simd
import Outlaw


public extension matrix_double2x3 {
    public struct ExtractableKeys {
        public static let column0 = "0"
        public static let column1 = "1"
    }
    public struct ExtractableIndexes {
        public static let column0: Int = 0
        public static let column1: Int = 1
    }
    fileprivate typealias keys = matrix_double2x3.ExtractableKeys
    fileprivate typealias indexes = matrix_double2x3.ExtractableIndexes
}

extension matrix_double2x3: Value {
    public static func value(from object: Any) throws -> matrix_double2x3 {
        if let data = object as? Extractable {
            let col0: vector_double3 = try data.value(for: keys.column0)
            let col1: vector_double3 = try data.value(for: keys.column1)
            
            return matrix_double2x3(columns: (col0, col1))
        }
        else if let data = object as? IndexExtractable {
            let col0: vector_double3 = try data.value(for: indexes.column0)
            let col1: vector_double3 = try data.value(for: indexes.column1)
            
            return matrix_double2x3(columns: (col0, col1))
        }
        else {
            let expectedType = "Extractable or IndexExtractable"
            throw OutlawError.typeMismatch(expected: expectedType, actual: type(of: object))
        }
    }
}

extension matrix_double2x3: Serializable {
    public func serialized() -> [String: [String: Double]] {
        var result = [String: [String: Double]]()
        result[keys.column0] = self.columns.0.serialized()
        result[keys.column1] = self.columns.1.serialized()
        
        return result
    }
}

extension matrix_double2x3: IndexSerializable {
    public func serializedIndexes() -> [[Double]] {
        var result = [[Double]](repeating: [0], count: 2)
        result[indexes.column0] = self.columns.0.serializedIndexes()
        result[indexes.column1] = self.columns.1.serializedIndexes()
        
        return result
    }
}
