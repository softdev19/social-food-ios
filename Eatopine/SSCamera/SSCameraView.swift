//
//  SSCameraView.swift
//  SSCamera
//
//  Created by ShawnDu on 15/12/11.
//  Copyright © 2015年 Shawn. All rights reserved.
//

import UIKit

protocol SSCameraViewDelegate {
    func backButtonPressed()
    func switchButtonPressed()
    func captureButtonPressed()
}

class SSCameraView: UIView {
    
    var delegate: SSCameraViewDelegate?
    var preview: UIView!
    var bottomHeight = kCameraBottomHeight
    
    //MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    //MARK: - delegate
    func backButtonPressed() {
        self.delegate?.backButtonPressed()
    }
    
    func switchButtonPressed() {
        self.delegate?.switchButtonPressed()
    }
    
    func captureButtonPressed() {
        self.delegate?.captureButtonPressed()
    }
    
    //MARK: - private method
    fileprivate func initViews() {
        if kScreenHeight == kIPhone4sHeight {
            bottomHeight = kCameraBottom4SHeight
        }
        self.addPreView()
        self.addTopView()
        self.addBottomView()
    }
    
    fileprivate func addTopView() {
        let topView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationHeight))
        topView.backgroundColor = UIColor.black
        
        let switchButton = UIButton.init(frame: CGRect(x: kScreenWidth - kButtonClickWidth, y: 0, width: kButtonClickWidth, height: kButtonClickWidth))
        switchButton.setImage(UIImage(named: "SwitchNormal"), for: UIControlState())
        switchButton.setImage(UIImage(named: "SwitchPress"), for: UIControlState.highlighted)
        switchButton.addTarget(self, action: "switchButtonPressed", for: UIControlEvents.touchUpInside)
        topView.addSubview(switchButton)
        
        self.addSubview(topView)
    }
    
    fileprivate func addPreView() {
        preview = UIView.init(frame: CGRect(x: 0, y: kNavigationHeight, width: self.width, height: self.height - kNavigationHeight - bottomHeight))
        self.addSubview(preview)
    }
    
    fileprivate func addBottomView() {
        let bottomView = UIView.init(frame: CGRect(x: 0, y: self.height - kCameraBottomHeight, width: kScreenWidth, height: bottomHeight))
        bottomView.backgroundColor = UIColor(red: 0.04, green: 0.78, blue: 0.9, alpha: 1.0)
        self.addSubview(bottomView)
        
        let captureImage = UIImage(named: "CaptureNormal")
        let captureButton = UIButton.init(frame: CGRect(x: (self.width - (captureImage?.width)!)/2, y: (bottomView.height - (captureImage?.height)!)/2, width: (captureImage?.width)!, height: (captureImage?.height)!))
        captureButton.setImage(captureImage, for: UIControlState())
        captureButton.setImage(UIImage(named: "CapturePress"), for: UIControlState.highlighted)
        captureButton.addTarget(self, action: "captureButtonPressed", for: UIControlEvents.touchUpInside)
        bottomView.addSubview(captureButton)
    }
    
}
