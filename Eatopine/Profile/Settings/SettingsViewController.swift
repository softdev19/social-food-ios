//
//  SettingsViewController.swift
//  Eatopine
//
//  Created by Ourangzaib khan on 9/11/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    var userData:UserProfile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   self.navigationController?.title = "Settings"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogoutBtnClick(sender: AnyObject) {
        AppUtility.logout()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editProfile" {
            (segue.destinationViewController as! EditProfileTableViewController).userData = userData
        }
    }

}
