//
//  Parser.swift
//  VeracrossCurl
//
//  Created by Jack Boyce on 11/3/16.
//
//

import Foundation
import Alamofire
//import Kanna

class Parser {
    var username: String = ""
    var password: String = ""
    var courses: [Course] = []
   // var table: [NSString] = [""]
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    init() {
        username = ""
        password = ""
    }
    
    func getGradeUpToAndIncluding(assignment: Assignment, array: [Assignment] ) -> Double{
        var finalGrade = 0.0
        var weightings :[Double] = []
        var willPrint = false
        for i in array{
            if !weightings.contains(i.weight){
                weightings.append(i.weight)
            }
        }
        if weightings.contains(0.25){
            willPrint = true
        }
        var assignments = array
        for k in assignments{
            if k > assignment{
                assignments.remove(at: assignments.index(of: k)!)
            }
        }
        
        for i in weightings{
            var numer = 0.0
            var denom = 0.0
            
            
            
            
            for k in assignments{
                
                if(k.weight == i){
                   
                    numer += k.numerator
                    denom += k.denominator
                }
            }
            if willPrint{
                
            }
            if(numer == 0 && denom == 0){
                finalGrade += i
            }
            else{
                finalGrade +=  numer / denom * i
            }
            
        }
        return finalGrade
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
    
    func getArrayOfAssignments(course: Course) -> [Assignment]{
        var wTable: [String: Double] = [:]
        var toReturn: [Assignment] = [Assignment.init(dueDate:"", name:"",score:"")]
        toReturn.removeAll()
        
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
        
        
        
        //Get the html table to use for grophs
        let tableOpener = "<iframe id=\"grade-detail-document\" src=\""
        let tableCloser = "\" data-scroll=\"scroll\">"
        let tableURLString = getStringBetween(opener: tableOpener, closer: tableCloser, target: html)
        
        let tableURL = URL(string: tableURLString)
        var table: NSString = ""
        do {
            let tableHTMLString = try String(contentsOf: tableURL!, encoding: .ascii)
            table = (tableHTMLString as NSString)
        } catch let error {
            print("Error: \(error)")
        }

        //var tableOfGroups = getArrayOfStringsBetween(opener: "<tbody class=", closer:"</tbody>", target: table)
        // print(tableOfGroups[0...3])
        var tableOfGroups = getArrayOfStringsBetween(opener: "<td class='description text' ><strong>", closer: "</strong>", target: table)
        var m = 0;
        while m < tableOfGroups.count {
            tableOfGroups[m] = tableOfGroups[m].lowercased()
            tableOfGroups[m] = tableOfGroups[m].replacingOccurrences(of: " ", with: "_")
            m += 1
        }
        var tableOfGroupsNew = getArrayOfStringsBetween(opener: "<tbody class=", closer:"</tbody>", target: table)
        
        var tableOfGroupsOld: [String] = [""]
        tableOfGroupsOld.removeAll()
        
        for p in tableOfGroups{
            for o in tableOfGroupsNew{
                if o.contains(p){
                    tableOfGroupsOld.append(o)
                }
            }
        }
        
        var strs = getArrayOfStringsBetween(opener: "weight number", closer: "graph", target: table)
        var categoryName: [String] = [""];
        categoryName.remove(at: 0)
        for i in tableOfGroups{
            categoryName.append(i)
            
            
            if(strs.isEmpty){
                wTable[i] = 100
            
            }
            else{
                
                wTable[i] =  Double(self.getStringBetween(opener: "label\">", closer: "%", target: strs[tableOfGroups.index(of: i)!] as NSString))
            }
            
            
        }
        //print(tableOfGroups)
        var assignments: [[String]] = [[""]];
        assignments.removeAll()
        var counter = 0;
        
        
        while counter < categoryName.count{
            assignments.append(getArrayOfStringsBetween(opener: "<tr class=\'row_", closer: "</tr>", target: tableOfGroupsOld[counter] as NSString))
            var strsBetween = getArrayOfStringsBetween(opener: "<tr class=\'row_", closer: "</tr>", target: tableOfGroupsOld[counter] as NSString)
            var strsBetweenIndex = 0
            while strsBetweenIndex < strsBetween.count{
                strsBetween[strsBetweenIndex] = "<Date:" + getStringBetween(opener: "due_date text\' >", closer: "</td>", target: strsBetween[strsBetweenIndex] as NSString) + "EndDate><Assignment:" + getStringBetween(opener: "assignment text\' >", closer: "</td>", target: strsBetween[strsBetweenIndex] as NSString) + "EndAssignment><Score:" + getStringBetween(opener: "\"score-number\">", closer: "</span>", target: strsBetween[strsBetweenIndex] as NSString) + "EndScore>"
                //print(strsBetween[strsBetweenIndex])
                
                toReturn.append(Assignment.init(stringRepresentation: strsBetween[strsBetweenIndex], weight: wTable[categoryName[counter]]!))
                
                strsBetweenIndex+=1
            }
            assignments[counter].insert(categoryName[counter], at: 0)
            
            
            counter += 1
            
        }
       // print("Assignments")
        //print(assignments[1])
        
        
        //print(categoryName)
        
        
       // print(toReturn)
        
       return toReturn
    }
    
    
    func getPDF(course: Course) {
        let yourURL = NSURL(string: "https://documents.veracross.com/sjp/grade_detail/\(course.number).pdf?\(course.key)")
        let urlRequest = NSURLRequest(url: yourURL! as URL)
        do {
            try course.pdf = NSURLConnection.sendSynchronousRequest(urlRequest as URLRequest, returning: nil) as NSObject
        } catch let error as NSError {
            
        }
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
        
        var courseArray = [Course]()
        
        let dispatchGroup = DispatchGroup()
        let rangeGroup = DispatchGroup()
        let parseQueue = DispatchQueue.global()
        let rangeQueue = DispatchQueue.global()
        
        
        for range in activeRanges {
            rangeQueue.async(group: rangeGroup, execute: {
                rangeGroup.enter()
                let start = range.start
                let end = range.end
                var courseName = ""
                var number = ""
                var grade = ""
                
                parseQueue.async(group: dispatchGroup, execute: {
                    dispatchGroup.enter()
                    let courseOpener = "<a title=\"view class website\" class=\"class-name\" href=\""
                    let courseCloser = "</a>"
                    courseName = self.getStringBetween(opener: courseOpener, closer: courseCloser, target: html, begin: start, end: end, leftOffset: 27)
                    dispatchGroup.leave()
                })
                
                parseQueue.async(group: dispatchGroup, execute: {
                    dispatchGroup.enter()
                    let numOpener = "<a class=\"view-assignments\" href=\"/sjp/student/classes/"
                    let numCloser = "\">view all assignments</a>"
                    
                    number = self.getStringBetween(opener: numOpener, closer: numCloser, target: html, begin: start, end: end, rightOffset: 0)
                    dispatchGroup.leave()
                })
                
                parseQueue.async(group: dispatchGroup, execute: {
                    dispatchGroup.enter()
                    let gradeOpener = "<span class=\"numeric-grade\">"
                    let gradeCloser = "</span>"
                    
                    grade = self.getStringBetween(opener: gradeOpener, closer: gradeCloser, target: html, begin: start, end: end)
                    dispatchGroup.leave()
                })
                
                dispatchGroup.notify(queue: parseQueue, execute: {
                    if courseName != "" && grade != "" && number != "" {
                        courseArray.append(Course(name: courseName, grade: grade, number: number))
                    }
                })
                dispatchGroup.wait()
                rangeGroup.leave()
            })
            rangeGroup.wait()
        }
        
        if html.contains("Log In"){
            courseArray.append(Course(name: "Wrong username or password", grade: "", number: ""))
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
    
    func getArrayOfStringsBetween(opener: String, closer: String, target: NSString) -> [String]{
        var ret: [String] = []
        var begin = 0
        var str: String
        var bleh = getStringAndIndexBetween(opener: opener, closer: closer, target: target, begin: begin)
        str = bleh.str
        begin = bleh.index
        while str != "" {
            ret.append(str)
            bleh = getStringAndIndexBetween(opener: opener, closer: closer, target: target, begin: begin)
            str = bleh.str
            begin = bleh.index
            
        }
        
        return ret
    }
    
    func getStringAndIndexBetween(opener: String, closer: String, target: NSString, begin: Int = 0, end: Int = 0, leftOffset: Int = 0, rightOffset: Int = 0) -> (str: String, index: Int){
            //Need this because swift is dumb and wont let me do it in the parameters
            var end = end
            if end == 0 {
                end = target.length
            }
            
            var openIndex = begin
            var ret: String = ""
            var found = false
            var retIndex = 0
        
            while openIndex < end - opener.characters.count && !found {
                if target.substring(with: NSRange(location: openIndex, length: opener.characters.count)) == opener {
                    var closeIndex = openIndex
                    while !found {
                        if target.substring(with: NSRange(location: closeIndex, length: closer.characters.count)) == closer {
                            ret = target.substring(with: NSRange(location: openIndex + opener.characters.count + leftOffset, length: closeIndex - openIndex - opener.characters.count - leftOffset - rightOffset))
                            found = true
                            retIndex = (openIndex + opener.characters.count + leftOffset) + (closeIndex - openIndex - opener.characters.count - leftOffset - rightOffset) + closer.characters.count
                        }
                        closeIndex += 1
                    }
                }
                openIndex += 1
            }
            return (ret, retIndex)

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
}
