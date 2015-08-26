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
        
        if let studentList = OTMClient.sharedInstance().studentList as [AnyObject]? {
            let dict: NSDictionary = studentList[indexPath.row] as! NSDictionary
            let firstName = dict["firstName"] as! String
            let lastName = dict["lastName"] as! String
            cell.textLabel!.text = "\(firstName) \(lastName)"
            
            let image: UIImage = UIImage(named: "pin")!
            cell.imageView!.image = image
        }
        
        return cell
        
    }
    
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
    
    @IBAction func reloadList(sender: UIBarButtonItem) {
        self.loadStudents(true)
    }
    
}
