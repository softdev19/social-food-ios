//
//  SignUpTableViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 27/07/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit
import TTTAttributedLabel
class SignUpTableViewController: UITableViewController, UITextFieldDelegate,EPFacebookDelegate,TTTAttributedLabelDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!

    @IBOutlet weak var label: TTTAttributedLabel!
    
    
    var tapViewEndEditing:UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SignUpTableViewController.popController))
  //      self.navigationItem.backBarButtonItem = backButton
        
        tapViewEndEditing = UITapGestureRecognizer(target: self, action: #selector(SignUpTableViewController.viewEndEditing))
        tapViewEndEditing?.numberOfTapsRequired = 1
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = COLOR_EATOPINE_REAL_RED
        self.navigationController?.navigationBar.tintColor =  UIColor.whiteColor()
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black;
        
        let tosRange = NSString(string: label.text!).rangeOfString("Terms of Service")
        let ppRange = NSString(string: label.text!).rangeOfString("Privacy Policy")
        
        // setup label
        label.delegate = self
        self.label.linkAttributes = [NSFontAttributeName:UIFont.boldSystemFontOfSize(13), kCTForegroundColorAttributeName:COLOR_EATOPINE_RED]
        
        self.label.addLinkToURL(NSURL(string: WEB_LINK_TOS), withRange: tosRange)
        self.label.addLinkToURL(NSURL(string: WEB_LINK_PRIVACY_POLICY), withRange: ppRange)
    }

    override func viewWillDisappear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func viewEndEditing() {
        self.view.endEditing(true)
    }
    
    // MARK: - Actions
    
//    func popController() {
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    
    @IBAction func facebookLogin(sender: AnyObject?) {
        ApplicationDelegate.facebookLogin(self,downloadUserProfile:true)
    }
    
    
    @IBAction func login(sender: AnyObject?) {
        if isInputValid() {
            AppUtility.showActivityOverlay("Signing")
            EatopineAPI.signUp(emailTextField.text!, password: passwordTextField.text!, fullName: firstNameTextField.text!, username: usernameTextField.text!, completionClosure: { (success) -> () in
                AppUtility.hideActivityOverlay()
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        ApplicationDelegate.showTabBarController()
                    })
                }
            })
        }
    }
    
    
    func isInputValid() -> Bool {
        
        if usernameTextField.text == ""{
            AppUtility.showAlert("Please type your username", title: "Notice")
            return false
        }
        if usernameTextField.text!.characters.count < 4{
            AppUtility.showAlert("Username is too short. Must be at least 4 characters", title: "Notice")
            return false
        }
        if usernameTextField.text!.characters.count > 15{
            AppUtility.showAlert("Username is too long. Max is 15 characters", title: "Notice")
            return false
        }
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
    
    //MARK: TTTAttributedLabel methods
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        print("called \(url.absoluteString)")
        if url.absoluteString == WEB_LINK_TOS {
            // open Terms of service in Safari
            UIApplication.sharedApplication().openURL(NSURL(string: WEB_LINK_TOS)!)
        }else{
            // open Privacy policy
            UIApplication.sharedApplication().openURL(NSURL(string: WEB_LINK_PRIVACY_POLICY)!)
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
        
        if textField == firstNameTextField{
            usernameTextField.becomeFirstResponder()
        }else if textField == usernameTextField {
            emailTextField.becomeFirstResponder()
        }else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
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
