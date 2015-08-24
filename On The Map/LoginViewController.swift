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
            
            let method: String = OTMClient.Methods.authUrl
            let json: [String: [String: String]] = [
                "udacity": [
                    "username": usernameTextField.text,
                    "password": passwordTextField.text
                ]
            ]
            var otmClient = OTMClient()
            
            let task = otmClient.taskForPOSTMethod(method, parameters: nil, jsonBody: json) { result, error in
                
                if let error = error {
                    println(error)
                } else {
                    println(result)
                }
            }
        }
    }
}