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
    
    var studentList: [AnyObject]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentTable.dataSource = self
        studentTable.delegate = self
        
        self.loadStudents { result, error in
            if let result = result {
                self.studentList = result as! [AnyObject]
                self.studentTable.reloadData()
            }
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let studentList = self.studentList {
            return self.studentList!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentTableCell", forIndexPath: indexPath) as! UITableViewCell
        
        if let studentList = self.studentList as [AnyObject]? {
            let dict: NSDictionary = studentList[indexPath.row] as! NSDictionary
            let firstName = dict["firstName"] as! String
            let lastName = dict["lastName"] as! String
            cell.textLabel!.text = "\(firstName) \(lastName)"
            
            let image: UIImage = UIImage(named: "pin")!
            cell.imageView!.image = image
        }
        
        return cell
        
    }
    
    func loadStudents(completionHandler: (results: AnyObject?, error: NSError?) -> Void) {
        OTMClient.sharedInstance().getStudents() { result, error in
            if let error = error {
                var alert = UIAlertView(title: "Error", message: "Error retrieving student data.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            } else {
                if let result = result as? NSDictionary {
                    if let studentList = result["results"] as? [AnyObject] {
                        completionHandler(results: studentList, error: nil)
                    } else {
                        completionHandler(results: nil, error: error)
                    }
                }
            }
        }
    }
}
