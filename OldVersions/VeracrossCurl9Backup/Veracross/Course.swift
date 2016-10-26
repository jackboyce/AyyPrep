//
//  Course.swift
//  VeracrossCurl
//
//  Created by Jack Boyce on 10/11/16.
//
//

import Foundation

class Course {
    let name: String
    let grade: String
    let number: String
    var key: String
    
    init(name: String, grade: String, number: String, key: String? = "") {
        self.name = name
        self.grade = grade
        self.number = number
        self.key = key!
    }
}
