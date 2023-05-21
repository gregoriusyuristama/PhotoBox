//
//  RegionModel.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/21/23.
//

import Foundation
import CoreLocation

struct RegionData {
    let center: CLLocationCoordinate2D
    let radius: CLLocationDistance
    let identifier: String
}
