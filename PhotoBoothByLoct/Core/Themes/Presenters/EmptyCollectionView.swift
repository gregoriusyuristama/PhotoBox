//
//  EmptyCollectionView.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/18/23.
//

import SwiftUI

struct EmptyCollectionView: View {
    var body: some View {
        VStack{
            Text(Prompt.Empty.noCollectionTitle)
                .padding(.bottom, 5)
                .font(.headline)
            Text(Prompt.Empty.noCollectionCaption)
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct EmptyCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyCollectionView()
    }
}
