//
//  LocationViewModel.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/17/23.
//

import Foundation
class LocationViewModel: ObservableObject {
    var locationModelRepository = LocationModelRepository()

    // UI control
    @Published var savedLocationModelIndex = [LocationModel]()
    @Published var latitude = ""
    @Published var longitude = ""
    
    func saveResult() {
        let newLocationModel = LocationModel(savedAt: Date(), latitude: latitude, longitude: longitude)
        locationModelRepository.add(newLocationModel)
        updateSavedHistories()
    }
    
    func updateSavedHistories() {
        self.savedLocationModelIndex = locationModelRepository.savedLocationModel
    }
    
    func isEmptyHistory() -> Bool {
        return locationModelRepository.savedLocationModel.count == 0
    }
}
