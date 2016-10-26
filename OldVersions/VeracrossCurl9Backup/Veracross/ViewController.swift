//
//  ViewController.swift
//  Veracross
//
//  Created by Jack Boyce on 10/8/16.
//
//

import UIKit
import Alamofire
import Darwin
import Foundation
import GoogleMobileAds

class ViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var loadingCircle: UIActivityIndicatorView!
    @IBOutlet weak var htmlViewer: UIWebView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let uname = UserDefaults.standard.string(forKey: "username") {
            username.text = uname
        }
        if let pword = UserDefaults.standard.string(forKey: "password") {
            password.text = pword
        }
        rememberSwitch.setOn(UserDefaults.standard.bool(forKey: "Switch"), animated: false)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        loadAd()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebView" {
            let webViewController = segue.destination as! WebViewController
            //webViewController.PROPERTY = VALUE
            webViewController.username = username.text!
            webViewController.password = password.text!
        }
    }
    
    func loadAd() {
        bannerView.adUnitID = "ca-app-pub-3661213011866300/3610294678"
        bannerView.rootViewController = self
        let request = GADRequest()
        //request.testDevices = ["bb505274d09fc799b9245042f14bd4c5"]
        bannerView.adSize = kGADAdSizeBanner
        bannerView.load(request)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func save() {
        if rememberSwitch.isOn {
            UserDefaults.standard.set(username.text!, forKey: "username")
            UserDefaults.standard.set(password.text!, forKey: "password")
        } else {
            UserDefaults.standard.set("", forKey: "username")
            UserDefaults.standard.set("", forKey: "password")
        }
        UserDefaults.standard.set(rememberSwitch.isOn, forKey: "Switch")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        save()
    }
}
