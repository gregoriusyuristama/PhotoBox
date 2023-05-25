//
//  CameraController.swift
//  PhotoBoothByLoct
//
//  Created by Gregorius Yuristama Nugraha on 5/23/23.
//

import SwiftUI
import AVFoundation
import Photos
import os.log

class CameraController: NSObject, ObservableObject {
    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var completion: ((UIImage) -> Void)?
    private var cameraAuthorizationStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    var overlayImages: [UIImage] = []
    private var currentOverlayIndex = 0
    
//    let photoCollection = PhotoCollection(smartAlbum: .smartAlbumUserLibrary)
    
    @Published var session: AVCaptureSession
    
    override init() {
        self.overlayImages = [
            UIImage(named: "emptyOverlay")!,
            UIImage(named: "testOverlay")!,
            UIImage(named: "testOverlay2")!,
            UIImage(named: "testOverlay3")!,
            UIImage(named: "testOverlay4")!,
            UIImage(named: "testOverlay5")!,
        ]
        
        session = captureSession
        super.init()
        
        setupCaptureSession()
        checkCameraAuthorizationStatus()
    }
    
    func setCurrentOverlay(index: Int) {
        guard index >= 0 && index < overlayImages.count else {
            return
        }
        
        currentOverlayIndex = index
    }
    
    func setupCaptureSession() {
        captureSession.beginConfiguration()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified) else {
            print("Failed to get video capture device.")
            return
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            print("Failed to create video input.")
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
            
        }
        
        // Set the desired preset to 3:4
        if captureSession.canSetSessionPreset(.photo) {
            captureSession.sessionPreset = .photo
            photoOutput.isHighResolutionCaptureEnabled = true
        }
        
        // Set the desired video settings with the desired aspect ratio
        let desiredAspectRatio = CGSize(width: 3, height: 4)
        if let format = videoCaptureDevice.formats.first(where: { format in
            let formatDimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
            let formatAspectRatio = CGSize(width: CGFloat(formatDimensions.width), height: CGFloat(formatDimensions.height))
            return formatAspectRatio == desiredAspectRatio
        }) {
            
            do {
                try videoCaptureDevice.lockForConfiguration()
                videoCaptureDevice.activeFormat = format
                videoCaptureDevice.unlockForConfiguration()
            } catch {
                print("Failed to set video format: \(error.localizedDescription)")
            }
        }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        captureSession.commitConfiguration()
    }
    
    
    func checkCameraAuthorizationStatus() {
        switch cameraAuthorizationStatus {
        case .authorized:
            break
        case .notDetermined:
            requestCameraAccess()
        default:
            break
        }
    }
    
    func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            if granted {
                self?.startSession()
            }
        }
    }
    
    func startSession() {
        DispatchQueue.global().async { [self] in
            if !captureSession.isRunning {
                captureSession.startRunning()
            }
        }
        
    }
    
    func stopSession() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func flipCamera() {
        guard let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput else {
            return
        }
        
        captureSession.beginConfiguration()
        
        // Remove the current input
        captureSession.removeInput(currentInput)
        
        // Get the current camera position
        let currentPosition = currentInput.device.position
        
        // Get the desired position for the new camera
        let desiredPosition: AVCaptureDevice.Position = (currentPosition == .back) ? .front : .back
        
        // Find the new camera device with the desired position
        if let newCamera = findCamera(with: desiredPosition) {
            do {
                let newInput = try AVCaptureDeviceInput(device: newCamera)
                
                // Add the new input to the session
                if captureSession.canAddInput(newInput) {
                    captureSession.addInput(newInput)
                }
            } catch {
                print("Failed to create input for new camera: \(error.localizedDescription)")
            }
        }
        
        captureSession.commitConfiguration()
    }
    
    func findCamera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                mediaType: .video,
                                                                position: .unspecified)
        
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        
        return nil
    }
    
    
    func capturePhoto(completion: @escaping (UIImage) -> Void) {
        guard let connection = photoOutput.connection(with: .video), connection.isVideoOrientationSupported else {
            return
        }
        
        let photoSettings = AVCapturePhotoSettings()
        if photoSettings.availablePreviewPhotoPixelFormatTypes.isEmpty {
            return
        }
        
        photoSettings.isHighResolutionPhotoEnabled = true
        if photoSettings.__availablePreviewPhotoPixelFormatTypes.contains(NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)) {
            photoSettings.previewPhotoFormat = [
                kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
            ]
        }
        
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
        
        self.completion = completion
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(), let capturedImage = UIImage(data: imageData) {
            // Do any necessary post-processing or modifications to the captured image here
            // Pass the captured image to the completion handler
            
//            if let overlayImage =  {
                let compositeImage = drawOverlayImage(overlayImages[currentOverlayIndex], on: capturedImage)
                completion?(compositeImage!)
////                savePhotoToLibrary(compositeImage!)
//            }
//            else {
//                completion?(capturedImage)
////                savePhotoToLibrary(capturedImage)
//            }
            //            DispatchQueue.main.async { [self] in
            //                completion?(capturedImage)
            //            }
        }
    }
    
    private func drawOverlayImage(_ overlayImage: UIImage, on baseImage: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(baseImage.size, false, baseImage.scale)
        baseImage.draw(in: CGRect(origin: .zero, size: baseImage.size))
        
        let overlaySize = CGSize(width: baseImage.size.width, height: baseImage.size.height)
        overlayImage.draw(in: CGRect(origin: .zero, size: overlaySize))
        
        let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return compositeImage
    }
}



fileprivate let logger = Logger(subsystem: "gregoriusyuristama.cameraController", category: "CameraController")
