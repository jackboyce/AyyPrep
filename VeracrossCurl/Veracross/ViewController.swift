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
        
        //Load the remember me data into the text boxes
        if let uname = UserDefaults.standard.string(forKey: "username") {
            username.text = uname
        }
        if let pword = UserDefaults.standard.string(forKey: "password") {
            password.text = pword
        }
        rememberSwitch.setOn(UserDefaults.standard.bool(forKey: "Switch"), animated: false)
        
        //Let the keyboard be dismissed by tapping anywhere not on the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Load an add on the page
        loadAd()
    }
    
    //Called when this view is being seagued
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebView" {
            let webViewController = segue.destination as! WebViewController
            //Pass the username and password to the new view controller
            webViewController.username = username.text!
            webViewController.password = password.text!
        }
    }
    
    //Called to load ads onto the bannerview
    func loadAd() {
        bannerView.adUnitID = "ca-app-pub-3661213011866300/3610294678"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = ["bb505274d09fc799b9245042f14bd4c5"]
        request.testDevices = ["kGADSimulatorID"]
        bannerView.adSize = kGADAdSizeBanner
        bannerView.load(request)
    }
    
    //Called to dismiss the keyboard
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //Called to save the data from the username and password field
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
