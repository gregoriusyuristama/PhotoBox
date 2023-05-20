/*
 See the License.txt file for this sample’s licensing information.
 */

import SwiftUI

struct CameraView: View {
    @StateObject private var model = DataModel()
    
    private static let barHeightFactor = 0.15
    
    
    var body: some View {
        
        ZStack {
            VStack{
                ViewfinderView(image:  $model.viewfinderImage )
                //                    .overlay(alignment: .top) {
                //                        Color.black
                //                            .opacity(0.75)
                //                            .frame(height: geometry.size.height * Self.barHeightFactor)
                //                    }
                //                    .overlay(alignment: .bottom) {
                //                        buttonsView()
                //                            .frame(height: geometry.size.height * Self.barHeightFactor)
                //                            .background(.black.opacity(0.75))
                //                    }
                //                    .overlay(alignment: .center)  {
                //                        Color.clear
                //                            .frame(height: geometry.size.height * (1 - (Self.barHeightFactor * 2)))
                //                            .accessibilityElement()
                //                            .accessibilityLabel("View Finder")
                //                            .accessibilityAddTraits([.isImage])
                //                    }
                    .background(.black)
                    .frame(width: 333, height: 480)
                    .mask{
                        Rectangle()
                            .frame(width: 333, height: 480)
                            .cornerRadius(30)
                    }
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ViewfinderView(image:  $model.viewfinderImage )
                            .frame(width: 71, height: 76)
                            .mask{
                                Rectangle()
                                    .frame(width: 71, height: 76)
                                    .cornerRadius(10)
                            }
                        ViewfinderView(image:  $model.viewfinderImage )
                            .frame(width: 71, height: 76)
                            .mask{
                                Rectangle()
                                    .frame(width: 71, height: 76)
                                    .cornerRadius(10)
                            }
                        ViewfinderView(image:  $model.viewfinderImage )
                            .frame(width: 71, height: 76)
                            .mask{
                                Rectangle()
                                    .frame(width: 71, height: 76)
                                    .cornerRadius(10)
                            }
                        ViewfinderView(image:  $model.viewfinderImage )
                            .frame(width: 71, height: 76)
                            .mask{
                                Rectangle()
                                    .frame(width: 71, height: 76)
                                    .cornerRadius(10)
                            }
                        ViewfinderView(image:  $model.viewfinderImage )
                            .frame(width: 71, height: 76)
                            .mask{
                                Rectangle()
                                    .frame(width: 71, height: 76)
                                    .cornerRadius(10)
                            }
                        ViewfinderView(image:  $model.viewfinderImage )
                            .frame(width: 71, height: 76)
                            .mask{
                                Rectangle()
                                    .frame(width: 71, height: 76)
                                    .cornerRadius(10)
                            }
                        ViewfinderView(image:  $model.viewfinderImage )
                            .frame(width: 71, height: 76)
                            .mask{
                                Rectangle()
                                    .frame(width: 71, height: 76)
                                    .cornerRadius(10)
                            }
                    }
                }
                HStack{
                    NavigationLink {
                        PhotoCollectionView(photoCollection: model.photoCollection)
                            .onAppear {
                                model.camera.isPreviewPaused = true
                            }
                            .onDisappear {
                                model.camera.isPreviewPaused = false
                            }
                    } label: {
                        ThumbnailView(image: model.thumbnailImage)
                        .frame(width: 61, height: 61)
                        .mask{
                            Rectangle()
                                .frame(width: 61, height: 61)
                                .cornerRadius(10)
                        }
                        .padding(.leading, 46)
                    }
                    
//                    Image("sampleImage")
//                        .resizable()
//                        .frame(width: 61, height: 61)
//                        .mask{
//                            Rectangle()
//                                .frame(width: 61, height: 61)
//                                .cornerRadius(10)
//                        }
//                        .padding(.leading, 46)
                    Spacer()
                    Button{
                        
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
                        model.camera.switchCaptureDevice()
                    }label: {
                        Text("\(Image(systemName: "arrow.triangle.2.circlepath.camera"))")
                            .font(.system(size: 34))
                            .padding(.trailing, 46)
                            .foregroundColor(.white)
                    }

                }
                
            }
            
        }
        .task {
            await model.camera.start()
            await model.loadPhotos()
            await model.loadThumbnail()
        }
        .navigationTitle("Photo Booth")
        .navigationBarTitleDisplayMode(.inline)
        //            .navigationBarHidden(true)
        .ignoresSafeArea()
        .statusBar(hidden: true)
    }
    
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            
            Spacer()
            
            NavigationLink {
                PhotoCollectionView(photoCollection: model.photoCollection)
                    .onAppear {
                        model.camera.isPreviewPaused = true
                    }
                    .onDisappear {
                        model.camera.isPreviewPaused = false
                    }
            } label: {
                Label {
                    Text("Gallery")
                } icon: {
                    ThumbnailView(image: model.thumbnailImage)
                }
            }
            
            Button {
                model.camera.takePhoto()
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 62, height: 62)
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
    
}
