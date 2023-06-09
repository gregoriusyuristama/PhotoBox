//
//  CollectionPreview.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/19/23.
//

import SwiftUI

struct CollectionPreview: View {
    var previewImage: Data?
    var name: String
    var count: Int
    var body: some View {
        VStack(alignment: .leading){
            
            if let image = previewImage{
                let compressionQuality: CGFloat = 0.0
                
                if let compressedData = UIImage(data: image)?.jpegData(compressionQuality: compressionQuality){
                    Image(uiImage: UIImage(data: compressedData)!)
                        .resizable()
        //                .scaledToFit()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 168, height: 168)
                        .mask{
                            Rectangle()
                                .cornerRadius(10)
                                .frame(width: 168, height: 168)
                        }
                }
            } else {
                Image("noPhotos")
                    .resizable()
    //                .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 168, height: 168)
                    .mask{
                        Rectangle()
                            .cornerRadius(10)
                            .frame(width: 168, height: 168)
                    }
            }
//            Image(uiImage: ((previewImage != nil) ? UIImage(data: previewImage!) : UIImage(named: "noPhotos"))!)
//                .resizable()
////                .scaledToFit()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 168, height: 168)
//                .mask{
//                    Rectangle()
//                        .cornerRadius(10)
//                        .frame(width: 168, height: 168)
//                }
            Text("@\(name)")
            Text("\(count)")
                .foregroundColor(.gray)
        }

    }
}

struct CollectionPreview_Previews: PreviewProvider {
    static var previews: some View {
        CollectionPreview(name: "ADA", count: 0)
    }
}
