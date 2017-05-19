//
//  URLSessionInvocationInjection.swift
//  AutomaticInvocationTracker
//
//  Created by Matteo Sassano on 19.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import Foundation

private let swizzlingURLSession: (URLSession.Type) -> () = { session in
    
    let originalSelector = #selector((URLSession.dataTask(with:completionHandler:)) as (URLSession) -> (URLRequest, @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask)
    let swizzledSelector = #selector(session.injectedDataTask(request:completionHandler:))
    
    let originalMethod = class_getInstanceMethod(session, originalSelector)
    let swizzledMethod = class_getInstanceMethod(session, swizzledSelector)
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    
    print("swizzled")
}

extension URLSession {
    
    open override class func initialize() {
        // make sure this isn't a subclass
        guard self === URLSession.self else { return }
        swizzlingURLSession(self)
    }
    
    func injectedDataTask(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let agent = Agent.getInstance()
        let invocationId = agent.trackInvocation()
        print("start request")
        var mutableRequest: NSMutableURLRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        agent.injectHeaderAttributes(request: &mutableRequest)
        let dataTask = injectedDataTask(request: mutableRequest as URLRequest, completionHandler: {data, response, error -> Void in
            completionHandler(data, response, error)
            agent.closeInvocation(id: invocationId)
            print("close request")
        })
        return dataTask
    }
    
}



