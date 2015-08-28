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
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
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
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapView") as! MapViewController
            controller.locationString = locationTextField.text
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    

}

