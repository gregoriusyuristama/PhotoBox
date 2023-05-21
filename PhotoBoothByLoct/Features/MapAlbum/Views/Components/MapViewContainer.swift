//
//  MapViewContainer.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/20/23.
//

import SwiftUI
import MapKit

class MapViewContainer: ObservableObject {
    
    @Published public private(set) var mapView = MKMapView(frame: .zero)
    
}
