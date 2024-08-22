//
//  ContentView2.swift
//  CustomCamera
//
//  Created by Heical Chandra on 21/08/24.
//

import SwiftUI
import DotLottie

struct ContentView3: View {
    @StateObject var camera = CameraModel2()
    @State var isTaken:Bool = false
    @State var croppedImage: UIImage? = nil
    
    var body: some View {
        ZStack{
            //camera
            CameraPreview2(camera: camera)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .opacity(isTaken ? 0 : 1)
                .ignoresSafeArea()
            if camera.isTaken{
                VStack{
                    ZStack{
                        if let image = camera.showPic {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width)
                                .opacity(isTaken ? 1 : 0.0)
                        }
                        if let image2 = camera.croppedImage {
                            VStack{
                                Spacer()
                                HStack {
                                    Spacer()
                                    Image(uiImage: image2)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 150, height: 150)
                                        .opacity(isTaken ? 1 : 0.0)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 0)
                                                .stroke(isTaken ? Color.white : Color.clear, lineWidth: 4)
                                        )
                                        .onAppear {
                                            self.croppedImage = image2
                                        }
                                }
                            }
                        }
                    }
                    .background(.red)
                    
                    HStack{
                        Spacer()
                        Button(action: { camera.reTake(); isTaken = false }, label: {
                            Text("Retake")
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                                .fontWeight(.regular)
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .background(Color.black.opacity(0.1))
                                .cornerRadius(10)
                        })
                        Spacer()
                        NavigationLink(destination: ResultViewDUMMY(selectedImage: croppedImage), label: {
                            Text("Use Pict")
                                .font(.system(size: 17))
                                .foregroundColor(.white)
                                .fontWeight(.regular)
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .background(Color.purple)
                                .cornerRadius(10)
                        })
                        Spacer()
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                }
            } else {
                VStack{
                    HStack{
                        Spacer()
                        Button(action: { camera.toggleCamera() }) {
                            Image(systemName: "camera.rotate")
                                .resizable()
                                .frame(width: 33, height: 30)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing)
                    }
                    VStack{
                        Text("Point the camera at the pimple")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(.black.opacity(0.2))
                    .cornerRadius(10)
                    Spacer()
                    DotLottieAnimation(
                        fileName: "scan",
                        config: AnimationConfig(autoplay: true, loop: true)
                    )
                    .view()
                    .frame(width: UIScreen.main.bounds.width, height: 500)
                    Spacer()
                    VStack{
                        Button(action: {camera.takePic(); isTaken = true}, label: {
                            Text("Take Photo")
                                .font(.system(size: 17))
                                .foregroundColor(.white)
                                .fontWeight(.regular)
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .background(Color.purple)
                                .cornerRadius(10)
                        })
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                .padding(.top, 50)
                .padding(.bottom, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear(perform: {
            camera.Check()
        })
    }
}

#Preview {
    ContentView2()
}

