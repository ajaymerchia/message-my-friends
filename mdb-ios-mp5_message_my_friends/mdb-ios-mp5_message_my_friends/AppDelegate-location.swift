//
//  AppDelegate-location.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/3/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import CoreLocation

extension AppDelegate: CLLocationManagerDelegate {
    func setUpLocationManagerSubscriber() {
        locationManager = CLLocationManager()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = CLLocationDistance(exactly: 100)!
        updateLocationFrom(manager: locationManager)

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateLocationFrom(manager: manager)
        
    }
    
    func updateLocationFrom(manager: CLLocationManager) {
        guard let uid = LocalData.getLocalData(forKey: .uid) else { return }
        guard let newLocation = manager.location else { return }
        
        FirebaseAPI.update(location: newLocation, for: uid, completion: {})
    }
}
