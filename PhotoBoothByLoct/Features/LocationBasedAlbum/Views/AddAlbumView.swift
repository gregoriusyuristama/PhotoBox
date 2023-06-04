//
//  AddAlbumView.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/21/23.
//

import SwiftUI

struct AddAlbumView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var locationDataManager = LocationDataManager()
    
    @State private var name = ""
    
    var body: some View {
        Form{
            Section{
                TextField(Prompt.AddAlbum.addAlbumNameHint, text: $name)
                MKMapViewRepresentable(userTrackingMode: .constant(.follow))
                    .environmentObject(MapViewContainer())
                    .frame(height: 300)
                HStack{
                    Spacer()
                    Button(Prompt.AddAlbum.addAlbumActionText){
                        AlbumDataController().addAlbum(name: name, latitude: Double((locationDataManager.locationManager.location?.coordinate.latitude.description)!)!, longitude: Double((locationDataManager.locationManager.location?.coordinate.longitude.description)!)!, context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct AddAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AddAlbumView()
    }
}
