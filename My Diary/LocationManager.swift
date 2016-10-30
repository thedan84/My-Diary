//
//  LocationManager.swift
//  My Diary
//
//  Created by Dennis Parussini on 28-10-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    var locationManager = CLLocationManager()
    var onLocationFix: ((CLLocation) -> Void)?
    
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
    
    func loadLocationForEntry(entry: Entry) -> CLLocation? {
        guard let location = entry.location else { return nil }
        
        return CLLocation(latitude: location.latitude, longitude: location.longitude)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        if let onLocationFix = onLocationFix {
            onLocationFix(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error)")
    }
}
