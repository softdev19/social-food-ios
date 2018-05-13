//
//  DishNameViewController.swift
//  Eatopine
//
//  Created by jcb on 9/28/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit
import CoreLocation

class DishNameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imgDish: UIImageView!
    @IBOutlet weak var txtDishName: UITextField!
    
    var restId = 0
    var dishes = [EPDish]()
    var selectedDish: EPDish!
    var dishImage: UIImage!
    var locValue:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgDish.image = dishImage
       // getDishName("")
        txtDishName.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DishNameCell", forIndexPath: indexPath) as! DishNameCell
        
        let dish = dishes[indexPath.row]
        cell.lblDishName.text = dish.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedDish = dishes[indexPath.row]
        for viewController in self.navigationController!.viewControllers {
            if (viewController is AddRatingViewController) {
                (viewController as! AddRatingViewController).dish = selectedDish
                (viewController as! AddRatingViewController).dishName = ""
            }
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onBackBtnClick(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func onOkBtnClick(sender: UIBarButtonItem) {
        for viewController in self.navigationController!.viewControllers {
            if (viewController is AddRatingViewController) {
                (viewController as! AddRatingViewController).dish = nil
                (viewController as! AddRatingViewController).dishName = txtDishName.text!
            }
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getDishName(dishName: String) {
        if dishes.count == 0 {
            //AppUtility.showActivityOverlay("")
        }
        
        var params :[String: AnyObject] = ["name": "\(dishName)"]

        if (restId != 0) {
            params["rest_id"] = restId
        }
        if (locValue != nil) {
            params["latitude"] = "\(locValue.latitude)"
            params["longitude"] = "\(locValue.longitude)"
        }
        //params["city"] = ""

        EatopineAPI.getDish(params, completionClosure: { (success, dishes) in
           // AppUtility.hideActivityOverlay()
            if dishes == nil {
                self.dishes = [EPDish]()
                self.txtDishName.becomeFirstResponder()
            }
            else {
                self.dishes = dishes!
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        })
    }
    
    //MARK: TextField Protocol
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print(textField.text!)
        var subString = textField.text!
        if string == "" {
            let index = subString.startIndex.advancedBy(subString.length - 1)
            subString = subString.substringToIndex(index)
        }
        else {
            subString = subString + string
        }
        print(subString)
        if subString.length > 1 {
            getDishName(subString)
        }
        return true
    }
}


class DishNameCell: UITableViewCell {
    @IBOutlet weak var lblDishName: UILabel!
}