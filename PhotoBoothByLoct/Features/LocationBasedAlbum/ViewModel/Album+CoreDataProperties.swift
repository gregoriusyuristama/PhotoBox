//
//  Album+CoreDataProperties.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/22/23.
//
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var albumName: String?
    @NSManaged public var idAlbum: UUID?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var albumToPhotos: Set<Photos>?
    
    public var photos: [Photos]{
        let setOfPhotos = albumToPhotos
        if let setPhotos = setOfPhotos{
            return setPhotos.sorted{
                $0.id > $1.id
            }
        }else{
            return []
        }
    }

}

// MARK: Generated accessors for albumToPhotos
extension Album {

    @objc(addAlbumToPhotosObject:)
    @NSManaged public func addToAlbumToPhotos(_ value: Photos)

    @objc(removeAlbumToPhotosObject:)
    @NSManaged public func removeFromAlbumToPhotos(_ value: Photos)

    @objc(addAlbumToPhotos:)
    @NSManaged public func addToAlbumToPhotos(_ values: NSSet)

    @objc(removeAlbumToPhotos:)
    @NSManaged public func removeFromAlbumToPhotos(_ values: NSSet)

}

extension Album : Identifiable {

}
