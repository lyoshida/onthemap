//
//  OTMParseConvenience.swift
//  On The Map
//
//  Created by Luis Yoshida on 8/25/15.
//  Copyright (c) 2015 Msen. All rights reserved.
//

import Foundation

extension OTMClient {
    
    func getStudents(completionHandler: (result: AnyObject?, errorString: NSError?) -> Void) {
        
        let url: String = "\(OTMClient.Constants.parseApiUrl)"
        let headerParams: [String: String] = [
            "X-Parse-Application-Id": OTMClient.Constants.parseApplicationId,
            "X-Parse-REST-API-Key": OTMClient.Constants.parseApiKey
        ]
        
        let task = taskForParseGETMethod(url, parameters:nil) { result, error in
            
            if let error = error {
                completionHandler(result: result, errorString: error)
            } else {
                completionHandler(result: result, errorString: nil)
            }
            
        }
        
    }
    
    func taskForParseGETMethod(url: String, parameters: [String: AnyObject]?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var urlString : String
        // Build the URL
        if let params = parameters {
            urlString = "\(url)\(OTMClient.escapedParameters(params))"
        } else {
            urlString = "\(url)"
        }
        
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        
        request.addValue(OTMClient.Constants.parseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(OTMClient.Constants.parseApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) {
            data, response, downloadError in
            
            if let error = downloadError {
                completionHandler(result: nil, error: downloadError)
            } else {
                OTMClient.parseJSONWithCompletionHandler(data, removeStart: false, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    func taskForParsePOSTMethod(url: String, parameters: [String: AnyObject]?, jsonBody: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var urlString : String
        // Build the URL
        if let params = parameters {
            urlString = "\(url)\(OTMClient.escapedParameters(params))"
        } else {
            urlString = "\(url)"
        }
        
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        var jsonifyError: NSError? = nil
        
        request.addValue(OTMClient.Constants.parseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(OTMClient.Constants.parseApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        // Request setup
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        
        // Make the request
        let task = session.dataTaskWithRequest(request) {
            data, response, downloadError in
            
            if let error = downloadError {
                completionHandler(result: nil, error: downloadError)
            } else {
                OTMClient.parseJSONWithCompletionHandler(data, removeStart: false, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
        
    }

    
}