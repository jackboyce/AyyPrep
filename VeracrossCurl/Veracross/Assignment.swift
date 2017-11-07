//
//  Assignment.swift
//  VeracrossCurl
//
//  Created by Christian DeSimone on 12/24/16.
//
//

import Foundation
import UIKit
class Assignment: Comparable {
    let category: String
    let dueDate: String
    let name: String
    let score: String
    var weight: Double = 100
    var numerator: Double
    var denominator: Double
    var weightedNumerator: Double
    var weightedDenominator: Double
    var weightedScore: String
    var intDueDate = 0
    var num: Double
    var denom: Double
    
    init(dueDate: String, name: String, score: String) {
        self.dueDate = dueDate
        self.name = name
        self.score = score
        self.category = name
        let needle: Character = "/"
       
        if let idx = score.characters.index(of: needle) {
            //pos = score.characters.distance(from: score.startIndex, to: idx)
            numerator = Double(score.substring(to: idx))!
            denominator = Double(score.substring(from: idx))!
            num = Double(score.substring(to: idx))!
            denom = Double(score.substring(from: idx))!
        }
        else{
            numerator = 0
            denominator = 0
            num = 0
            denom = 0
        }
        
        weightedDenominator = denominator * weight
        weightedNumerator = numerator * weight
        weightedScore = String(weightedNumerator) + " / " + String(weightedDenominator)
    }
    
    init(stringRepresentation: String, weight: Double) {
        print(stringRepresentation)
        let p: Parser = Parser.init(username: "", password: "")
        dueDate = p.getStringBetween(opener: "<Date:", closer: "EndDate>", target: stringRepresentation as NSString)
        name = p.getStringBetween(opener: "<Assignment:", closer: "EndAssignment", target: stringRepresentation as NSString)
        score = p.getStringBetween(opener: "<Score:", closer: "EndScore>", target: stringRepresentation as NSString)
        category = p.getStringBetween(opener: "<Category:", closer: "EndCategory>", target: stringRepresentation as NSString)
        num = 0
        denom = 0
        self.weight = weight / 100.0
        
        print(stringRepresentation)
        
        let needle: Character = "/"
        var pos: Int = 0
        if let idx = score.characters.index(of: needle) {
            pos = score.characters.distance(from: score.startIndex, to: idx)
        }
        
        var numerStr = ""
        var denomStr = ""
        var onNumer = true
        for l in score.characters {
            if l != "/" && onNumer && l != " " {
                numerStr.append(l)
            }
            if l == "/" {
                onNumer = false
            }
            if l != "/" && !onNumer && l != " " {
                denomStr.append(l)
            }
        }
        
        if numerStr == "NotTurnedIn" {
            numerator = Double(p.getStringBetween(opener: "<Numerator", closer: "EndNumerator>", target: stringRepresentation as NSString))!
            denominator = Double(p.getStringBetween(opener: "<Denominator", closer: "EndDenominator>", target: stringRepresentation as NSString))!
        } else {
            denominator = Double(denomStr)!
            numerator = Double(numerStr)!
        }
        
        weightedDenominator = denominator * weight
        weightedNumerator = numerator * weight

        weightedScore = String(weightedNumerator) + " / " + String(weightedDenominator)
        
        intDueDate = dueDateToInt(dueDate: dueDate)
    }
}

func < (lhs: Assignment, rhs: Assignment) -> Bool {
    return lhs.intDueDate < rhs.intDueDate
}

func == (lhs: Assignment, rhs: Assignment) -> Bool {
    return lhs.intDueDate == rhs.intDueDate
}

public func dueDateToInt(dueDate: String) -> Int{
    var foundSpace = false
    var strl = ""
    var intDueDate = 0;
    for p in dueDate.characters {
        if p != " " && foundSpace {
            strl.append(p)
        }
        if(p == " ") {
            foundSpace = true
        }
    }
    if dueDate.contains("Jul") {
        intDueDate = Int(strl)!
    }
    else if dueDate.contains("Aug") {
        intDueDate = 31 + Int(strl)!
    }
    else if dueDate.contains("Sep") {
        intDueDate = 61 + Int(strl)!
    }
    else if dueDate.contains("Oct") {
        intDueDate = 92 + Int(strl)!
    }
    else if dueDate.contains("Nov") {
        intDueDate = 122 + Int(strl)!
    }
    else if dueDate.contains("Dec") {
        intDueDate = 153 + Int(strl)!
    }
    else if dueDate.contains("Jan") {
        intDueDate = 184 + Int(strl)!
    }
    else if dueDate.contains("Feb") {
        intDueDate =  213 + Int(strl)!
    }
    else if dueDate.contains("Mar") {
        intDueDate = 244 + Int(strl)!
    }
    else if dueDate.contains("Apr") {
        intDueDate = 274 + Int(strl)!
    }
    else if dueDate.contains("May") {
        intDueDate = 305 + Int(strl)!
    }
    else if dueDate.contains("Jun") {
        intDueDate = 335 + Int(strl)!
    }
    return intDueDate
}



