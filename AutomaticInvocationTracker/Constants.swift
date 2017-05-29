//
//  Constants.swift
//  AutomaticInvocationTracker
//
//  Created by Matteo Sassano on 30.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit

class Constants: NSObject {
    
    static let INVALID = "INVALID".data(using: .utf8)
    static let UNKNOWN : String = "unknown"
    static var HOST : String = ""
    static let submitResultUrl : String = "/rest/mobile/newinvocation"
    static var spanServicetUrl : String = ""
    
}
