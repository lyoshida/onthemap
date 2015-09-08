//
//  StudentInformation.swift
//  On The Map
//
//  Created by Luis Yoshida on 8/26/15.
//  Copyright (c) 2015 Msen. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    var student: [String: AnyObject]
    
    init(studentJson: [String: AnyObject]) {
        
        self.student = studentJson
        
    }
    
    func getFullName() -> String{
        
        var firstName: String = ""
        var lastName: String = ""
        
        if let fName = self.student["firstName"] as? String {
            firstName = fName
        }
        
        if let lName = self.student["lastName"] as? String {
            lastName = lName
        }
        
        return "\(firstName) \(lastName)"
    }
    
    func getMediaURL() -> String? {
        
        var mediaURL: String? = nil
        if let url = self.student["mediaURL"] as? String{
            mediaURL = url
        }
        
        return mediaURL
    }
    
    func getLatitude() -> Double {
        
        var latitude: Double = 0.0
        if let lat = self.student["latitude"] as? Double {
            latitude = lat
        }
        return latitude
        
    }
    
    func getLongitude() -> Double {
        
        var longitude: Double = 0.0
        if let long = self.student["longitude"] as? Double {
            longitude = long
        }
        return longitude
    }
    
    func getObjectId() -> String? {
        var objectId: String? = nil
        if let objId = self.student["objectId"] as? String {
            objectId = objId
        }
        return objectId
    }
    
    func getUpdatedAt() -> NSDate? {
        var date: NSDate?
        if let dateString = self.student["updatedAt"] as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSxxx"
            date = dateFormatter.dateFromString(dateString)
        }
        return date
        
    }
    
}