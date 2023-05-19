//
//  CollectionPreview.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/19/23.
//

import SwiftUI

struct CollectionPreview: View {
    var previewImage: String?
    var body: some View {
        VStack(alignment: .leading){
            Image(previewImage ?? "sampleImage")
                .resizable()
                .frame(width: 168, height: 168)
                .mask{
                    Rectangle()
                        .cornerRadius(10)
                        .frame(width: 168, height: 168)
                }
            Text("@ADA")
            Text("2.100")
                .foregroundColor(.gray)
        }

    }
}

struct CollectionPreview_Previews: PreviewProvider {
    static var previews: some View {
        CollectionPreview()
    }
}
