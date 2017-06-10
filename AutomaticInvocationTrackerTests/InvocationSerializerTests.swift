//
//  InvocationSerializerTests.swift
//  AutomaticInvocationTracker
//
//  Created by Matteo Sassano on 11.06.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import XCTest

@testable import AutomaticInvocationTracker
class InvocationSerializerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Agent.reinitAgent()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        Agent.reinitAgent()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
