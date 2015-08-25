//
//  MapViewLocationController.swift
//  On The Map
//
//  Created by Luis Yoshida on 8/22/15.
//  Copyright (c) 2015 Msen. All rights reserved.
//
// http://sweettutos.com/2015/04/24/swift-mapkit-tutorial-series-how-to-search-a-place-address-or-poi-in-the-map/

import UIKit

class MapViewLocationController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let locationTextField = locationTextField {
            locationTextField.attributedPlaceholder = NSAttributedString(string:"Enter your location here", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            
        }
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

