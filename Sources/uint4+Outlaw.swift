//
//  uint4+Outlaw.swift
//  OutlawSimd
//
//  Created by Brian Mullen on 12/13/16.
//  Copyright © 2016 Molbie LLC. All rights reserved.
//

import simd
import Outlaw


public extension uint4 {
    public struct ExtractableKeys {
        public static let x = "x"
        public static let y = "y"
        public static let z = "z"
        public static let w = "w"
    }
}

extension uint4: Value {
    public static func value(from object: Any) throws -> uint4 {
        if let data = object as? Extractable {
            typealias keys = uint4.ExtractableKeys
            
            let x: UInt32 = try data.value(for: keys.x)
            let y: UInt32 = try data.value(for: keys.y)
            let z: UInt32 = try data.value(for: keys.z)
            let w: UInt32 = try data.value(for: keys.w)
            
            return uint4(x: x, y: y, z: z, w: w)
        }
        else if let data = object as? IndexExtractable {
            let x: UInt32 = try data.value(for: 0)
            let y: UInt32 = try data.value(for: 1)
            let z: UInt32 = try data.value(for: 2)
            let w: UInt32 = try data.value(for: 3)
            
            return uint4(x: x, y: y, z: z, w: w)
        }
        else {
            let expectedType = "Extractable or IndexExtractable"
            throw OutlawError.typeMismatch(expected: expectedType, actual: type(of: object))
        }
    }
}

extension uint4: Serializable {
    public func serialized() -> [String: UInt32] {
        typealias keys = uint4.ExtractableKeys
        
        var result = [String: UInt32]()
        result[keys.x] = self.x
        result[keys.y] = self.y
        result[keys.z] = self.z
        result[keys.w] = self.w
        
        return result
    }
}

extension uint4: IndexSerializable {
    public func serialized() -> [UInt32] {
        return [self.x, self.y, self.z, self.w]
    }
}
