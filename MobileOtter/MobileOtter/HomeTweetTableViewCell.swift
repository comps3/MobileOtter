//
//  HomeTweetTableViewCell.swift
//  MobileOtter
//
//  Created by Brian Huynh on 5/26/15.
//  Copyright (c) 2015 Brian Huynh. All rights reserved.
//

import UIKit

class HomeTweetTableViewCell: UITableViewCell {
    
    // Elements of custom table view cell
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var userTweet: UITextView!
    @IBOutlet weak var timeStamp: UILabel!
   
}
