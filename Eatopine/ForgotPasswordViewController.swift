//
//  ForgotPasswordViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 26/07/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  //      let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ForgotPasswordViewController.popController))
    //    self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = COLOR_EATOPINE_REAL_RED
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
//    func popController() {
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    
    @IBAction func forgotPressed(sender: AnyObject?) {
        if isInputValid() {
            AppUtility.showActivityOverlay("Sending")
            EatopineAPI.forgotPassword(emailTextField.text!, completionClosure: { (success) -> () in
                AppUtility.showActivityOverlaySuccessAndHideAfterDelay("E-mail sent successfully")
                if success {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
        }
    }
    
    func isInputValid() -> Bool {
        
        if emailTextField.text == ""{
            AppUtility.showAlert("Email field is empty", title: "Notice")
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
}
