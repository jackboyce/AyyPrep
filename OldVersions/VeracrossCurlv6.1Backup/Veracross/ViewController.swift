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

class ViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var scrolltext: UITextView!
    //@IBOutlet weak var gradeText: UITextView!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var loadingCircle: UIActivityIndicatorView!
    
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
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        //Starts loasing circle
        loadingCircle.startAnimating()
        //saves the data in the form if the switch is flipped
        save()
        //Starts the Alamofire post request inside a handler
        login { (html) in
            if html != nil {
                self.scrolltext.text = html
                //print(html)
                self.parse()
                //Stops the loading circle when the data has been processed and assigned to the text box
                self.loadingCircle.stopAnimating()
            }
        }
        //scrolltext.text = "Math: 100%\nScience: 95%\nEnglish: 85%\nHistory: 83.14%\nArt: 97.25%"
    }
    
    func parse() {
        let original = scrolltext.text! as NSString
        var change = ""
        //gradeText.text = ""
        
        var courses = [Course]()
        
        courses = generateCourses(html: original)
        
        
        for i in courses {
            change += "\(i.name): \t\t\t\(stringToGrade(grade: i.grade))\t\(i.grade)\n\n"
            //gradeText.text! += "\t\t\(stringToGrade(grade: i.grade))\t\(i.grade) \n\n"
        }
        
        
        var find = "Log In"
        var i = 0
        //print(original)
        while i < original.length - find.characters.count {
            if original.substring(with: NSRange(location: i, length: find.characters.count)) == find {
                change = "Invalid username or password"
            }
            i += 1
        }
        
        scrolltext.text = change as String
    }
    
    func stringToGrade(grade: String) -> String {
        let doubGrade = (grade as NSString).doubleValue
        if doubGrade > 96.5 {
            return "A+"
        } else if doubGrade > 92.5 {
            return "A"
        } else if doubGrade > 89.5 {
            return "A-"
        } else if doubGrade > 86.5 {
            return "B+"
        } else if doubGrade > 82.5 {
            return "B"
        } else if doubGrade > 79.5 {
            return "B-"
        } else if doubGrade > 76.5 {
            return "C+"
        } else if doubGrade > 72.5 {
            return "C"
        } else if doubGrade > 70.5 {
            return "C-"
        } else if doubGrade > 69.5 {
            return "D"
        } else {
            return "F"
        }
    }
    
    func generateCourses(html: NSString) -> [Course] {
        
        let activeRanges:[(start:Int, end:Int)] = getActiveRanges(html: html)
        //print(activeRanges)
        
        var courseArray = [Course]()
        
        for e in activeRanges {
            let start = e.start
            let end = e.end
            
            for t in start ... end {
                let courseOpener = "<a title=\"view class website\" class=\"class-name\" href=\""
                let courseCloser = "</a>"
                var courseName: String = ""
                if html.substring(with: NSRange(location: t, length: courseOpener.characters.count)) == courseOpener {
                    var courseClosed = false
                    //print("found course opener")
                    var j = t
                    while !courseClosed {
                        if html.substring(with: NSRange(location: j, length: courseCloser.characters.count)) == courseCloser {
                            //print("found course closer")
                            courseName = html.substring(with: NSRange(location: t + courseOpener.characters.count + 27, length: j - t - courseOpener.characters.count - 27))
                            //print(courseName)
                            let gradeOpener = "<span class=\"numeric-grade\">"
                            let gradeCloser = "</span>"
                            var grade = ""
                            var n = j
                            
                            var gradeClosed = false
                            while n < e.end - gradeOpener.characters.count && !gradeClosed { //fix the end exception range
                                if html.substring(with: NSRange(location: n, length: gradeOpener.characters.count)) == gradeOpener {
                                    //print("found grade opener")
                                    var m = n
                                    while !gradeClosed {
                                        if html.substring(with: NSRange(location: m, length: gradeCloser.characters.count)) == gradeCloser {
                                            //print("found grade closer")
                                            grade = html.substring(with: NSRange(location: n + gradeOpener.characters.count, length: m - n - gradeOpener.characters.count))
                                            //print(grade)
                                            courseArray.append(Course(name: courseName, grade: grade))
                                            gradeClosed = true
                                        }
                                        m += 1
                                    }
                                }
                                n += 1
                            }
                            
                            courseClosed = true
                        }
                        j += 1
                    }
                }
            }
            
        }
        
        return courseArray
    }
    
    func getActiveRanges(html: NSString) -> [(start:Int, end:Int)]{
        let activeOpener = "<li data-status=\"active\">"
        let activeCloser = "</li>"
        var activeRanges:[(start:Int, end:Int)] = []
        
        var l = 0
        
        while l < html.length - (activeOpener.characters.count) {
            if html.substring(with: NSRange(location: l, length: activeOpener.characters.count)) == activeOpener {
                var p = l
                var activeClosed = false
                while !activeClosed {
                    if html.substring(with: NSRange(location: p, length: activeCloser.characters.count)) == activeCloser {
                        activeRanges.append((l, p))
                        activeClosed = true
                    }
                    p += 1
                }
            }
            l += 1
        }
        return activeRanges
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
    
    func login(completionHandler: @escaping (String?) -> ()) -> () {
        let payload = ["username": "\(username.text!)", "password": "\(password.text!)", "return_to": "https://portals.veracross.com/sjp/student", "Application": "Portals", "commit": "Log In"] as [String : Any]
        
        let loginurl = "https://portals.veracross.com/sjp/login"
        Alamofire.request(loginurl, method: .post, parameters: payload).responseString {
            (response) in
            
            let html = response.result.value
            
            completionHandler(html)
        }
    }
}

