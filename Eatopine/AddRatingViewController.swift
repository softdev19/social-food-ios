//
//  AddRatingViewController.swift
//  Eatopine
//
//  Created by jcb on 9/28/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit
import CoreLocation
import Social

class AddRatingViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var imgDish: UIImageView!
    @IBOutlet weak var ratingView: EatopineRatingView!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var lblResName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblCourse: UILabel!
    
    @IBOutlet weak var btnFirstPrice: UIButton!
    @IBOutlet weak var btnSecondPrice: UIButton!
    @IBOutlet weak var btnThirdPrice: UIButton!
    @IBOutlet weak var btnForthPrice: UIButton!
    
    @IBOutlet weak var swFacebook: UISwitch!
    @IBOutlet weak var swInstagram: UISwitch!
    
    @IBOutlet weak var lblFacebook: UILabel!
    @IBOutlet weak var lblInstagram: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var dishImage: UIImage!
    
    var dishName = ""
    var dish:EPDish!
    var restaurant: EPRestaurant!
    
    var restaurantDict: [String: AnyObject]!
    var selectedCourse = -1
    var selectedPrice = 0
    
    let locationManager = CLLocationManager()
    var locValue:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = COLOR_EATOPINE_REAL_RED
        
        imgDish.image = dishImage
        
        if dish == nil {
            lblDishName.text = dishName
        }
        else {
            lblDishName.text = dish.name
        }
        
        lblDishName.textColor = UIColor.blackColor()
        if lblDishName.text == "" {
            lblDishName.text = "Dish Name"
            lblDishName.textColor = COLOR_EATOPINE_GRAY
        }
        
        if restaurant != nil {
            lblResName.text = restaurant.name
            lblLocation.text = restaurant.address
        }
        else {
            lblResName.text = ""
            lblLocation.text = ""
        }
        
        txtDescription.delegate = self
        
        btnFirstPrice.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
        btnSecondPrice.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
        btnThirdPrice.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
        btnForthPrice.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
        
        btnFirstPrice.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        btnSecondPrice.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        btnThirdPrice.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        btnForthPrice.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        
        ratingView.setupForEatopineBigWithRate()
        ratingView.rating = 1.0
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if dish == nil {
            lblDishName.text = dishName
        }
        else {
            lblDishName.text = dish.name
        }
        
        lblDishName.textColor = UIColor.blackColor()
        if lblDishName.text == "" {
            lblDishName.text = "Dish Name"
            lblDishName.textColor = COLOR_EATOPINE_GRAY
        }
        
        if restaurant != nil {
            lblResName.text = restaurant.name
            lblLocation.text = restaurant.address
        }
        else if restaurantDict != nil {
            lblResName.text = restaurantDict["name"] as! String
            lblLocation.text = restaurantDict["address"] as! String
            
        }
        else {
            lblResName.text = ""
            lblLocation.text = ""
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
        print("Location : \(locValue.latitude) : \(locValue.longitude)")
    }
    
    @IBAction func onBackBtnClick(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func onPublishBtnClick(sender: AnyObject) {
        
        if !checkValid() {
            return
        }
        var restId = 0
        if restaurant == nil {
            restId = restaurantDict["rest_id"] as! Int
        }
        else {
            restId = restaurant.id
        }
        var dict: [String:AnyObject] = ["rest_id": restId, "user_id": AppUtility.currentUserId.integerValue, "dish_name": lblDishName.text!, "vote": ratingView.rating, "description": txtDescription.text!, "country": "En_US"]
        
        if dish != nil {
            dict["dish_id"] = dish.id
        }
        if selectedCourse > 0 {
            dict["course"] = selectedCourse
        }
        if selectedPrice > 0 {
            dict["price"] = selectedPrice
        }
        
        print(dict)
        AppUtility.showActivityOverlay("")
        EatopineAPI.addRating(dict, image: imgDish.image!) { (success) in
            AppUtility.hideActivityOverlay()
            if success {
                self.tabBarController?.selectedIndex = 0
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    func checkValid() -> Bool {
        // rest_id, user_id, dish_name, vote, description is requried field
        if (restaurant == nil && restaurantDict == nil) {
            AppUtility.showAlert("Please Select Restaurant", title: "Input Error")
            return false
        }
        if (!AppUtility.isUserLogged(ShowAlert: false)) {
            AppUtility.showAlert("You should login to Add Rating", title: "Input Error")
            return false
        }
        if txtDescription.text == "" {
            AppUtility.showAlert("Please input description", title: "Input Error")
            return false
        }
        return true
    }
    
    @IBAction func onDishNameBtnClick(sender: UIButton) {
        let dishNameViewController = storyboard?.instantiateViewControllerWithIdentifier("DishNameViewController") as! DishNameViewController
        if (restaurant != nil) {
            dishNameViewController.restId = restaurant.id
        }
        else if (restaurantDict != nil) {
            dishNameViewController.restId = restaurantDict["rest_id"] as! Int
        }

        dishNameViewController.locValue = locValue
        dishNameViewController.dishImage = dishImage
        self.navigationController?.pushViewController(dishNameViewController, animated: true)
    }
    
    @IBAction func onChangeBtnClick(sender: UIButton) {
        let restaurantLocationViewController = storyboard?.instantiateViewControllerWithIdentifier("RestaurantLocationTableViewController") as! RestaurantLocationTableViewController
        restaurantLocationViewController.locValue = locValue
        self.navigationController?.pushViewController(restaurantLocationViewController, animated: true)
    }
    
    @IBAction func onCourseBtnClick(sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let appetizer = UIAlertAction(title: "Appetizer", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
            self.lblCourse.text = "Appetizer"
            self.selectedCourse = 1
            self.lblCourse.textColor = UIColor.blackColor()
        })
        alertController.addAction(appetizer)
        
        let starter = UIAlertAction(title: "Starter", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
            self.lblCourse.text = "Starter"
            self.selectedCourse = 2
            self.lblCourse.textColor = UIColor.blackColor()
        })
        alertController.addAction(starter)
        
        let mainCourse = UIAlertAction(title: "Main Course", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
            self.lblCourse.text = "Main Course"
            self.selectedCourse = 3
            self.lblCourse.textColor = UIColor.blackColor()
        })
        alertController.addAction(mainCourse)
        
        let soup = UIAlertAction(title: "Soup", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
            self.lblCourse.text = "Soup"
            self.selectedCourse = 4
            self.lblCourse.textColor = UIColor.blackColor()
        })
        alertController.addAction(soup)
        
        let dessert = UIAlertAction(title: "Dessert", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
            self.lblCourse.text = "Dessert"
            self.selectedCourse = 5
            self.lblCourse.textColor = UIColor.blackColor()
        })
        alertController.addAction(dessert)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil)
        alertController.addAction(cancelButton)
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    @IBAction func onPriceBtnClick(sender: UIButton) {
        switch sender.tag {
        case 1:
            btnFirstPrice.selected = true
            btnSecondPrice.selected = false
            btnThirdPrice.selected = false
            btnForthPrice.selected = false
            selectedPrice = sender.tag
            break
        case 2:
            btnFirstPrice.selected = false
            btnSecondPrice.selected = true
            btnThirdPrice.selected = false
            btnForthPrice.selected = false
            selectedPrice = sender.tag
            break
        case 3:
            btnFirstPrice.selected = false
            btnSecondPrice.selected = false
            btnThirdPrice.selected = true
            btnForthPrice.selected = false
            selectedPrice = sender.tag
            break
        case 4:
            btnFirstPrice.selected = false
            btnSecondPrice.selected = false
            btnThirdPrice.selected = false
            btnForthPrice.selected = true
            selectedPrice = sender.tag
            break
        default:
            break
        }
    }
    
    @IBAction func onSwitchBtnClick(sender: UISwitch) {
        if swFacebook.on {
            lblFacebook.textColor = COLOR_EATOPINE_BLUE
        }
        else {
            lblFacebook.textColor = UIColor.grayColor()
        }
        if swInstagram.on {
            lblInstagram.textColor = UIColor.blackColor()
        }
        else {
            lblInstagram.textColor = UIColor.grayColor()
        }
    }
    
    //MARK: TextView Protocol
    
    func textViewDidBeginEditing(textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: txtDescription.frame.origin.y), animated: true)
        if txtDescription.text == "Description (max 160 chars)" {
            txtDescription.text = ""
        }
        txtDescription.textColor = UIColor.blackColor()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if txtDescription.text == "" {
            let attributeText = NSMutableAttributedString(string: "Description (max 160 chars)", attributes: [NSForegroundColorAttributeName:COLOR_EATOPINE_GRAY])
            attributeText.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue", size: 19.0)!, range: NSRange(location: 0, length: 11))
            attributeText.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Italic", size: 14.0)!, range: NSRange(location: 12, length: 15))
            txtDescription.attributedText = attributeText
        }
        else {
            txtDescription.textColor = UIColor.blackColor()
        }
        txtDescription.resignFirstResponder()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
}
