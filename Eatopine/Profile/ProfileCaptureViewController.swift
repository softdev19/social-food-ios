//
//  ProfileCaptureViewController.swift
//  Eatopine
//
//  Created by  on 10/16/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import CoreMotion
import Photos

class ProfileCaptureViewController: UIViewController {
    internal class func checkCameraPermission(handler: (granted: Bool) -> Void) {
        func hasCameraPermission() -> Bool {
            return AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) == .Authorized
        }
        
        func needsToRequestCameraPermission() -> Bool {
            return AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) == .NotDetermined
        }
        
        hasCameraPermission() ? handler(granted: true) : (needsToRequestCameraPermission() ?
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { granted in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    hasCameraPermission() ? handler(granted: true) : handler(granted: false)
                })
            }) : handler(granted: false))
    }
    
    internal var didCancel: (() -> Void)?
    internal var didFinishCapturingImage: ((image: UIImage) -> Void)?
    
    internal var cameraOverlayView: UIView? {
        didSet {
            if let cameraOverlayView = cameraOverlayView {
                self.view.addSubview(cameraOverlayView)
            }
        }
    }
    
    /// The flashModel will to be remembered to next use.
    internal var flashMode:AVCaptureFlashMode! {
        didSet {
            self.updateFlashButton()
            self.updateFlashMode()
            self.updateFlashModeToUserDefautls(self.flashMode)
        }
    }
    
    internal class func isAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    internal var allowsRotate = false
    
    internal let captureSession = AVCaptureSession()
    internal var previewLayer: AVCaptureVideoPreviewLayer!
    private var beginZoomScale: CGFloat = 1.0
    private var zoomScale: CGFloat = 1.0
    
    internal var currentDevice: AVCaptureDevice?
    internal var captureDeviceFront: AVCaptureDevice?
    internal var captureDeviceBack: AVCaptureDevice?
    private weak var stillImageOutput: AVCaptureStillImageOutput?
    
    
    @IBOutlet weak var contentView: UIView!
    
    internal var originalOrientation: UIDeviceOrientation!
    internal var currentOrientation: UIDeviceOrientation!
    internal let motionManager = CMMotionManager()
    
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var btnCameraSwitch: UIBarButtonItem!
    @IBOutlet weak var btnLibrary: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = COLOR_EATOPINE_REAL_RED
        self.tabBarController?.hidesBottomBarWhenPushed
        // Do any additional setup after loading the view.
        self.setupDevices()
        self.setupUI()
        self.beginSession()
        
        let imgManager = PHImageManager.defaultManager()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        
        // Sort the images by creation date
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions) {
            
            if fetchResult.count > 0 {
                // Perform the image request
                imgManager.requestImageForAsset(fetchResult.objectAtIndex(fetchResult.count - 1) as! PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.AspectFill, options: requestOptions, resultHandler: { (image, _) in
                    
                    // Add the returned image to your array
                    self.btnLibrary.setImage(image, forState: UIControlState.Normal)
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = COLOR_EATOPINE_REAL_RED
        if !self.captureSession.running {
            self.captureSession.startRunning()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.captureSession.stopRunning()
        self.motionManager.stopAccelerometerUpdates()
    }
    
    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    internal override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    internal func setupDevices() {
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        
        for device in devices {
            if device.position == .Back {
                self.captureDeviceBack = device
            }
            
            if device.position == .Front {
                self.captureDeviceFront = device
            }
        }
        
        self.currentDevice = self.captureDeviceBack ?? self.captureDeviceFront
    }
    
    let bottomView = UIView()
    
    internal func setupUI() {
        self.view.backgroundColor = UIColor.blackColor()
        
        contentView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(CameraViewController.handleZoom(_:))))
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CameraViewController.handleFocus(_:))))
    }
    
    // MARK: - Callbacks
    
    internal func dismiss() {
        self.didCancel?()
    }
    
    internal func takePicture() {
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        if authStatus == .Denied {
            return
        }
        
        if let stillImageOutput = self.stillImageOutput {
            dispatch_async(dispatch_get_global_queue(0, 0), {
                let connection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo)
                if connection == nil {
                    return
                }
                
                connection.videoScaleAndCropFactor = self.zoomScale
                
                stillImageOutput.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { (imageDataSampleBuffer, error: NSError?) -> Void in
                    
                    if error == nil {
                        let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                        
                        if let takenImage = UIImage(data: imageData) {
                            
                            let outputRect = self.previewLayer.metadataOutputRectOfInterestForRect(self.previewLayer.bounds)
                            let takenCGImage = takenImage.CGImage
                            let width = CGFloat(CGImageGetWidth(takenCGImage))
                            let height = CGFloat(CGImageGetHeight(takenCGImage))
                            let cropRect = CGRect(x: outputRect.origin.x * width, y: outputRect.origin.y * height, width: outputRect.size.width * width, height: outputRect.size.height * height)
                            
                            let cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect)
                            let cropTakenImage = UIImage(CGImage: cropCGImage!, scale: 1, orientation: takenImage.imageOrientation)
                            
                            self.captureSession.stopRunning()
                            self.motionManager.stopAccelerometerUpdates()
                            
                            for tempVC in (self.navigationController?.viewControllers)! {
                                if tempVC is EditProfileTableViewController {
                                    (tempVC as! EditProfileTableViewController).newProfilePhoto = cropTakenImage
                                    self.navigationController?.popViewControllerAnimated(true)
                                }
                            }
                        }
                        
                    } else {
                        print("error while capturing still image: \(error!.localizedDescription)", terminator: "")
                    }
                })
            })
        }
        
    }
    
    // MARK: - Handles Zoom
    
    internal func handleZoom(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Began {
            self.beginZoomScale = self.zoomScale
        } else if gesture.state == .Changed {
            self.zoomScale = min(4.0, max(1.0, self.beginZoomScale * gesture.scale))
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.025)
            self.previewLayer.setAffineTransform(CGAffineTransformMakeScale(self.zoomScale, self.zoomScale))
            CATransaction.commit()
        }
    }
    
    // MARK: - Handles Focus
    
    internal func handleFocus(gesture: UITapGestureRecognizer) {
        if let currentDevice = self.currentDevice where currentDevice.focusPointOfInterestSupported {
            let touchPoint = gesture.locationInView(self.view)
            self.focusAtTouchPoint(touchPoint)
        }
    }
    
    // MARK: - Handles Switch Camera
    
    internal func switchCamera() {
        self.currentDevice = self.currentDevice == self.captureDeviceBack ?
            self.captureDeviceFront : self.captureDeviceBack
        
        self.setupCurrentDevice()
    }
    
    // MARK: - Handles Flash
    
    internal func switchFlashMode() {
        switch self.flashMode! {
        case .Auto:
            self.flashMode = .Off
        case .On:
            self.flashMode = .Auto
        case .Off:
            self.flashMode = .On
        }
    }
    
    internal func flashModeFromUserDefaults() -> AVCaptureFlashMode {
        let rawValue = NSUserDefaults.standardUserDefaults().integerForKey ("CameraViewController.flashMode")
        return AVCaptureFlashMode(rawValue: rawValue)!
    }
    
    internal func updateFlashModeToUserDefautls(flashMode: AVCaptureFlashMode) {
        NSUserDefaults.standardUserDefaults().setInteger(flashMode.rawValue, forKey: "CameraViewController.flashMode")
    }
    
    internal func updateFlashButton() {
        struct FlashImage {
            
            static let images = [
                AVCaptureFlashMode.Auto : UIImage(named: "flash_auto.png"),
                AVCaptureFlashMode.On : UIImage(named: "flash_on.png"),
                AVCaptureFlashMode.Off : UIImage(named: "flash_off.png")
            ]
            
        }
        let flashImage: UIImage = FlashImage.images[self.flashMode]!!
        
        self.btnFlash.setImage(flashImage, forState: UIControlState())
    }
    
    // MARK: - Capture Session
    
    internal func beginSession() {
        self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        self.setupCurrentDevice()
        
        let stillImageOutput = AVCaptureStillImageOutput()
        if self.captureSession.canAddOutput(stillImageOutput) {
            self.captureSession.addOutput(stillImageOutput)
            self.stillImageOutput = stillImageOutput
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewLayer.frame = self.contentView.bounds
        
        let rootLayer = self.view.layer
        rootLayer.masksToBounds = true
        rootLayer.insertSublayer(self.previewLayer, atIndex: 0)
    }
    
    internal func setupCurrentDevice() {
        if let currentDevice = self.currentDevice {
            
            if currentDevice.flashAvailable {
                self.btnFlash.hidden = false
                self.flashMode = self.flashModeFromUserDefaults()
            } else {
                self.btnFlash.hidden = true
            }
            
            for oldInput in self.captureSession.inputs as! [AVCaptureInput] {
                self.captureSession.removeInput(oldInput)
            }
            
            let frontInput = try? AVCaptureDeviceInput(device: self.currentDevice)
            if self.captureSession.canAddInput(frontInput) {
                self.captureSession.addInput(frontInput)
            }
            
            try! currentDevice.lockForConfiguration()
            if currentDevice.isFocusModeSupported(.ContinuousAutoFocus) {
                currentDevice.focusMode = .ContinuousAutoFocus
            }
            
            if currentDevice.isExposureModeSupported(.ContinuousAutoExposure) {
                currentDevice.exposureMode = .ContinuousAutoExposure
            }
            
            currentDevice.unlockForConfiguration()
        }
    }
    
    internal func updateFlashMode() {
        if let currentDevice = self.currentDevice
            where currentDevice.flashAvailable && currentDevice.isFlashModeSupported(self.flashMode) {
            try! currentDevice.lockForConfiguration()
            currentDevice.flashMode = self.flashMode
            currentDevice.unlockForConfiguration()
        }
    }
    
    internal func focusAtTouchPoint(touchPoint: CGPoint) {
        
        func showFocusViewAtPoint(touchPoint: CGPoint) {
            
            struct FocusView {
                static let focusView: UIView = {
                    let focusView = UIView()
                    let diameter: CGFloat = 100
                    focusView.bounds.size = CGSize(width: diameter, height: diameter)
                    focusView.layer.borderWidth = 2
                    focusView.layer.cornerRadius = diameter / 2
                    focusView.layer.borderColor = UIColor.whiteColor().CGColor
                    
                    return focusView
                }()
            }
            FocusView.focusView.transform = CGAffineTransformIdentity
            FocusView.focusView.center = touchPoint
            self.view.addSubview(FocusView.focusView)
            UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.1,
                                       options: UIViewAnimationOptions(), animations: { () -> Void in
                                        FocusView.focusView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.6, 0.6)
            }) { (Bool) -> Void in
                FocusView.focusView.removeFromSuperview()
            }
        }
        
        if self.currentDevice == nil || self.currentDevice?.flashAvailable == false {
            return
        }
        
        let focusPoint = self.previewLayer.captureDevicePointOfInterestForPoint(touchPoint)
        
        showFocusViewAtPoint(touchPoint)
        
        if let currentDevice = self.currentDevice {
            try! currentDevice.lockForConfiguration()
            currentDevice.focusPointOfInterest = focusPoint
            currentDevice.exposurePointOfInterest = focusPoint
            
            currentDevice.focusMode = .ContinuousAutoFocus
            
            if currentDevice.isExposureModeSupported(.ContinuousAutoExposure) {
                currentDevice.exposureMode = .ContinuousAutoExposure
            }
            
            currentDevice.unlockForConfiguration()
        }
        
    }
    
    @IBAction func onCancelBtnClick(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func captureFrame(sender: AnyObject) {
        takePicture()
    }
    
    @IBAction func onChangeCameraClick(sender: UIBarButtonItem) {
        switchCamera()
    }
    
    @IBAction func onFlashBtnClick(sender: UIButton) {
        switchFlashMode()
    }
    
    @IBAction func onPhotoLibraryBtnClick(sender: AnyObject) {
        self.captureSession.stopRunning()
        self.motionManager.stopAccelerometerUpdates()
        
        let imagePickerController = storyboard?.instantiateViewControllerWithIdentifier("PhotoLibraryViewController") as! PhotoLibraryViewController
        self.navigationController?.pushViewController(imagePickerController, animated: true)
    }
}
