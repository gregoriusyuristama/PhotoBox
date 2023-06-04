//
//  AlbumDataController.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/21/23.
//

import Foundation
import CoreData

class AlbumDataController: ObservableObject {
    let container = NSPersistentContainer(name: "AlbumModel")
    
    init() {
        container.loadPersistentStores{ desc, error in
            if let error = error {
                print("Failed to load data \(error.localizedDescription)")
            }
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
    private func save(context: NSManagedObjectContext){
        do {
            try context.save()
            print("Data Saved!! Woohoo")
        } catch {
            print("Could not save the data...")
        }
    }
    
    func addAlbum(name: String, latitude: Double, longitude: Double, context: NSManagedObjectContext){
        let album = Album(context: context)
        album.idAlbum = UUID()
        album.albumName = name
        album.latitude = latitude
        album.longitude = longitude
        
        save(context: context)
    }
    
    func editAlbum(album: Album, name: String, context: NSManagedObjectContext){
        album.albumName = name
        
        save(context: context)
    }
    func deleteAlbum(album: Album, context: NSManagedObjectContext){
        context.delete(album)
        save(context: context)
    }
    
    func addPhoto(album: Album, photo: Data, context: NSManagedObjectContext){
        let newPhoto = Photos(context: context)
        newPhoto.photosToAlbum = album
        newPhoto.id = UUID()
        newPhoto.photo = photo
        save(context: context)
    }
    
    func addNewPhotoWithID(withID id: String, photo: Data, context: NSManagedObjectContext) {
//           let context = persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Album> = Album.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
           if let existingAlbum = try? context.fetch(fetchRequest).first {
               // Item with the given ID already exists, you can update its properties if needed.
               // For example: existingItem.name = newName
               let newPhoto = Photos(context: context)
               newPhoto.id = UUID()
               newPhoto.photo = photo
               save(context: context)
           }
       }
    
    func deletePhoto(photo: Photos, context: NSManagedObjectContext){
        context.delete(photo)
        save(context: context)
    }
}

