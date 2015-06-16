//
//  FeedbackViewController.swift
//  MobileOtter
//
//  Created by Brian Huynh on 6/15/15.
//  Copyright (c) 2015 Brian Huynh. All rights reserved.
//

import UIKit
import QuartzCore

class FeedbackViewController: UIViewController {

    @IBOutlet weak var userGender: UISegmentedControl!
    @IBOutlet weak var userAgeGroup: UISegmentedControl!
    @IBOutlet weak var userReasonForDownload: UITextView!
    @IBOutlet weak var userNeedsMet: UISegmentedControl!
    @IBOutlet weak var instructionForFeedback: UILabel!
    @IBOutlet weak var userFeedback: UITextView!
    
    let feedbackBackend = NSURL(string: "http://hosting.csumb.edu/huynhbrian/mobileotter/feedback.php")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userReasonForDownload.layer.cornerRadius = 8.0
        userReasonForDownload.layer.borderColor = UIColor.blackColor().CGColor
        userReasonForDownload.layer.borderWidth = 1.0
        
        userFeedback.layer.cornerRadius = 8.0
        userFeedback.layer.borderColor = UIColor.blackColor().CGColor
        userFeedback.layer.borderWidth = 1.0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkUserNeedsMet(sender: UISegmentedControl) {
            instructionForFeedback.hidden = !instructionForFeedback.hidden
            userFeedback.hidden = !userFeedback.hidden
    }
    @IBAction func userFinishedFeedback() {
        
        var gender = ""
        var ageGroup = ""
        var reasonForDownload = userReasonForDownload.text
        var appSuitUserNeeds = ""
        var feedback = ""
        
        switch userGender.selectedSegmentIndex {
            case 0: gender = "M"
            case 1: gender = "F"
            default: gender = "O"
        }
        
        switch userAgeGroup.selectedSegmentIndex {
            case 0: ageGroup = "10-20"
            case 1: ageGroup = "21-31"
            case 2: ageGroup = "32-42"
            default: ageGroup = "43+"
        }
        
        if userNeedsMet.selectedSegmentIndex == 1 {
            appSuitUserNeeds = "N"
            feedback = userFeedback.text
        }
        else {
            appSuitUserNeeds = "Y"
        }
        
        let request = NSMutableURLRequest(URL: feedbackBackend!)
        request.HTTPMethod = "POST"
        
        let bodyData = "gender=\(gender)&ageGroup=\(ageGroup)&reasonForDownload=\(reasonForDownload)&userNeedsMet=\(appSuitUserNeeds)&feedback=\(feedback)"
        println(bodyData)
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                println("error=\(error)")
                return
            }
            
            // You can print out response object
            println("response = \(response)")
            
            // Print out response body
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
            
            //Let's convert response sent from a server side script to a NSDictionary object:
            
            var err: NSError?
            var myJSON = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error:&err) as? NSDictionary
            
            if let parseJSON = myJSON {
                println("Success!")
            }
            
        }
        
        task.resume()
        
        
    }

    

    

}
