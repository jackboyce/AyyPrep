//
//  PDFViewController.swift
//  VeracrossCurl
//
//  Created by Christian DeSimone on 11/10/16.
//
//

import UIKit
import GoogleMobileAds
import Alamofire

class PDFViewController: UIViewController {

    
    @IBOutlet weak var htmlViewer: UIWebView!
    
    //var htmlLoaded = "https://documents.veracross.com/sjp/grade_detail/\(course.number).pdf?\(course.key)"
    var course: Course = Course(name: "", grade: "", number: "")
    var parser: Parser? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pdf = course.pdf {
            htmlViewer.load(course.pdf as! Data, mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: URL(string: "https://google.com")!)
        } else {
            parser?.getPDF(course: course)
            htmlViewer.load(course.pdf as! Data, mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: URL(string: "https://google.com")!)
        }
    }
}

