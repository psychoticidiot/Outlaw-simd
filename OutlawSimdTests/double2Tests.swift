//
//  double2Tests.swift
//  OutlawSimd
//
//  Created by Brian Mullen on 12/17/16.
//  Copyright © 2016 Molbie LLC. All rights reserved.
//

import XCTest
import simd
import Outlaw
@testable import OutlawSimd


class double2Tests: XCTestCase {
    func testExtractableValue() {
        typealias keys = double2.ExtractableKeys
        
        let rawData: [String: Double] = [keys.x: 1,
                                         keys.y: 2]
        let data: [String: [String: Double]] = ["value": rawData]
        let value: double2 = try! data.value(for: "value")
        
        XCTAssertEqual(value.x, rawData[keys.x])
        XCTAssertEqual(value.y, rawData[keys.y])
    }
    
    func testIndexExtractableValue() {
        let rawData: [Double] = [1, 2]
        let data: [[Double]] = [rawData]
        let value: double2 = try! data.value(for: 0)
        
        XCTAssertEqual(value.x, rawData[0])
        XCTAssertEqual(value.y, rawData[1])
    }
    
    func testInvalidValue() {
        let rawData: String = "Hello, Outlaw!"
        let data: [String] = [rawData]
        
        let ex = self.expectation(description: "Invalid data")
        do {
            let _: double2 = try data.value(for: 0)
        }
        catch {
            if case OutlawError.typeMismatchWithIndex = error {
                ex.fulfill()
            }
        }
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSerializable() {
        typealias keys = double2.ExtractableKeys
        
        let value = double2(x: 1, y: 2)
        let data: [String: Double] = value.serialized()
        
        XCTAssertEqual(data[keys.x], value.x)
        XCTAssertEqual(data[keys.y], value.y)
    }
    
    func testIndexSerializable() {
        let value = double2(x: 1, y: 2)
        let data: [Double] = value.serialized()
        
        XCTAssertEqual(data[0], value.x)
        XCTAssertEqual(data[1], value.y)
    }
}
