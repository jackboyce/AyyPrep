//
//  Assignment.swift
//  VeracrossCurl
//
//  Created by Christian DeSimone on 12/24/16.
//
//

import Foundation
import UIKit
class Assignment : Comparable{
    let dueDate: String;
    let name: String;
    let score: String;
    var weight: Double = 1
    var numerator: Double;
    var denominator: Double;
    var weightedScore: String;
    var intDueDate = 0;
    
    init(dueDate: String, name: String, score: String){
        self.dueDate = dueDate
        self.name = name
        self.score = score
        let needle: Character = "/"
       
        if let idx = score.characters.index(of: needle){
            //pos = score.characters.distance(from: score.startIndex, to: idx)
            numerator = Double(score.substring(to: idx))!
            denominator = Double(score.substring(from: idx))!
        }
        else{
           numerator = 0
            denominator = 0
        }
        
        
        weightedScore = String(Double(numerator) * weight) + " / " + String(Double(denominator) * weight)
        
    }
    init(stringRepresentation: String, weight: Double){
        let p: Parser = Parser.init(username: "", password: "")
        dueDate = p.getStringBetween(opener: "<Date:", closer: "EndDate>", target: stringRepresentation as NSString)
        name = p.getStringBetween(opener: "<Assignment:", closer: "EndAssignment", target: stringRepresentation as NSString)
        score = p.getStringBetween(opener: "<Score:", closer: "EndScore>", target: stringRepresentation as NSString)
        self.weight = weight
        let needle: Character = "/"
        var pos: Int = 0
        if let idx = score.characters.index(of: needle){
            pos = score.characters.distance(from: score.startIndex, to: idx)
            
        }
        var numerStr = ""
        var denomStr = ""
        var onNumer = true
        for l in score.characters{
            if l != "/" && onNumer && l != " "{
                numerStr.append(l)
                
            }
            if l == "/"{
                onNumer = false
            }
            if l != "/" && !onNumer && l != " "{
                denomStr.append(l)
            }
        }
        //print(denomStr)
        denominator = Double(denomStr)!
        numerator = Double(numerStr)!

        weightedScore = String(Double(numerator) * weight) + " / " + String(Double(denominator) * weight)
        
        //print(weightedScore)
        //print(score)
        //print(weight)
                       var foundSpace = false
        var strl = ""
        for p in dueDate.characters{
            if p != " " && foundSpace{
                strl.append(p)
            }
            if(p == " "){
                foundSpace = true
            }
        }
        if dueDate.contains("Jul"){
            intDueDate = Int(strl)!
        }
        else if(dueDate.contains("Aug")){
            intDueDate = 100 + Int(strl)!
        }
        else if(dueDate.contains("Sep")){
            intDueDate = 200 + Int(strl)!
        }
        else if(dueDate.contains("Oct")){
            intDueDate = 300 + Int(strl)!
        }
        else if(dueDate.contains("Nov")){
            intDueDate = 400 + Int(strl)!
        }
        else if(dueDate.contains("Dec")){
            intDueDate = 500 + Int(strl)!
        }
        else if(dueDate.contains("Jan")){
            intDueDate = 600 + Int(strl)!
        }
        else if(dueDate.contains("Feb")){
            intDueDate = 700 + Int(strl)!
        }
        else if(dueDate.contains("Mar")){
            intDueDate = 800 + Int(strl)!
        }
        else if(dueDate.contains("Apr")){
            intDueDate = 900 + Int(strl)!
        }
        else if(dueDate.contains("May")){
            intDueDate = 1000 + Int(strl)!
        }
        else if(dueDate.contains("Jun")){
            intDueDate = 1100 + Int(strl)!
        }
        
        
}
    

}

func < (lhs: Assignment, rhs: Assignment) -> Bool {
    return lhs.intDueDate < rhs.intDueDate
}

func == (lhs: Assignment, rhs: Assignment) -> Bool {
    return lhs.intDueDate == rhs.intDueDate
}

