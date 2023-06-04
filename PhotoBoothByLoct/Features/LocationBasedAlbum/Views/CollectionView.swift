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
    
    let rows = [
        GridItem(.flexible()),GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack{
            VStack{
                if albums.isEmpty {
                    EmptyCollectionView()
                }
                else {
                    HStack{
                        Text(Prompt.Title.collectionViewSubtitle)
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.leading, 15)
                    ScrollView(.horizontal, showsIndicators: false){
                        LazyHGrid(rows: rows, spacing: 10){
                            ForEach(albums){ album in
                                NavigationLink(destination: AlbumView( name: album.albumName!, album: album)){
                                    CollectionPreview(previewImage: album.photos.last?.photo, name: album.albumName!, count: album.photos.count)
                                }
                                .frame(width: 168, height: 206)
                            }
                        }
                        .frame(height: 500)
                        .padding(.horizontal, 20)
                    }
                    Spacer()
                }
                
            }
            .navigationTitle(Prompt.Title.collectionViewTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        showingAddView.toggle()
                    }label: {
                        Label(Prompt.Title.addButtonText, systemImage: "plus")
                    }
                }
            }
            
            .sheet(isPresented: $showingAddView){
                AddAlbumView()
            }
        }
    }

}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}


