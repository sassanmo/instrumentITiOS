//
//  InvocationMapper.swift
//  AutomaticInvocationTracker
//
//  Created by Matteo Sassano on 15.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit

class InvocationMapper: NSObject {
    
    var invocationStack : [Invocation]?
    
    var invocationMap : [UInt64 : Invocation]?
    
    var closedInvocations : [Invocation]?
    
    override init() {
        invocationStack = [Invocation]()
        invocationMap = [UInt64 : Invocation]()
        closedInvocations = [Invocation]()
    }
    
    func pushInvocation(invocation: Invocation) {
        if invocationStack?.count == 0 {
            invocation.setRootProperies()
        } else {
            let parentInvocation = invocationStack?.popLast()
            if let updatedParent = invocation.setInvocationRelation(parent: parentInvocation) {
                invocationStack?.append(updatedParent)
                invocationMap?[updatedParent.id] = updatedParent
            }
        }
        invocationStack?.append(invocation)
        invocationMap?[invocation.id] = invocation
    }
    
    func popInvocation(id: UInt64? = nil) -> Invocation? {
        if let invocationID = id {
            for (index, invocation) in invocationStack!.enumerated() {
                if invocation.id == invocationID {
                    if let closedInvocation = invocationStack?.remove(at: index) {
                        closedInvocation.closeInvocation()
                        closedInvocations?.append(closedInvocation)
                        invocationMap?[closedInvocation.id] = nil
                        return closedInvocation
                    }
                }
            }
        } else {
            if let closedInvocation = invocationStack?.popLast() {
                closedInvocation.closeInvocation()
                closedInvocations?.append(closedInvocation)
                invocationMap?[closedInvocation.id] = nil
                return closedInvocation
            }
        }
        return nil
    }

}
