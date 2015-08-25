//
//  OTMConvenience.swift
//  On The Map
//
//  Created by Luis Yoshida on 8/24/15.
//  Copyright (c) 2015 Msen. All rights reserved.
//

import Foundation

extension OTMClient {
    
    func login(username: String, password: String, completionHandler: (success: Bool, statusCode: String?, errorString: String?) -> Void) {
        let url: String = "\(OTMClient.Constants.baseUrl)\(OTMClient.Methods.authUrl)"
        let json: [String: [String: String]] = [
            "udacity": [
                "username": username,
                "password": password
            ]
        ]
        
        let task = taskForPOSTMethod(url, parameters: nil, headerParams: nil, jsonBody: json) { result, error in
            
            if let error = result.valueForKey("error") as? String {
                completionHandler(success: false, statusCode: result.valueForKey("status") as? String, errorString: error)
            } else {
                if let session = result.valueForKey("session") as? NSDictionary {
                    if let sessionId = session.valueForKey("id") as? String {
                        self.sessionId = sessionId
                        completionHandler(success: true, statusCode: nil, errorString: nil)
                    }
                }
            }
        }
    }
    
    
    func getStudents(completionHandler: (result: AnyObject?, errorString: NSError?) -> Void) {
        
        let url: String = "\(OTMClient.Constants.parseApiUrl)"
        let headerParams: [String: String] = [
            "X-Parse-Application-Id": OTMClient.Constants.parseApplicationId,
            "X-Parse-REST-API-Key": OTMClient.Constants.parseApiKey
        ]
        
        let task = taskForGETMethod(url, parameters:nil, headerParams: headerParams) { result, error in
            
            if let error = error {
                completionHandler(result: result, errorString: error)
            } else {
                completionHandler(result: result, errorString: nil)
            }
            
        }
        
        
    }
    
}