//
//  RestManager.swift
//  AutomaticInvocationTracker
//
//  Created by Matteo Sassano on 30.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit

class RestManager: NSObject {
    
    func httpPostRequest(path: String, body : String, completion: @escaping (Bool)->()) -> Void {
        print("Starting post request")
        let request = NSMutableURLRequest(url: URL(string: path)!)
        
        // Set the method to POST
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set the POST body for the request
        let validatedJSON = validateJSON(json:body);
        if (validatedJSON != Constants.INVALID) {
            
            request.httpBody = validatedJSON;
            print("Request was successfully setup")
            performRequest(request: request, completion: completion);
        } else {
            print("JSON data is invalid, post Request aborted!");
            completion(true);
        }
    }
    
    private func performRequest (request : NSMutableURLRequest, completion: @escaping (Bool)->()) -> Void {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = request.timeoutInterval
        config.timeoutIntervalForResource = request.timeoutInterval
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
            do {
                if(error == nil) {
                    if let httpResponse = response as? HTTPURLResponse {
                        if (httpResponse.statusCode/200 == 1) {
                            if let receivedData = data {
                                let json = try JSONSerialization.jsonObject(with: receivedData, options:[])
                                let data1 = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted);
                                print(String(data: data1, encoding: String.Encoding.utf8)!)
                                completion(false)
                            } else {
                                print("unexpected Response from server")
                                completion(false);
                            }
                        } else {
                            print(String(format: "%@%i", "The Server responded with Code: ", httpResponse.statusCode));
                            completion(true);
                        }
                    }
                } else {
                    throw error!
                }
            } catch {
                let nserror = error as NSError
                if nserror.code == NSURLErrorTimedOut {
                    print("Request timed out")
                    completion(true)
                } else {
                    print(error.localizedDescription)
                    completion(true);
                }
            }
        })
        task.resume()
    }
    
    private func validateJSON(json: String) -> Data {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!)
            if (JSONSerialization.isValidJSONObject(jsonData)) {
                return try JSONSerialization.data(withJSONObject: jsonData);
            }
        } catch {
            print("The following inputstring caused an exception:");
            print(json);
        }
        print("invalid json");
        return Constants.INVALID!;
    }

}
