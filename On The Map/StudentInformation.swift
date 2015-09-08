//
//  StudentInformation.swift
//  On The Map
//
//  Created by Luis Yoshida on 8/26/15.
//  Copyright (c) 2015 Msen. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    var mediaURL: String
    var firstName: String
    var lastName: String
    var fullName: String
    var latitude: Double
    var longitude: Double
    var objectId: String
    
    init(studentJson: [String: AnyObject]) {
        
        self.firstName = studentJson["firstName"] as! String
        self.lastName = studentJson["lastName"] as! String
        self.fullName = "\(self.firstName) \(self.lastName)"
        self.mediaURL = studentJson["mediaURL"] as! String
        self.latitude = studentJson["latitude"] as! Double
        self.longitude = studentJson["longitude"] as! Double
        self.objectId = studentJson["objectId"] as! String
        
    }

    
}