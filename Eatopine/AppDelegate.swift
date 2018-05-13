//
//  AppDelegate.swift
//  Eatopine
//
//  Created by on 25/07/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord
import FBSDKCoreKit
import FBSDKLoginKit
import Fabric
import Crashlytics
import TwitterKit
import GooglePlaces

let kFacebookErrorTitle = "Facebok login failed"


@objc protocol EPFacebookDelegate {
   optional func didLoginToFacebook(userProfileJSON:[String : AnyObject]?)
   optional func didReturnFromAskingPublishPermission(didGetPermission:Bool)
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?
    var delegate: EPFacebookDelegate?
    var shouldRotate = false;
    var previousTabIndex = 0;
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        setupDB()
        Fabric.with([Crashlytics(), Twitter.self()])

        if AppUtility.isUserLogged(ShowAlert: false) {
            showTabBarController()
        }
        
        GMSPlacesClient.provideAPIKey("AIzaSyC3R0D5FzxuCbdFfulZ2Dnr1nqxWGULZEg")
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance()
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackerWithTrackingId("UA-55944228-2")
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.dispatchInterval = 20
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release

        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if (AppUtility.isUserLogged(ShowAlert: false)) {
            LocationManager.getCurrentUserLocation { (location, error) -> () in
                
            }
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        MagicalRecord.cleanUp()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        if shouldRotate == true{
            return UIInterfaceOrientationMask.AllButUpsideDown
        }else{
            return UIInterfaceOrientationMask.Portrait
        }
    }
    
    
    func showTabBarController() {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let newRootController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") 
        window?.rootViewController = newRootController
        
        // Start LocationManager
        LocationManager.getCurrentUserLocation { (location, error) -> () in
        }
    }
    
    func showWelcomeController() {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let newRootController = storyboard.instantiateViewControllerWithIdentifier("WelcomeNavViewController") as! UINavigationController
        window?.rootViewController = newRootController
    }
    

    //MARK: Facebook methods
    
    func facebookLogin(delegate:AnyObject,downloadUserProfile:Bool) {
        
        self.delegate = delegate as? EPFacebookDelegate
        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["email","public_profile","user_friends"]) { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if error != nil {
                AppUtility.showAlert("\(error.localizedDescription)", title: kFacebookErrorTitle)
            }else if result.isCancelled {
                AppUtility.showAlert("You cancelled Facebook login", title: kFacebookErrorTitle)
            }else{
                if result.grantedPermissions.contains("email") && result.grantedPermissions.contains("public_profile") {
                    
                    if downloadUserProfile == true {
                        // go get user profile info
                        FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,name,email,gender,first_name,last_name"]).startWithCompletionHandler({ (connection:FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
                            print("params \(result)")
                            if error == nil {
                                self.delegate?.didLoginToFacebook!(result as? [String : AnyObject])
                            }else{
                                AppUtility.showAlert("Could not get your Facebook profile data.\(error.localizedDescription)", title: kFacebookErrorTitle)
                            }
                        })
                    }else{
                        self.delegate?.didLoginToFacebook!(nil)
                    }
                    
                }else{
                    AppUtility.showAlert("Needed permissions not granted", title: kFacebookErrorTitle)
                }
            }
        }
    }
    
    func facebookLoginPublishPermissions(delegate:AnyObject) {
        
        self.delegate = delegate as? EPFacebookDelegate
        let login = FBSDKLoginManager()
        login.logInWithPublishPermissions(["publish_actions"]) { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if error != nil {
                AppUtility.showAlert("\(error.localizedDescription)", title: kFacebookErrorTitle)
                self.delegate?.didReturnFromAskingPublishPermission!(false)
            }else if result.isCancelled {
                AppUtility.showAlert("You cancelled Facebook action", title: kFacebookErrorTitle)
                self.delegate?.didReturnFromAskingPublishPermission!(false)
            }else{
                if result.grantedPermissions.contains("publish_actions"){
                    self.delegate?.didReturnFromAskingPublishPermission!(true)
                }else{
                    AppUtility.showAlert("Needed permissions not granted", title: kFacebookErrorTitle)
                    self.delegate?.didReturnFromAskingPublishPermission!(false)
                }
            }
        }
    }
    
    //MARK: MagicalRecord/CoreData methods
    func setupDB() {
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed(self.dbStore())
    }
    
    func dbStore() -> String {
        return "\(self.bundleID()).sqlite"
    }
    
    func bundleID() -> String {
        return NSBundle.mainBundle().bundleIdentifier!
    }
    
    func cleanAndResetupDB() {
        let dbStore = self.dbStore()
        
        let url = NSPersistentStore.MR_urlForStoreName(dbStore)
        
        MagicalRecord.cleanUp()
        do{
            try NSFileManager.defaultManager().removeItemAtURL(url)
            self.setupDB()
        } catch  let error as NSError{
            print("An error has occured while deleting \(dbStore)")
            print("Error description: \(error.description)")
        }

    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        previousTabIndex = tabBarController.selectedIndex
        return true
    }

}

