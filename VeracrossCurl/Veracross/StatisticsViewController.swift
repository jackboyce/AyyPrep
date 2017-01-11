//
//  StatisticsViewController.swift
//  VeracrossCurl
//
//  Created by Jack Boyce on 10/18/16.
//
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var text: UITextView!
    var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quarterUnweighted()
    }
    
    func quarterUnweighted() {
        var total = 0.0
        for course in courses {
            total += stringToGPA(letter: stringToGrade(grade: course.grade))
        }
        total /= Double(courses.count)
        text.text = "Unweighted: \(total)"
    }
    
    func stringToGPA(letter: String) -> Double{
        
        if letter == "A+" {
            return 4
        } else if letter == "A" {
            return 4
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
            return 1
        } else {
            return 0
        }
    }

    func stringToGrade(grade: String) -> String {
        let doubGrade = (grade as NSString).doubleValue
        
        if doubGrade >= 96.5 {
            return "A+"
        } else if doubGrade >= 92.5 {
            return "A"
        } else if doubGrade >= 89.5 {
            return "A-"
        } else if doubGrade >= 86.5 {
            return "B+"
        } else if doubGrade >= 82.5 {
            return "B"
        } else if doubGrade >= 79.5 {
            return "B-"
        } else if doubGrade >= 76.5 {
            return "C+"
        } else if doubGrade >= 72.5 {
            return "C"
        } else if doubGrade >= 70.5 {
            return "C-"
        } else if doubGrade >= 69.5 {
            return "D"
        } else {
            return "F"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
