//
//  LocationManager.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/17/23.
//

import Foundation
import CoreLocation
import Combine
import SwiftUI

class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
//    @FetchRequest(sortDescriptors: [SortDescriptor(\.albumName)]) var albums: FetchedResults<Album>
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    var regionList: [CLCircularRegion] = [CLCircularRegion]()
    var regionEnteredHandler: ((String) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
//        albums.forEach{ album in
//            locationManager.startMonitoring(for: CLCircularRegion(center: CLLocationCoordinate2D(latitude: album.latitude, longitude: album.longitude), radius: locationManager.maximumRegionMonitoringDistance, identifier: album.idAlbum!.uuidString))
//            print(album.albumName)
//        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            // Insert code here of what should happen when Location services are authorized
            
            authorizationStatus = .authorizedWhenInUse
//            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
            
            
//            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -6.3058101, longitude: 106.6526647), radius: 100, identifier: "Ur ID")
//            region.notifyOnExit = true
//            region.notifyOnEntry = true
//            manager.startMonitoring(for: region)
            break
            
        case .restricted:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .restricted
            break
            
        case .denied:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .denied
            break
            
        case .notDetermined:        // Authorization not determined yet.
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    func startMonitoring(regions: [CLRegion]) {
        for region in regions {
            locationManager.startMonitoring(for: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Insert code to handle location updates
//        print(locations.last!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        // User has exited from ur regiom
        print("exited from region \(region.identifier)")
        regionEnteredHandler?("")
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // User has exited from ur region
        print("entered to region \(region.identifier)")
        regionEnteredHandler?(region.identifier)
        
    }
    
    
}


