//
//  RestaurantReviewTableViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 14/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit
import SZTextView
import MRProgress
class RestaurantReviewTableViewController: UITableViewController,EatopineSearchControllerDelegate {

    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblRestaurantAddress: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    
    @IBOutlet weak var rating: TPFloatRatingView!
    @IBOutlet weak var textView: SZTextView!
    
    @IBOutlet weak var photoPickerView: EPHorizontalPhotoPickerView!
    @IBOutlet weak var publishButton: UIButton!
    
    var showRestaurantPageWhenFinish = false
    var restaurant:EPRestaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rating.setupForEatopineBigWithRate()
        publishButton.layer.cornerRadius = 5
        
        // will be used to present Image Picker
        photoPickerView.setPresentingController(self)
        updateViewLabels()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        updateViewLabels()
    }

    func updateViewLabels() {
        if restaurant != nil {
            lblRestaurantName.text = restaurant.name
            lblRestaurantAddress.text = restaurant.fullAddress
        }
    }
    
    
    @IBAction func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func changeRestaurant() {
        let searchRestaurantController = storyboard?.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        searchRestaurantController.delegate = self
//        searchRestaurantController.searchType = .Restaurant
        self.navigationController?.pushViewController(searchRestaurantController, animated: true)
    }
    
    @IBAction func publish(sender: AnyObject?) {
        
        if isInputValid() {
            self.view.endEditing(true)
            AppUtility.showActivityOverlay("Publishing review")
            EatopineAPI.reviewRestaurant(restaurant.id, reviewText: textView.text, rating: Int(rating.rating),photos:photoPickerView.getPhotos(), completionClosure: { (success) -> () in
                if success{
                    AppUtility.showActivityOverlaySuccessAndHideAfterDelay("Success")
                    NotificationCenter.postNotificationName("RefreshRestaurantReviews", object: nil)
                    NotificationCenter.postNotificationName("RefreshRestaurantInfo", object: nil)
                }else{
                    AppUtility.hideActivityOverlay()
                }
                if self.showRestaurantPageWhenFinish == true {
                    let restaurantDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RestaurantDetailTableViewController") as! RestaurantDetailTableViewController
                    restaurantDetailViewController.restaurant = self.restaurant
                    self.navigationController?.pushViewController(restaurantDetailViewController, animated: true)
                }else{
                    self.dismissViewController()
                }
            })
        }
        
    }
    
    func isInputValid() -> Bool {
        
        if restaurant == nil{
            AppUtility.showAlert("Please choose restaurant to review", title: "Notice")
            return false
        }
        
        if textView.text.characters.count < 50{
            AppUtility.showAlert("Review text should be at least 50 characters", title: "Notice")
            return false
        }

        if rating.rating == 0{
            AppUtility.showAlert("Please rate by selecting Chefs", title: "Notice")
            return false
        }
        
        return true
    }
    
    //MARK: EatopineSearchControllerDelegate 
    
    func didSelect(object: AnyObject) {
        let selectedRestaurant = object as! EPRestaurant
        self.restaurant = selectedRestaurant
    }
    
}
