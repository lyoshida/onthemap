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
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self

        addPins(true)
        
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
                
                self.showErrorAlert("Error", message: "Error retrieving student data", cancelButtonTitle: "Dismiss")
                
            } else {
                
                for studentJson in result as! [AnyObject] {
                    
                    let student = Student(studentJson: studentJson)
                    
                    let pin = MKPointAnnotation()
                    pin.coordinate = CLLocationCoordinate2DMake(student.getLatitude(), student.getLongitude())
                    pin.title = student.getFullName()
                    pin.subtitle = student.getMediaUrl()
                    dispatch_async(dispatch_get_main_queue(), {
                        self.mapView.addAnnotation(pin)
                    })
                    
                }
                
            }
            
        }
        
    }
    
    // Checks if there is a previous location before presenting the MapViewLocationController
    @IBAction func MapViewLocation(sender: UIBarButtonItem) {
        
        OTMClient.sharedInstance().getLoggedUserObjectId({ result, error in
            if let error = error {
                
                self.showErrorAlert("Error", message: "Error retriving user's ObjectID", cancelButtonTitle: "Dismiss")
                
            } else {
                
                if let objId = result {
                    
                    var alert = UIAlertController(title: "Warning", message: "A previous location exists. Do you want to overwrite it?", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) in
                        
                        // Do nothing
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                        
                        let mapViewLocationcontroller = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewLocationController") as! UIViewController
                        self.presentViewController(mapViewLocationcontroller, animated: true, completion: nil)
                        
                    }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
                
            }
        })
    }
    
    @IBAction func refreshData(sender: UIBarButtonItem) {
        self.addPins(true)
    }
    
    func showErrorAlert(title: String?, message: String, cancelButtonTitle: String) -> Void {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) in
            
            // Do nothing
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
}