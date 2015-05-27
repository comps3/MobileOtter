//
//  Tweets.swift
//  MobileOtter
//
//  Created by Brian Huynh on 5/26/15.
//  Copyright (c) 2015 Brian Huynh. All rights reserved.
//

import Foundation
import SwifteriOS

class Tweets {
    
    var twitterConnection = Swifter(consumerKey: "f7acy8W7k4xGGrMEm2SUA9PCb", consumerSecret: "3hu3lB2eWVS5YoaafMWwVMt3kniUN3Pp0bU5sZr5qvn3agsf2i")
    
    func fetchCSUMBTweets() -> JSON? {
        let failureHandler: ((NSError) -> Void) = {
            error in
            self.alertWithTitle("Error", message: error.localizedDescription)
        }
        
    }
    
    
}