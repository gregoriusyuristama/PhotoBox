//
//  CameraViewNew.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/23/23.
//

import SwiftUI
import Photos

struct CameraViewNew: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var cameraController = CameraController()
    @ObservedObject var locationDataManager = LocationDataManager()
    @State private var capturedImage: UIImage?
    @State private var selectedOverlayIndex = 0
    var album: Album?
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.black)
                .frame(width: .infinity, height: .infinity)
                .ignoresSafeArea()
            VStack {
                if let image = capturedImage {
                    VStack{
                        
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .toolbar{
                                ToolbarItem(placement: .navigationBarTrailing){
                                    Button{
                                        let fixedPhoto = fixOrientation(img: capturedImage!)
                                        AlbumDataController().addPhoto(album: album!, photo: fixedPhoto.pngData()!, context: managedObjContext)
                                        savePhotoToLibrary(fixedPhoto)
                                        dismiss()
                                        
                                    }label: {
                                        Text("Save Photo")
                                    }
                                }
                            }
                        Button{
                            let fixedPhoto = fixOrientation(img: capturedImage!)
                            AlbumDataController().addPhoto(album: album!, photo: fixedPhoto.pngData()!, context: managedObjContext)
                            savePhotoToLibrary(fixedPhoto)
                            dismiss()
                            
                        }label: {
                            Text("Save Photo")
                        }
                    }
                } else {
                    ZStack{
                        CameraPreview(session: cameraController.session)
                            .frame(width: 300, height: 400)
                            .mask{
                                Rectangle()
                                    .frame(width: 300, height: 400)
                                    .cornerRadius(30)
                            }
                        Image(uiImage: cameraController.overlayImages[selectedOverlayIndex])
                            .resizable()
                            .frame(width: 300, height: 400)
                            .aspectRatio(contentMode: .fit)
                            .mask{
                                Rectangle()
                                    .frame(width: 300, height: 400)
                                    .cornerRadius(30)
                            }
                    }
                    
                    Picker(selection: $selectedOverlayIndex, label: Text("Overlay Image")){
                        ForEach(0..<cameraController.overlayImages.count, id: \.self){ index in
                            Text("\(index + 1)")
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .onChange(of: selectedOverlayIndex) { newValue in
                        cameraController.setCurrentOverlay(index: newValue)
                    }
                    
                    HStack{
                        Button{
                            dismiss()
                        }label: {
                            if let image = album?.photos.last?.photo{
                                Image(uiImage: UIImage(data: image)!)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .mask{
                                        Rectangle()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(10)
                                    }
                                    .padding(.leading, 46)
                            }else {
                                Image("noPhotos")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .mask{
                                        Rectangle()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(10)
                                    }
                                    .padding(.leading, 46)
                            }
                        }
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
    
    private func savePhotoToLibrary(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                print("Access to photo library denied.")
                return
            }
            
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { success, error in
                if let error = error {
                    print("Error saving photo to library:", error.localizedDescription)
                } else {
                    print("Photo saved to library.")
                }
            }
        }
    }
}


struct CameraViewNew_Previews: PreviewProvider {
    static var previews: some View {
        CameraViewNew()
    }
}
