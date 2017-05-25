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
    
    var remotecallMap : [UInt64 : RemoteCall]?
    
    var closedInvocations : [Invocation]?
    
    override init() {
        invocationStack = [Invocation]()
        remotecallMap = [UInt64 : RemoteCall]()
        closedInvocations = [Invocation]()
    }
    
    func pushInvocation(invocation: Invocation) {
        if invocationStack?.count == 0 {
            invocation.setRootProperies()
        } else {
            let parentInvocation = invocationStack?.popLast()
            if let updatedParent = invocation.setInvocationRelation(parent: parentInvocation) {
                invocationStack?.append(updatedParent)
            }
        }
        invocationStack?.append(invocation)
    }
    
    func popInvocation(id: UInt64? = nil) -> Invocation? {
        if let invocationID = id {
            for (index, invocation) in invocationStack!.enumerated() {
                if invocation.id == invocationID {
                    if let closedInvocation = invocationStack?.remove(at: index) {
                        closedInvocation.closeInvocation()
                        closedInvocations?.append(closedInvocation)
                        return closedInvocation
                    }
                }
            }
        } else {
            if let closedInvocation = invocationStack?.popLast() {
                closedInvocation.closeInvocation()
                closedInvocations?.append(closedInvocation)
                return closedInvocation
            }
        }
        return nil
    }
    
    func mapRemoteCall(remoteCall: RemoteCall) {
        if invocationStack?.count == 0 {
            remoteCall.setRootProperies()
        } else {
            let parentInvocation = invocationStack?.popLast()
            if let updatedParent = remoteCall.setInvocationRelation(parent: parentInvocation) {
                invocationStack?.append(updatedParent)
            }
        }
        remotecallMap?[remoteCall.id] = remoteCall
    }

}
