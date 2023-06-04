//
//  DetailedPhotoView.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/22/23.
//

import SwiftUI

struct DetailedPhotoView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State var photo: Photos
    @State var isShowingDeleteConfirmation = false
    var body: some View {
        GeometryReader{ geo in
            if let imageData = photo.photo{
                Image(uiImage: UIImage(data: imageData)!)
                    .resizable()
                    .frame(height: geo.size.height * 0.8)
            } else {
                Image("noPhotos")
                    .resizable()
                    .frame(height: geo.size.height * 0.8)
            }
        }
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button(role: .destructive){
                    isShowingDeleteConfirmation = true
                }label: {
                    Image(systemName: "trash")
                }
            }
        }
        .confirmationDialog(Prompt.DetailedPhoto.deletePrompt, isPresented: $isShowingDeleteConfirmation){
            Button(role: .destructive){
                AlbumDataController().deletePhoto(photo: photo, context: managedObjContext)
                dismiss()
                DispatchQueue.main.async {
                    dismiss() // Dismiss the view twice
                }
//                AlbumDataController().deleteAlbum(album: album, context: managedObjContext)
//                dismiss()
            }label: {
                Text(Prompt.DetailedPhoto.deletePrompt)
            }
        }

    }
}

//struct DetailedPhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailedPhotoView(photo: )
//    }
//}
