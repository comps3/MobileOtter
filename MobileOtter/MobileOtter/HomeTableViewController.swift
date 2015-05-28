//
//  HomeTableViewController.swift
//  MobileOtter
//
//  Created by Brian Huynh on 5/26/15.
//  Copyright (c) 2015 Brian Huynh. All rights reserved.
//

import UIKit
import SwifteriOS

class HomeTableViewController: UITableViewController, UITableViewDelegate {
    
    var twitterConnection: Swifter?
    var tweetArray: [(profileImage :UIImage, fullName:String, screenName:String, tweet:String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let redValue = CGFloat(34.0/255.0)
        let greenValue = CGFloat(52.0/255.0)
        let blueValue = CGFloat(106.0/255.0)
        self.tableView.rowHeight = 95
        navigationController?.navigationBar.barTintColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        connectToTwitter()
        fetchCSUMBTweets()
    }
    
    func connectToTwitter() {
        let twitterConsumerKey = valueForAPIKey("TWITTER_CONSUMER_KEY")
        let twitterConsumerSecret = valueForAPIKey("TWITTER_CONSUMER_SECRET")
        
        twitterConnection = Swifter(consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    }
    
    // Fetches API Keys from plist file
    private func valueForAPIKey(keyname:String) -> String {
        let filePath = NSBundle.mainBundle().pathForResource("ApiKeys", ofType:"plist")
        let plist = NSDictionary(contentsOfFile:filePath!)
        let value:String = plist?.objectForKey(keyname) as! String
        return value
    }

    
    func fetchCSUMBTweets() {
        
        let failureHandler: ((NSError) -> Void) = {
            error in
            println("\(error.localizedDescription)")
        }
        
        self.twitterConnection!.getStatusesUserTimelineWithUserID("18624536", count: 50, sinceID: nil, maxID: nil, trimUser: nil, contributorDetails: nil, includeEntities: false, success: {( rawTweets: [JSONValue]?) in
            if let tweets = rawTweets {
                for i in 0..<tweets.count {
                    if let name = tweets[i]["retweeted_status"]["user"]["name"].string {
                        if let screen_name = tweets[i]["retweeted_status"]["user"]["screen_name"].string {
                            if let tweet = tweets[i]["retweeted_status"]["text"].string {
                                if let userImage = tweets[i]["retweeted_status"]["user"]["profile_image_url"].string {
                                    if let imageURL = NSURL(string: userImage) {
                                        if let imageData = NSData(contentsOfURL: imageURL) {
                                            if let finalImage = UIImage(data: imageData) {
                                                 self.tweetArray.append((profileImage: finalImage, fullName: name, screenName: screen_name, tweet: tweet))
                                            }
                                        }
                                   
                                    }
                                }
                            }
                        }
                    }
                    else {
                        if let csumbImage = tweets[i]["user"]["profile_image_url"].string {
                            if let csumbName = tweets[i]["user"]["name"].string {
                                if let csumbScreenName = tweets[i]["user"]["screen_name"].string {
                                    if let csumbText = tweets[i]["text"].string {
                                        if let imageURL = NSURL(string: csumbImage) {
                                            if let imageData = NSData(contentsOfURL: imageURL) {
                                                if let finalImage = UIImage(data: imageData) {
                                                    self.tweetArray.append((profileImage: finalImage, fullName: csumbName, screenName: csumbScreenName, tweet: csumbText))
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                        self.tableView.reloadData()
                    }
                }
                
            }
            
            }, failure: failureHandler)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if tweetArray.isEmpty {
            return 0
        }
        else {
            return tweetArray.count
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("csumbTweet", forIndexPath: indexPath) as! HomeTweetTableViewCell
        // Look through documentation to takes an URL and convert to UIImageView
        cell.userProfileImage.image = tweetArray[indexPath.row].profileImage
        cell.userFullName.text = tweetArray[indexPath.row].fullName
        cell.userHandle.text = "@\(tweetArray[indexPath.row].screenName)"
        cell.userTweet.text = tweetArray[indexPath.row].tweet
        return cell
    }

}
