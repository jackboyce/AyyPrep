//
//  AssignmentViewController.swift
//  VeracrossCurl
//
//  Created by Christian DeSimone on 11/8/17.
//
//

import Foundation
import UIKit

class AssignmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
 
    @IBOutlet weak var assignmentTable: UITableView!
    var assignments: [Assignment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewDidLoad), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        assignmentTable.delegate = self
        assignmentTable.dataSource = self
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return assignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentCell")
        cell?.textLabel?.text = assignments[indexPath.row].name
        cell?.detailTextLabel?.text = (assignments[indexPath.row].category) + ": " + (assignments[indexPath.row].score)
        return cell!
    }
}
