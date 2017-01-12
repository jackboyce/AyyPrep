//
//  GPAViewController.swift
//  customCell
//
//  Created by Scott Erlandson on 12/29/16.
//  Copyright © 2016 Scott Erlandson. All rights reserved.
//

import UIKit

class GPAViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var classes = ["Class 1"]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "GPA Calculator"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(insertPush))
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let center = UIButton(type: UIButtonType.custom) as UIButton
        center.frame = CGRect(x:0, y:0, width: 100, height: 40) as CGRect
        center.setTitleColor(UIColor.init(colorLiteralRed: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0), for: UIControlState.normal)
        center.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        center.setTitle("Calculate", for: UIControlState.normal)
        center.addTarget(self, action: #selector(calculate), for: UIControlEvents.touchUpInside)
        self.navigationItem.titleView = center
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertPush(_ sender: Any) {
        classes.append("Class \(classes.count + 1)")
        //self.tableView.insertRows(at: classes.count+1, with: .top)
        self.tableView.reloadData()
    }
    
    @IBAction func calculate(_ sender: Any) {
        var courses: [(grade: String, level: String)] = []
        for cell in tableView.visibleCells as! [TableViewCell] {
            courses.append((grade: cell.gradeField.text!, level: cell.levelField.text!))
        }
        let gpa = self.storyboard?.instantiateViewController(withIdentifier: "GPAList") as! GPAListViewController
        gpa.courses = courses
        self.navigationController?.pushViewController(gpa, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.classes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            if editingStyle == .insert {
                self.classes.append("Class \(classes.count + 1)")
                self.tableView.insertRows(at: [indexPath], with: .top)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.configure(namePlaceholder: "Course Name",
                       levelPlaceholder: "AP, H, A, CP",
                       gradePlaceholder: "A+...F")
        cell.myLabel.text = classes[indexPath.row]
        return cell
    }
    
}
