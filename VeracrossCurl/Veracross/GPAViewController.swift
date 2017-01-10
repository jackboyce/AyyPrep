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
    @IBOutlet weak var GPALabel: UILabel!
    var classes = ["Class 1"]

    override func viewDidLoad() {
        super.viewDidLoad()
        GPALabel.text = ""
        navigationItem.title = "GPA Calculator"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func insertPush(_ sender: Any) {
        classes.append("Class \(classes.count + 1)")
        //self.tableView.insertRows(at: classes.count+1, with: .top)
        self.tableView.reloadData()
    }
    
    @IBAction func calculate(_ sender: Any) {
        loopGrade()
    }
    
    func loopGrade() -> Double {
        var totalUnweighted = 0.0
        var totalSJP = 0.0
        for cell in tableView.visibleCells as! [TableViewCell] {
            print(cell.gradeField.text!)
            print(cell.levelField.text!)
            totalUnweighted += stringToGPA(letter: cell.gradeField.text!)
        }
        totalUnweighted /= Double(classes.count)
        GPALabel.text = "\(totalUnweighted)"
        return totalUnweighted
    }

    func stringToGPA(letter: String) -> Double{
        
        if letter == "A+" {
            return 4.0
        } else if letter == "A" {
            return 4.0
        } else if letter == "A-" {
            return 3.7
        } else if letter == "B+" {
            return 3.3
        } else if letter == "B" {
            return 3.0
        } else if letter == "B-" {
            return 2.7
        } else if letter == "C+" {
            return 2.3
        } else if letter == "C" {
            return 2.0
        } else if letter == "C-" {
            return 1.7
        } else if letter == "D" {
            return 1.0
        } else {
            return 0
        }
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

            //self.tableView.reloadData()
            //self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.top)
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print (classes)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        /*cell.configure(nameText: "", namePlaceholder: "Course Name",
                       levelText: "", levelPlaceholder: "AP, H, A, CP",
                       gradeText: "", gradePlaceholder: "A+...F")
         */
        cell.configure(namePlaceholder: "Course Name",
                       levelPlaceholder: "AP, H, A, CP",
                       gradePlaceholder: "A+...F")
        cell.myLabel.text = classes[indexPath.row]
        return cell
    }

}
