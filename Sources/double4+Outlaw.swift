//
//  double4+Outlaw.swift
//  OutlawSimd
//
//  Created by Brian Mullen on 12/11/16.
//  Copyright © 2016 Molbie LLC. All rights reserved.
//

import simd
import Outlaw


public extension double4 {
    public struct ExtractableKeys {
        public static let x = "x"
        public static let y = "y"
        public static let z = "z"
        public static let w = "w"
    }
    public struct ExtractableIndexes {
        public static let x: Int = 0
        public static let y: Int = 1
        public static let z: Int = 2
        public static let w: Int = 3
    }
    fileprivate typealias keys = double4.ExtractableKeys
    fileprivate typealias indexes = double4.ExtractableIndexes
}

extension double4: Value {
    public static func value(from object: Any) throws -> double4 {
        if let data = object as? Extractable {
            let x: Double = try data.value(for: keys.x)
            let y: Double = try data.value(for: keys.y)
            let z: Double = try data.value(for: keys.z)
            let w: Double = try data.value(for: keys.w)
            
            return double4(x: x, y: y, z: z, w: w)
        }
        else if let data = object as? IndexExtractable {
            let x: Double = try data.value(for: indexes.x)
            let y: Double = try data.value(for: indexes.y)
            let z: Double = try data.value(for: indexes.z)
            let w: Double = try data.value(for: indexes.w)
            
            return double4(x: x, y: y, z: z, w: w)
        }
        else {
            let expectedType = "Extractable or IndexExtractable"
            throw OutlawError.typeMismatch(expected: expectedType, actual: type(of: object))
        }
    }
}

extension double4: Serializable {
    public func serialized() -> [String: Double] {
        var result = [String: Double]()
        result[keys.x] = self.x
        result[keys.y] = self.y
        result[keys.z] = self.z
        result[keys.w] = self.w
        
        return result
    }
}

extension double4: IndexSerializable {
    public func serializedIndexes() -> [Double] {
        var result = [Double](repeating: 0, count: 4)
        result[indexes.x] = self.x
        result[indexes.y] = self.y
        result[indexes.z] = self.z
        result[indexes.w] = self.w
        
        return result
    }
}
