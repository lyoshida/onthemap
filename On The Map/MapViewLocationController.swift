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
    
    var annotation: MKAnnotation!
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch: MKLocalSearch!
    var localSearchResponse: MKLocalSearchResponse!
    var error: NSError!
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    
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
            localSearchRequest = MKLocalSearchRequest()
            localSearchRequest.naturalLanguageQuery = self.locationTextField.text
            localSearch = MKLocalSearch(request: localSearchRequest)
            localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
                
                if localSearchResponse == nil {
                    var alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "try again?")
                    alert.show()
                    self.locationSelectView.hidden = false
                    self.confirmView.hidden = true
                    return
                }

                self.latitude = localSearchResponse.boundingRegion.center.latitude as Double
                self.longitude = localSearchResponse.boundingRegion.center.longitude as Double
                self.localName = localSearchResponse.mapItems[0].name
                
                self.pointAnnotation = MKPointAnnotation()
                self.pointAnnotation.title = self.localName
                self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
                
                self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
                self.mapView.centerCoordinate = self.pointAnnotation.coordinate
                self.mapView.addAnnotation(self.pinAnnotationView.annotation)
                
            }

        }
    }
    
    @IBAction func submitLocation(sender: UIButton) {
        
        // TODO: Check if url is empty
        
        OTMClient.sharedInstance().postUserLocation(self.localName!, link: self.linkTextField.text!, latitude: self.latitude!, longitude: self.longitude!) { result, error in
            
            if let error = error {
                var alert = UIAlertView(title: nil, message: "Could not post location.", delegate: self, cancelButtonTitle: "try again?")
                alert.show()
            } else {
                if let objId = result?.valueForKey("objectId") as? String {
                    OTMClient.sharedInstance().objectId = objId
                }
            }
            
        }
        
        
        
    }
    
}

