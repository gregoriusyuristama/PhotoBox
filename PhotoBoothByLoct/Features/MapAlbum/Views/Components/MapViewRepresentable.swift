//
//  MapViewRepresentable.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/20/23.
//

import SwiftUI

import SwiftUI
import MapKit

// MARK: - MKMapViewRepresentable

struct MKMapViewRepresentable: UIViewRepresentable {
    
    var userTrackingMode: Binding<MKUserTrackingMode>
    
    @EnvironmentObject private var mapViewContainer: MapViewContainer
    @State private var annotations: [AnnotationItem] = [AnnotationItem()]
    //    @StateObject private var authStatus = locationdata
    
    func makeUIView(context: UIViewRepresentableContext<MKMapViewRepresentable>) -> MKMapView {
        mapViewContainer.mapView.delegate = context.coordinator
        
        context.coordinator.followUserIfPossible()
        
        return mapViewContainer.mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: UIViewRepresentableContext<MKMapViewRepresentable>) {
        if mapView.userTrackingMode != userTrackingMode.wrappedValue {
            mapView.setUserTrackingMode(userTrackingMode.wrappedValue, animated: true)
        }
        mapView.addAnnotations(annotations.map { annotationItem in
            let annotation = MKPointAnnotation()
            annotation.coordinate = annotationItem.coordinate
            return annotation
        })
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        let coordinator = MapViewCoordinator(self)
        return coordinator
    }
    
    // MARK: - Coordinator
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        
        var control: MKMapViewRepresentable
        
        //        let locationManager = CLLocationManager()
        @State var locationDataManager = LocationDataManager()
        
        init(_ control: MKMapViewRepresentable) {
            self.control = control
            
            super.init()
            
            //            setupLocationManager()
        }
        
        //        func setupLocationManager() {
        //            locationDataManager.locationManager.delegate = self
        //            locationDataManager.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //            locationDataManager.locationManager.pausesLocationUpdatesAutomatically = true
        //        }
        
        func followUserIfPossible() {
            switch locationDataManager.locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                control.userTrackingMode.wrappedValue = .follow
            default:
                break
            }
        }
        
        private func present(_ alert: UIAlertController, animated: Bool = true, completion: (() -> Void)? = nil) {
            // UIApplication.shared.keyWindow has been deprecated in iOS 13,
            // so you need a little workaround to avoid the compiler warning
            // https://stackoverflow.com/a/58031897/10967642
            
            let keyWindow = UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .last { $0.isKeyWindow }
            keyWindow?.rootViewController?.present(alert, animated: animated, completion: completion)
        }
        
        // MARK: MKMapViewDelegate
        
        func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
#if DEBUG
            print("\(type(of: self)).\(#function): userTrackingMode=", terminator: "")
            switch mode {
            case .follow:            print(".follow")
            case .followWithHeading: print(".followWithHeading")
            case .none:              print(".none")
            @unknown default:        print("@unknown")
            }
#endif
            
            DispatchQueue.global().async {
                if CLLocationManager.locationServicesEnabled() {
                    switch mode {
                    case .follow, .followWithHeading:
                        switch self.locationDataManager.locationManager.authorizationStatus {
                        case .notDetermined:
                            self.locationDataManager.locationManager.requestWhenInUseAuthorization()
                        case .restricted:
                            // Possibly due to active restrictions such as parental controls being in place
                            let alert = UIAlertController(title: "Location Permission Restricted", message: "The app cannot access your location. This is possibly due to active restrictions such as parental controls being in place. Please disable or remove them and enable location permissions in settings.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                                // Redirect to Settings app
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            })
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                            
                            self.present(alert)
                            
                            DispatchQueue.main.async {
                                self.control.userTrackingMode.wrappedValue = .none
                            }
                        case .denied:
                            let alert = UIAlertController(title: "Location Permission Denied", message: "Please enable location permissions in settings.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                                // Redirect to Settings app
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            })
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                            self.present(alert)
                            
                            DispatchQueue.main.async {
                                self.control.userTrackingMode.wrappedValue = .none
                            }
                        default:
                            DispatchQueue.main.async {
                                self.control.userTrackingMode.wrappedValue = mode
                            }
                        }
                    default:
                        DispatchQueue.main.async {
                            self.control.userTrackingMode.wrappedValue = mode
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services in settings.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                        // Redirect to Settings app
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    })
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    self.present(alert)
                    
                    DispatchQueue.main.async {
                        self.control.userTrackingMode.wrappedValue = mode
                    }
                }
            }
            
            
        }
        
        // MARK: CLLocationManagerDelegate
        
        //        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //            #if DEBUG
        //            print("\(type(of: self)).\(#function): status=", terminator: "")
        //            switch status {
        //            case .notDetermined:       print(".notDetermined")
        //            case .restricted:          print(".restricted")
        //            case .denied:              print(".denied")
        //            case .authorizedAlways:    print(".authorizedAlways")
        //            case .authorizedWhenInUse: print(".authorizedWhenInUse")
        //            @unknown default:          print("@unknown")
        //            }
        //            #endif
        //
        //            switch status {
        //            case .authorizedAlways, .authorizedWhenInUse:
        //                locationDataManager.locationManager.startUpdatingLocation()
        //                control.mapViewContainer.mapView.setUserTrackingMode(control.userTrackingMode.wrappedValue, animated: true)
        //            default:
        //                control.mapViewContainer.mapView.setUserTrackingMode(.none, animated: true)
        //            }
        //        }
        
    }
    
}

struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate = CLLocationCoordinate2D(latitude: -6.3058101, longitude: 106.6526647)
}
