//
//  TwitterFeed.swift
//  MobileOtter
//
//  Created by Brian Huynh on 5/27/15.
//  Copyright (c) 2015 Brian Huynh. All rights reserved.
//

import Foundation
import SwifteriOS

class TwitterFeed {
    
    var twitterConnection = Swifter(consumerKey: "", consumerSecret: "")
    
    func fetchCSUMBTweets() -> [JSONValue]? {
        
        var tweets = [JSONValue]()
    
        let failureHandler: ((NSError) -> Void) = {
            error in
            println("\(error.localizedDescription)")
        }
        
        self.twitterConnection.getStatusesUserTimelineWithUserID("18624536", count: 50, sinceID: nil, maxID: nil, trimUser: nil, contributorDetails: nil, includeEntities: false, success: {( rawTweets: [JSONValue]?) in
            
            if let _ = rawTweets {
                tweets = rawTweets!
            }
            
            }, failure: failureHandler)
        
        if tweets.isEmpty {
            return nil
        }
        else {
            return tweets
        }

    }
}