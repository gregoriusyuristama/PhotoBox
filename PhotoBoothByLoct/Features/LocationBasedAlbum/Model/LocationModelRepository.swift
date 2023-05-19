//
//  LocationModelRepository.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/17/23.
//

import Foundation


struct LocationModelRepository {
    var savedLocationModel :[LocationModel] = []
    
    mutating func add(_ locationModel: LocationModel) {
        savedLocationModel.insert(locationModel, at: 0)
    }
}
