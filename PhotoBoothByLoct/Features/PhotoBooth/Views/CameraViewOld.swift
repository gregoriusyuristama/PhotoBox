//
//  CameraView.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/19/23.
//

import SwiftUI

struct CameraViewOld: View {
    @StateObject private var model = CameraViewModel()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black)
                .frame(width: .infinity, height: .infinity)
                .ignoresSafeArea()
            VStack{
                FrameView(image: model.frame)
                    .frame(width: 333, height: 510)
                    .mask{
                        Rectangle()
                            .frame(width: 333, height: 480)
                            .cornerRadius(30)
                    }
//                    .padding(.bottom, 24)
//                    .padding(.top, 14)
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        FrameView(image: model.frame)
                            .frame(width: 71, height: 76)
                            .mask{
                                Rectangle()
                                    .frame(width: 71, height: 76)
                                    .cornerRadius(10)
                            }
                        FrameView(image: model.frame)
                            .frame(width: 71, height: 76)
                            .mask{
                                Rectangle()
                                    .frame(width: 71, height: 76)
                                    .cornerRadius(10)
                            }
                        FrameView(image: model.frame)
                            .frame(width: 71, height: 76)
                            .mask{
                                Rectangle()
                                    .frame(width: 71, height: 76)
                                    .cornerRadius(10)
                            }
                        FrameView(image: model.frame)
                            .frame(width: 71, height: 76)
                            .mask{
                                Rectangle()
                                    .frame(width: 71, height: 76)
                                    .cornerRadius(10)
                            }
                        FrameView(image: model.frame)
                            .frame(width: 71, height: 76)
                            .mask{
                                Rectangle()
                                    .frame(width: 71, height: 76)
                                    .cornerRadius(10)
                            }
                        FrameView(image: model.frame)
                            .frame(width: 71, height: 76)
                            .mask{
                                Rectangle()
                                    .frame(width: 71, height: 76)
                                    .cornerRadius(10)
                            }
                    }
                }
                HStack{
                    Image("sampleImage")
                        .resizable()
                        .frame(width: 61, height: 61)
                        .mask{
                            Rectangle()
                                .frame(width: 61, height: 61)
                                .cornerRadius(10)
                        }
                        .padding(.leading, 46)
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
                    Text("\(Image(systemName: "arrow.triangle.2.circlepath.camera"))")
                        .font(.system(size: 34))
                        .padding(.trailing, 46)
                        .foregroundColor(.white)
                }
                .padding(.bottom)
                
            }
            
            
            ErrorView(error: model.error)
            
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraViewOld()
    }
}

