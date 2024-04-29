//
//  CameraView.swift
//  CustomCamera
//
//  Created by Heical Chandra on 25/04/24.
//

import SwiftUI
import AVFoundation

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
    @Published var showPic: UIImage? = nil
    
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
    func takePic() {
        DispatchQueue.global(qos: .background).async {

            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
        
        DispatchQueue.main.async {
            self.isTaken.toggle()
//            DispatchQueue.main.async { Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in self.session.stopRunning() } }
        }
    }
    func reTake() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
//            print("retake")
        }
        DispatchQueue.main.async {
            self.isTaken.toggle()
            // Clear
            self.isSaved = false
//            print("sini")
        }
    }
    func cropImageToSquare(image: UIImage) -> UIImage? {
        let originalWidth = image.size.width
        let originalHeight = image.size.height
        
        let squareSize = min(originalWidth, originalHeight)
        
        let cropX = (originalWidth - squareSize)
        let cropY = (originalHeight - squareSize) / 100
        
        let cropRect = CGRect(x: 400, y: cropY, width: squareSize, height: squareSize)
        
        if let cgImage = image.cgImage?.cropping(to: cropRect) {
            return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
        }
        
        return nil
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        print("ali botak")
        if error != nil{
            print("error njir")
            print(error as Any)
            return
        }
        print("pic taken..")
        
        guard let imageData = photo.fileDataRepresentation() else{return}
        
        self.picData = imageData
        
        //show
        let image = UIImage(data: self.picData)!
        
        let croppedImage = cropImageToSquare(image: image)!
        self.showPic = croppedImage
    }
    
    func savePic(){
        let image = UIImage(data: self.picData)!
        
        let croppedImage = cropImageToSquare(image: image)!

        UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil)
        
//        UIImageWriteToSavedPhotosAlbum(UIImage(data: self.picData)!, nil, nil, nil)
//        
        self.isSaved = true
        print("saved sucessfully")
    }
    
    func showPict(){
        let image = UIImage(data: self.picData)!
        
        let croppedImage = cropImageToSquare(image: image)!
        
        return
    }
}

//setting preview

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .init(x: 90, y: -150, width: 312, height: 321))
        let customSize = CGSize(width: 312, height: 321) // Change these values to your desired size

        let viewController = UIViewController()
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = CGRect(origin: .init(x: 0, y: 0), size: customSize)
        camera.preview.position = CGPoint(x: 155, y: 160)
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
