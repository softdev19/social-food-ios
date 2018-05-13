//
//  DishRateViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 26/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit
import SZTextView
import MRProgress

class DishRateViewController: UITableViewController,EatopineSearchControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak private var lblRestaurantName: UILabel!
    @IBOutlet weak private var lblRestaurantAddress: UILabel!
    
    private var autocompleteDishList = [EPDish]()
    @IBOutlet weak private var txtFldDishName: AutoCompleteTextField!
    @IBOutlet weak private var btnChange: UIButton!
    
    @IBOutlet weak private var rating: TPFloatRatingView!
    @IBOutlet weak private var textView: SZTextView!
    
    @IBOutlet weak private var txtFldCourse: UITextField!
    
    @IBOutlet weak private var photoPickerView: EPHorizontalPhotoPickerView!
    @IBOutlet weak private var publishButton: UIButton!
    
    var tapGesture:UITapGestureRecognizer!
    var showDishPageWhenFinish = false
    var restaurant:EPRestaurant!
    var dish:EPDish!{
        didSet{ isAddingNewDish = false }
    }
    var isAddingNewDish = false
    var course:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(DishRateViewController.endEditing))
        
        if dish == nil {
            isAddingNewDish = true
            self.title = "Add a dish"
        }else{
            txtFldCourse.alpha = 0
        }
        
        rating.setupForEatopineBigWithRate()
        publishButton.layer.cornerRadius = 5
        
        // will be used to present Image Picker
        photoPickerView.setPresentingController(self)
        updateViewLabels()
        
        configureTextField()
        handleTextFieldInterfaces()
    }

    func endEditing(){
        self.view.endEditing(true)
    }
    
    override func viewWillLayoutSubviews() {
        publishButton.layer.cornerRadius = 5
        if dish == nil {
              publishButton.setTitle("add", forState: .Normal)
        }
    }
    
    override func viewDidLayoutSubviews() {
        updateViewLabels()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateViewLabels() {
        if restaurant != nil {
            lblRestaurantName.text = restaurant.name
            lblRestaurantAddress.text = restaurant.fullAddress
        }
        
        if dish != nil {
            txtFldDishName.text = dish.name
        }
    }

    @IBAction func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func changeRestaurant() {
        let searchDishController = storyboard?.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
     //   searchDishController.searchType = .Dish
        searchDishController.delegate = self
        self.navigationController?.pushViewController(searchDishController, animated: true)
    }
    
    @IBAction func publish(sender: AnyObject?) {
        
        if isInputValid() {
            self.view.endEditing(true)
            
            AppUtility.showActivityOverlay("")
            if isAddingNewDish == true {
                EatopineAPI.addDish(restaurant.id, dishName:txtFldDishName.text!, reviewText: textView.text, rating: Int(rating.rating), course: course, photos: photoPickerView.getPhotos(), completionClosure: { (success, dishID) -> () in
                    if success == true {
                        AppUtility.showActivityOverlaySuccessAndHideAfterDelay("")
                    }else{
                        AppUtility.hideActivityOverlay()
                    }
                    
                    NotificationCenter.postNotificationName("RefreshRestaurantInfo", object: nil)
                    if self.showDishPageWhenFinish == true && dishID != 0 {
                        EatopineAPI.downloadDish(dishID, completionClosure: { (success, dish) -> () in
                            AppUtility.hideActivityOverlay()
                            if success == true{
                                let dishDetailController = self.storyboard?.instantiateViewControllerWithIdentifier("DishDetailTableViewController") as! DishDetailTableViewController
                               // dishDetailController.dish = dish
                                //dishDetailController.title = dish!.restaurant_name
                                self.navigationController?.pushViewController(dishDetailController, animated: true)
                            }else{
                                self.dismissViewController()
                            }
                        })
                    }else{
                        self.dismissViewController()
                    }
                })
            }else{
                EatopineAPI.rateDish(dish.id, reviewText: textView.text, rating: Int(rating.rating), photos: photoPickerView.getPhotos(), completionClosure: { (success) -> () in
                    if success == true {
                        AppUtility.showActivityOverlaySuccessAndHideAfterDelay("")
                    }else{
                        AppUtility.hideActivityOverlay()
                    }
                    NotificationCenter.postNotificationName("RefreshDishDetail", object: nil)
                    self.dismissViewController()
                })
            }
        }
    }
    
    
    func isInputValid() -> Bool {
        
        if isAddingNewDish == false && dish == nil{
            AppUtility.showAlert("Please choose dish to rate", title: "Notice")
            return false
        }
        
        if isAddingNewDish == true && txtFldDishName.text?.characters.count < 6 {
            AppUtility.showAlert("Dish name should have at least 6 characters", title: "Notice")
            return false
        }
        
        if isAddingNewDish == true && txtFldDishName.text?.characters.count > 45 {
            AppUtility.showAlert("Dish name is too long, max is 45 characters", title: "Notice")
            return false
        }
        
//        if textView.text == ""{
  //          AppUtility.showAlert("Please write a review", title: "Notice")
    //        return false
      //  }
        
        if rating.rating == 0{
            AppUtility.showAlert("Please rate by selecting Chefs", title: "Notice")
            return false
        }
        
        if photoPickerView.getPhotos().count == 0 {
            AppUtility.showAlert("Please add dish picture", title: "Notice")
            return false
        }
        
        return true
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        }else{
            if indexPath.row == 0 {
                return 44
            }else if indexPath.row == 1 {
                return 70
            }else if indexPath.row == 2 {
                if isAddingNewDish == true {
                    return 70
                }else{
                    return 0
                }
            }else{
                return 205
            }
        }
    }
    
    
    //MARK: EatopineSearchControllerDelegate
    
    func didSelect(object: AnyObject) {
        
        if object is EPDish {
            let selectedDish = object as! EPDish
            self.dish = selectedDish
        }else{
            restaurant = object as! EPRestaurant
        }
        
        
     //   updateViewLabels()
    }
    
    //MARK: AutoCompleteTextField
    
    func downloadDishesByName() {
        
        if txtFldDishName.text?.characters.count == 0 {
            return
        }
        EatopineAPI.searchDishes(txtFldDishName.text!) { (success, dishes) -> () in
            self.autocompleteDishList = dishes!
            
            var mutArray = [String]()
            
            for dish in self.autocompleteDishList {
                mutArray.append(dish.name)
            }
            self.txtFldDishName.autoCompleteStrings = mutArray
        }
    }
    
   
    
    private func handleTextFieldInterfaces(){
        txtFldDishName.onTextChange = {[weak self] text in
            if !text.isEmpty{
               self!.txtFldDishName.autoCompleteTableView?.removeFromSuperview()
                self?.txtFldDishName.autoCompleteTableView?.frame.origin.y = 130
                self!.txtFldDishName.autoCompleteTableView?.frame.size.height = 128
                self?.tableView.addSubview(self!.txtFldDishName.autoCompleteTableView!)
                
                self!.downloadDishesByName()
            }
        }
        
        txtFldDishName.onSelect = {[weak self] text, indexpath in
            
            if self?.autocompleteDishList.count > indexpath.row {
                let selectedDish = self?.autocompleteDishList[indexpath.row]
                if selectedDish != nil {
                    self?.txtFldDishName.resignFirstResponder()
                    self!.dish = selectedDish
                    self?.updateViewLabels()
                }
            }
        }
    }
    
    private func configureTextField(){
     //   txtFldDishName.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
       // txtFldDishName.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        txtFldDishName.autoCompleteCellHeight = 35.0
        txtFldDishName.maximumAutoCompleteCount = 3
        txtFldDishName.hidesWhenSelected = true
        txtFldDishName.hidesWhenEmpty = true
        txtFldDishName.enableAttributedText = true
        txtFldDishName.autoCompleteTableHeight = 200.0
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        txtFldDishName.autoCompleteAttributes = attributes
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == txtFldCourse {
            selectCourse()
        }else if textField == txtFldDishName{
            self.view.addGestureRecognizer(tapGesture)
            
        }
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == txtFldDishName {
            self.view.removeGestureRecognizer(tapGesture)
            self.txtFldDishName.autoCompleteStrings = []
            self.txtFldDishName.autoCompleteTableView?.removeFromSuperview()
        }
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        dish = nil
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func selectCourse() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let appetizer = UIAlertAction(title: "Appetizer", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
            self.course = 1
            self.txtFldCourse.text = alertButton.title
        })
        alertController.addAction(appetizer)
        let starter = UIAlertAction(title: "Starter", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
            self.course = 2
            self.txtFldCourse.text = alertButton.title
        })
        alertController.addAction(starter)
        let main = UIAlertAction(title: "Main Course", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
            self.course = 3
            self.txtFldCourse.text = alertButton.title
        })
        alertController.addAction(main)
        let soup = UIAlertAction(title: "Soup", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
            self.course = 4
            self.txtFldCourse.text = alertButton.title
        })
        alertController.addAction(soup)
        let dessert = UIAlertAction(title: "Dessert", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
            self.course = 5
            self.txtFldCourse.text = alertButton.title
        })
        alertController.addAction(dessert)
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil)
        alertController.addAction(cancelButton)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
