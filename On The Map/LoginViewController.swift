//
//  loginViewController.swift
//  On The Map
//
//  Created by Luis Yoshida on 8/23/15.
//  Copyright (c) 2015 Msen. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController {
    
    @IBOutlet weak var usernameTextField: PaddingTextField!
    @IBOutlet weak var passwordTextField: PaddingTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Sets visual layout
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor(red: 250.0/255.0, green: 172.0/255.0, blue: 135.0/255.0, alpha: 1.0).CGColor, UIColor(red: 247.0/255.0, green: 140.0/255.0, blue: 53.0/255.0, alpha: 1.0).CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
    }
    
    // Prevents view to autorotate to landscape mode.
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginRequest(sender: UIButton) {
        
        if usernameTextField.text == "" || passwordTextField.text == "" {
            
            statusLabel.text = "Please fill your username and password."
            
        } else {
            
            OTMClient.sharedInstance().login(usernameTextField.text, password: passwordTextField.text, completionHandler: { success, error in
                
                if success == false {
                    
                    if let error = error {
                        
                        self.showErrorAlert("Error", message: error.localizedDescription, cancelButtonTitle: "Dismiss")
                    }
                    
                } else {
                    // Get User details
                    
                    OTMClient.sharedInstance().getUserDetails({success, statusCode, errorString in
                        if success == true {
                            
                            self.completeLogin()
                            
                        } else {
                            
                            self.showErrorAlert("Error", message: "Failed to retrieve user details.", cancelButtonTitle: "Dismiss")
                            
                        }
                        
                    })
                    
                }
                
            })
        }
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! UITabBarController
            
            self.presentViewController(controller, animated: true, completion: nil)
        
        })
        
    }
    
    // Display messages in the status Label
    func displayMessage(message: String) {
        statusLabel.text = message
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
}