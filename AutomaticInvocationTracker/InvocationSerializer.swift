//
//  InvocationSerializer.swift
//  AutomaticInvocationTracker
//
//  Created by Matteo Sassano on 15.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit

class InvocationSerializer: NSObject {
    
    var invocationMapper : InvocationMapper
    var metricsController : MetricsController
    var serializedInvocations : [String]
    
    init(invocationMapper: InvocationMapper, metricsConroller: MetricsController) {
        self.serializedInvocations = [String]()
        self.invocationMapper = invocationMapper
        self.metricsController = metricsConroller
    }
    
    func getDataPackage() {
        var jsonObject = [String : Any]()
        jsonObject["deviceID"] = Agent.getInstance().agentProperties["id"] as! UInt64
        jsonObject["spans"] = getInvocations()
        jsonObject["measurements"] = getMeasurements()
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString : String = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            print(jsonString)
            serializedInvocations.append(jsonString)
        } catch {
            print(error)
        }
    }
    
    func serializeInvocation(invocation : Invocation) -> [String : Any] {
        return invocation.getInvocationMap()
    }
    
    func getMeasurements() -> [[String : Any]] {
        var measurements = [[String : Any]]()
        for measurement in metricsController.measurementMapList {
            let measurementObject = measurement
            measurements.append(measurementObject)
        }
        metricsController.measurementMapList = [[String : Any]]()
        return measurements
    }
    
    func getInvocations() -> [[String : Any]] {
        var invocations = [[String : Any]]()
        if let closedtraces = invocationMapper.closedTraces {
            for trace in closedtraces {
                for invocation in trace {
                    let invocationObject = serializeInvocation(invocation: invocation)
                    invocations.append(invocationObject)
                }
            }
        }
        invocationMapper.closedTraces = [[Invocation]]()
        return invocations
    }
    
//    func getJsonObject(_ metricsController : IntervalMetricsController, deviceID : UInt64, rootId: UInt64) -> String? {
//        var timestampList = metricsController.timestampList
//        var cpuList = metricsController.cpuList
//        var powerList = metricsController.powerList
//        var memoryList = metricsController.memoryList
//        var diskList = metricsController.diskList
//        
//        var measurements = [NSMutableDictionary]()
//        
//        for (i, _) in timestampList.enumerated() {
//            let measurement = NSMutableDictionary()
//            measurement["type"] = "MobilePeriodicMeasurement"
//            measurement["timestamp"] = timestampList[i]
//            if i < cpuList.count {
//                measurement["cpuUsage"] = cpuList[i]
//            }
//            if i < powerList.count {
//                measurement["batteryPower"] = powerList[i]
//            }
//            if i < memoryList.count {
//                measurement["memoryUsage"] = memoryList[i]
//            }
//            if i < diskList.count {
//                measurement["storageUsage"] = diskList[i]
//            }
//            measurements.append(measurement)
//        }
//        
//        var jsonObject = [String : Any]()
//        jsonObject["deviceID"] = deviceID
//        jsonObject["spans"] = spans[rootId]
//        jsonObject["measurements"] = measurements
//        
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions.prettyPrinted)
//            let jsonString : String = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
//            print(jsonString)
//            spans[rootId] = []
//            return jsonString
//        } catch {
//            print(error)
//        }
//        return nil
//    }

}
