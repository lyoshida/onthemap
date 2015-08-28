//
//  Student.swift
//  On The Map
//
//  Created by Luis Yoshida on 8/26/15.
//  Copyright (c) 2015 Msen. All rights reserved.
//

import Foundation

struct Student {
    
    var student: [String: AnyObject]
    
    init(studentJson: AnyObject) {
        self.student = studentJson as! [String: AnyObject]
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
    
    func getMediaUrl() -> String? {
        
        var mediaUrl: String? = nil
        if let url = self.student["mediaURL"] as? String{
            mediaUrl = url
        }
        
        return mediaUrl
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
    
}