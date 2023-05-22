//
//  CollectionView.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/18/23.
//

import SwiftUI
import CoreLocation

struct CollectionView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.albumName)]) var albums: FetchedResults<Album>
    
    @StateObject var locationDataManager = LocationDataManager()
    @State private var showingAddView = false
    
    var body: some View {
        NavigationStack{
            
            VStack{
                if albums.isEmpty {
                    EmptyCollectionView()
                }
                else {
                    HStack{
                        Text("Your Collections")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.leading, 15)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(albums){ album in
                                NavigationLink(destination: AlbumView( name: album.albumName!, album: album)){
                                    CollectionPreview(previewImage: album.photos.last?.photo, name: album.albumName!, count: album.photos.count)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
                
            }
            .navigationTitle("Photo Box")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        showingAddView.toggle()
                    }label: {
                        Label("Add Album", systemImage: "plus")
                    }
                }
            }
            
            .sheet(isPresented: $showingAddView){
                AddAlbumView()
            }
        }
        .onAppear{
            
            
//            albums.forEach{ album in
//                locationDataManager.locationManager.startMonitoring(for: CLCircularRegion(center: CLLocationCoordinate2D(latitude: album.latitude, longitude: album.longitude), radius: locationDataManager.locationManager.maximumRegionMonitoringDistance, identifier: album.idAlbum!.uuidString))
//                print(album.albumName)
//            }
        }


    }

}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}


