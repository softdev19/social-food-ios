//
//  ActivityIndicatorImageView.swift
//  Eatopine
//
//  Created by Borna Beakovic on 17/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class ActivityIndicatorImageView: UIImageView {

    override var image:UIImage? {
        didSet {
            
            if image != nil {
                stopIndicator()
            }
        }
    }

    override var center:CGPoint {
        didSet {
        //    print("did set bounds \(bounds)")
            startIndicator()
            
            activityIndicator.center = self.center
        }
    }
    
    
    var activityIndicator:UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startIndicator() {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            activityIndicator.tintColor = COLOR_EATOPINE_RED
          //  activityIndicator.center = self.center
            self.addSubview(activityIndicator)
        }
        activityIndicator.startAnimating()
    }
    
    func stopIndicator() {
        if activityIndicator != nil {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}
