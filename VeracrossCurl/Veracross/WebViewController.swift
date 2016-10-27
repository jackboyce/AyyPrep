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
import Firebase


class WebViewController: UIViewController {

    var username: String = ""
    var password: String = ""
    //An array of courses
    var courses: [Course] = []
    
    //Generated html that is used to display the grades after loading
    var landingPage: String = ""
    
    @IBOutlet weak var loadingCircle: UIActivityIndicatorView!
    @IBOutlet weak var htmlViewer: UIWebView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Starts loasing circle
        loadingCircle.startAnimating()
        
        //Starts the Alamofire post request inside a handler
        login { (html) in
            if html != nil {
                //Parses the html of the website
                self.parse(string: html!)
                //Stops the loading circle when the data has been processed and assigned to the text box
                self.loadingCircle.stopAnimating()
                //Load an add when done processing grades
                self.loadAd()
            }
        }
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
        self.htmlViewer.loadHTMLString(landingPage, baseURL: NSURL(string: "https://portals.veracross.com/sjp/student") as URL?)
        //htmlViewer.reload()
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
    
    
    func parse(string: String) {
        //Original html of the website
        let original = string as NSString
        //Html that we generate to displpay on the webview
        var genHTML = ""
        courses = generateCourses(html: original)
        
        //Loops through all of the courses
        for i in courses {
            var html: NSString = ""
            
            //Get the html of the all assignments page of course i
            let myURLString = "https://portals.veracross.com/sjp/student/classes/\(i.number)/grade_detail/"
            guard let myURL = URL(string: myURLString) else {
                print("Error: \(myURLString) doesn't seem to be a valid URL")
                return
            }
            
            do {
                let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
                html = myHTMLString as NSString
            } catch let error {
                print("Error: \(error)")
            }
            
            //Get the key to use to fetch the grade detail pdf
            let keyOpener = "<iframe id=\"grade-detail-document\" src=\"https://documents.veracross.com/sjp/grade_detail/"
            let keyCloser = "\" data-scroll=\"scroll\"></iframe>"
            
            var keyClosed = false
            var r = 0
            while r < html.length - keyOpener.characters.count && !keyClosed {
                if html.substring(with: NSRange(location: r, length: keyOpener.characters.count)) == keyOpener {
                    var m = r
                    while !keyClosed {
                        if html.substring(with: NSRange(location: m, length: keyCloser.characters.count)) == keyCloser {
                            i.key = html.substring(with: NSRange(location: r + keyOpener.characters.count + 29, length: m - r - keyOpener.characters.count - 29))
                            keyClosed = true
                        }
                        m += 1
                    }
                }
                r += 1
            }
            
            //Add the course to the html that we display
            genHTML += "<p><a href=\"https://documents.veracross.com/sjp/grade_detail/\(i.number).pdf?grading_period=1&key=\(i.key)\"><span style=\"font-size:400%;\">\(i.name): <span style=\"float:right;\">\(stringToGrade(grade: i.grade)) \(i.grade)</span></span><a/></p><br>"
        }
        
        //Check for if the login is invalid and display error if it is
        var find = "Log In"
        var i = 0
        while i < original.length - find.characters.count {
            if original.substring(with: NSRange(location: i, length: find.characters.count)) == find {
                genHTML = "<p><span style=\"font-size:400%;\">Invalid username or password</span></p>"
            }
            i += 1
        }
        landingPage = genHTML;
        self.htmlViewer.loadHTMLString(genHTML, baseURL: NSURL(string: "https://portals.veracross.com/sjp/student") as URL?)
    }
    
    //Takes in a string with a double inside it and outputs a letter grade as a string
    func stringToGrade(grade: String) -> String {
        let doubGrade = (grade as NSString).doubleValue
        if doubGrade >= 96.5 {
            return "A+"
        } else if doubGrade >= 92.5 {
            return "A"
        } else if doubGrade >= 89.5 {
            return "A-"
        } else if doubGrade >= 86.5 {
            return "B+"
        } else if doubGrade >= 82.5 {
            return "B"
        } else if doubGrade >= 79.5 {
            return "B-"
        } else if doubGrade >= 76.5 {
            return "C+"
        } else if doubGrade >= 72.5 {
            return "C"
        } else if doubGrade >= 70.5 {
            return "C-"
        } else if doubGrade >= 69.5 {
            return "D"
        } else {
            return "F"
        }
    }
    
    //Takes in html of the webpage and outputs an array of courses
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
                            var y = j
                            
                            let numOpener = "href=\"/sjp/student/classes/"
                            let numCloser = "/grade_detail\""
                            
                            var number: String = ""
                            
                            //USED TO GET THE CLASS NUMBER
                            var numClosed = false
                            while y < e.end - gradeOpener.characters.count && !numClosed {
                                if html.substring(with: NSRange(location: y, length: numOpener.characters.count)) == numOpener {
                                    var m = y
                                    while !numClosed {
                                        if html.substring(with: NSRange(location: m, length: numCloser.characters.count)) == numCloser {
                                            number = html.substring(with: NSRange(location: y + numOpener.characters.count, length: m - y - numOpener.characters.count))
                                            //print(number)
                                            numClosed = true
                                        }
                                        m += 1
                                    }
                                }
                                y += 1
                            }
                            
                            var n = j
                            //USED TO GET THE GRADE FOR THE CLASS
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
                                            courseArray.append(Course(name: courseName, grade: grade, number: number))
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
    
    //Used to get the ranges between the active html tags
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
    
    //Logs in using the username and password
    func login(completionHandler: @escaping (String?) -> ()) -> () {
        let payload = ["username": "\(username)", "password": "\(password)", "return_to": "https://portals.veracross.com/sjp/student", "Application": "Portals", "commit": "Log In"] as [String : Any]
        
        let loginurl = "https://portals.veracross.com/sjp/login"
        Alamofire.request(loginurl, method: .post, parameters: payload).responseString {
            (response) in
            
            let html = response.result.value
            
            completionHandler(html)
        }
    }
}
