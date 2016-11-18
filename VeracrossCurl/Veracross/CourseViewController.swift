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
                        i.key = (self.parser?.getKey(course: i))!
                        keyGroup.leave()
                    }
                    keyQueue.async {
                        keyGroup.enter()
                        if i.pdf == nil {
                            self.parser?.getPDF(course: i)
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
        
        //Starts loasing circle
        loadingCircle.startAnimating()
        
        parser = Parser(username: username, password: password)
        parser?.login(completionHandler: completeParser)
        
        courseTable.delegate = self
        courseTable.dataSource = self
        
        //UNCOMMENT FOR STATISTICS VIEW
//        //Adds a button to the center of the navigation bar
//        let center =  UIButton(type: UIButtonType.custom) as UIButton
//        center.frame = CGRect(x: 0,y: 0,width: 100,height: 40) as CGRect
//        //button.backgroundColor = UIColor.red
//        center.setTitleColor(UIColor.init(colorLiteralRed: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0), for: UIControlState.normal)
//        center.setTitleColor(UIColor.white, for: UIControlState.highlighted)
//        center.setTitle("Statistics", for: UIControlState.normal)
//        center.addTarget(self, action: #selector(statisticsPressed), for: UIControlEvents.touchUpInside)
//        self.navigationItem.titleView = center
        loadAd()
    }
    
    //Called when the statistics button is pressed in the navigation bar
    func statisticsPressed() {
        let statisticsViewController = self.storyboard?.instantiateViewController(withIdentifier: "Statistics") as! StatisticsViewController
        statisticsViewController.courses = courses
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
        cell?.detailTextLabel?.text =  (courses[indexPath.row].grade == "" ? "" : parser?.stringToGrade(grade: courses[indexPath.row].grade))! + " " + courses[indexPath.row].grade
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if courses[indexPath.row].key != "" {
            let pdfViewController = self.storyboard?.instantiateViewController(withIdentifier: "PDF") as! PDFViewController
            pdfViewController.course = courses[indexPath.row]
            pdfViewController.parser = self.parser!
            
            self.navigationController?.pushViewController(pdfViewController, animated: true)
        }
    }
}
