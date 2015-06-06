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
    let athleticsDatabaseURL = "http://hosting.otterlabs.org/huynhbrian/mobileotter/athleticsInfo.php"
    
    var buildings: [Building] = []
    var parking: [Parking] = []
    var athletics: [Athletics] = []
    
    func fetchBuildingsInfo() -> [Building]? {
        var parseError: NSError?
        if let url = NSURL(string: buildingDatabaseURL) {
            if let jsonData = NSData(contentsOfURL: url) {
                if let buildingInfoInJSON: AnyObject = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &parseError) {
                    if let buildingInfo = buildingInfoInJSON as? NSArray {
                        for item in buildingInfo {
                            let id = (item["id"] as! String).toInt()!
                            let type = (item["bType"] as! String).toInt()!
                            let name = item["name"] as! String
                            let long = (item["longitude"] as! NSString).doubleValue
                            let lat = (item["latitude"] as! NSString).doubleValue
                            let description = item["description"] as! String
                            
                            buildings.append(Building(id: id, type: type, name: name, long: long, lat: lat, description: description))
                        }
                    }
                }
                else {
                    println("Error in JSON parsing: \(parseError!.localizedDescription)")
                    return nil
                }
            }
        }
       return buildings
    }
    
    func fetchParkingInfo() -> [Parking]? {
        
        var parseError: NSError?
        if let url = NSURL(string: parkingLotDatabaseURL) {
            if let jsonData = NSData(contentsOfURL: url) {
                if let parkingInfoInJSON: AnyObject = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &parseError) {
                    if let parkingInfo = parkingInfoInJSON as? NSArray {
                        for item in parkingInfo {
                            let lotNumber = (item["lot"] as! String).toInt()!
                            let parkingLong = (item["longitude"] as! NSString).doubleValue
                            let parkingLat = (item["latitude"] as! NSString).doubleValue
                            self.parking.append(Parking(name: lotNumber, long: parkingLong, lat: parkingLat, description: ""))
                        }
                    }
                }
                else {
                    println("Error in JSON parsing: \(parseError!.localizedDescription)")
                    return nil
                }
            }
        }
        return self.parking
    }
    
    func fetchAthleticsInfo() -> [Athletics]? {
        var parseError: NSError?
        if let url = NSURL(string: athleticsDatabaseURL) {
            if let jsonData = NSData(contentsOfURL: url) {
                if let athleticsInfoInJSON: AnyObject = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &parseError) {
                    if let athleticsInfo = athleticsInfoInJSON as? NSArray {
                        for item in athleticsInfo {
                            let name = item["name"] as! String
                            let longitude = (item["longitude"] as! NSString).doubleValue
                            let latitude = (item["latitude"] as! NSString).doubleValue
                            let description = item["description"] as! String
                            self.athletics.append(Athletics(name: name, long: longitude, lat: latitude, description: description))
                        }
                    }
                }
                else {
                    println("Error in JSON parsing: \(parseError!.localizedDescription)")
                    return nil
                }
            }
        }
       return self.athletics
    }
    
    func searchPlaces(searchTerm: String) -> [Place]? {
        var desiredPlaces = [Place]()
        if let numericSearchTerm = searchTerm.toInt() {
            println(numericSearchTerm)
            for lot in parking {
                if lot.name == numericSearchTerm {
                    desiredPlaces.append(Place(type: 3, name: "Lot \(lot.name)", latitude: lot.lat, longitude: lot.long, description: lot.description))
                }
            }
            for building in buildings {
                if building.id == numericSearchTerm {
                    desiredPlaces.append(Place(type: 2, name: building.name, latitude: building.lat, longitude: building.long, description: building.description))
                }
            }
        }
        
        else {
            if searchTerm.lowercaseString == "halls" || searchTerm.lowercaseString == "residence" || searchTerm.lowercaseString == "dorm" || searchTerm.lowercaseString == "dorms" {
                // Load all residence halls into desired places
                println("Load the dorms!")
                for item in buildings {
                    if item.type == 2 {
                        // Types are conflicting
                        desiredPlaces.append(Place(type: 2, name: item.name, latitude: item.lat, longitude: item.long, description: item.description))
                    }
                }
            }
            else if searchTerm.lowercaseString == "sports" || searchTerm.lowercaseString == "recreation" {
                // Load all sports buildings into desired places
                println("Load the athletics")
                for item in athletics {
                    desiredPlaces.append(Place(type: 1, name: item.name, latitude: item.lat, longitude: item.long, description: item.description))
                }
            }
            else {
                for building in buildings {
                    if building.name.lowercaseString.rangeOfString(searchTerm) != nil {
                        desiredPlaces.append(Place(type: 2, name: building.name, latitude: building.lat, longitude: building.long, description: building.description))
                    }
                }
                for athletic in athletics {
                    if athletic.name.lowercaseString.rangeOfString(searchTerm) != nil {
                        desiredPlaces.append(Place(type: 1, name: athletic.name, latitude: athletic.lat, longitude: athletic.long, description: athletic.description))
                    }
                }
            }
        }
        
        if desiredPlaces.isEmpty {
            return nil
        }
        return desiredPlaces
    }
    
}