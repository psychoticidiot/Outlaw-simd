//
//  float2x2Tests.swift
//  OutlawSimd
//
//  Created by Brian Mullen on 12/17/16.
//  Copyright © 2016 Molbie LLC. All rights reserved.
//

import XCTest
import simd
import Outlaw
@testable import OutlawSimd


class float2x2Tests: XCTestCase {
    func testExtractableValue() {
        let rawData: [String: [String: Float]] = ["c0": ["x": 0, "y": 10],
                                                  "c1": ["x": 1, "y": 11]]
        let data: [String: [String: [String: Float]]] = ["value": rawData]
        let value: float2x2 = try! data.value(for: "value")
        
        XCTAssertEqual(value[0].x, rawData["c0"]?["x"])
        XCTAssertEqual(value[0].y, rawData["c0"]?["y"])
        
        XCTAssertEqual(value[1].x, rawData["c1"]?["x"])
        XCTAssertEqual(value[1].y, rawData["c1"]?["y"])
    }
    
    func testIndexExtractableValue() {
        let rawData: [[Float]] = [[0, 10],
                                  [1, 11]]
        let data: [[[Float]]] = [rawData]
        let value: float2x2 = try! data.value(for: 0)
        
        XCTAssertEqual(value[0].x, rawData[0][0])
        XCTAssertEqual(value[0].y, rawData[0][1])
        
        XCTAssertEqual(value[1].x, rawData[1][0])
        XCTAssertEqual(value[1].y, rawData[1][1])
    }
    
    func testInvalidValue() {
        let rawData: String = "Hello, Outlaw!"
        let data: [String] = [rawData]
        
        let ex = self.expectation(description: "Invalid data")
        do {
            let _: float2x2 = try data.value(for: 0)
        }
        catch {
            if case OutlawError.typeMismatchWithIndex = error {
                ex.fulfill()
            }
        }
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSerializable() {
        let value = float2x2([float2(0, 10),
                              float2(1, 11)])
        let data: [String: [String: Float]] = value.serialized()
        
        XCTAssertEqual(data["c0"]?["x"], value[0].x)
        XCTAssertEqual(data["c0"]?["y"], value[0].y)
        
        XCTAssertEqual(data["c1"]?["x"], value[1].x)
        XCTAssertEqual(data["c1"]?["y"], value[1].y)
    }
    
    func testIndexSerializable() {
        let value = float2x2([float2(0, 10),
                              float2(1, 11)])
        let data: [[Float]] = value.serialized()
        
        XCTAssertEqual(data[0][0], value[0].x)
        XCTAssertEqual(data[0][1], value[0].y)
        
        XCTAssertEqual(data[1][0], value[1].x)
        XCTAssertEqual(data[1][1], value[1].y)
    }
}