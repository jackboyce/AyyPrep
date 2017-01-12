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
import Locksmith

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
        print("1")
        
        if let dictionary = Locksmith.loadDataForUserAccount(userAccount: "Veracross")
        {
               print("2")
            username.text = dictionary["username"] as! String?
            password.text = dictionary["password"] as! String?

        }
        else{
            print("3")
            do{
                try  Locksmith.saveData(data:["username": "", "password": ""], forUserAccount: "Veracross")
            }
            catch{
                print("error")

                
            }
        }
        //Load the remember me data into the text boxes
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
            let courseViewController = segue.destination as! CourseViewController
            //Pass the username and password to the new view controller
            courseViewController.username = username.text!
            courseViewController.password = password.text!
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
            do{
                try Locksmith.updateData(data: ["username": username.text!, "password": password.text!], forUserAccount: "Veracross")
            }
            catch{
               print("error")
            }
        } else {
            do{
                try Locksmith.deleteDataForUserAccount(userAccount: "Veracross")
            }
            catch{
                print("error")
 
            }
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
