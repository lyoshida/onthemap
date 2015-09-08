//
//  MapViewLocationController.swift
//  On The Map
//
//  Created by Luis Yoshida on 8/22/15.
//  Copyright (c) 2015 Msen. All rights reserved.
//
// http://sweettutos.com/2015/04/24/swift-mapkit-tutorial-series-how-to-search-a-place-address-or-poi-in-the-map/

import UIKit
import MapKit

class MapViewLocationController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var locationSelectView: UIView!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var latitude: Double? = nil
    var longitude: Double? = nil
    var localName: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the placeholder color to white
        if let locationTextField = locationTextField {
            locationTextField.attributedPlaceholder = NSAttributedString(string:"Enter your location here", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        }
        
        if let linkTextField = linkTextField {
            linkTextField.attributedPlaceholder = NSAttributedString(string:"Share your link here", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        }
        
        self.activityIndicator.hidden = true
        self.confirmView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func findLocation(sender: UIButton) {
        
        if locationTextField.text != "" {
            
            locationSelectView.hidden = true
            confirmView.hidden = false
            
            CLGeocoder().geocodeAddressString(locationTextField.text, completionHandler: { (placemarks, error) -> Void in
                
                if let placemark = placemarks?[0] as? CLPlacemark {
                    
                    self.latitude = placemark.location.coordinate.latitude
                    self.longitude = placemark.location.coordinate.longitude
                    self.localName = placemark.name as String
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.mapView.centerCoordinate = CLLocationCoordinate2D(latitude: placemark.location.coordinate.latitude, longitude: placemark.location.coordinate.longitude)
                    })
                    
                    var annotation = MKPointAnnotation()
                    annotation.title = self.localName
                    annotation.coordinate = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)

                    self.mapView.addAnnotation(annotation)
                    
                    
                }
            
            })

        }
    }
    
    @IBAction func submitLocation(sender: UIButton) {
        
        self.activityOn()
        
        if let objId =  OTMClient.sharedInstance().objectId {
            
            OTMClient.sharedInstance().putUserLocation(objId, location: self.localName!, link: self.linkTextField.text!, latitude: self.latitude!, longitude: self.longitude!) { result, error in
                
                self.activityOff()
                
                if let error = error {
                    
                    self.showErrorAlert("Error", message: "Could not update location", cancelButtonTitle: "Dismiss")
                    
                } else {
                    
                    let mapViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! UITabBarController
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(mapViewController, animated: true, completion: nil)
                    })
                    
                }
                
            }
            
        } else {
            
            OTMClient.sharedInstance().postUserLocation(self.localName!, link: self.linkTextField.text!, latitude: self.latitude!, longitude: self.longitude!) { result, error in
                
                self.activityOff()
                
                if let error = error {
                    
                    self.showErrorAlert("Error" , message: "Could not post location.", cancelButtonTitle: "try again?")
                    
                } else {
                    
                    let mapViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! UITabBarController
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(mapViewController, animated: true, completion: nil)
                    })
                    
                }
                
            }
            
        }
    }
    
    
    func showErrorAlert(title: String?, message: String, cancelButtonTitle: String) -> Void {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) in
            
            // Do nothing
            
        }))
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alert, animated: true, completion: nil)
        })
        
    }
    
    /**
    Disables submit button and shows activity indicator
    */
    func activityOn() {
        dispatch_async(dispatch_get_main_queue(), {
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
            self.submitButton.enabled = false
            self.submitButton.alpha = 0.5
        })
    }
    
    /**
    Enables submit button and hides activity indicator
    */
    func activityOff() {
        dispatch_async(dispatch_get_main_queue(), {
            self.activityIndicator.hidden = true
            self.activityIndicator.stopAnimating()
            self.submitButton.enabled = true
            self.submitButton.alpha = 1
        })
    }

    
    
}

