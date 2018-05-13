//
//  Extensions.swift
//  Eatopine
//
//  Created by Borna Beakovic on 26/07/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import Foundation
import UIKit
extension UITabBarController {
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        // animate the tabBar
        UIView.animateWithDuration(animated ? 0.3 : 0.0) {
            self.tabBar.frame = CGRectOffset(frame, 0, offsetY)
            self.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height + offsetY)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }
}

extension UINavigationBar {
    
    func hideBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView!.hidden = true
    }
    
    func showBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView!.hidden = false
    }
    
    private func hairlineImageViewInNavigationBar(view: UIView) -> UIImageView? {
        if view.isKindOfClass(UIImageView) && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        
        let subviews = (view.subviews )
        for subview: UIView in subviews {
            if let imageView: UIImageView = hairlineImageViewInNavigationBar(subview) {
                return imageView
            }
        }
        
        return nil
    }
    
}

extension UIToolbar {
    
    func hideHairline() {
        let navigationBarImageView = hairlineImageViewInToolbar(self)
        navigationBarImageView!.hidden = true
    }
    
    func showHairline() {
        let navigationBarImageView = hairlineImageViewInToolbar(self)
        navigationBarImageView!.hidden = false
    }
    
    private func hairlineImageViewInToolbar(view: UIView) -> UIImageView? {
        if view.isKindOfClass(UIImageView) && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        
        let subviews = (view.subviews )
        for subview: UIView in subviews {
            if let imageView: UIImageView = hairlineImageViewInToolbar(subview) {
                return imageView
            }
        }
        
        return nil
    }
}

extension UINavigationItem {
    
    func backButtonNoText() {
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.backBarButtonItem = backButton
    }
}


extension UIView {
    
    func addBottomToTopGradient(){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.endPoint = CGPointMake(0.5, 1.2)
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]
        self.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    func smallBottomToTopGradient(){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.endPoint = CGPointMake(0.5, 1.5)
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]
        self.layer.insertSublayer(gradient, atIndex: 0)
    }
}

class EatopineRatingView: TPFloatRatingView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}

extension TPFloatRatingView {
    
    func setupForEatopineSmall(){
        
        self.emptySelectedImage = UIImage(named: "ratingChef_smaller_empty")
        self.fullSelectedImage = UIImage(named: "ratingChef_smaller_full")
        self.maxRating = 5;
        self.minRating = 0;
        self.editable = false;
        self.halfRatings = true;
        self.floatRatings = false;
    }
    
    func setupForEatopineMiddle(){
        
        self.emptySelectedImage = UIImage(named: "ratingChef_middle_empty")
        self.fullSelectedImage = UIImage(named: "ratingChef_middle_full")
        
//        self.emptySelectedImage = UIImage(named: "chef_hat_white")
//        self.fullSelectedImage = UIImage(named: "chef_hat_red")
        self.maxRating = 5;
        self.minRating = 0;
        self.editable = false;
        self.halfRatings = true;
        self.floatRatings = false;
    }
    
    func setupForEatopineBigWithRate(){
        self.emptySelectedImage = UIImage(named: "ratingChef_big_empty")
        self.fullSelectedImage = UIImage(named: "ratingChef_big_full")
        self.maxRating = 5;
        self.minRating = 0;
        self.editable = true;
        self.halfRatings = false;
        self.floatRatings = false;
        self.rating = 0
    }
    
    func setupForAnnotation(){
        
        self.emptySelectedImage = UIImage(named: "ratingChef_tiny_empty")
        self.fullSelectedImage = UIImage(named: "ratingChef_tiny_full")
        self.maxRating = 5;
        self.minRating = 0;
        self.editable = false;
        self.halfRatings = true;
        self.floatRatings = false;
    }
    
}


extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}


extension UISearchController {
    func initialSetup() {
        self.searchBar.sizeToFit()
        self.searchBar.tintColor = UIColor.whiteColor()
        self.searchBar.barTintColor = COLOR_EATOPINE_REAL_RED
        self.searchBar.backgroundImage = UIImage.imageWithColor(COLOR_EATOPINE_REAL_RED)
        self.dimsBackgroundDuringPresentation = false
        
        getSearchBarTextField()?.tintColor = COLOR_EATOPINE_RED
        
    }
    
    func searchBarCursorColor(color:UIColor){
        getSearchBarTextField()?.tintColor = color
    }
    
    func getSearchBarTextField() -> UITextField? {
        let subView = self.searchBar.subviews[0] 
        let textField = subView.subviews[1] 
        return textField as? UITextField
    }
}

extension UISearchBar {
    
    func setCursorColor(color:UIColor){
        getSearchBarTextField()?.tintColor = color
    }
    
    func getSearchBarTextField() -> UITextField? {
        let subView = self.subviews[0]
        let textField = subView.subviews[1]
        return textField as? UITextField
    }
}

extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}


