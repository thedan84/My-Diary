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
}

class LocationManager: NSObject {
    var locationManager = CLLocationManager()
    var delegate: LocationManagerDelegate?
    
    func getLocation(completion: (Void) -> Void) {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.delegate?.locationManagerDidUpdateLocation(manager: self, location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unresolved error: \(error)")
    }
}
