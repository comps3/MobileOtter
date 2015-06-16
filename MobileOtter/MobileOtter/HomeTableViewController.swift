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
    var tweetArray: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sets the color of navigation bar
        let redValue = CGFloat(34.0/255.0)
        let greenValue = CGFloat(52.0/255.0)
        let blueValue = CGFloat(106.0/255.0)
        self.tableView.rowHeight = 95
        navigationController?.navigationBar.barTintColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // Intializes a connection to Twitter
        connectToTwitter()
        // Begin fetching CSUMB Tweets
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
        // Twitter API: /statuses/user_timeline.json
        self.twitterConnection!.getStatusesUserTimelineWithUserID("18624536", count: 50, sinceID: nil, maxID: nil, trimUser: nil, contributorDetails: nil, includeEntities: false, success: {( rawTweets: [JSONValue]?) in
            // Loops through tweets pulled from CSUMB's Timeline
            if let tweets = rawTweets {
                for i in 0..<tweets.count {
                    // Display the original person if their tweet was retweeted
                    if let name = tweets[i]["retweeted_status"]["user"]["name"].string {
                        if let screen_name = tweets[i]["retweeted_status"]["user"]["screen_name"].string {
                            if let tweet = tweets[i]["retweeted_status"]["text"].string {
                                if let userImage = tweets[i]["retweeted_status"]["user"]["profile_image_url"].string {
                                    if let tweetTimestamp = tweets[i]["retweeted_status"]["created_at"].string {
                                        if let finalTimestamp = self.convertTweetTimestampToUsableDate(tweetTimestamp) {
                                            self.tweetArray.append(Tweet(profileImageURL: userImage, name: name, screenName: screen_name, tweet: tweet, timeStamp: finalTimestamp))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else {
                        // Display CSUMB's tweets
                        if let csumbImage = tweets[i]["user"]["profile_image_url"].string {
                            if let csumbName = tweets[i]["user"]["name"].string {
                                if let csumbScreenName = tweets[i]["user"]["screen_name"].string {
                                    if let csumbText = tweets[i]["text"].string {
                                       if let tweetTimestamp = tweets[i]["created_at"].string {
                                            if let finalTimestamp = self.convertTweetTimestampToUsableDate(tweetTimestamp) {
                                                self.tweetArray.append(Tweet(profileImageURL: csumbImage, name: csumbName, screenName: csumbScreenName, tweet: csumbText, timeStamp: finalTimestamp))
                                            }
                                       }
                                    }
                                }
                             }
                          }
                    }
                    // Interesting stuff...
                    NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                        self.tableView.reloadData()
                    }
                }
                
            }
            
            }, failure: failureHandler)
    }
    
    // Converts timestamp from JSON to iOS Date Standard
    func convertTweetTimestampToUsableDate(tweetDate: String) -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        if let date = dateFormatter.dateFromString(tweetDate) {
            let currentDate = NSDate()
            let secondsFromCreation = Int(currentDate.timeIntervalSinceDate(date))
            println("Seconds from creation \(secondsFromCreation)")
            
            if secondsFromCreation > 86458 {
                let calendar = NSCalendar.currentCalendar()
                let dateComponents = calendar.components(.CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitYear, fromDate: date)
                println("Month: \(dateComponents.month)")
                println("Day: \(dateComponents.day)")
                println("Year: \(dateComponents.year)")
                return "\(dateComponents.month)/\(dateComponents.day)/\(dateComponents.year)"
            }
            
            switch secondsFromCreation {
                case 0...59: println("Seconds: \(secondsFromCreation)"); return "\(secondsFromCreation) sec"
                case 60...3599: println("Minutes: \(Int(secondsFromCreation / 60))"); return "\(Int(secondsFromCreation / 60)) min"
                case 3600...86458: println("Hours: \(Int(secondsFromCreation / 3600)) hr"); return "\(Int(secondsFromCreation / 3600)) hr"
                default: println("Houston, we may have a problem...")
            }
            
            
        }
        return nil
    }
    
    func fetchImageFromURL(url: String) -> UIImage? {
        if let imageURL = NSURL(string: url) {
            if let imageData = NSData(contentsOfURL: imageURL) {
                if let finalImage = UIImage(data: imageData) {
                    return finalImage
                }
            }
        }
        return nil
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

        cell.userProfileImage.image = fetchImageFromURL(tweetArray[indexPath.row].profileImageURL)
        cell.userProfileImage.layer.cornerRadius = 8.0
        cell.userProfileImage.clipsToBounds = true
    
        cell.userFullName.text = tweetArray[indexPath.row].name
        cell.userHandle.text = "@\(tweetArray[indexPath.row].screenName)"
        cell.userTweet.text = tweetArray[indexPath.row].tweet
        //println(tweetArray[indexPath.row].timeStamp)
        cell.timeStamp.text = tweetArray[indexPath.row].timeStamp
        return cell
    }

}
