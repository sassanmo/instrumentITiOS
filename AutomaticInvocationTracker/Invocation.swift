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
    
    var threadName : String?
    
    var duration : UInt64?
    
    var startTime : UInt64? 
    
    var endTime : UInt64?
    
    var ended : Bool = false
    
    init(name: String, holder: String) {
        self.id = calculateUuid()
        self.name = name
        self.holder = holder
        self.threadName = Thread.current.description
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
    func setInvocationRelation(parent: Invocation? = nil) -> Invocation? {
        if let parentInvocation = parent {
            parentInvocation.childrenIds?.append(self.id)
            self.parentId = parentInvocation.id
            return parentInvocation
        } else {
            self.parentId = self.id
            return nil
        }
    }
    
    func setRootProperies() {
        self.traceId = self.id
        self.parentId = self.id
    }
    
    override var description: String {
        return "\(holder).\(name)"
    }
    
}

