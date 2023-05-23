//
//  EmptyAlbumView.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/22/23.
//

import SwiftUI

struct EmptyAlbumView: View {
    var body: some View {
        VStack{
            Text("No Collection")
                .padding(.bottom, 5)
                .font(.headline)
            Text("You can add new photos when on album location and by tapping button \(Image(systemName: "camera")) above")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct EmptyAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyAlbumView()
    }
}
