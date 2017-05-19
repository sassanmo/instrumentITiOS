//
//  MetricsController.swift
//  AutomaticInvocationTracker
//
//  Created by Matteo Sassano on 15.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit

class MetricsController: NSObject {
    
    var networkReachability : NetworkReachability!
    var nativeRessources : native_diagnostic_info_t
    var networktypeList : [String]
    var cpuList : [Float]
    var memoryList : [Float]
    var diskList : [Double]
    var powerList : [Float]
    var timestampList : [UInt64]
    var timer : Timer
    let bufferSize : Int = 1000
    var fireTimeIntervall : Float = 1
    
    override init() {
        nativeRessources = native_diagnostic_info_t()
        timer = Timer()
        networkReachability = NetworkReachability()
        networktypeList = [String]()
        cpuList = [Float]()
        memoryList = [Float]()
        diskList = [Double]()
        powerList = [Float]()
        timestampList = [UInt64]()
        super.init()
        self.reinitializeTimer()
    }
    
    func changeTimerIntervall(seconds: Float) {
        self.fireTimeIntervall = seconds
    }
    
    func getCpuUsage() -> Float {
        if getCPULoad(&nativeRessources.cpuusage) == 0 {
            return nativeRessources.cpuusage
        } else {
            return -1.0;
        }
    }
    
    func getResidentalMemorySize() -> UInt64 {
        getMemoryUsage(&nativeRessources.memory.memory_info)
        return nativeRessources.memory.memory_info.rss
    }
    
    func getVirtualMemorySize() -> UInt64 {
        getMemoryUsage(&nativeRessources.memory.memory_info)
        return nativeRessources.memory.memory_info.vs
    }
    
    func getMemoryLoad() -> Float {
        return 1.0 - (Float(getFreeMemory()) / Float(ProcessInfo.processInfo.physicalMemory))
    }
    
    func getMemorySize() -> UInt64 {
        return UInt64(getResidentMemory())
    }
    
    func getFreeMem() -> Int64 {
        return getFreeMemory()
    }
    
    func getDataInSpecificIntervall() {
        self.collectMetrics()
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.fireTimeIntervall), target: self, selector: #selector(self.collectMetrics), userInfo: nil, repeats: true);
    }
    
    func reinitializeTimer() {
        DispatchQueue.main.async(execute: {
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.fireTimeIntervall), target: self, selector: #selector(self.collectMetrics), userInfo: nil, repeats: true);
            
        })
    }
    
    func invalidateTimer() {
        self.timer.invalidate()
    }
    
    @objc func collectMetrics() {
        let cpupercentage = getCpuUsage()
        let memory = getMemoryLoad()
        let disk = DiskMetric.getUsedDiskPercentage()
        let power = BatteryLevel.getBatteryLevel()
        let timestamp = getTimestamp()
        
        if (cpuList.count >= bufferSize) {
            self.cpuList.remove(at: 0)
            self.memoryList.remove(at: 0)
            self.diskList.remove(at: 0)
            self.powerList.remove(at: 0)
            self.timestampList.remove(at: 0)
        }
        
        self.cpuList.append(cpupercentage)
        self.memoryList.append(memory)
        self.diskList.append(disk)
        self.powerList.append(power)
        self.timestampList.append(timestamp)
        
//        if NetworkReachability.getConnectionInformation().0 == "WLAN" {
//            Agent.getInstance().spansDispatch()
//        }
    }

}
