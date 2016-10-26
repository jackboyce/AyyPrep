//
//  WebViewController.swift
//  VeracrossCurl
//
//  Created by Jack Boyce on 10/15/16.
//
//

import UIKit
import Alamofire


class WebViewController: UIViewController {

    var username: String = ""
    var password: String = ""
    var key: String = ""
    
    var landingPage: String = ""
    
    @IBOutlet weak var loadingCircle: UIActivityIndicatorView!
    @IBOutlet weak var htmlViewer: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Starts loasing circle
        loadingCircle.startAnimating()
        //Starts the Alamofire post request inside a handler
        login { (html) in
            if html != nil {
                self.parse(string: html!)
                //Stops the loading circle when the data has been processed and assigned to the text box
                self.loadingCircle.stopAnimating()
                //print(self.key)
            }
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(backPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(reloadPressed))
    }
    
    func backPressed(sender: UIBarButtonItem) {
        //htmlViewer.reload()
        //print(htmlViewer.canGoBack)
        navigationController?.popViewController(animated: true)
    }
    
    func reloadPressed(sender: UIBarButtonItem) {
        self.htmlViewer.loadHTMLString(landingPage, baseURL: NSURL(string: "https://portals.veracross.com/sjp/student") as URL?)
        //htmlViewer.reload()
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
    
    func parse(string: String) {
        let original = string as NSString
        var genHTML = ""
        var courses = [Course]()
        courses = generateCourses(html: original)
        
        for i in courses {
            var html: NSString = ""
            
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
            genHTML += "<p><a href=\"https://documents.veracross.com/sjp/grade_detail/\(i.number).pdf?grading_period=1&key=\(i.key)\"><span style=\"font-size:400%;\">\(i.name): <span style=\"float:right;\">\(stringToGrade(grade: i.grade)) \(i.grade)</span></span><a/></p><br>"
        }
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
