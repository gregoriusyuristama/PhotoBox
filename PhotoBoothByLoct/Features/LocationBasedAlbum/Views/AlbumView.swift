//
//  AlbumView.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/19/23.
//

import SwiftUI

struct AlbumView: View {
    var body: some View {
        ScrollView{
            VStack{
                HStack(spacing: 1){
                    Image("sampleImage")
                        .resizable()
                        .frame(width: 130, height: 130)
                    Image("sampleImage")
                        .resizable()
                        .frame(width: 130, height: 130)
                    Image("sampleImage")
                        .resizable()
                        .frame(width: 130, height: 130)
                }
                
            }
        }
        
        .navigationTitle("Your Collection @ADA")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink{
                    CameraView()
                        .toolbar(.hidden, for: .tabBar)
                }label: {
                    Image(systemName: "camera")
                }
            }
        }
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView()
    }
}
