//
//  Utility.swift
//  Kisha
//
//  Created by Borna Beakovic on 13/09/14.
//  Copyright (c) 2014 Kisha. All rights reserved.
//

import UIKit
import MRProgress
import CoreLocation
import AFDateHelper
import Foundation

let AppUtility = Utility.sharedInstance


class Utility: NSObject {
   
    var currentViewController = UIViewController()
    var activityOverlay:MRProgressOverlayView!
    
    var currentUserId:NSNumber {
        get {
            let id = PersistancyManager.getCurrentUser()?.id
            if id != nil {
                return id!
            }else{
                return 0
            }
        }
    }
    
    class var sharedInstance :Utility {
    struct Singleton {
        static let instance = Utility()
        }
        
        return Singleton.instance
    }
    
    override init() {
        
    }

    func isUserLogged(ShowAlert showAlert:Bool) -> Bool{
        if PersistancyManager.getCurrentUser() == nil {
            if showAlert {
                self.showAlert("Tap on My Profile and create an account to give reviews, rate and add dishes.", title: "Not logged in")
            }
            return false
        }else{
            return true
        }
    }

    
    func showAlert(message:String, title: String) {

            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okButton)
         //   alertController.view.tintColor = UIColor.blackColor()
            topViewController().presentViewController(alertController, animated: true, completion: nil)
    }
    
    func logout() {
        
        EatopineAPI.removeTokenHeader()
        ApplicationDelegate.cleanAndResetupDB()
        ApplicationDelegate.showWelcomeController()

    }
    
    func savePassword(password:String) {
   //     var bundleIdentifier = NSBundle.mainBundle().bundleIdentifier
     //   SSKeychain.setAccessibilityType(kSecAttrAccessibleAlways)
       // SSKeychain.setPassword(password, forService: bundleIdentifier, account: "AccountPassword")
    }
    
    func showActivityOverlay(text:String) {
        if activityOverlay == nil {
            activityOverlay = MRProgressOverlayView.showOverlayAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
        }
        
        activityOverlay?.titleLabelText = text
      //  activityOverlay?.mode = MRProgressOverlayViewMode.IndeterminateSmall
        activityOverlay?.tintColor = COLOR_EATOPINE_RED
    }
    
    func showActivityOverlaySuccessAndHideAfterDelay(message:String) {
        
        
        activityOverlay?.titleLabelText = message
        activityOverlay.mode = MRProgressOverlayViewMode.Checkmark
        
        // hide after 2 seconds
        let delay = 1 * Double(NSEC_PER_SEC)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(delayTime, dispatch_get_main_queue(), {
            self.hideActivityOverlay()
        })
    }
    
    func hideActivityOverlay() {
        dispatch_async(dispatch_get_main_queue(),{
            if self.activityOverlay != nil {
                self.activityOverlay.dismiss(true)
            }
            
            self.activityOverlay = nil
        })
    }
    
    func topViewController() -> UIViewController {
        return topViewControllerWithRootViewController(UIApplication.sharedApplication().keyWindow!.rootViewController!)
    }
    
    func topViewControllerWithRootViewController(rootViewController:UIViewController) -> UIViewController {
        if rootViewController.isKindOfClass(UITabBarController) {
            let tabBarController = rootViewController as! UITabBarController
            return self.topViewControllerWithRootViewController(tabBarController.selectedViewController!)
        }else if rootViewController.isKindOfClass(UINavigationController) {
            let navController = rootViewController as! UINavigationController
            return self.topViewControllerWithRootViewController(navController.visibleViewController!)
        }else if (rootViewController.presentedViewController != nil) {
            let presentedViewController = rootViewController.presentedViewController
            return self.topViewControllerWithRootViewController(presentedViewController!)
        }else{
            return rootViewController
        }
    }

    
    func distanceFromRestaurantInMiles(restaurant:EPRestaurant) -> String{
        let restaurantLocation = CLLocation(latitude: CLLocationDegrees(restaurant.latitude), longitude: CLLocationDegrees(restaurant.longitude))
     //   println("location \(LocationManager.userLocation)")
        
        if LocationManager.userLocation != nil {
            
            let miles = LocationManager.userLocation!.distanceFromLocation(restaurantLocation)/1609.344
        //    println("miles \(miles)")
            let double =  NSString(format: "%.2f", miles).doubleValue
            
            return "\(double) mi"
        }else{
            return ""
        }
        
    }
    
    //MARK: Date Helpers
    
    func reviewCellDateString(date:NSDate) -> String{
        
        if date.isToday() {
            return "Today"
        }
        if date.isYesterday() {
            return "Yesterday"
        }
        if date.daysAfterDate(NSDate()) < 0 {
            let daysAgo = date.daysAfterDate(NSDate())
            return "\(abs(daysAgo)) days ago"
        }
        
        return "Unknown"
    }
    
    func makeCircleImageView(image: UIImageView){
        image.layer.borderWidth = 0
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.blackColor().CGColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
    
    func getMinutesFromToday(dateString: String) -> String{
        let today = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.dateFromString(dateString)
        let betweenGap = today.timeIntervalSinceDate(date!)
        
        var gapString: String = ""
        
        if betweenGap > 3600 * 24 {
            gapString = String(format: "%.d days ago", Int(betweenGap / (3600 * 24) + 1))
        }
        else if betweenGap > 3600 {
            gapString = String(format: "%.d hours ago", Int(betweenGap / 3600))
        }
        else if betweenGap > 60 {
            gapString = String(format: "%.d min ago", Int(betweenGap / 60))
        }
        else if betweenGap > 0 {
            gapString = String(format: "%.d seconds ago", Int(betweenGap))
        }
        else {
            gapString = "0 seconds ago"
        }

        return gapString
    }
}
