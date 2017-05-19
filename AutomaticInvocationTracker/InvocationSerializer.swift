//
//  InvocationSerializer.swift
//  AutomaticInvocationTracker
//
//  Created by Matteo Sassano on 15.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit

class InvocationSerializer: NSObject {
    
    var serializedInvocations : [UInt64 : [[String : Any]]]
    
    override init() {
        serializedInvocations = [UInt64 : [[String : Any]]]()
    }
    
    func serializeInvocation(invocation : Invocation) {

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
