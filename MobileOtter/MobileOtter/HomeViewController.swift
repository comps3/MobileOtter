//
//  HomeViewController.swift
//  MobileOtter
//
//  Created by Brian Huynh on 5/26/15.
//  Copyright (c) 2015 Brian Huynh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Red, Green and Blue values of Navigation Bar
        // Initializer only takes values from 0.0 to 1.0
        let redValue = CGFloat(34.0/255.0)
        let greenValue = CGFloat(52.0/255.0)
        let blueValue = CGFloat(106.0/255.0)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }

}
