//
//  AlbumView.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/19/23.
//

import SwiftUI
import CoreLocation
import Combine

struct AlbumView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var locationDataManager = LocationDataManager()
    @StateObject var locationViewModel = LocationViewModel()
    //    @State var testLocVM = TestLocViewModel()
    
    @State private var isPresentingConfirm: Bool = false
    @State private var isPresentingRename: Bool = false
    @State private var isPresentingLockedRegion: Bool = false
    @State private var isShowingAddSheet: Bool = false
    @State private var textFieldText = ""
    @State private var selectedImage = UIImage()
//    @State public var isInsideRegion = false
//    @State private var enteredRegion: String = ""
    //    private var cancellables = Set<AnyCancellable>()
    
    
    
    var name: String
    //    var deleteAlbum: (Album) -> ()
    var album: Album!
    
    @State private var region: CLCircularRegion?
    var body: some View {
        ScrollView{
            VStack{
                HStack(spacing: 1){
                    ForEach(album.photos){ photo in
                        Image(uiImage: UIImage(data: photo.photo!)!)
                            .resizable()
                            .frame(width: 130, height: 130)
                    }
//                    Image("sampleImage")
//                        .resizable()
//                        .frame(width: 130, height: 130)
//                    Image("sampleImage")
//                        .resizable()
//                        .frame(width: 130, height: 130)
//                    Image("sampleImage")
//                        .resizable()
//                        .frame(width: 130, height: 130)
                }
                Text("latitude: \(album.latitude)")
                Text("latitude: \(album.longitude)")
                Text(locationDataManager.isInRegion ? "Inside Region" : "Outside Region")
                switch locationDataManager.locationManager.authorizationStatus {
                case .authorizedWhenInUse:  // Location services are available.
                    // Insert code here of what should happen when Location services are authorized
                    Text("Your current location is:")
                    Text("Latitude: \(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")")
                    Text("Longitude: \(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")")
                    Button{
                        locationDataManager.locationManager.startUpdatingLocation()
                        locationViewModel.latitude = (locationDataManager.locationManager.location?.coordinate.latitude.description)!
                        locationViewModel.longitude = (locationDataManager.locationManager.location?.coordinate.longitude.description)!
                        //                    locationViewModel.saveResult()
                    }label: {
                        Text("Refresh Location")
                    }
                    
                case .restricted, .denied:  // Location services currently unavailable.
                    // Insert code here of what should happen when Location services are NOT authorized
                    Text("Current location data was restricted or denied.")
                case .notDetermined:        // Authorization not determined yet.
                    Text("Finding your location...")
                    ProgressView()
                default:
                    ProgressView()
                }
                
                Text("Region: \(locationDataManager.isInRegion ? locationDataManager.regionIdentifierToCheck! : String("Test"))")
                
                
            }
            
        }
        
        .navigationTitle("@\(name)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if locationDataManager.isInRegion {
                    Button{
//                        CameraView()
//                            .toolbar(.hidden, for: .tabBar)
                        isShowingAddSheet = true
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
                .confirmationDialog("Are you sure want to delete this album?", isPresented: $isPresentingConfirm){
                    Button(role: .destructive){
                        AlbumDataController().deleteAlbum(album: album, context: managedObjContext)
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
                            AlbumDataController().editAlbum(album: album, name: textFieldText, context: managedObjContext)
                        }
                    }
                }
                .alert("Locked",isPresented: $isPresentingLockedRegion){
                } message: {
                    Text("You are outside photo box location, camera locked")
                }
                .sheet(isPresented: $isShowingAddSheet){
                    ImagePickerView(selectedImage: $selectedImage)
                        .onDisappear{
                            
                            addPhoto()
                        }
                }
                
            }
        }
        .onAppear{
            locationDataManager.shouldStartMonitoring = true
            region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: album.latitude, longitude: album.longitude), radius: 1000, identifier: album.idAlbum!.uuidString)
            locationDataManager.startMonitoring(region: region!, identifier: album.idAlbum!.uuidString)
            
//            locationDataManager.regionEnteredHandler = { region in
//                enteredRegion = region
//                print(region)
//                if enteredRegion == album.idAlbum!.uuidString{
//                    isInsideRegion = true
//                } else {
//                    isInsideRegion = false
//                }
//            }
//                print(locationDataManager.locationManager.monitoredRegions)
            
            
            
            //            locationDataManager.locationManager.startUpdatingHeading()
            
        }
        .onDisappear{
//            locationDataManager.shouldStartMonitoring = false
            //            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: album.latitude, longitude: album.longitude), radius: 1000, identifier: album.idAlbum!.uuidString)
//            locationDataManager.locationManager.stopMonitoring(for: self.region!)
            //            locationDataManager.locationManager.startMonitoring(for: region)
        }
        
        
    }
    private func addPhoto(){
        let newPhoto = Photos(context: managedObjContext)
        newPhoto.photosToAlbum = album
        newPhoto.id = UUID()
        newPhoto.photo = selectedImage.pngData()
        do {
            try managedObjContext.save()
        } catch{
            print("Error While saving photos")
        }
    }
}




struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView(name: "ADA")
    }
}
