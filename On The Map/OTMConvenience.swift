//
//  OTMConvenience.swift
//  On The Map
//
//  Created by Luis Yoshida on 8/24/15.
//  Copyright (c) 2015 Msen. All rights reserved.
//

import Foundation

extension OTMClient {
    
    
    // Performs login via Udacity's API and saves the sessionId and UserId
    func login(username: String, password: String, completionHandler: (success: Bool, statusCode: Int?, errorString: String?) -> Void) {
        let url: String = "\(OTMClient.Constants.baseUrl)\(OTMClient.Methods.authUrl)"
        let json: [String: [String: String]] = [
            "udacity": [
                "username": username,
                "password": password
            ]
        ]
        
        let task = taskForPOSTMethod(url, parameters: nil, headerParams: nil, jsonBody: json) { result, error in
            
            if let error = error {
                
                // Connection Error
                completionHandler(success: false, statusCode: nil, errorString: error.localizedDescription)
                
            } else {
                
                // Check for error such as invalid credentials
                if let status = result["status"] as? Int  {
                    if let errorMessage = result["error"] as? String {
                        
                        completionHandler(success: false, statusCode: status, errorString: errorMessage)
                        
                    }
                    
                } else {
                    
                    if let session = result.valueForKey("session") as? NSDictionary {
                        if let sessionId = session.valueForKey("id") as? String {
                            self.sessionId = sessionId
                        }
                    }
                    if let account = result.valueForKey("account") as? NSDictionary {
                        if let userId = account.valueForKey("key") as? String {
                            self.userId = userId
                        }
                    }
                    
                    completionHandler(success: true, statusCode: nil, errorString: nil)
                }
                
            }
            
        }
    }
    
    // Get user details
    func getUserDetails(completionHandler: (success: Bool, statusCode: String?, errorString: String?) -> Void) {
        
        if let id = self.userId {
            userId = id
            
            let url: String = "\(OTMClient.Constants.baseUrl)\(OTMClient.Methods.userDataUrl)\(userId)"
            
            let task = taskForGETMethod(url, parameters: nil, headerParams: nil) { result, error in
                if let error = error {
                    completionHandler(success: false, statusCode: nil, errorString: "Error retrieving user details.")
                    return
                } else {
                    println(result)
                    if let firstName = result.valueForKey("user")!.valueForKey("first_name") as? String {
                        self.userFirstName = firstName
                    }
                    if let lastName = result.valueForKey("user")!.valueForKey("last_name") as? String {
                        self.userLastName = lastName
                    }
                    completionHandler(success: true, statusCode: nil, errorString: nil)
                }
                
            }
        } else {
            
            completionHandler(success: false, statusCode: nil, errorString: "Could not retrieve user details.")
            
        }
        
        
    }
    
    // Log out function
    func deleteSession(completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> Void {
        
        let url = NSURL(string: "\(OTMClient.Constants.baseUrl)\(OTMClient.Methods.authUrl)")
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: nil, error: error)
            } else {
                OTMClient.parseJSONWithCompletionHandler(data, removeStart: true, completionHandler: completionHandler)
            }
            
        }
        task.resume()
        
    }
    
    
}