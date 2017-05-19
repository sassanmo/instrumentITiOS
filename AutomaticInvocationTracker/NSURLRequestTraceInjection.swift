//
//  NSURLSessionTraceInjection.swift
//  AutomaticInvocationTracker
//
//  Created by Matteo Sassano on 19.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import Foundation

private let swizzlingNSURLRequest: (NSURLRequest.Type) -> () = { request in
    
    let originalSelector = #selector(request.init(url:cachePolicy:timeoutInterval:))
    let swizzledSelector = #selector(request.injectedInit(url:cachePolicy:timeoutInterval:))
    
    let originalMethod = class_getInstanceMethod(request, originalSelector)
    let swizzledMethod = class_getInstanceMethod(request, swizzledSelector)
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    
    print("swizzled")
}

extension NSURLRequest {
    
    open override class func initialize() {
        // make sure this isn't a subclass
        guard self === NSURLRequest.self else { return }
        swizzlingNSURLRequest(self)
    }
    
    func injectedInit(url: URL?,
                      cachePolicy: NSURLRequest.CachePolicy,
                      timeoutInterval: TimeInterval) -> NSMutableURLRequest {
        let agent = Agent.getInstance()
        let _ = agent.trackInvocation()
        var request: NSMutableURLRequest = injectedInit(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        agent.closeInvocation()
        return request
    }

}


