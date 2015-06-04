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
    var foundPlaces: [Place] = []
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
        
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
    
        view.addSubview(mapView!)
        view.bringSubviewToFront(campusMapBar)
        
        loadPlacesFromDatabase(campusInfo.fetchBuildingsInfo())
        loadPlacesFromDatabase(campusInfo.fetchParkingInfo())
        loadMarkersOntoMapView(foundPlaces)
     
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility Methods
    func loadPlacesFromDatabase(places: [Place]) {
        for place in places {
            foundPlaces.append(place)
        }
    }
    
    func loadMarkersOntoMapView(places: [Place]) {
        for place in places {
            var marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(place.lat, place.long)
            marker.title = place.name as! String
            marker.snippet = place.description
            marker.map = mapView
        }
    }
    
    // MARK: - Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        
    }
    
    @IBAction func centerCameraOnCurrentLocation() {
        isUserLocationCenterOfCamera = false
        mapView.animateToCameraPosition(GMSCameraPosition.cameraWithTarget(userLocation, zoom: 15.0)
)
    }
    

}
