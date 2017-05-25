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
    
    static var agent: Agent?
    
    var invocationMapper: InvocationMapper?
    
    var locationHandler: LocationHandler?
    
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
        locationHandler = LocationHandler()
        invocationMapper = InvocationMapper()
        Agent.agent = self
        locationHandler?.requestLocationAuthorization()
    }
    
    static func getInstance() -> Agent {
        if Agent.agent == nil {
            return Agent()
        } else {
            return Agent.agent!
        }
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
    
    func trackInvocation(function: String = #function, file: String = #file) {
        let invocation = Invocation(name: function, holder: file)
        invocationMapper?.pushInvocation(invocation: invocation)
    }
    
    func closeInvocation(id: UInt64? = nil) {
        if let invocation = invocationMapper?.popInvocation(id: id) {
            //return invocation.id
        }
        //return nil
    }
    
    func trackRemoteCall(url: String) -> UInt64 {
        let remotecall = RemoteCall(url: url)
        invocationMapper?.mapRemoteCall(remoteCall: remotecall)
        return remotecall.id
    }
    
    func closeRemoteCall(id: UInt64, response: URLResponse?, error: Error?) {
        if var remotecall = invocationMapper?.remotecallMap?[id] {
            invocationMapper?.remotecallMap?[id] = nil
            setRemoteCallEndProperties(remotecall: &remotecall)
            remotecall.closeRemoteCall(response: response, error: error)
        }
    }
    
    private func setRemoteCallStartProperties(remotecall: inout RemoteCall) {
        remotecall.startPosition = locationHandler?.getUsersPosition()
        remotecall.startSSID = SSIDSniffer.getSSID()
        remotecall.startConnectivity = NetworkReachability.getConnectionInformation().0
        remotecall.startProvider = NetworkReachability.getConnectionInformation().1
    }
    
    private func setRemoteCallEndProperties(remotecall: inout RemoteCall) {
        remotecall.endPosition = locationHandler?.getUsersPosition()
        remotecall.endSSID = SSIDSniffer.getSSID()
        remotecall.endConnectivity = NetworkReachability.getConnectionInformation().0
        remotecall.endProvider = NetworkReachability.getConnectionInformation().1
    }
    
    /// TODO:
    static func allowedProperty(property: String) -> Bool {
        return true
    }
    
    func injectHeaderAttributes(request: inout NSMutableURLRequest) {
        if let lastInvocation = invocationMapper?.invocationStack?.last {
            let id = lastInvocation.id
            let traceId = lastInvocation.traceId
            request.addValue(decimalToHex(decimal: id), forHTTPHeaderField: "x-inspectit-spanid")
            request.addValue(decimalToHex(decimal: traceId!), forHTTPHeaderField: "x-inspectit-traceid")
        }
    }
    
}
