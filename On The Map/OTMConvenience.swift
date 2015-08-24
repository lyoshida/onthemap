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
        let method: String = OTMClient.Methods.authUrl
        let json: [String: [String: String]] = [
            "udacity": [
                "username": username,
                "password": password
            ]
        ]
        
        let task = taskForPOSTMethod(method, parameters: nil, jsonBody: json) { result, error in
            
            
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
}