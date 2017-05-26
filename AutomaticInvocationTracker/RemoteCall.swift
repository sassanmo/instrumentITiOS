//
//  RemoteCall.swift
//  AutomaticInvocationTracker
//
//  Created by Matteo Sassano on 22.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import Foundation
import CoreLocation

class RemoteCall: Invocation {
    
    var timeout: Bool?
    
    var responseCode: Int?
    
    var startPosition: CLLocationCoordinate2D?
    
    var endPosition: CLLocationCoordinate2D?
    
    var startProvider: String?
    
    var endProvider: String?
    
    var startConnectivity: String?
    
    var endConnectivity: String?
    
    var startSSID: String?
    
    var endSSID: String?
    
    var httpMethod : String?
    
    var url : String?
    
    init(name: String, holder: String, url: String) {
        super.init(name: name, holder: holder)
        self.url = url
    }
    
    // TODO: Response and error
    func closeRemoteCall(response: URLResponse?, error: Error?) {
        self.ended = true
        self.endTime = getTimestamp()
        if let endtime = self.endTime, let starttime = self.startTime {
            self.duration = endtime - starttime
        }
    }

}
