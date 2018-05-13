//
//  AddRestaurantViewController.swift
//  Eatopine
//
//  Created by jcb on 9/28/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit
import GooglePlaces

class AddRestaurantViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtName.delegate = self
        txtAddress.delegate = self
        txtCity.delegate = self
        txtState.delegate = self
        txtCountry.delegate = self
        
        txtName.becomeFirstResponder()
    }
    
    @IBAction func onCancelBtnClick(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onSaveBtnClick(sender: UIBarButtonItem) {
        if !checkValid() {
            return
        }
        
        AppUtility.showActivityOverlay("")
        EatopineAPI.createRestaurant(txtName.text!, address: txtAddress.text!, city: txtCity.text!, country: txtCountry.text!, userId: AppUtility.currentUserId.integerValue, state: txtState.text!) { (success, restId) in
            AppUtility.hideActivityOverlay()
            if restId != "" {
                let myInt: Int? = Int(restId)
                let dict: [String : AnyObject] = ["name": self.txtName.text!, "address": self.txtAddress.text!, "rest_id": myInt!]
                for viewController in self.navigationController!.viewControllers {
                    if viewController is AddRatingViewController {
                        (viewController as! AddRatingViewController).restaurantDict = dict
                        (viewController as! AddRatingViewController).restaurant = nil
                        self.navigationController?.popToViewController(viewController, animated: true)
                    }
                }
            }
        }
    }

    //MARK: check Validation
    func checkValid() -> Bool {
        if txtName.text == "" {
            AppUtility.showAlert("Please input Name", title: "Error")
            return false
        }
        if txtAddress.text == "" {
            AppUtility.showAlert("Please input Address", title: "Error")
            return false
        }
        if txtCity.text == "" {
            AppUtility.showAlert("Please input City", title: "Error")
            return false
        }
        if txtCountry.text == "" {
            AppUtility.showAlert("Please input Country", title: "Error")
            return false
        }
        
        return true
    }
    
    //MARK: TextField Protocol
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case txtName:
            txtAddress.becomeFirstResponder()
            break
        case txtAddress:
            txtCity.becomeFirstResponder()
            break
        case txtCity:
            txtState.becomeFirstResponder()
            break
        case txtState:
            txtCountry.becomeFirstResponder()
            break
        case txtCountry:
            txtCountry.resignFirstResponder()
            break
        default:
            break
        }
        
        return true
    }
}
