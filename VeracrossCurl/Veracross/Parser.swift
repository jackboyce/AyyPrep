//
//  Parser.swift
//  VeracrossCurl
//
//  Created by Jack Boyce on 11/3/16.
//
//

import Foundation
import Alamofire

class Parser {
    var username: String = ""
    var password: String = ""
    var genHTMLhtml: String = ""
    var generatedHTML: String = ""
    var courses: [Course] = []
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
//    func getHTML(completionHandler: @escaping (String?) -> ()) -> NSString {
//        login(completionHandler: completionHandler)
//        
//        return (genHTMLhtml as NSString)
//        
//    }

    func parse(string: NSString) -> String{
        //Original html of the website
        courses = generateCourses(html: string)
        //print(courses)
        
        //Loops through all of the courses
        
        
        //Check for if the login is invalid and display error if it is
        var find = "Log In"
        var i = 0
        while i < string.length - find.characters.count {
            if string.substring(with: NSRange(location: i, length: find.characters.count)) == find {
                return "<p><span style=\"font-size:400%;\">Invalid username or password</span></p>"
            }
            i += 1
        }
        
        generatedHTML = generateHTML(courses: courses)
        
        return generatedHTML
    }
    
    func getKey(course: Course) -> String{
        var html: NSString = ""
        //Get the html of the all assignments page of course i
        let myURLString = "https://portals.veracross.com/sjp/student/classes/\(course.number)/grade_detail/"
        let myURL = URL(string: myURLString)
        
        do {
            let myHTMLString = try String(contentsOf: myURL!, encoding: .ascii)
            html = myHTMLString as NSString
        } catch let error {
            print("Error: \(error)")
        }
        
        //Get the key to use to fetch the grade detail pdf
        let keyOpener = "<iframe id=\"grade-detail-document\" src=\"https://documents.veracross.com/sjp/grade_detail/"
        let keyCloser = "\" data-scroll=\"scroll\"></iframe>"
        let key = getStringBetween(opener: keyOpener, closer: keyCloser, target: html, leftOffset: 8)
        
        return key
    }
    
    
    func generateHTML(courses: [Course]) -> String {
        var genHTML: String = ""
        
        for i in courses {
            genHTML += "<p><a href=\"https://documents.veracross.com/sjp/grade_detail/\(i.number).pdf?\(i.key)\"><span style=\"font-size:400%;\">\(i.name): <span style=\"float:right;\">\(stringToGrade(grade: i.grade)) \(i.grade)</span></span><a/></p><br>"
        }
        return genHTML
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
        
        for range in activeRanges {
            let start = range.start
            let end = range.end
            
            let courseOpener = "<a title=\"view class website\" class=\"class-name\" href=\""
            let courseCloser = "</a>"
            let courseName = getStringBetween(opener: courseOpener, closer: courseCloser, target: html, begin: start, end: end, leftOffset: 27)
            print("Course name: \(courseName)")
            
            let numOpener = "<a class=\"view-assignments\" href=\"/sjp/student/classes/"
            let numCloser = "\">view all assignments</a>"
            
            let number = getStringBetween(opener: numOpener, closer: numCloser, target: html, begin: start, end: end, rightOffset: 0)
            print("Course number: \(number)")
            
            let gradeOpener = "<span class=\"numeric-grade\">"
            let gradeCloser = "</span>"
            
            let grade = getStringBetween(opener: gradeOpener, closer: gradeCloser, target: html, begin: start, end: end)
            print("Course grade: \(grade)")
            
            if courseName != "" && grade != "" && number != "" {
                courseArray.append(Course(name: courseName, grade: grade, number: number))
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
    
    func getStringBetween(opener: String, closer: String, target: NSString, begin: Int = 0, end: Int = 0, leftOffset: Int = 0, rightOffset: Int = 0) -> String{
        //Need this because swift is dumb and wont let me do it in the parameters
        var end = end
        if end == 0 {
            end = target.length
        }
        
        var openIndex = begin
        var ret: String = ""
        var found = false
        
        while openIndex < end - opener.characters.count && !found {
            if target.substring(with: NSRange(location: openIndex, length: opener.characters.count)) == opener {
                var closeIndex = openIndex
                while !found {
                    if target.substring(with: NSRange(location: closeIndex, length: closer.characters.count)) == closer {
                        //print("\(openIndex) \(closeIndex)")
                        ret = target.substring(with: NSRange(location: openIndex + opener.characters.count + leftOffset, length: closeIndex - openIndex - opener.characters.count - leftOffset - rightOffset))
                        found = true
                    }
                    closeIndex += 1
                }
            }
            openIndex += 1
        }
        //print(ret)
        return ret
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
    //        let myURLString = "https://portals.veracross.com/sjp/login"
    //        let myURL = URL(string: myURLString)
    //
    //        do {
    //            let myHTMLString = try String(contentsOf: myURL!, encoding: .ascii)
    //            html = myHTMLString as NSString
    //        } catch let error {
    //            print("Error: \(error)")
    //        }


}
