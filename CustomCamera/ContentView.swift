//
//  ContentView.swift
//  CustomCamera
//
//  Created by Heical Chandra on 25/04/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var camera = CameraModel()
    
    var body: some View {
//        ZStack{
//            ZStack {
//                Color.yellow.ignoresSafeArea()
//                ZStack {
//                    CameraPreview(camera: camera).frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
//                    Group{
//                        Rectangle()
//                            .fill(Color.white)
//                            .opacity(0)
//                            .frame(width: 65, height: 65)
//                        Rectangle()
//                            .stroke(Color.white, lineWidth: 2)
//                            .frame(width: 75, height: 75)
//                    }.padding(.bottom, 130)
//                }
//
//            }
//            VStack{
//                if camera.isTaken{
//                    HStack {
//                        Spacer()
//                        Button(action: camera.reTake, label: {
//                            Image(systemName: "arrow.triangle.2.circlepath.camera")
//                                .foregroundColor(.black)
//                                .padding()
//                                .background(Color.white)
//                                .clipShape(Circle())
//                        })
//                        .padding(.trailing, 10)
//                    }
//                }
//                Spacer()
//                HStack{
//                    if camera.isTaken{
//                        Button(action: {if !camera.isSaved{camera.savePic()}}, label: {
//                            Text(camera.isSaved ? "saved" : "Save")
//                                .foregroundColor(.black)
//                                .fontWeight(.semibold)
//                                .padding(.vertical, 10)
//                                .padding(.horizontal, 20)
//                                .background(Color.white)
//                                .clipShape(Capsule())
//                        })
//                        .padding(.leading)
//                        Spacer()
//                    } else{
//                        Button(action: camera.takePic, label: {
//                            ZStack{
//                                Image("btc").resizable().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
//                            }
//                        })
//                    }
//                }
//                .frame(height: 75)
//            }
//        }
//        .onAppear(perform: {
//            camera.Check()
//        })
        
        ZStack {
            Image("bgcolor").resizable().ignoresSafeArea()
            VStack{
                HStack{
                    Image("time")
                    Spacer()
                }.padding(.horizontal, 55).padding(.top, 40).padding(.bottom, -30)
                HStack{
                    ZStack{
                        //camera
                        CameraPreview(camera: camera)
                        Image("frame").padding(.top, 25)
                    }.padding(.top, 50).frame(width: 312, height: 321)
                }
                Image("bawah").padding(.top, 50)
                Spacer()
                HStack{
                    if camera.isTaken{
                        HStack{
                            Button(action: {if !camera.isSaved{camera.savePic()}}, label: {
                                Text(camera.isSaved ? "saved" : "Save")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            })
                            .padding(.leading)
                            Spacer()
                            Button(action: camera.reTake, label: {
                                Image(systemName: "arrow.triangle.2.circlepath.camera")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                            })
                            .padding(.trailing, 10)
                        }

                    } else{
                        Button(action: camera.takePic, label: {
                            ZStack{
                                Image("Camera").resizable().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                            }
                        })
                    }
                }
                .padding(.bottom)
            }
        }.onAppear(perform: {
            camera.Check()
        })
    }
}

#Preview {
    ContentView()
}
