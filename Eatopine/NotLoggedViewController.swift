//
//  NotLoggedViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 26/10/15.
//  Copyright © 2015 Eatopine. All rights reserved.
//

import UIKit

class NotLoggedViewController: UIViewController,EPFacebookDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func facebookLogin(sender: AnyObject?) {
        ApplicationDelegate.facebookLogin(self,downloadUserProfile:true)
    }
    
    //MARK: FacebookDelegate methods
    
    func didLoginToFacebook(userProfileJSON: [String : AnyObject]?) {
        // login to Eatopine API
        EatopineAPI.loginFacebook(userProfileJSON!, completionClosure: { (success) -> () in
            dispatch_async(dispatch_get_main_queue(), {
                ApplicationDelegate.showTabBarController()
            })
        })
    }
}
