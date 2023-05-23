//
//  CameraViewNew.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/23/23.
//

import SwiftUI

struct CameraViewNew: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    @StateObject private var cameraController = CameraController()
    @State private var capturedImage: UIImage?
    var album: Album?
    
    var body: some View {
        VStack {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button{
                                let fixedPhoto = fixOrientation(img: capturedImage!)
                                AlbumDataController().addPhoto(album: album!, photo: fixedPhoto.pngData()!, context: managedObjContext)
                                dismiss()
                            }label: {
                                Text("Save Photo")
                            }
                        }
                    }
            } else {
                CameraPreview(session: cameraController.session)
                    .frame(width: 300, height: 400)
                    .mask{
                        Rectangle()
                            .frame(width: 300, height: 400)
                            .cornerRadius(30)
                    }
                HStack{
                    Image("noPhotos")
                        .frame(width: 60, height: 60)
                        .mask{
                            Rectangle()
                                .frame(width: 60, height: 60)
                                .cornerRadius(10)
                        }
                        .padding(.leading, 46)
                    Spacer()
                    Button{
                        cameraController.capturePhoto { image in
                            capturedImage = image
                        }
                    }label: {
                        Circle()
                            .fill(.white)
    //                        .stroke(lineWidth: 1)
                            .frame(width: 95, height: 95)
                            .overlay{
                                Circle()
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(.black)
                                    .frame(width: 86, height: 86)
                            }
                    }
                    Spacer()
                    Button{
                            cameraController.flipCamera()
                    }label: {
                        Text("\(Image(systemName: "arrow.triangle.2.circlepath.camera"))")
                            .font(.system(size: 34))
                            .padding(.trailing, 46)
                            .foregroundColor(.white)
                    }
                }
            }
            
            
//            Button("Flip") {
//                cameraController.flipCamera()
//            }
            
//            Button("Capture") {
//                cameraController.capturePhoto { image in
//                    capturedImage = image
//                }
//            }
        }
        .onAppear {
            cameraController.startSession()
        }
        .onDisappear {
            cameraController.stopSession()
        }
    }
    private func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}


struct CameraViewNew_Previews: PreviewProvider {
    static var previews: some View {
        CameraViewNew()
    }
}
