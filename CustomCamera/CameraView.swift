//
//  CameraView.swift
//  CustomCamera
//
//  Created by Heical Chandra on 25/04/24.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    var body: some View {
            Camera()
    }
}

#Preview {
    CameraView()
}

struct Camera: View {
    
    @StateObject var camera = CameraModel()
    
    var body: some View {
        ZStack{
            ZStack {
                Color.yellow.ignoresSafeArea()
                ZStack {
                    CameraPreview(camera: camera).frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    Group{
                        Rectangle()
                            .fill(Color.white)
                            .opacity(0)
                            .frame(width: 65, height: 65)
                        Rectangle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 75, height: 75)
                    }.padding(.bottom, 130)
                }

            }
            VStack{
                if camera.isTaken{
                    HStack {
                        Spacer()
                        Button(action: {}, label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        })
                        .padding(.trailing, 10)
                    }
                }
                Spacer()
                HStack{
                    if camera.isTaken{
                        Button(action: {}, label: {
                            Text("Save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                        .padding(.leading)
                        Spacer()
                    } else{
                        Button(action: {camera.isTaken.toggle()}, label: {
                            ZStack{
                                Image("btc").resizable().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                            }
                        })
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear(perform: {
            camera.Check()
        })
    }
}

class CameraModel: ObservableObject{
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    //read pic data
    @Published var output = AVCapturePhotoOutput()
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    func Check(){
        //check camera permission
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            setUp()
            return
            
        //setup session
        case .notDetermined:
            //retusting
            AVCaptureDevice.requestAccess(for: .video){(status) in
                if status{
                    self.setUp()
                }
            }
        case .denied:
            alert.toggle()
            return
            
        default:
            return
        }
    }
    
    func setUp(){
        //set camera
        do{
            self.session.beginConfiguration()
            let device = AVCaptureDevice.default(.builtInDualCamera,
                                                 for: .video, position: .back)
            let input = try AVCaptureDeviceInput(device: device!)
            
            //check and add session
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        }catch{
            print(error.localizedDescription)
        }
    }
}

//setting preview

struct CameraPreview: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .init(x: 90, y: -150, width: 250, height: 250))
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        //own properti
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        //starting
        camera.session.startRunning()
        
        return view
    }
}
