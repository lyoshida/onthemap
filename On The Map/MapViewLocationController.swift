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
    @IBOutlet weak var findLocationButton: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the placeholder color to white
        if let locationTextField = locationTextField {
            locationTextField.attributedPlaceholder = NSAttributedString(string:"Enter your location here", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
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
                    return
                }
                
                self.pointAnnotation = MKPointAnnotation()
                self.pointAnnotation.title = self.locationTextField.text
                self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude:     localSearchResponse.boundingRegion.center.longitude)
                
                self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
                self.mapView.centerCoordinate = self.pointAnnotation.coordinate
                self.mapView.addAnnotation(self.pinAnnotationView.annotation)
                
                
                
            }

        
        }
    }
    
    

}

