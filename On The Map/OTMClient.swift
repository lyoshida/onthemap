//
//  OTMClient.swift
//  On The Map
//
//  Created by Luis Yoshida on 8/23/15.
//  Copyright (c) 2015 Msen. All rights reserved.
//

import Foundation

class OTMClient : NSObject {
    
    var session: NSURLSession
    
    var sessionId: String? = nil
    var userId: String? = nil
    var userFirstName: String? = nil
    var userLastName: String? = nil
    var objectId: String? = nil
    
    var studentList: [StudentInformation]? = nil
    
    override init() {
        
        session = NSURLSession.sharedSession()
        super.init()
        
    }
    
    func taskForGETMethod(url: String, parameters: [String: AnyObject]?, headerParams: [String: String]?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the URL
        var urlString : String
        if let params = parameters {
            urlString = "\(url)\(OTMClient.escapedParameters(params))"
        } else {
            urlString = "\(url)"
        }
        
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        
        // Set header parameters to the request object
        if let headerParams = headerParams {
            for (key, value) in headerParams {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            
            if let error = downloadError {
                
                completionHandler(result: nil, error: downloadError)
                
            } else {
                
                OTMClient.parseJSONWithCompletionHandler(data, removeStart: true, completionHandler: completionHandler)
                
            }
        }
        
        task.resume()
        
        return task
    }
    
    
    func taskForPOSTMethod(url: String, parameters: [String: AnyObject]?, headerParams: [String: String]?, jsonBody: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the URL
        var urlString : String
        if let params = parameters {
            urlString = "\(url)\(OTMClient.escapedParameters(params))"
        } else {
            urlString = "\(url)"
        }
        
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        var jsonifyError: NSError? = nil
        
        // Set header parameter to the request object
        if let headerParams = headerParams {
            for (key, value) in headerParams {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Request setup
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        
        // Make the request
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            
            if let error = downloadError {
                
                completionHandler(result: nil, error: downloadError)
                
            } else {
                
                OTMClient.parseJSONWithCompletionHandler(data, removeStart: true, completionHandler: completionHandler)
                
            }
        }
        
        task.resume()
        
        return task
        
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, removeStart: Bool, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        var newData = data
        if removeStart {
            newData = data.subdataWithRange(NSMakeRange(5, data.length-5))
        }
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    class func sharedInstance() -> OTMClient {
        
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        
        return Singleton.sharedInstance
    }

}