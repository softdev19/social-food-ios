//
//  ExplodeControlView.swift
//  Eatopine
//
//  Created by Borna Beakovic on 27/07/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

protocol ExplodeControlViewDelegate {
    func explodeViewDidSelectButton()
//    func explodeViewShouldHide()
}

class ExplodeControlView: UIView {

    var delegate: ExplodeControlViewDelegate?
    @IBOutlet weak var checkinButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var addRatebutton: UIButton!
    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
  //  var actionType = ""
    
    class func instanceFromNib() -> ExplodeControlView {

        return UINib(nibName: "ExplodeControlView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ExplodeControlView
        
    }
    
    
    override init(frame: CGRect) {
         super.init(frame: frame)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
     //   fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    @IBAction func checkin(sender: AnyObject?) {
        if AppUtility.isUserLogged(ShowAlert: true) {
         //   actionType = "Checkin"
            showCheckinControllerWithSearch()
            delegate?.explodeViewDidSelectButton()
        }
    }
    @IBAction func restReview(sender: AnyObject?) {
        if AppUtility.isUserLogged(ShowAlert: true) {
        //    actionType = "Checkin"
            showReviewControllerWithSearch()
            delegate?.explodeViewDidSelectButton()
        }
    }
    
    
    @IBAction func addRateDish(sender: AnyObject?) {
        let addDishController = storyboard.instantiateViewControllerWithIdentifier("DishRateViewController") as! DishRateViewController
        addDishController.showDishPageWhenFinish = true
        let navigationController = RedNavigationController(rootViewController: addDishController)
        let searchRestaurantController = storyboard.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        searchRestaurantController.delegate = addDishController
//        searchRestaurantController.searchType = .Restaurant
        navigationController.viewControllers.append(searchRestaurantController)
        
        ApplicationDelegate.window?.rootViewController!.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func showCheckinControllerWithSearch() {
        
        let checkinViewController = storyboard.instantiateViewControllerWithIdentifier("CheckinViewController") as! CheckinViewController
        checkinViewController.showRestaurantPageWhenFinish = true
        let navigationController = RedNavigationController(rootViewController: checkinViewController)
        let searchRestaurantController = storyboard.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        searchRestaurantController.delegate = checkinViewController
  //      searchRestaurantController.searchType = .Restaurant
        navigationController.viewControllers.append(searchRestaurantController)
        
        ApplicationDelegate.window?.rootViewController!.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func showReviewControllerWithSearch() {
        
        let reviewController = storyboard.instantiateViewControllerWithIdentifier("RestaurantReviewTableViewController") as! RestaurantReviewTableViewController
        reviewController.showRestaurantPageWhenFinish = true
        let navigationController = RedNavigationController(rootViewController: reviewController)
        let searchRestaurantController = storyboard.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        searchRestaurantController.delegate = reviewController
//        searchRestaurantController.searchType = .Restaurant
        navigationController.viewControllers.append(searchRestaurantController)
        
        ApplicationDelegate.window?.rootViewController!.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    
}
