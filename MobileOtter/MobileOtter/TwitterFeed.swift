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

    var twitterConnection: Swifter?
    var cleanedTweets: [(profileImageUrl :String, fullName:String, screenName:String, tweet:String)] = []
    
    func connectToTwitter() {
        println("Connecting to Twitter...")
        let twitterConsumerKey = valueForAPIKey("TWITTER_CONSUMER_KEY")
        let twitterConsumerSecret = valueForAPIKey("TWITTER_CONSUMER_SECRET")
        
        twitterConnection = Swifter(consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    }
    
    // Fetches API Keys from plist file
    private func valueForAPIKey(keyname:String) -> String {
        let filePath = NSBundle.mainBundle().pathForResource("ApiKeys", ofType:"plist")
        let plist = NSDictionary(contentsOfFile:filePath!)
        let value:String = plist?.objectForKey(keyname) as! String
        println("Fetched API key from plist")
        return value
    }
    
    func fetchCSUMBTweets() {
        
        println("Pulling tweets from Twitter @csumb")
    
        let failureHandler: ((NSError) -> Void) = {
            error in
            println("\(error.localizedDescription)")
        }
        
        // Set parameters to fetch tweets from CSUMB's timeline
        // CSUMB's User ID: 18624536
        self.twitterConnection!.getStatusesUserTimelineWithUserID("18624536", count: 50, sinceID: nil, maxID: nil, trimUser: nil, contributorDetails: nil, includeEntities: false, success: {( rawTweets: [JSONValue]?) in
            if let tweets = rawTweets {
                for i in 0..<tweets.count {
                    if let tweetName = tweets[i]["retweeted_status"]["user"]["name"].string {
                        println("Name: \(tweetName)")
                        if let tweetScreen = tweets[i]["retweeted_status"]["user"]["screen_name"].string
                        {
                            println("Screen Name: \(tweetScreen)")
                            if let tweet = tweets[i]["retweeted_status"]["text"].string {
                                println("Tweet: \(tweet)")
                                if let userImg = tweets[i]["retweeted_status"]["user"]["profile_image_url"].string {
                                    println("Profile URL: \(userImg)")
                                }
                            }
                        }
                    }
                    else if tweets[i]["retweeted_status"].string == nil {
                        let sTweet = tweets[i]["retweeted_status"].string
                        println(sTweet)
                    }
                    
//                        if let profileImgUrl = tweets[i]["retweeted_status"]["profile_image_url"].string {
//                            if let name = tweets[i]["retweeted_status"]["user"]["name"].string {
//                                if let screen_name = tweets[i]["retweeted_status"]["user"]["screen_name"].string {
//                                    if let tweet = tweets[i]["retweeted_status"]["text"].string {
//                                        self.cleanedTweets.append((profileImageUrl: profileImgUrl, fullName: name, screenName: screen_name, tweet: tweet))
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    else {
//                        if let profileImgUrl = tweets[i]["profile_image_url"].string {
//                            println("Found CSUMB tweet. Tweet #\(i)")
//                            if let name = tweets[i]["user"]["name"].string {
//                                if let screen_name = tweets[i]["user"]["screen_name"].string {
//                                    if let tweet = tweets[i]["text"].string {
//                                        self.cleanedTweets.append((profileImageUrl: profileImgUrl, fullName: name, screenName: screen_name, tweet: tweet))
//                                    }
//                                }
//                            }
//                        }
                    }
                }
    
        }, failure: failureHandler)
    }
    
}

