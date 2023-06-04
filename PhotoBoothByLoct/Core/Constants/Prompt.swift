//
//  Prompt.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/29/23.
//

import Foundation
import SwiftUI

struct Prompt { private init() {} }

extension Prompt {
    struct Empty{
        static let noPhotosTitle = "No Collection"
        static let noPhotosCaption = "You can add new photos when on album location and by tapping button \(Image(systemName: "camera")) above"
        
        static let noCollectionTitle = "No Collection"
        static let noCollectionCaption = "You can add new collection by tapping button \(Image(systemName: "plus")) above"
//        static let
    }
    
    struct Title{
        static let mapViewTitle = "Places of Memories"
        static let collectionViewSubtitle = "Your Collections"
        static let collectionViewTitle = "GeoBooth"
        static let addButtonText = "Add Album"
    }
    
    struct Welcome{
        
        static let welcomeTitle = "Welcome to\nGeoBooth"
        
        static let welcomePointOne = "Location Based Album"
        static let welcomeCaptionOne = "Save your photo collection based on location you’ve visited."
        
        static let welcomePointTwo = "Map"
        static let welcomeCaptionTwo = "Revisit your collection by looking at the map provided on the app."
        
        static let welcomePointThree = "Photo Booth"
        static let welcomeCaptionThree = "Customize you photo experience by using photo booth filter."
        
        static let welcomeButtonText = "Continue"
        
    }
    
    struct AlbumView {
        static let renameTitle = "Rename Album"
        static let deleteTitle = "Delete Album"
        static let deleteConfirmation = "Are you sure want to delete this album?"
        
        static let deleteWarning = "You cannot undo this action"
        static let renameTitlePrompt = "New album name"
        
        static let lockedTitle = "Locked"
        static let lockedCaption = "You are outside GeoBooth location, camera locked"
        
    }
    
    struct AddAlbum {
        
        static let addAlbumNameHint = "Album Name"
        static let addAlbumActionText = "Add New Album"
        
    }
    
    struct DetailedPhoto{
        static let deletePrompt = "Delete Photo"
    }
}
