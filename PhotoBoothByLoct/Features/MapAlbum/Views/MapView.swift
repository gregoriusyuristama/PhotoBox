//
//  MapView.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/18/23.
//

import SwiftUI
import MapKit

struct MapView: View {
//    @StateObject var locationDataManager = LocationDataManager()
    @State private var userTrackingMode: MKUserTrackingMode = .none
//    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    var body: some View {
        NavigationStack {
            VStack{
                ZStack{
//                    Map(coordinateRegion: $mapRegion, interactionModes: .all, showsUserLocation: true)
                    MKMapViewRepresentable(userTrackingMode: $userTrackingMode)
                        .environmentObject(MapViewContainer())
                    HStack{
                        Spacer()
                        VStack {
                            Button{
                                userTrackingMode = .follow
                            }label: {
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
                            }
                            .padding(.top, 60)
                            .padding(.trailing, 12)

                            Spacer()
                        }
                    }
                    
                }
                
            }
            .navigationTitle(Prompt.Title.mapViewTitle)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
