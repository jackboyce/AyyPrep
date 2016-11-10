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


class WebViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var courseTable: UITableView!
    var username: String = ""
    var password: String = ""
    var courses: [Course] = []
    var parser: Parser? = nil
    var htmlLoaded: String = ""
    var i = -1
    
    //Generated html that is used to display the grades after loading
    var landingPage: String = ""
    
    @IBOutlet weak var loadingCircle: UIActivityIndicatorView!
    @IBOutlet weak var htmlViewer: UIWebView!
    @IBOutlet weak var bannerView: GADBannerView!
    func bleh(html: String?) -> (){
        if(html != nil){
            
            htmlLoaded = (parser?.parse(string: (html!) as NSString))!
            courses = (parser?.generateCourses(html: html! as NSString))!
            //print(html)
            //print("test")
            print(courses)
            loadingCircle.stopAnimating()
            courseTable.dataSource = self
            courseTable.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Starts loasing circle
        loadingCircle.startAnimating()
        
        parser = Parser(username: username, password: password)
        parser?.login(completionHandler: bleh)
        
        
        
        //Add the logout button to the right of the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutPressed))
        //Add the home buton to the left of the navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(reloadPressed))
        
        //Adds a button to the center of the navigation bar
        let center =  UIButton(type: UIButtonType.custom) as UIButton
        center.frame = CGRect(x: 0,y: 0,width: 100,height: 40) as CGRect
        //button.backgroundColor = UIColor.red
        center.setTitleColor(UIColor.init(colorLiteralRed: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0), for: UIControlState.normal)
        center.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        center.setTitle("Statistics", for: UIControlState.normal)
        center.addTarget(self, action: #selector(statisticsPressed), for: UIControlEvents.touchUpInside)
        self.navigationItem.titleView = center
        print(courses)
        
    }
    
    //Called when the statistics button is pressed in the navigation bar
    func statisticsPressed() {
        let statisticsViewController = self.storyboard?.instantiateViewController(withIdentifier: "Statistics") as! StatisticsViewController
        
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
    
    //Called when the logout buton is pressed
    func logoutPressed(sender: UIBarButtonItem) {
        //htmlViewer.reload()
        //print(htmlViewer.canGoBack)
        navigationController?.popViewController(animated: true)
    }
    
    //Called when the home button is pressed
    func reloadPressed(sender: UIBarButtonItem) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell")
        cell?.textLabel?.text = courses[indexPath.row].name
        cell?.detailTextLabel?.text =  (parser?.stringToGrade(grade: courses[indexPath.row].grade))! + " " + courses[indexPath.row].grade
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        i = indexPath.row
        let pdfViewController = self.storyboard?.instantiateViewController(withIdentifier: "PDF") as! PDFViewController
        pdfViewController.courses = self.courses
        pdfViewController.htmlLoaded = "https://documents.veracross.com/sjp/grade_detail/\(courses[i].number).pdf?\(courses[i].key)"
        
        self.navigationController?.pushViewController(pdfViewController, animated: true)
    }
    
}
