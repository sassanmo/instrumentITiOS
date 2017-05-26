//
//  InvocationMapper.swift
//  AutomaticInvocationTracker
//
//  Created by Matteo Sassano on 15.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit

class InvocationMapper: NSObject {
    
    var invocationMap : [UInt64 : Invocation]?
    
    var invocationStackMap : [UInt : [Invocation]]?
    
    var childMap : [UInt : Invocation]?
    
    var remotecallMap : [UInt64 : RemoteCall]?
    
    var closedTraces : [[Invocation]]?
    
    override init() {
        invocationMap = [UInt64 : Invocation]()
        invocationStackMap = [UInt : [Invocation]]()
        childMap = [UInt : Invocation]()
        remotecallMap = [UInt64 : RemoteCall]()
        closedTraces = [[Invocation]]()
    }
    
    func addInvocation(invocation: Invocation) {
        if var parent = childMap?[invocation.threadId] {
            invocation.setInvocationRelation(parent: &parent)
        } else {
            invocation.setInvocationAsRoot()
        }
        childMap?[invocation.threadId] = invocation
        invocationMap?[invocation.id] = invocation
        if invocationStackMap?[invocation.threadId] == nil {
            invocationStackMap?[invocation.threadId] = [Invocation]()
        }
        invocationStackMap?[invocation.threadId]?.append(invocation)
    }
    
    func removeInvocation(id: UInt64) {
        if let invocation = invocationMap?[id] {
            if childMap?[invocation.threadId]?.id == invocation.id {
                invocation.closeInvocation()
                childMap?[invocation.threadId] = nil
                if invocation.id == invocation.parentId {
                    closeTrace(threadId: invocation.threadId)
                } else {
                    if let parent = invocationMap?[invocation.parentId!] {
                        childMap?[invocation.threadId] = parent
                    } else {
                        print("[ERROR] parent invocation with id \(invocation.parentId) not found")
                    }
                }
            } else {
                print("[ERROR] invocation is not last child")
            }
        } else {
            print("[ERROR] invocation with id \(id) not found")
        }
    }
    
    func closeTrace(threadId: UInt) {
        if let trace = invocationStackMap?[threadId] {
            closedTraces?.append(trace)
        }
    }
    
    func mapRemoteCall(remoteCall: RemoteCall) {
        if var parent = childMap?[remoteCall.threadId] {
            remoteCall.setInvocationRelation(parent: &parent)
        } else {
            remoteCall.setInvocationAsRoot()
        }
        invocationMap?[remoteCall.id] = remoteCall
        remotecallMap?[remoteCall.id] = remoteCall
    }

}
