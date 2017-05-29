//
//  Invocation.swift
//  AutomaticInvocationTracker
//
//  Created by Matteo Sassano on 15.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//


import Foundation

class Invocation: NSObject {
    
    var id : UInt64
    
    var parentId : UInt64?
    
    var traceId : UInt64?
    
    var childrenIds : [UInt64]?
    
    /// Defines the name of the callable function
    var name : String
    
    /// Describes the object/class holding the method
    var holder : String
    
    /// Describes the framework where the method is located in
    /// By default the framework is the project name.
    /// UIViewController functions e.g. are storing UIKit here
    //  var framework : String
    
    var threadName : String
    
    var threadId : UInt
    
    var duration : UInt64?
    
    var startTime : UInt64? 
    
    var endTime : UInt64?
    
    var ended : Bool = false
    
    convenience init(name: String) {
        self.init(name: name, holder: "")
    }
    
    init(name: String, holder: String) {
        self.id = calculateUuid()
        self.name = name
        self.holder = holder
        
        let threadDescription = Thread.current.description
        var s = threadDescription.components(separatedBy: "number = ")
        var s1 = s[1].components(separatedBy: ", name = ")
        self.threadId = UInt(s1[0])!
        var s2 = s1[1].components(separatedBy: "}")
        self.threadName = s2[0]
        
        self.startTime = getTimestamp()
    }
    
    func closeInvocation() {
        self.ended = true
        self.endTime = getTimestamp()
        if let endtime = self.endTime, let starttime = self.startTime {
            self.duration = endtime - starttime
        }
    }
    
    /// returns: updated parent
    func setInvocationRelation(parent: inout Invocation) {
        parent.childrenIds?.append(self.id)
        self.parentId = parent.id
        self.traceId = parent.traceId
    }
    
    func setInvocationAsRoot() {
        self.traceId = self.id
        self.parentId = self.id
    }
    
    func getThreadProperties() -> (UInt, String) {
        let threadDescription = Thread.current.description
        var s = threadDescription.components(separatedBy: "number = ")
        var s1 = s[1].components(separatedBy: ", name = ")
        let threadId = UInt(s1[0])
        var s2 = s1[1].components(separatedBy: "}")
        let threadName = s2[0]
        return (threadId!, threadName)
    }
    
    func getInvocationMap() -> [String : Any] {
        var serializedInvocation: [String : Any] = [String : Any]()
        var tags: [String : Any] = [String : Any]()
        var spanContext: [String : Any] = [String : Any]()
        serializedInvocation["operationName"] = self.name
        serializedInvocation["startTimeMicros"] = self.startTime
        serializedInvocation["duration"] = self.duration
        tags["span.kind"] = "client"
        tags["ext.propagation.type"] = "IOS"
        serializedInvocation["tags"] = tags
        spanContext["id"] = self.id
        spanContext["traceId"] = self.traceId
        spanContext["parentId"] = self.parentId
        serializedInvocation["spanContext"] = spanContext
        return serializedInvocation
    }
    
    override var description: String {
        return "\(holder).\(name)"
    }
    
}

