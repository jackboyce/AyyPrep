//
//  GPAListViewController.swift
//  VeracrossCurl
//
//  Created by Jack Boyce on 1/10/17.
//
//

import UIKit

class GPAListViewController: UIViewController {
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
    var courses: [(grade: String, level: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        unweighted()
        prep()
    }
    
    func unweighted() {
        var unweighted = 0.0
        for i in courses {
            unweighted += stringToGPA(letter: i.grade)
        }
        unweighted /= Double(courses.count)
        firstLabel.text = "Unweighted : \(unweighted)"
        unweighted = 0
    }
    
    func prep() {
        var prep = 0.0
        for i in courses {
            prep += stringToPrepGPA(letter: i.grade) + prepLeveltoGPA(letter: i.level)
        }
        prep /= Double(courses.count)
        thirdLabel.text = "Prep Weighted : \(prep)"
        prep = 0
    }
    
    func stringToGPA(letter: String) -> Double{
        let input = letter.uppercased()
        if input == "A+" {
            return 4.0
        } else if input == "A" {
            return 4.0
        } else if input == "A-" {
            return 3.7
        } else if input == "B+" {
            return 3.3
        } else if input == "B" {
            return 3.0
        } else if input == "B-" {
            return 2.7
        } else if input == "C+" {
            return 2.3
        } else if input == "C" {
            return 2.0
        } else if input == "C-" {
            return 1.7
        } else if input == "D" {
            return 1.0
        } else {
            return 0
        }
    }
    
    func stringToPrepGPA(letter: String) -> Double{
        let input = letter.uppercased()
        if input == "A+" {
            return 4.25
        } else if input == "A" {
            return 4.0
        } else if input == "A-" {
            return 3.75
        } else if input == "B+" {
            return 3.5
        } else if input == "B" {
            return 3.25
        } else if input == "B-" {
            return 3.0
        } else if input == "C+" {
            return 2.75
        } else if input == "C" {
            return 2.5
        } else if input == "C-" {
            return 2.25
        } else if input == "D" {
            return 1.25
        } else {
            return 0
        }
    }
    
    func prepLeveltoGPA(letter: String) -> Double{
        let input = letter.uppercased()
        if input == "AP" {
            return 0.75
        } else if input == "H" {
            return 0.5
        } else if input == "A" {
            return 0.25
        }
        return 0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
