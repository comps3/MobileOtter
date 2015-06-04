//
//  CampusDatabaseConnection.swift
//  MobileOtter
//
//  Created by Brian Huynh on 6/3/15.
//  Copyright (c) 2015 Brian Huynh. All rights reserved.
//

import Foundation

class CampusDatabaseConnection {
    
    let buildingDatabaseURL = "http://hosting.otterlabs.org/huynhbrian/mobileotter/buildingsInfo.php"
    let parkingLotDatabaseURL = "http://hosting.otterlabs.org/huynhbrian/mobileotter/parkingInfo.php"
    
    var foundPlaces: [Place] = []
    
    func fetchBuildingsInfo() -> [Place] {
        var parseError: NSError?
        if let url = NSURL(string: buildingDatabaseURL) {
            if let jsonData = NSData(contentsOfURL: url) {
                if let buildingInfoInJSON: AnyObject = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &parseError) {
                    if let buildingInfo = buildingInfoInJSON as? NSArray {
                        for building in buildingInfo {
                            let name = building["name"] as! NSString
                            let long = (building["longitude"] as! NSString).doubleValue
                            let lat = (building["latitude"] as! NSString).doubleValue
                            let description = building["description"] as! String
                            
                            foundPlaces.append(Place(name: name, long: long, lat: lat, description: description))
                        }
                    }
                }
                else {
                    println("Error in JSON parsing: \(parseError!.localizedDescription)")
                }
            }
        }
        return foundPlaces
    }
    
    func fetchParkingInfo() -> [Place] {
        
        var parseError: NSError?
        if let url = NSURL(string: parkingLotDatabaseURL) {
            if let jsonData = NSData(contentsOfURL: url) {
                if let parkingInfoInJSON: AnyObject = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &parseError) {
                    if let parkingInfo = parkingInfoInJSON as? NSArray {
                        for parking in parkingInfo {
                            let lotNumber = parking["lot"] as! String
                            let parkingLong = (parking["longitude"] as! NSString).doubleValue
                            let parkingLat = (parking["latitude"] as! NSString).doubleValue
                            foundPlaces.append(Place(name: "Lot \(lotNumber)", long: parkingLong, lat: parkingLat, description: ""))
                        }
                    }
                }
                else {
                    println("Error in JSON parsing: \(parseError!.localizedDescription)")
                }
            }
        }
        return foundPlaces
    }
    
}