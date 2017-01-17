//
//  WebViewController.swift
//  VeracrossCurl
//
//  Created by Jack Boyce on 10/15/16.
//
//

import UIKit
import Alamofire
import GoogleMobileAds
//import Firebase


class CourseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var courseTable: UITableView!
    var username: String = ""
    var password: String = ""
    var courses: [Course] = []
    var parser: Parser? = nil
    var progressOnAssignments: Int = 0
    
    @IBOutlet weak var loadingCircle: UIActivityIndicatorView!
    @IBOutlet weak var htmlViewer: UIWebView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    func completeParser(html: String?) -> (){
        if(html != nil){
            courses = (parser?.generateCourses(html: html! as NSString))!
            courseTable.reloadData()
            
            let keyGroup = DispatchGroup()
            let keyQueue = DispatchQueue.global()
            let queue = DispatchQueue.global()
            let group = DispatchGroup()
            
            //Load key and save PDF asynchronously
            queue.async {
                group.enter()
                for i in self.courses {
                    keyQueue.sync {
                        keyGroup.enter()
                        if i.key == "" {
                            i.key = (self.parser?.getKey(course: i))!
                            print("got key \(i.name)")
                        }
                        keyGroup.leave()
                    }
                    keyQueue.async {
                        keyGroup.enter()
                        i.assignments = (self.parser?.getArrayOfAssignments(course: i))!
                        /*
                        for k in i.assignments{
                            print(k.name)
                            print(k.category)
                            print(k.weight)
                            print(k.numerator)
                            print(k.denominator)
                        }*/
                        i.assignments.sort()
                        self.progressOnAssignments += 1
                        if i.pdf == nil {
                            self.parser?.getPDF(course: i)
                            print("got pdf \(i.name)")
                        }
                        keyGroup.leave()
                    }
                    keyGroup.wait()
                }
                group.leave()
            }
            loadingCircle.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewDidLoad), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        //Starts loasing circle
        loadingCircle.startAnimating()
        
        parser = Parser(username: username, password: password)
        parser?.login(completionHandler: completeParser)
        
        courseTable.delegate = self
        courseTable.dataSource = self
        
        let center = UIButton(type: UIButtonType.custom) as UIButton
        center.frame = CGRect(x:0, y:0, width: 100, height: 40) as CGRect
        center.setTitleColor(UIColor.init(colorLiteralRed: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0), for: UIControlState.normal)
        center.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        center.setTitle("Graphs", for: UIControlState.normal)
        center.addTarget(self, action: #selector(graphsPressed), for: UIControlEvents.touchUpInside)
        self.navigationItem.titleView = center
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "GPA Calc", style: .plain, target: self, action: #selector(statisticsPressed))
        
        loadAd()
    }
    
    func graphsPressed(){
        if(progressOnAssignments == courses.count && progressOnAssignments != 0 && courses.first?.name != "Wrong username or password"){
            let graphsViewController = self.storyboard?.instantiateViewController(withIdentifier: "Graphs") as! GraphsViewController
            graphsViewController.courses = courses
            self.navigationController?.pushViewController(graphsViewController, animated: true)
        }
    }
    
    //Called when the statistics button is pressed in the navigation bar
    func statisticsPressed() {
        let statisticsViewController = self.storyboard?.instantiateViewController(withIdentifier: "Statistics") as! GPAViewController
        self.navigationController?.pushViewController(statisticsViewController, animated: true)
    }
    
    //Called to load add into the banner view
    func loadAd() {
        bannerView.adUnitID = "ca-app-pub-3661213011866300/3610294678"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = ["bb505274d09fc799b9245042f14bd4c5"]
        request.testDevices = ["kGADSimulatorID"]
        bannerView.adSize = kGADAdSizeBanner
        bannerView.load(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell")
        cell?.textLabel?.text = courses[indexPath.row].name
        cell?.detailTextLabel?.text =  (courses[indexPath.row].grade == "" ? "" : GPACalc.stringToGrade(grade: courses[indexPath.row].grade)) + " " + courses[indexPath.row].grade
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if courses[indexPath.row].key == "" {
            courses[indexPath.row].key = (self.parser?.getKey(course: courses[indexPath.row]))!
        }
        let pdfViewController = self.storyboard?.instantiateViewController(withIdentifier: "PDF") as! PDFViewController
        pdfViewController.course = courses[indexPath.row]
        pdfViewController.parser = self.parser!
        self.navigationController?.pushViewController(pdfViewController, animated: true)
    }
}
