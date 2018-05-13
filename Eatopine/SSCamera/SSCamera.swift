//
//  SSCamera.swift
//  SSCamera
//
//  Created by ShawnDu on 15/12/11.
//  Copyright © 2015年 Shawn. All rights reserved.
//

import UIKit
import AVFoundation

public enum CameraFlashMode: Int {
    case off, on, auto
}

class SSCamera: NSObject{
    
    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var captureDevice: AVCaptureDevice!
    var stillImageOutput: AVCaptureStillImageOutput!
    var input: AVCaptureDeviceInput!
    var isUsingFront = true
    var cameraPosition: AVCaptureDevicePosition {
        get {
            return input.device.position
        }
        set {
        }
    }
    
    init(sessionPreset: String, position: AVCaptureDevicePosition) {
        session = AVCaptureSession.init()
        session.sessionPreset = sessionPreset
        
        previewLayer = AVCaptureVideoPreviewLayer.init(session: session)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kCameraBottomHeight - kNavigationHeight)
        if kScreenHeight == kIPhone4sHeight {
            previewLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kCameraBottom4SHeight - kNavigationHeight)
        }
        
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for device in devices! {
            if (device as AnyObject).position == position {
                captureDevice = device as! AVCaptureDevice
            }
        }
        
        do {
            input = try AVCaptureDeviceInput.init(device: captureDevice)
            if session.canAddInput(input) {
                session.addInput(input)
            }
        } catch {
            print("add video input error")
        }
        
        stillImageOutput = AVCaptureStillImageOutput.init()
        let outputSettings = NSDictionary.init(object: AVVideoCodecJPEG, forKey: AVVideoCodecKey as NSCopying)
        stillImageOutput.outputSettings = outputSettings as! [AnyHashable: Any]
        if session.canAddOutput(stillImageOutput) {
            session.addOutput(stillImageOutput)
        }
        session.startRunning()
    }
    
    //MARK: - public method
    func takePhoto(_ complete: @escaping ((UIImage?) -> Void)){
        var image: UIImage!
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                self.session.stopRunning()
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    image = UIImage.init(data: imageData!)
                    complete(image)
                } else if error != nil {
                    print("Take photo error", error)
                }
            })
        }
    }
    
    func startCapture() {
        if !session.isRunning {
            session.startRunning()
        }
    }
    
    func stopCapture() {
        if session.isRunning {
            session.stopRunning()
        }
    }
    
    func switchCamera() {
        var currentCameraPosition = self.cameraPosition
        if currentCameraPosition == AVCaptureDevicePosition.back {
            currentCameraPosition = AVCaptureDevicePosition.front
            isUsingFront = true
        } else {
            currentCameraPosition = AVCaptureDevicePosition.back
            isUsingFront = false
        }
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        var afterSwitchCamera: AVCaptureDevice?
        var newInput: AVCaptureDeviceInput?
        for device in devices! {
            if (device as AnyObject).position == currentCameraPosition {
                afterSwitchCamera = device as? AVCaptureDevice
            }
        }
        do {
            newInput = try AVCaptureDeviceInput.init(device: afterSwitchCamera)
            session.beginConfiguration()
            session.removeInput(input)
            if session.canAddInput(newInput) {
                input = newInput
            }
            session.addInput(input)
            session.commitConfiguration()
            captureDevice = afterSwitchCamera
        } catch {
            print("add new input error when switch")
        }
    }
    
    func turnOnFlashMode() {
        if (!captureDevice.isFlashAvailable) {
            return
        }
        do {
            try captureDevice!.lockForConfiguration()
            if (captureDevice?.flashMode == .auto){
                captureDevice?.flashMode = .on
//                btnFlash.setImage(UIImage(named: "flashOn") , forState: .Normal)
            }else if (captureDevice?.flashMode == .on){
                captureDevice?.flashMode = .off
//                btnFlash.setImage(UIImage(named: "flashOff") , forState: .Normal)
            }else{
                captureDevice?.flashMode = .auto
//                btnFlash.setImage(UIImage(named: "flashAuto") , forState: .Normal)
            }
            captureDevice!.unlockForConfiguration()
        } catch _ { }
    }
}
