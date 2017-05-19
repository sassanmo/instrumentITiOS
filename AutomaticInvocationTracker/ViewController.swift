//
//  ViewController.swift
//  AutomaticInvocationTracker
//
//  Created by Matteo Sassano on 15.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var agent: Agent = Agent()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doSomething() {
        // The agent starts tracking the doSomething function
        let invocationId = agent.trackInvocation()
        
        for i in 0...UInt16.max {
            print(i)
        }
        
        // The agent stops tracking the doSomething function
        agent.closeInvocation(id: invocationId)
    }


}

