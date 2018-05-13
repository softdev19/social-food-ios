//
//  EditProfileTableViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 07/09/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit
import SDWebImage

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtAbout: UITextView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtTelephone: UITextField!
    
    @IBOutlet weak var txtGender: UITextField!
    
    var userData:UserProfile!
    private var saveMedia:Bool?
    var newProfilePhoto:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (userData.profilePhoto == "") {
            newProfilePhoto = UIImage(named: "placeholder_profile")
        }
        else {
            imgProfile.sd_setImageWithURL(NSURL(string: userData.profilePhoto), placeholderImage: UIImage(named: "placeholder_profile"))
            newProfilePhoto = imgProfile.image
        }
        imgProfile.clipsToBounds = true
        imgProfile.layer.cornerRadius = 25
        txtFullName.text = userData.fullname
        txtUserName.text = userData.username
        txtAbout.text = userData.description
        txtEmail.text = userData.email
        txtTelephone.text = userData.phone
        txtCity.text = userData.city
        
        txtAbout.delegate = self
        if txtAbout.text == "" {
            txtAbout.textColor = COLOR_EATOPINE_GRAY
            txtAbout.text = "About you"
        }
        else {
            txtAbout.textColor = UIColor.blackColor()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        imgProfile.image = newProfilePhoto
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UIText View Protocol
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "About you" {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = "About you"
            textView.textColor = COLOR_EATOPINE_GRAY
        }
    }
    
    //MARK: Actions
    
    @IBAction func addPhoto(sender: AnyObject?) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let facebutton = UIAlertAction(title: "Import from Facebook", style: UIAlertActionStyle.Default, handler: { (takeButton:UIAlertAction) -> Void in
            print("")
            self.alertControllerClickedButtonAtIndex(0)
        })
        alertController.addAction(facebutton)
        let takebutton = UIAlertAction(title: "Take a Picture", style: UIAlertActionStyle.Default, handler: { (chooseButton:UIAlertAction) -> Void in
            self.alertControllerClickedButtonAtIndex(1)
        })
        alertController.addAction(takebutton)
        let choosebutton = UIAlertAction(title: "Choose from Library", style: UIAlertActionStyle.Default, handler: { (chooseButton:UIAlertAction) -> Void in
            self.alertControllerClickedButtonAtIndex(2)
        })
        alertController.addAction(choosebutton)
        let remobebutton = UIAlertAction(title: "Remove current picture", style: UIAlertActionStyle.Default, handler: { (chooseButton:UIAlertAction) -> Void in
            self.removeProfileImg()
        })
        remobebutton.setValue(UIColor.redColor(), forKey: "titleTextColor")
        alertController.addAction(remobebutton)
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil)
        alertController.addAction(cancelButton)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func closePressed(sender: AnyObject?) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func savePressed(sender: AnyObject?) {
        
        if !isInputValid() {
            return
        }
        
        var description = txtAbout.text
        if txtAbout.text == "About you" {
            description = ""
        }
        
        if isInputValid() {
            AppUtility.showActivityOverlay("Updating")
            EatopineAPI.updateUser(userData.login_id, fullName: txtFullName.text!, userName: txtUserName.text!, city: txtCity.text!, description: description, email: txtEmail.text!, telephone: txtTelephone.text!, gender: txtGender.text!, photo: imgProfile.image, completionClosure: { (success) in
                if success {
                    AppUtility.showActivityOverlaySuccessAndHideAfterDelay("Success")
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else {
                    AppUtility.hideActivityOverlay()
                }
            })
        }
    }
    
    func removeProfileImg() {
        if AppUtility.isUserLogged(ShowAlert: true) {
            AppUtility.showActivityOverlaySuccessAndHideAfterDelay("")
            EatopineAPI.removeUserProfilePhoto(AppUtility.currentUserId.integerValue, completionClosure: { (success) in
                if success {
                    AppUtility.showActivityOverlaySuccessAndHideAfterDelay("Success")
                    self.imgProfile.image = nil
                }
                else {
                    AppUtility.hideActivityOverlay()
                }
            })
        }
    }
    func isInputValid() -> Bool {
        
        if txtUserName.text!.characters.count == 0{
            AppUtility.showAlert("Please Input User Name", title: "Empty")
            txtUserName.becomeFirstResponder()
            return false
        }
        if txtEmail.text!.characters.count == 0 {
            AppUtility.showAlert("Please Input Email", title: "Empty")
            txtEmail.becomeFirstResponder()
            return false
        }
        
        self.view.endEditing(true)
        return true
    }
    
    func alertControllerClickedButtonAtIndex(buttonIndex: Int) {
        if buttonIndex == 0 {

        }
        else if buttonIndex == 1 {
            self.performSegueWithIdentifier("CameraShow", sender: nil)
        }
        else if buttonIndex == 2 {
            self.performSegueWithIdentifier("LibraryShow", sender: nil)
        }
    }
}
