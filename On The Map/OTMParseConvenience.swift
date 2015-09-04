//
//  OTMParseConvenience.swift
//  On The Map
//
//  Created by Luis Yoshida on 8/25/15.
//  Copyright (c) 2015 Msen. All rights reserved.
//

import Foundation

extension OTMClient {
    
    
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
    
    func taskForParsePUTMethod(url: String, parameters: [String: AnyObject]?, jsonBody: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
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
        request.HTTPMethod = "PUT"
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
    
    // Retrives the list of students, saves it to the self.studentList variable and return the result to the completionHandler.
    func getStudents(forceReload: Bool, completionHandler: (result: AnyObject?, errorString: NSError?) -> Void) {
        
        // If a studentList already exists return it. If self.studentList is nil or forceReload is true, retrieve the list of students.
        if forceReload == false && self.studentList != nil {
            completionHandler(result: self.studentList, errorString: nil)
            return
        } else {
            
            let url: String = "\(OTMClient.Constants.parseApiUrl)"
            let headerParams: [String: String] = OTMClient.Constants.headerParams
            let task = taskForParseGETMethod(url, parameters:nil) { result, error in
                
                if let error = error {
                    completionHandler(result: result, errorString: error)
                } else {
                    if let result = result as? NSDictionary {
                        if let studentList = result["results"] as? [AnyObject] {
                            self.studentList = studentList as? [AnyObject]
                            completionHandler(result: self.studentList, errorString: nil)
                        }
                    }
                }
                
            }
            
        }
        
    }
    
    /**
        Checks if the user has posted a location and returns its ObjectId.
    
        :params completionHandler The callback function
        
        :returns void
    */
    func getLoggedUserObjectId(completionHandler: (result: String?, error: NSError?) -> Void) {
        
        let url: String = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(self.userId!)%22%7D"
        
        let task = taskForParseGETMethod(url, parameters: nil) { result, error in
            
            if let error = error {
                
                completionHandler(result: nil, error: error)
                
            } else {
                
                if let studentsList: [AnyObject] = result.valueForKey("results") as? [AnyObject] {
                    
                    if let userJson: AnyObject = studentsList[0] as AnyObject? {
                        
                        let userObj = Student(studentJson: userJson)
                        
                        self.objectId = userObj.getObjectId()
                        completionHandler(result: self.objectId, error: nil)
                    
                    } else {
                        
                        completionHandler(result: nil, error: nil)
                        
                    }
                    
                } else {
                    
                    completionHandler(result: nil, error: NSError())
                    
                }
                
            }
            
        }
        
    }

    func postUserLocation(location: String, link: String, latitude: Double, longitude: Double, completionHandler: (result: AnyObject?, errorString: NSError?) -> Void) {
        
        let url: String = "\(OTMClient.Constants.parseApiUrl)"
        let headerParams: [String: String] = OTMClient.Constants.headerParams
        
        let jsonBody: [String: AnyObject] = [
            "latitude": latitude,
            "longitude": longitude,
            "uniqueKey": self.userId!,
            "firstName": self.userFirstName!,
            "lastName": self.userLastName!,
            "mapString": location,
            "mediaURL": link
        ]
        
        let task = taskForParsePOSTMethod(url, parameters: nil, jsonBody: jsonBody) { result, error in
            if let error = error {
                completionHandler(result: nil, errorString: error)
            } else {
                completionHandler(result: result, errorString: error)
            }
            
        }
    }
    
    func putUserLocation(objectID: String, location: String, link: String, latitude: Double, longitude: Double, completionHandler: (result: AnyObject?, errorString: NSError?) -> Void) {
        
        let url: String = "\(OTMClient.Constants.parseApiUrl)/\(objectID)"
        let headerParams: [String: String] = OTMClient.Constants.headerParams

        let jsonBody: [String: AnyObject] = [
            "latitude": latitude,
            "longitude": longitude,
            "uniqueKey": self.userId!,
            "firstName": self.userFirstName!,
            "lastName": self.userLastName!,
            "mapString": location,
            "mediaUrl": link
        ]
        
        let task = taskForParsePUTMethod(url, parameters: nil, jsonBody: jsonBody) { result, error in
            
            if let error = error {
                completionHandler(result: nil, errorString: error)
            } else {
                completionHandler(result: result, errorString: error)
            }
            
        }
    }
    
}