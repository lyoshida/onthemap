//
//  MapViewController.swift
//  On The Map
//
//  Created by Luis Yoshida on 8/25/15.
//  Copyright (c) 2015 Msen. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotation: MKAnnotation!
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch: MKLocalSearch!
    var localSearchResponse: MKLocalSearchResponse!
    var error: NSError!
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    var locationString: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if locationString != nil {
            localSearchRequest = MKLocalSearchRequest()
            localSearchRequest.naturalLanguageQuery = self.locationString
            localSearch = MKLocalSearch(request: localSearchRequest)
            localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
                
                if localSearchResponse == nil {
                    var alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "try again?")
                    alert.show()
                    return
                }
                
                self.pointAnnotation = MKPointAnnotation()
                self.pointAnnotation.title = self.locationString
                self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude:     localSearchResponse.boundingRegion.center.longitude)
                
                self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
                self.mapView.centerCoordinate = self.pointAnnotation.coordinate
                self.mapView.addAnnotation(self.pinAnnotationView.annotation)
                
                
            }
        }
    }
    
}