//
//  PDFViewController.swift
//  VeracrossCurl
//
//  Created by Christian DeSimone on 11/10/16.
//
//

import UIKit
import GoogleMobileAds
import Alamofire

class PDFViewController: UIViewController {

    @IBOutlet weak var loadingCircle: UIActivityIndicatorView!
    @IBOutlet weak var htmlViewer: UIWebView!
    @IBOutlet weak var bannerView: GADBannerView!
    var htmlLoaded = ""
    var courses : [Course] = []
    func bleh(html: String?) -> (){
        if(html != nil){
            htmlViewer.loadRequest(NSURLRequest(url: (NSURL(string: htmlLoaded) as URL?)!) as URLRequest)
            //htmlViewer.loadHTMLString(htmlLoaded , baseURL: NSURL(string: "https://portals.veracross.com/sjp/student") as URL?)
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let stats = segue.destination as! StatisticsViewController
        stats.courses = self.courses
    }
}

