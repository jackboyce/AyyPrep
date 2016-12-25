//
//  GraphsViewController.swift
//  VeracrossCurl
//
//  Created by Christian DeSimone on 12/25/16.
//
//

import UIKit
import Charts

class GraphsViewController: UIViewController, ChartViewDelegate {
   
    @IBOutlet weak var lineChartView: LineChartView!
    var courses: [Course] = []
       override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.delegate = self
        
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
