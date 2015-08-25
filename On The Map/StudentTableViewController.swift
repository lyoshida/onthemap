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
        
        loadStudents()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func loadStudents() {
        OTMClient.sharedInstance().getStudents() { result, error in
            if let error = error {
                println(error)
            } else {
                println(result)
            }
            
        }
    }
}
