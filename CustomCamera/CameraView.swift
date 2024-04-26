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

//#Preview {
//    CameraView()
//}

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
                        Button(action: camera.reTake, label: {
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
                    } else{
                        Button(action: camera.takePic, label: {
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

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate{
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    //read pic data
    @Published var output = AVCapturePhotoOutput()
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    //picdata
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    
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
                                                 for:.video, position: .back)
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
            print("error disini2")
            print(error.localizedDescription)
        }
    }
    //take n retake
    func takePic(){
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
            }
        }
        self.session.stopRunning()
    }
    
    func reTake() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            DispatchQueue.main.async{
                withAnimation{self.isTaken.toggle()}
                //clear
                self.isSaved = false
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("ali botak")
        if error != nil{
            print("error njir")
            print(error as Any)
            return
        }
        print("pic taken..")
        
        guard let imageData = photo.fileDataRepresentation() else{return}
        self.picData = imageData
    }

    func savePic(){
        let image = UIImage(data: self.picData)!
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
//        UIImageWriteToSavedPhotosAlbum(UIImage(data: self.picData)!, nil, nil, nil)
//        
        self.isSaved = true
        print("saved sucessfully")
    }
}

//setting preview

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) -> UIView {
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
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
