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
    //    @StateObject private var cameraController = CameraController()
    @StateObject private var model = CameraDataModel()
    @ObservedObject var locationDataManager = LocationDataManager()
    @State private var capturedImage: UIImage?
    @State private var selectedOverlayIndex = 0
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
                                savePhotoToLibrary(fixedPhoto)
                                dismiss()
                                
                            }label: {
                                Text("Save Photo")
                            }
                        }
                    }
                    .onAppear {
                        model.camera.isPreviewPaused = true
                    }
                    .onDisappear {
                        model.camera.isPreviewPaused = false
                    }
            } else {
                ZStack{
                    ViewfinderView(image:  $model.viewfinderImage )
                        .background(.black)
                        .frame(width: 300, height: 400)
                        .mask{
                            Rectangle()
                                .frame(width: 300, height: 400)
                                .cornerRadius(30)
                        }
                    Image(uiImage: model.camera.overlayImages[selectedOverlayIndex])
                        .resizable()
                        .frame(width: 300, height: 400)
                        .aspectRatio(contentMode: .fit)
                        .mask{
                            Rectangle()
                                .frame(width: 300, height: 400)
                                .cornerRadius(30)
                        }
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<self.model.camera.overlayImages.count, id: \.self) { i in
                            
                            ZStack{
                                ViewfinderView(image:  $model.viewfinderImage )
                                    .background(.black)
                                    .frame(width: 70, height: 70)
                                    .mask{
                                        Rectangle()
                                            .frame(width: 70, height: 70)
                                            .cornerRadius(10)
                                    }
                                
                                Image(uiImage: model.camera.overlayImages[i])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .gesture(TapGesture().onEnded({ self.selectedOverlayIndex = i }))
                            }
                            .mask{
                                Rectangle()
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(10)
                            }
                            .overlay{
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(lineWidth: 2)
                                    .foregroundColor(.yellow)
                                    .frame(width: 70, height: 70)
                                    .opacity(self.selectedOverlayIndex == i ? 1 : 0)
                            }
                            
                            
                            .gesture(TapGesture().onEnded({ self.selectedOverlayIndex = i }))
                        }
                    }
                }
                .frame(maxHeight: 80)
                .padding(.vertical, 30)
                .onChange(of: selectedOverlayIndex){ newValue in
                    model.camera.setCurrentOverlay(index: newValue)
                }
                
                
                HStack{
                    Button{
                        dismiss()
                    }label: {
                        if let image = album?.photos.last?.photo{
                            if let compressedData = UIImage(data: image)?.jpegData(compressionQuality: 0.0){
                                Image(uiImage: UIImage(data: compressedData)!)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .mask{
                                        Rectangle()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(10)
                                    }
                                    .padding(.leading, 46)
                           
                                
                            }
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
                        model.camera.takePhoto { image in
                            capturedImage = image
                        }
                    }label: {
                        Circle()
                            .fill(.white)
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
                        model.camera.switchCaptureDevice()
                    }label: {
                        Text("\(Image(systemName: "arrow.triangle.2.circlepath.camera"))")
                            .font(.system(size: 34))
                            .padding(.trailing, 46)
                            .foregroundColor(.white)
                    }
                }
                
                .padding(.bottom,50)
            }
        }
        .background(.black)
        
        .task {
            await model.camera.start()
        }
        .onDisappear{
            model.camera.stop()
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
