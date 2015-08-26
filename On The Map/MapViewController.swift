//
//  MapViewController.swift
//  On The Map
//
//  Created by Luis Yoshida on 8/25/15.
//  Copyright (c) 2015 Msen. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
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
        
        self.mapView.delegate = self
        addPins(false)
//        if locationString != nil {
//            localSearchRequest = MKLocalSearchRequest()
//            localSearchRequest.naturalLanguageQuery = self.locationString
//            localSearch = MKLocalSearch(request: localSearchRequest)
//            localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
//                
//                if localSearchResponse == nil {
//                    var alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "try again?")
//                    alert.show()
//                    return
//                }
//                
//                self.pointAnnotation = MKPointAnnotation()
//                self.pointAnnotation.title = self.locationString
//                self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude:     localSearchResponse.boundingRegion.center.longitude)
//                
//                self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
//                self.mapView.centerCoordinate = self.pointAnnotation.coordinate
//                self.mapView.addAnnotation(self.pinAnnotationView.annotation)
//                
//                
//            }
//        }
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
        
        if (annotationView == nil) {
            return nil
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func addPins(forceReload: Bool) {
        
        OTMClient.sharedInstance().getStudents(forceReload) { result, error in
            if let error = error {
                var alert = UIAlertView(title: "Error", message: "Error retrieving student data.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            } else {
                for student in result as! [AnyObject] {
                    let pin = MKPointAnnotation()
                    let latitude = student["latitude"] as! Double
                    let longitude = student["longitude"] as! Double
                    pin.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                    pin.title = String(stringInterpolationSegment:student["firstName"]) + " " + String(stringInterpolationSegment: student["lastName"])
                    self.mapView.addAnnotation(pin)
                    
                }
            }
        }
    }
    
}