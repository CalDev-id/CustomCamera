//
//  ContentView.swift
//  CustomCamera
//
//  Created by Heical Chandra on 25/04/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var camera = CameraModel()
    @State var isTaken:Bool = false
    
    //time
    @State private var timeRemaining = 30
    @State private var timerIsRunning = true
    @State var width = UIScreen.main.bounds.width
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image("bgcolor").resizable().ignoresSafeArea()
            VStack{
                HStack{
                    Spacer()
                    VStack{
                        Image(systemName: "hourglass")
                            .resizable()
                            .frame(width: 30, height: 35)
                            .foregroundColor(.white)
                        Text(String(format: "00:%02d", timeRemaining))
                            .font(.system(size: 45))
                            .padding(-10)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        }
                    Spacer()
                }.padding(.horizontal, 55).padding(.top, 40).padding(.bottom, -30)
                HStack{
//                    if isTaken{
//                        if let image = camera.showPic {
//                                    Image(uiImage: image)
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                        .frame(width: 322, height: 331)
//                                }
//                    }else{
//                        ZStack{
//                            //camera
//                            CameraPreview(camera: camera)
//                            Image("frame").padding(.top, 25)
//                            
//                        }.padding(.top, 50).frame(width: 312, height: 321)
//                    }
                    ZStack{
                        //camera
                        CameraPreview(camera: camera).frame(width: 312, height: 321)
                        Image("frame").frame(width: 312, height: 321)
                        if let image = camera.showPic {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
//                                        .frame(width: 320, height: 321)
                                        .opacity(isTaken ? 1 : 0.0)
                                }
                        
                    }.padding(.top, 50)
                }

                Image("bawah").padding(.top, 50)
                Spacer()
                HStack{
                    if camera.isTaken{
                        HStack{
                            Spacer()
                            Button(action: { camera.reTake(); isTaken = false }, label: {
                                Image(systemName: "arrow.clockwise.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.white)
                            })
                            Spacer()
                            Button(action: {if !camera.isSaved{camera.savePic()}}, label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 90, height: 90)
                                    .foregroundColor(.white)

                            })
                            .padding(.leading)
                            Spacer()
                            Button(action: { camera.reTake(); isTaken = false }, label: {
                                Image(systemName: "arrow.clockwise.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.white)
                            })
                            Spacer()
                        }.frame(height: 150)

                    } else{
                        Button(action: {camera.takePic(); isTaken = true}, label: {
                            ZStack{
                                Image("Camera").resizable().frame(width: 150, height: 150)
                            }
                        })
                    }
                }
                .padding(.bottom)
            }
        }.onAppear(perform: {
            camera.Check()
        }).onReceive(timer) { _ in
            if self.timerIsRunning {
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timerIsRunning = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
