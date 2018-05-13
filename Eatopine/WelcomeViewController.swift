//
//  WelcomeViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 26/07/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class WelcomeViewController: GAITrackedViewController, EPFacebookDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("ui", action: "app_opened", label: "welcome_screen", value: nil).build() as [NSObject : AnyObject])
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
    }
    
    @IBAction func pushLogin(sender: AnyObject?) {
        let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginTableViewController") as! LoginTableViewController
        loginController.prepareForWelcome = true
        self.navigationController?.pushViewController(loginController, animated: true)
    }
    
    @IBAction func skipLogin(sender: AnyObject?) {
        ApplicationDelegate.showTabBarController()
    }
    
    @IBAction func facebookLogin(sender: AnyObject?) {
        ApplicationDelegate.facebookLogin(self,downloadUserProfile:true)
    }
    
    //MARK: FacebookDelegate methods
    
    func didLoginToFacebook(userProfileJSON: [String : AnyObject]?) {
        // login to Eatopine API
        EatopineAPI.loginFacebook(userProfileJSON!, completionClosure: { (success) -> () in
            ApplicationDelegate.showTabBarController()
        })
    }
}


