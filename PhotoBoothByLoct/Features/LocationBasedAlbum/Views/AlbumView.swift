//
//  AlbumView.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/19/23.
//

import SwiftUI
import CoreLocation
import UIKit

struct AlbumView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var locationDataManager = LocationDataManager()
    
    @State private var isPresentingConfirm: Bool = false
    @State private var isPresentingRename: Bool = false
    @State private var isPresentingLockedRegion: Bool = false
    @State private var isShowingAddSheet: Bool = false
    @State private var textFieldText = ""
    @State private var selectedImage: UIImage?
    @State private var region: CLCircularRegion?
    @State private var isInsideRegion = false
    //    @State public var isInsideRegion = false
    //    @State private var enteredRegion: String = ""
    //    private var cancellables = Set<AnyCancellable>()
    
    var name: String
    var album: Album?
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        Group{
            if let alb = album{
                ScrollView{
                    LazyVGrid(columns: columns, spacing: 1){
                        ForEach(alb.photos){ photos in
                            NavigationLink{
                                DetailedPhotoView(photo: photos)
                            }label: {
                                
                                if let displayedPhoto = photos.photo {
                                    let compressionQuality: CGFloat = 0.0
                                    if let compressedData = UIImage(data: displayedPhoto)?.jpegData(compressionQuality: compressionQuality){
                                        Image(uiImage: UIImage(data: compressedData)!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 130, height: 130)
                                            .mask{
                                                Rectangle()
                                                    .frame(width: 130, height: 130)
                                            }
                                    }
                                }
                                
                            }
                            //
                            
                        }
                    }
                }
            }
            else{
                VStack{
                    Spacer()
                    EmptyAlbumView()
                    Spacer()
                }
            }
        }
        .onReceive(locationDataManager.$isInRegion){ newValue in
            print("new value : \(newValue)")
            isInsideRegion = newValue
            
            guard let circularRegion = region else{
                return
            }
            
            if CLLocation(latitude: (locationDataManager.locationManager.location?.coordinate.latitude)!, longitude: (locationDataManager.locationManager.location?.coordinate.longitude)!).distance(from: CLLocation(latitude: circularRegion.center.latitude, longitude: circularRegion.center.longitude)) < 150{
                isInsideRegion = true
            }
            
        }
        .navigationTitle("@\(name)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isInsideRegion{
                    NavigationLink{
                        CameraViewNew(album: self.album)
                        //                        CameraView()
                            .toolbar(.hidden, for: .tabBar)
                        //                        isShowingAddSheet = true
                        //                        ImagePickerView(selectedImage: $selectedImage)
                    }label: {
                        Image(systemName: "camera")
                    }
                }
                else {
                    Button{
                        isPresentingLockedRegion = true
                    }label: {
                        Image(systemName: "lock")
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing){
                Menu {
                    Button{
                        isPresentingRename = true
                    }label: {
                        HStack{
                            Text("Rename Album")
                            Spacer()
                            Image(systemName: "pencil")
                        }
                    }
                    
                    Button(role: .destructive){
                        isPresentingConfirm = true
                    }label: {
                        HStack{
                            Text("Delete Album")
                            Spacer()
                            Image(systemName: "trash")
                        }
                    }
                    
                } label: {
                    Label("More", systemImage: "ellipsis.circle")
                }
            }
            
        }
        .confirmationDialog("Are you sure want to delete this album?", isPresented: $isPresentingConfirm){
            Button(role: .destructive){
                AlbumDataController().deleteAlbum(album: album!, context: managedObjContext)
                dismiss()
            }label: {
                Text("Delete Album")
            }
        } message: {
            Text("You cannot undo this action")
        }
        .alert("Rename Album", isPresented: $isPresentingRename){
            TextField("New album name", text: $textFieldText)
            Button("OK"){
                if !textFieldText.isEmpty{
                    AlbumDataController().editAlbum(album: album!, name: textFieldText, context: managedObjContext)
                }
            }
        }
        .alert("Locked",isPresented: $isPresentingLockedRegion){
        } message: {
            Text("You are outside photo box location, camera locked")
        }
        .sheet(isPresented: $isShowingAddSheet){
            //            CameraViewNew(album: self.album)
            
            ImagePickerView(selectedImage: $selectedImage)
                .onDisappear{
                    if let image = selectedImage{
                        selectedImage = fixOrientation(img: image)
                        AlbumDataController().addPhoto(album: album!, photo: selectedImage!.pngData()!, context: managedObjContext)
                    }
                }
        }
        .onAppear{
            Task{
                print(locationDataManager.isInRegion.description)
                locationDataManager.shouldStartMonitoring = true
                region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: album!.latitude, longitude: album!.longitude), radius: 150, identifier: album!.idAlbum!.uuidString)
                locationDataManager.startMonitoring(region: region!, identifier: album!.idAlbum!.uuidString)
            }
            
        }
        .onDisappear{
            Task{
                locationDataManager.shouldStartMonitoring = false
                locationDataManager.stopMonitoring(region: region!)
            }
        }
        
        
    }
    
    private func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    //    private func addPhoto(){
    //        let newPhoto = Photos(context: managedObjContext)
    //        newPhoto.photosToAlbum = album
    //        newPhoto.id = UUID()
    //        newPhoto.photo = selectedImage!.pngData()
    //        do {
    //            try managedObjContext.save()
    //        } catch{
    //            print("Error While saving photos")
    //        }
    //    }
}




struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView(name: "ADA")
    }
}
