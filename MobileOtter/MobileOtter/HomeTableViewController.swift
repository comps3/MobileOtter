//
//  HomeTableViewController.swift
//  MobileOtter
//
//  Created by Brian Huynh on 5/26/15.
//  Copyright (c) 2015 Brian Huynh. All rights reserved.
//

import UIKit
import SwifteriOS

class HomeTableViewController: UITableViewController {
    
    let twitterFeed = TwitterFeed()
    var tweetArray: [JSONValue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let redValue = CGFloat(34.0/255.0)
        let greenValue = CGFloat(52.0/255.0)
        let blueValue = CGFloat(106.0/255.0)
        navigationController?.navigationBar.barTintColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        if let tweets = twitterFeed.fetchCSUMBTweets() {
            tweetArray = tweets
        }
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("csumbTweets", forIndexPath: indexPath) as! HomeTweetTableViewCell
        // Load an image from URL into UIImageView

        return cell
    }

}