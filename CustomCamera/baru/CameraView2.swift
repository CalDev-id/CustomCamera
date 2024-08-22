//
//  CameraView.swift
//  CustomCamera
//
//  Created by Heical Chandra on 25/04/24.
//

import SwiftUI
import AVFoundation

class CameraModel2: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    @Published var showPic: UIImage? = nil
    @Published var croppedImage: UIImage? = nil
    
    private var isUsingFrontCamera = false
    
    func Check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            alert.toggle()
        default:
            break
        }
    }
    
    func setUp() {
        do {
            self.session.beginConfiguration()
            
            let position: AVCaptureDevice.Position = isUsingFrontCamera ? .front : .back
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.inputs.count > 0 {
                self.session.removeInput(self.session.inputs[0])
            }
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        } catch {
            print("Error setting up camera: \(error.localizedDescription)")
        }
    }
    
    func toggleCamera() {
        isUsingFrontCamera.toggle()
        setUp()
    }
    
    func takePic() {
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
        DispatchQueue.main.async {
            self.isTaken.toggle()
        }
    }
    
    func reTake() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
        DispatchQueue.main.async {
            self.isTaken.toggle()
            self.isSaved = false
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
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        self.picData = imageData
        self.showPic = UIImage(data: self.picData)
        
        let cropping = cropImageToSquare(image: showPic!)!
        self.croppedImage = cropping
    }
    
    func savePic() {
        if let image = UIImage(data: self.picData) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.isSaved = true
            print("Saved successfully")
        }
    }
}

//setting preview

struct CameraPreview2: UIViewRepresentable {
    
    @ObservedObject var camera : CameraModel2
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        let viewController = UIViewController()
        
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
