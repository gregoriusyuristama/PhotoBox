//
//  CollectionView.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/18/23.
//

import SwiftUI

struct HomepageView: View {
    
    @AppStorage("firstTimeOpen") private var isShowingWelcomePage = true
    
    var body: some View {
        @State var selection = Tab.collection
        TabView{
            CollectionView()
                .tabItem{
                    Label("Collection", systemImage: "rectangle.stack")
                        .environment(\.symbolVariants, .none)
                }
                .tag(Tab.collection)
            
            MapView()
                .tabItem{
                    Label("Map View", systemImage: "map")
                        .environment(\.symbolVariants, .none)
                }
                .tag(Tab.mapView)
        }
        .sheet(isPresented: $isShowingWelcomePage){
            GeometryReader{ geo in
                VStack{
                    HStack{
                        Spacer()
                        Text("Welcome to\nPhotoBox")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top, geo.size.height*0.08)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    
                    HStack{
                        Image(systemName: "location")
                            .foregroundColor(.blue)
                            .font(.system(size: 30))
                        VStack{
                            HStack{
                                Text("Location Based Album")
                                    .font(.caption)
                                    .bold()
                                Spacer()
                            }
                            
                            HStack{
                                
                                Text("Save your photo collection based on location you’ve visited.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, geo.size.width*0.1)
                    .padding(.vertical, geo.size.height * 0.01)
                    
                    HStack{
                        Image(systemName: "map")
                            .foregroundColor(.blue)
                            .font(.system(size: 30))
                        VStack{
                            HStack{
                                Text("Map")
                                    .font(.caption)
                                    .bold()
                                Spacer()
                            }
                            
                            HStack{
                                
                                Text("Revisit your collection by looking at the map provided on the app.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, geo.size.width*0.1)
                    .padding(.vertical, geo.size.height * 0.01)
                    
                    HStack{
                        Image(systemName: "photo")
                            .foregroundColor(.blue)
                            .font(.system(size: 30))
                        VStack{
                            HStack{
                                Text("Photo Booth")
                                    .font(.caption)
                                    .bold()
                                Spacer()
                            }
                            
                            HStack{
                                
                                Text("Customize you photo experience by using photo booth filter.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, geo.size.width*0.1)
                    .padding(.vertical, geo.size.height * 0.01)
                    
                    Spacer()
                    
                    Button {
                        isShowingWelcomePage.toggle()
                    } label: {
                        Text("Continue")
                            .frame(maxWidth: .infinity, maxHeight: 32)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 16)
                    .padding(.horizontal, geo.size.width * 0.1)
                    
                }
            }
            
        }
    }
}

enum Tab: Int {
    case collection = 1
    case mapView = 2
//    var title: String {
//        switch self {
//            case .collection:
//            return "Photo Box"
//            case .mapView:
//            return "Places of Memories"
//        }
//    }
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView()
    }
}




