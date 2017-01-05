//
//  ViewController.swift
//  customCell
//
//  Created by Scott Erlandson on 12/29/16.
//  Copyright © 2016 Scott Erlandson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var classes = ["Class 1"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "GPA Calculator"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func insertPush(_ sender: Any) {
        classes.append("Class \(classes.count + 1)")
        tableView.reloadData()
    }
    
    @IBAction func calculate(_ sender: Any) {
        loopGrade()
    }
    
    func loopGrade() {
        for cell in tableView.visibleCells as! [TableViewCell] {
            print(cell.gradeField.text!)
            print(cell.levelField.text!)
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.classes.remove(at: indexPath.row)
            //self.tableView.reloadData()
            self.tableView.reloadRows(at: <#T##[IndexPath]#>, with: <#T##UITableViewRowAnimation#>)
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.configure(nameText: "", namePlaceholder: "Course Name",
                       levelText: "", levelPlaceholder: "AP, H, A, CP",
                       gradeText: "", gradePlaceholder: "A+...F")
        cell.myLabel.text = classes[indexPath.row]
        return cell
    }
    
    /*func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        <#code#>
    }
    */

}

