//
//  LoginTableViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 26/07/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginTableViewController: UITableViewController, UITextFieldDelegate, EPFacebookDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var tapViewEndEditing:UITapGestureRecognizer!
    var prepareForWelcome = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hideBottomHairline()
        
        let leftBarButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(LoginTableViewController.popController))
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        tapViewEndEditing = UITapGestureRecognizer(target: self, action: #selector(LoginTableViewController.viewEndEditing))
        tapViewEndEditing?.numberOfTapsRequired = 1
        
        //usern
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewEndEditing() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if prepareForWelcome == true {
            self.navigationController?.navigationBar.translucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.tintColor = UIColor.lightGrayColor()
            self.navigationController?.navigationBarHidden = false
            self.navigationController?.navigationBar.barStyle = UIBarStyle.Default;
        }
    }
    
    // MARK: - Actions
    
    func popController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func loginPressed(sender: AnyObject?) {
        if isInputValid() {
            AppUtility.showActivityOverlay("")
            EatopineAPI.login(emailTextField.text!, password: passwordTextField.text!, completionClosure: { (success) -> () in
                AppUtility.hideActivityOverlay()
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        ApplicationDelegate.showTabBarController()
                    })
                }
            })
        }
    }
    
//    @IBAction func facebookLogin(sender: AnyObject?) {
//        ApplicationDelegate.facebookLogin(self,downloadUserProfile:true)
//    }
//    
//    
    
    func isInputValid() -> Bool {
        
        if emailTextField.text == ""{
            AppUtility.showAlert("Email field is empty", title: "Notice")
            return false
        }
        if passwordTextField.text == ""{
            AppUtility.showAlert("Password field is empty", title: "Notice")
            return false
        }
        if passwordTextField.text!.characters.count < 6{
            AppUtility.showAlert("Password field is too short. Must be at least 6 characters", title: "Notice")
            return false
        }
        if passwordTextField.text!.characters.count > 12{
            AppUtility.showAlert("Password field is too long. Max is 12 characters", title: "Notice")
            return false
        }
        if !isEmailValid(emailTextField.text!){
            return false
        }
        
        self.view.endEditing(true)
        return true
    }
    
    func isEmailValid(emailString: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if (emailTest.evaluateWithObject(emailString)) {
            return true
        }else {
            AppUtility.showAlert("Check your email and try again", title: "Email not valid")
            return false
        }
    }
    
    
    //MARK: UITextField delegate methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.view.addGestureRecognizer(tapViewEndEditing!)
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.view.removeGestureRecognizer(tapViewEndEditing!)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            self.loginPressed(nil)
        }
        return true
    }
    
//    
//    
//    //MARK: FacebookDelegate methods
//    
//    func didLoginToFacebook(userProfileJSON: [String : AnyObject]?) {
//        // login to Eatopine API
//        EatopineAPI.loginFacebook(userProfileJSON!, completionClosure: { (success) -> () in
//            dispatch_async(dispatch_get_main_queue(), {
//                ApplicationDelegate.showTabBarController()
//            })
//        })
//    }
    
}
