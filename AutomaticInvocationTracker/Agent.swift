//
//  Agent.swift
//  AutomaticInvocationTracker
//
//  Created by Matteo Sassano on 15.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit

class Agent: NSObject {

    /// Strores the Agent properties
    var agentProperties: [String: Any]?
    
    var agent: Agent?
    
    var invocationMapper: InvocationMapper?
    
    init(properties: [(String, Any)]? = nil) {
        super.init()
        if let properties = properties {
            agentProperties = [String: Any]()
            for (property, value) in properties {
                if Agent.allowedProperty(property: property) {
                    agentProperties?["property"] = value
                }
            }
        }
        invocationMapper = InvocationMapper()
        agent = self
    }
    
    func setAgentConfiguration(properties: [(String, Any)]? = nil) {
        if let properties = properties {
            for (property, value) in properties {
                if Agent.allowedProperty(property: property) {
                    agentProperties?["property"] = value
                }
            }
        }
    }
    
    func trackInvocation(function: String = #function, file: String = #file) -> UInt64 {
        let invocation = Invocation(name: function, holder: file)
        invocationMapper?.pushInvocation(invocation: invocation)
        return invocation.id
    }
    
    func closeInvocation(id: UInt64? = nil) {
        if let invocation = invocationMapper?.popInvocation(id: id) {
            //return invocation.id
        }
        //return nil
    }
    
    /// TODO:
    static func allowedProperty(property: String) -> Bool {
        return true
    }
}
