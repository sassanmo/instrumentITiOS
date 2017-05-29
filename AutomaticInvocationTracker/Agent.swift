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
    var agentProperties: [String: Any]
    
    static var agent: Agent?
    
    var invocationMapper: InvocationMapper
    
    var locationHandler: LocationHandler?
    
    var networkReachability: NetworkReachability?
    
    var dataStorage: DataStorage
    
    var invocationSerializer: InvocationSerializer
    
    /// Collects device Infromation in a specific time interval
    var metricsConrtoller: MetricsController
    
    var restManager: RestManager
    
    init(properties: [(String, Any)]? = nil) {
        agentProperties = [String: Any]()
        invocationMapper = InvocationMapper()
        dataStorage = DataStorage()
        metricsConrtoller = MetricsController()
        invocationSerializer = InvocationSerializer(invocationMapper: invocationMapper, metricsConroller: metricsConrtoller)
        restManager = RestManager()
        super.init()
        
        if let properties = properties {
            for (property, value) in properties {
                if Agent.allowedProperty(property: property) {
                    agentProperties["property"] = value
                }
            }
        }
        loadAgentId()
        locationHandler = LocationHandler()
        networkReachability = NetworkReachability()
        
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
                    agentProperties["property"] = value
                }
            }
        }
    }
    
    func trackInvocation(function: String = #function, file: String = #file) -> UInt64 {
        let invocation = Invocation(name: function, holder: file)
        invocationMapper.addInvocation(invocation: invocation)
        return invocation.id
    }
    
    func closeInvocation(id: UInt64) {
        
    }
    
    func trackRemoteCall(function: String = #function, file: String = #file, url: String) -> UInt64 {
        let remotecall = RemoteCall(name: function, holder: file, url: url)
        invocationMapper.mapRemoteCall(remoteCall: remotecall)
        return remotecall.id
    }
    
    func closeRemoteCall(id: UInt64, response: URLResponse?, error: Error?) {
        if var remotecall = invocationMapper.remotecallMap?[id] {
            invocationMapper.remotecallMap?[id] = nil
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
    
    func setRemoteCallAsChild(id: UInt64) {
        if let remoteCall = invocationMapper.remotecallMap?[id] {
            invocationMapper.childMap?[remoteCall.threadId] = remoteCall
        }
    }
    
    /// TODO:
    static func allowedProperty(property: String) -> Bool {
        return true
    }
    
    func injectHeaderAttributes(id: UInt64, request: inout NSMutableURLRequest) {
        if let lastInvocation = invocationMapper.remotecallMap?[id] {
            let spanid = lastInvocation.id
            let traceId = lastInvocation.traceId
            request.addValue(decimalToHex(decimal: spanid), forHTTPHeaderField: "x-inspectit-spanid")
            request.addValue(decimalToHex(decimal: traceId!), forHTTPHeaderField: "x-inspectit-traceid")
        }
    }
    
    func spansDispatch() {
        if invocationSerializer.serializedInvocations.count != 0 {
            var invocationBuffer = invocationSerializer.serializedInvocations
            invocationSerializer.serializedInvocations = [String]()
            for (index, item) in invocationBuffer.enumerated() {
                restManager.httpPostRequest(path: Constants.HOST, body: item, completion: {error -> Void in
                    if error {
                        self.invocationSerializer.serializedInvocations.append(item)
                    } else {
                        invocationBuffer.remove(at: index)
                    }
                })
            }
        }
    }
    
    /// Loads the Agent ID whitch will be created once
    /// If not any stored than a new ID will be created
    func loadAgentId(){
        if let agentid = dataStorage.loadAgentId() {
            self.agentProperties["id"] = agentid
        } else {
            self.agentProperties["id"] = generateAgentId()
            self.dataStorage.storeAgentId(id: self.agentProperties["id"] as! UInt64)
        }
    }
    
    func generateAgentId() -> UInt64 {
        return calculateUuid()
    }
    
}
