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
        firstLabel.text = "Unweighted : \(GPACalc.courseToUnweightedGPA(courses: courses))"
    }
    
    func prep() {
        thirdLabel.text = "Prep Weighted : \(GPACalc.courseToPrepGPA(courses: courses))"
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
