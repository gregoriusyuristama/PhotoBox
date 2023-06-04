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
            Text(Prompt.Empty.noPhotosTitle)
                .padding(.bottom, 5)
                .font(.headline)
            Text(Prompt.Empty.noPhotosCaption)
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
