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

        let pictureUrl = URL(string: "https://upload.wikimedia.org/wikipedia/commons/9/98/The_earth_at_night_(2).jpg")!
        var request = NSMutableURLRequest(url: pictureUrl)
        request.httpMethod = "GET"
        let session = URLSession.shared;
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            do{
                if let httpResponse = response as? HTTPURLResponse {
                    if (httpResponse.statusCode == 200) {
                        if let receivedData = data {
                            //completionHandler(data, response, error)
                        }
                    } else {
                        //completionHandler(data, response, error)
                    }
                }
            } catch {
                print(error)
                //completionHandler(data, response, error)
            }
        })
        task.resume()
        
    }
    
    func getImage(request: NSMutableURLRequest, completion: @escaping (Data, Int)->()) -> Void {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

