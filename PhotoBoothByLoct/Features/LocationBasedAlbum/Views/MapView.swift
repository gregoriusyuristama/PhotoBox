//
//  MapView.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/18/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var locationDataManager = LocationDataManager()
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    var body: some View {
        NavigationStack {
            VStack{
                ZStack{
                    Map(coordinateRegion: $mapRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow))
                    HStack{
                        Spacer()
                        VStack {
                            ZStack {
                                Rectangle()
                                    .fill(.white)
                                    .cornerRadius(7)
                                    .frame(width: 34, height: 34)
                                .shadow(radius: 10, y:2)
                                
                               Image(systemName: "location")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.blue)
                            }
                            .padding(.top, 13)
                            .padding(.trailing, 12)

                            Spacer()
                        }
                    }
                    
                }
                
            }
            .navigationTitle("Places of Memories")
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
