//
//  CollectionView.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/18/23.
//

import SwiftUI

struct CollectionView: View {
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack{
                    HStack{
                        Text("Your Collections")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.leading, 15)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            NavigationLink{
                                AlbumView()
                            }label: {
                                CollectionPreview()
                                    .foregroundColor(.black)
                            }
                            CollectionPreview()
                            CollectionPreview()
                            
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                    }
                .navigationTitle("Photo Box")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            // Perform action for trailing button
                        }label: {
                            Image(systemName: "plus")
                        }
                    }
            }
            }
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}


