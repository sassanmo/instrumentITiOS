//
//  AutomaticInvocationTrackerTests.swift
//  AutomaticInvocationTrackerTests
//
//  Created by Matteo Sassano on 15.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import XCTest
@testable import AutomaticInvocationTracker

class InvocationMappingTests: XCTestCase {
    
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
    
    func testInvocationIds() {
        let invocationId = Agent.getInstance().trackInvocation()
        let invocationObject = Agent.getInstance().invocationMapper.invocationMap?[invocationId]
        assert(invocationObject?.id == invocationId)
        assert(invocationObject?.parentId == invocationId)
        assert(invocationObject?.traceId == invocationId)
    }
    
    func testFirstChildEquality() {
        let invocationId = Agent.getInstance().trackInvocation()
        let invocationObject = Agent.getInstance().invocationMapper.invocationMap?[invocationId]
        let childObject = Agent.getInstance().invocationMapper.childMap?[(invocationObject?.threadId)!]
        assert(invocationObject == childObject)
    }
    
    func testNextChildEquality() {
        _ = Agent.getInstance().trackInvocation()
        let secondInvocationId = Agent.getInstance().trackInvocation()
        let invocationObject = Agent.getInstance().invocationMapper.invocationMap?[secondInvocationId]
        let childObject = Agent.getInstance().invocationMapper.childMap?[(invocationObject?.threadId)!]
        assert(invocationObject == childObject)
    }
    
    func testStackElementEquality() {
        let invocationId = Agent.getInstance().trackInvocation()
        let invocationObject = Agent.getInstance().invocationMapper.invocationMap?[invocationId]
        let stackObject = Agent.getInstance().invocationMapper.invocationStackMap?[(invocationObject?.threadId)!]?.first
        assert(invocationObject == stackObject)
    }
    
    func testClosingInvoctaion() {
        let invocationId = Agent.getInstance().trackInvocation()
        let invocationObject = Agent.getInstance().invocationMapper.invocationMap?[invocationId]
        Agent.getInstance().closeInvocation(id: invocationId)
        let childObject = Agent.getInstance().invocationMapper.childMap?[(invocationObject?.threadId)!]
        let closedTraces = Agent.getInstance().invocationMapper.closedTraces
        assert(childObject == nil)
        assert(closedTraces?.count != 0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
