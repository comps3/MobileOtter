//
//  CampusMapViewController.swift
//  MobileOtter
//
//  Created by Brian Huynh on 5/28/15.
//  Copyright (c) 2015 Brian Huynh. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class CampusMapViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    var camera: GMSCameraPosition!
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D!
    let campusInfo = CampusDatabaseConnection()
    var isUserLocationCenterOfCamera = false
    
    private struct MapSetup {
        static let latitude: CLLocationDegrees = 36.6534
        static let longitude: CLLocationDegrees = -121.7964
        static let zoom: Float = 15
    }
    
    @IBOutlet weak var campusMapBar: UIView!
    @IBOutlet weak var searchBar: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        camera = GMSCameraPosition.cameraWithLatitude(MapSetup.latitude, longitude: MapSetup.longitude, zoom: MapSetup.zoom)
        
        mapView = GMSMapView.mapWithFrame(CGRectMake(0, 0, view.bounds.width, view.bounds.height), camera: camera)
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
    
        view.addSubview(mapView!)
        view.bringSubviewToFront(campusMapBar)
        
        loadBuildingMarkersOntoMapView(campusInfo.fetchBuildingsInfo()!)
        loadParkingMarkersOntoMapView(campusInfo.fetchParkingInfo()!)
        loadAthleticMarkersOntoMapView(campusInfo.fetchAthleticsInfo()!)
     
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility Methods
    
    func loadBuildingMarkersOntoMapView(places: [Building]) {
        for place in places {
            var marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(place.lat, place.long)
            marker.title = place.name
            marker.snippet = place.description
            marker.map = mapView
        }
    }
    
    func loadParkingMarkersOntoMapView(places: [Parking]) {
        for place in places {
            var marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(place.lat, place.long)
            marker.title = "Lot \(place.name)"
            marker.snippet = place.description
            marker.icon = GMSMarker.markerImageWithColor(UIColor.orangeColor())
            marker.map = mapView
        }
    }
    
    func loadAthleticMarkersOntoMapView(places: [Athletics]) {
        for place in places {
            var marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(place.lat, place.long)
            marker.title = place.name
            marker.snippet = place.description
            marker.icon = GMSMarker.markerImageWithColor(UIColor(red: 1.0, green: 0.843137, blue: 0, alpha: 1.0))
            marker.map = mapView
        }
    }
    
    func loadSearchResultsOntoMapView(places: [Place]) {
        for place in places {
            var marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(place.latitude, place.longitude)
            marker.title = place.name
            marker.snippet = place.description
            
            switch place.type {
                case 1: marker.icon = GMSMarker.markerImageWithColor(UIColor(red: 1.0, green: 0.843137, blue: 0, alpha: 1.0))
                case 2: break
                case 3: marker.icon = GMSMarker.markerImageWithColor(UIColor.orangeColor())
                default: println("Houston, the color section has leaked.")
            }
            marker.map = mapView
        }
    }

    
    func resetMap() {
        mapView.clear()
        loadBuildingMarkersOntoMapView(campusInfo.buildings)
        loadParkingMarkersOntoMapView(campusInfo.parking)
        loadAthleticMarkersOntoMapView(campusInfo.athletics)
    }
    
    // MARK: - Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldClear(textField: UITextField) -> Bool {
        textField.text = ""
        resetMap()
        return true;
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            mapView.myLocationEnabled = true
        }
    }
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if !isUserLocationCenterOfCamera {
            let myLocation: CLLocation = change[NSKeyValueChangeNewKey] as! CLLocation
            userLocation = myLocation.coordinate
            isUserLocationCenterOfCamera = true
        }
    }
    
    // MARK: - Action Methods
    @IBAction func userEnteredRequest(sender: UITextField) {
        if let result = campusInfo.searchPlaces(sender.text) {
            mapView.clear()
            loadSearchResultsOntoMapView(result)
        }
        else if sender.text.isEmpty {
            mapView.clear()
            resetMap()
        }
        else {
            let noResults = UIAlertView(title: "No results found", message: "\(sender.text) could not be found.", delegate: nil, cancelButtonTitle: "Exit")
            noResults.show()
        }
        
    }
    
    @IBAction func centerCameraOnCurrentLocation() {
        isUserLocationCenterOfCamera = false
        mapView.animateToCameraPosition(GMSCameraPosition.cameraWithTarget(userLocation, zoom: 15.0))
    }
    

}
