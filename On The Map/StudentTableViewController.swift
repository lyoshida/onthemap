//
//  StudentTableViewController.swift
//  On The Map
//
//  Created by Luis Yoshida on 8/25/15.
//  Copyright (c) 2015 Msen. All rights reserved.
//

import UIKit

class StudentTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var studentTable: UITableView!
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var mapLocationButton: UIButton!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentTable.dataSource = self
        studentTable.delegate = self
        
        self.loadStudents(false)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let studentList = OTMClient.sharedInstance().studentList {
            return studentList.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentTableCell", forIndexPath: indexPath) as! UITableViewCell
        
        if let studentList = OTMClient.sharedInstance().studentList {
            let student: StudentInformation = studentList[indexPath.row]
            cell.textLabel!.text = student.fullName
            
            let image: UIImage = UIImage(named: "pin")!
            cell.imageView!.image = image
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let student: StudentInformation = OTMClient.sharedInstance().studentList![indexPath.row]
        if student.mediaURL != "" {
            if let mediaURL = NSURL(string: student.mediaURL) {
                UIApplication.sharedApplication().openURL(mediaURL)
            }
            
        } else {
            
            self.showErrorAlert("Error", message: "No URL for this student", cancelButtonTitle: "Dismiss")
            
        }
        
        
    }
    
    // Refresh list of students
    func loadStudents(forceReload: Bool) {
        OTMClient.sharedInstance().getStudents(forceReload) { result, error in
            if let error = error {
                
                var alert = UIAlertView(title: "Error", message: "Error retrieving student data.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
            } else {
                    
                dispatch_async(dispatch_get_main_queue(), {
                    self.studentTable.reloadData()
                })
                
            }
        }
    }
    
    @IBAction func refreshData(sender: UIButton) {
        self.loadStudents(true)
    }
    
    // Checks if there is a previous location before presenting the MapViewLocationController
    @IBAction func MapViewLocation(sender: UIButton) {
        
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

    // Log out
    @IBAction func logOut(sender: UIBarButtonItem) {
        OTMClient.sharedInstance().deleteSession() { result, error in
            
            println(result)
            
            if let error = error {
                
                self.showErrorAlert("Error", message: "Could not log out", cancelButtonTitle: "Dismiss")
                
            } else {
                
                let loginController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(loginController, animated: true, completion: nil)
                })
                
            }
        }
        
    }

    func showErrorAlert(title: String?, message: String, cancelButtonTitle: String) -> Void {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) in
            
            // Do nothing
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
}
