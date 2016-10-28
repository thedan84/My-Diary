//
//  LocationManager.swift
//  My Diary
//
//  Created by Dennis Parussini on 28-10-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
    func locationManagerDidUpdateLocation(manager: LocationManager, location: CLLocation)
    func locationManagerDidFailWithError(manager: LocationManager, error: Error)
}

class LocationManager: NSObject {
    var locationManager = CLLocationManager()
    var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    func getLocation() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        self.delegate?.locationManagerDidUpdateLocation(manager: self, location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.locationManagerDidFailWithError(manager: self, error: error)
    }
}
