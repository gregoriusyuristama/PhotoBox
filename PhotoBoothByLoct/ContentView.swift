//
//  ContentView.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/17/23.
//

import SwiftUI
import MapKit
//import CoreLocationUI

struct ContentView: View {
    @StateObject var locationDataManager = LocationDataManager()
//    @StateObject var locationViewModel = LocationViewModel()
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    
    var body: some View {
        
//        var region: Binding<MKCoordinateRegion>? {
//            guard let location = locationDataManager.locationManager.location else {
//                return MKCoordinateRegion.goldenGateRegion().getBinding()
//            }
//
//            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
//
//            return region.getBinding()
//        }
        VStack {
            Map(coordinateRegion: $mapRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow))


            switch locationDataManager.locationManager.authorizationStatus {
            case .authorizedWhenInUse:  // Location services are available.
                // Insert code here of what should happen when Location services are authorized
                Text("Your current location is:")
                Text("Latitude: \(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")")
                Text("Longitude: \(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")")
                Button{
//                    locationViewModel.latitude = (locationDataManager.locationManager.location?.coordinate.latitude.description)!
//                    locationViewModel.longitude = (locationDataManager.locationManager.location?.coordinate.longitude.description)!
//                    locationViewModel.saveResult()
                }label: {
                    Text("Save Location")
                }
                Button{
                    locationDataManager.locationManager.requestLocation()
//                    locationViewModel.latitude = (locationDataManager.locationManager.location?.coordinate.latitude.description)!
//                    locationViewModel.longitude = (locationDataManager.locationManager.location?.coordinate.longitude.description)!
//                    locationViewModel.saveResult()
                }label: {       
                    Text("Refresh Location")
                }
                
            case .restricted, .denied:  // Location services currently unavailable.
                // Insert code here of what should happen when Location services are NOT authorized
                Text("Current location data was restricted or denied.")
            case .notDetermined:        // Authorization not determined yet.
                Text("Finding your location...")
                ProgressView()
            default:
                ProgressView()
            }
//            if !locationViewModel.isEmptyHistory(){
//                List(locationViewModel.savedLocationModelIndex) { loc in
//                    Text("\(loc.latitude), \(loc.longitude)")
//                }
//
//            }
        }
    }
}
//extension MKCoordinateRegion {
//
//    static func goldenGateRegion() -> MKCoordinateRegion {
//        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.819527098978355, longitude:  -122.47854602016669), latitudinalMeters: 5000, longitudinalMeters: 5000)
//    }
//
//    func getBinding() -> Binding<MKCoordinateRegion>? {
//        return Binding<MKCoordinateRegion>(.constant(self))
//    }
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
