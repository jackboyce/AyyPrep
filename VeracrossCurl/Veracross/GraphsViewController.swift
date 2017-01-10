//
//  GraphsViewController.swift
//  VeracrossCurl
//
//  Created by Christian DeSimone on 12/25/16.
//
//

import UIKit
import Charts

class GraphsViewController: UIViewController, ChartViewDelegate{
   
    @IBOutlet weak var lineChartView: LineChartView!
    var courses: [Course] = []
    var data: [[ChartDataEntry]] = []
    let p: Parser = Parser.init()
       override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lineChartView.delegate = self
        
        self.lineChartView.descriptionText = "Tap nodes for more info"
        
        self.lineChartView.backgroundColor = UIColor.lightGray
        for i in courses{
            data.append(getNumbers(course: i))
        }
        //data.append(getNumbers(course: courses[0]))
        
        setChartData()
                
    }
    func getNumbers(course: Course) -> [ChartDataEntry]{
        var toReturn: [ChartDataEntry] = [ChartDataEntry]()
        for i in course.assignments{
            toReturn.append(ChartDataEntry(x: Double(i.intDueDate), y: 100 * p.getGradeUpToAndIncluding(assignment: i, array: course.assignments)))
        }
        return toReturn
    }
    func setChartData(){
        var dataSets: [LineChartDataSet] = [LineChartDataSet]()
        var c = 0;
        let colors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.orange, UIColor.purple, UIColor.yellow, UIColor.magenta]
        for i in data{
            let set: LineChartDataSet = LineChartDataSet.init(values: i, label: courses[c].name)
            set.axisDependency = .left
            set.setColor(colors[c].withAlphaComponent(0.5))
            set.setCircleColor(colors[c])
            set.lineWidth = 2.0
            set.circleRadius = 6.0
            set.fillAlpha = 65 / 255.0
            set.highlightColor = UIColor.white
            set.drawCircleHoleEnabled = true
            dataSets.append(set)
            c += 1
        }
        
        let chartData: LineChartData = LineChartData(dataSets: dataSets)
        chartData.setValueTextColor(UIColor.white)
        
        
        
        self.lineChartView.data = chartData
        
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
