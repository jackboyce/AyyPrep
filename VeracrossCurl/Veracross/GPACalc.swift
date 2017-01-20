//
//  GPACalc.swift
//  VeracrossCurl
//
//  Created by Jack Boyce on 1/13/17.
//
//

import Foundation

class GPACalc {
    
    static func courseToUnweightedGPA(courses: [(grade: String, level: String)]) -> Double {
        var ret = 0.0
        for i in courses {
            ret += GPACalc.stringToGPA(letter: i.grade)
        }
        ret /= Double(courses.count)
        return ret
    }
    
    static func courseToPrepGPA(courses: [(grade: String, level: String)]) -> Double {
        var ret = 0.0
        for i in courses {
            ret += GPACalc.stringToPrepGPA(letter: i.grade) + GPACalc.prepLeveltoGPA(letter: i.level)
        }
        ret /= Double(courses.count)
        return ret
    }
    
    static func coursesToUnweightedGPA(courses: [Course]) -> Double {
        var ret = 0.0
        for i in courses {
            ret += GPACalc.stringToGPA(letter: GPACalc.stringToGrade(grade: i.grade))
        }
        ret /= Double(courses.count)
        return ret
    }
    
    static func stringToGPA(letter: String) -> Double {
        let input = letter.uppercased()
        if input == "A+" {
            return 4.0
        } else if input == "A" {
            return 4.0
        } else if input == "A-" {
            return 3.7
        } else if input == "B+" {
            return 3.3
        } else if input == "B" {
            return 3.0
        } else if input == "B-" {
            return 2.7
        } else if input == "C+" {
            return 2.3
        } else if input == "C" {
            return 2.0
        } else if input == "C-" {
            return 1.7
        } else if input == "D" {
            return 1.0
        } else {
            return 0
        }
    }
    
    static func stringToPrepGPA(letter: String) -> Double {
        let input = letter.uppercased()
        if input == "A+" {
            return 4.25
        } else if input == "A" {
            return 4.0
        } else if input == "A-" {
            return 3.75
        } else if input == "B+" {
            return 3.5
        } else if input == "B" {
            return 3.25
        } else if input == "B-" {
            return 3.0
        } else if input == "C+" {
            return 2.75
        } else if input == "C" {
            return 2.5
        } else if input == "C-" {
            return 2.25
        } else if input == "D" {
            return 1.25
        } else {
            return 0
        }
    }
    
    //Takes in a string with a double inside it and outputs a letter grade as a string
    static func stringToGrade(grade: String) -> String {
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
    
    static func prepLeveltoGPA(letter: String) -> Double {
        let input = letter.uppercased()
        if input == "AP" {
            return 0.75
        } else if input == "H" {
            return 0.5
        } else if input == "A" {
            return 0.25
        }
        return 0
    }
}
