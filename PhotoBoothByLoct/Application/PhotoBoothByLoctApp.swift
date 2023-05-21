//
//  PhotoBoothByLoctApp.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/17/23.
//

import SwiftUI

@main
struct PhotoBoothByLoctApp: App {
    @StateObject private var albumDataController = AlbumDataController()
    
    var body: some Scene {
        WindowGroup {
            HomepageView()
                .environment(\.managedObjectContext, albumDataController.container.viewContext)
//            ContentView()
        }
    }
}
