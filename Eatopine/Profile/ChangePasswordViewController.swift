//
//  ChangePasswordViewController.swift
//  Eatopine
//
//  Created by on 10/17/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UITableViewController {
    
    @IBOutlet weak var txtCurrentPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onCancelBtnClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onSaveBtnClick(sender: AnyObject) {
        if !isValid() {
            return
        }
        
        AppUtility.showActivityOverlay("")
        EatopineAPI.updatePassword(AppUtility.currentUserId.integerValue, currentPass: txtCurrentPass.text!, newPass: txtNewPass.text!) { (success) in
            if (success) {
                AppUtility.showActivityOverlaySuccessAndHideAfterDelay("Success")
                self.navigationController?.popViewControllerAnimated(true)
            }
            else {
                AppUtility.hideActivityOverlay()
            }
        }
    }
    
    func isValid() -> Bool {
        if txtCurrentPass.text! == "" {
            AppUtility.showAlert("Please Input Current Password", title: "Empty")
            txtCurrentPass.becomeFirstResponder()
            return false
        }
        if txtNewPass.text == "" {
            AppUtility.showAlert("Please Input New Password", title: "Empty")
            txtNewPass.becomeFirstResponder()
            return false
        }
        if txtConfirmPass.text == "" {
            AppUtility.showAlert("Please Input Confirm Password", title: "Empty")
            txtConfirmPass.becomeFirstResponder()
            return false
        }
        if txtNewPass.text != txtConfirmPass.text {
            AppUtility.showAlert("Password do not match", title: "Error")
            txtConfirmPass.becomeFirstResponder()
            return false
        }
        self.view.endEditing(true)
        return true
    }
}
