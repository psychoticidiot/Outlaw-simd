//
//  matrix_float2x4Tests.swift
//  OutlawSimd
//
//  Created by Brian Mullen on 12/17/16.
//  Copyright © 2016 Molbie LLC. All rights reserved.
//

import XCTest
import simd
import Outlaw
@testable import OutlawSimd


class matrix_float2x4Tests: XCTestCase {
    fileprivate typealias keys = matrix_float2x4.ExtractableKeys
    fileprivate typealias subkeys = vector_float4.ExtractableKeys
    fileprivate typealias indexes = matrix_float2x4.ExtractableIndexes
    fileprivate typealias subindexes = vector_float4.ExtractableIndexes
    
    func testExtractableValue() {
        let rawData: [String: [String: Float]] = [keys.column0: [subkeys.x: 0,
                                                                 subkeys.y: 10,
                                                                 subkeys.z: 20,
                                                                 subkeys.w: 30],
                                                  keys.column1: [subkeys.x: 1,
                                                                 subkeys.y: 11,
                                                                 subkeys.z: 21,
                                                                 subkeys.w: 31]]
        let data: [String: [String: [String: Float]]] = ["value": rawData]
        let value: matrix_float2x4 = try! data.value(for: "value")
        
        XCTAssertEqual(value.columns.0.x, rawData[keys.column0]?[subkeys.x])
        XCTAssertEqual(value.columns.0.y, rawData[keys.column0]?[subkeys.y])
        XCTAssertEqual(value.columns.0.z, rawData[keys.column0]?[subkeys.z])
        XCTAssertEqual(value.columns.0.w, rawData[keys.column0]?[subkeys.w])
        
        XCTAssertEqual(value.columns.1.x, rawData[keys.column1]?[subkeys.x])
        XCTAssertEqual(value.columns.1.y, rawData[keys.column1]?[subkeys.y])
        XCTAssertEqual(value.columns.1.z, rawData[keys.column1]?[subkeys.z])
        XCTAssertEqual(value.columns.1.w, rawData[keys.column1]?[subkeys.w])
    }
    
    func testIndexExtractableValue() {
        var rawData0 = [Float](repeating: 0, count: 4)
        rawData0[subindexes.x] = 0
        rawData0[subindexes.y] = 10
        rawData0[subindexes.z] = 20
        rawData0[subindexes.w] = 30
        var rawData1 = [Float](repeating: 0, count: 4)
        rawData1[subindexes.x] = 1
        rawData1[subindexes.y] = 11
        rawData1[subindexes.z] = 21
        rawData1[subindexes.w] = 31
        
        var rawData = [[Float]](repeating: [0], count: 2)
        rawData[indexes.column0] = rawData0
        rawData[indexes.column1] = rawData1
        
        let data: [[[Float]]] = [rawData]
        let value: matrix_float2x4 = try! data.value(for: 0)
        
        XCTAssertEqual(value.columns.0.x, rawData[indexes.column0][subindexes.x])
        XCTAssertEqual(value.columns.0.y, rawData[indexes.column0][subindexes.y])
        XCTAssertEqual(value.columns.0.z, rawData[indexes.column0][subindexes.z])
        XCTAssertEqual(value.columns.0.w, rawData[indexes.column0][subindexes.w])
        
        XCTAssertEqual(value.columns.1.x, rawData[indexes.column1][subindexes.x])
        XCTAssertEqual(value.columns.1.y, rawData[indexes.column1][subindexes.y])
        XCTAssertEqual(value.columns.1.z, rawData[indexes.column1][subindexes.z])
        XCTAssertEqual(value.columns.1.w, rawData[indexes.column1][subindexes.w])
    }
    
    func testInvalidValue() {
        let rawData: String = "Hello, Outlaw!"
        let data: [String] = [rawData]
        
        let ex = self.expectation(description: "Invalid data")
        do {
            let _: matrix_float2x4 = try data.value(for: 0)
        }
        catch {
            if case OutlawError.typeMismatchWithIndex = error {
                ex.fulfill()
            }
        }
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSerializable() {
        let value = matrix_float2x4(columns: (vector_float4(0, 10, 20, 30),
                                              vector_float4(1, 11, 21, 31)))
        let data = value.serialized()
        
        XCTAssertEqual(data[keys.column0]?[subkeys.x], value.columns.0.x)
        XCTAssertEqual(data[keys.column0]?[subkeys.y], value.columns.0.y)
        XCTAssertEqual(data[keys.column0]?[subkeys.z], value.columns.0.z)
        XCTAssertEqual(data[keys.column0]?[subkeys.w], value.columns.0.w)
        
        XCTAssertEqual(data[keys.column1]?[subkeys.x], value.columns.1.x)
        XCTAssertEqual(data[keys.column1]?[subkeys.y], value.columns.1.y)
        XCTAssertEqual(data[keys.column1]?[subkeys.z], value.columns.1.z)
        XCTAssertEqual(data[keys.column1]?[subkeys.w], value.columns.1.w)
    }
    
    func testIndexSerializable() {
        let value = matrix_float2x4(columns: (vector_float4(0, 10, 20, 30),
                                              vector_float4(1, 11, 21, 31)))
        let data = value.serializedIndexes()
        
        XCTAssertEqual(data[indexes.column0][subindexes.x], value.columns.0.x)
        XCTAssertEqual(data[indexes.column0][subindexes.y], value.columns.0.y)
        XCTAssertEqual(data[indexes.column0][subindexes.z], value.columns.0.z)
        XCTAssertEqual(data[indexes.column0][subindexes.w], value.columns.0.w)
        
        XCTAssertEqual(data[indexes.column1][subindexes.x], value.columns.1.x)
        XCTAssertEqual(data[indexes.column1][subindexes.y], value.columns.1.y)
        XCTAssertEqual(data[indexes.column1][subindexes.z], value.columns.1.z)
        XCTAssertEqual(data[indexes.column1][subindexes.w], value.columns.1.w)
    }
}
