//
//  CollectionView.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/18/23.
//

import SwiftUI

struct HomepageView: View {

    
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




