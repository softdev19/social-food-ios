//
//  DishDetailViewController.swift
//  Eatopine
//
//  Created by  on 9/22/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class DishDetailViewController: UIViewController, FoodContentViewDelegate, CommentsListViewControllerDelegate {
    
    var dish: EPDish!
    
    @IBOutlet weak var foodView: FoodContentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodView.delegate = self
        if dish != nil {
            foodView.setContent(dish)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onBackBtnClick(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //Mark: FoodContentView Protocol
    func pushRestName() {
        let restaurantDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("RestaurantDetailTableViewController") as! RestaurantDetailTableViewController
        restaurantDetailViewController.restaurantId = dish.restaurant_id
        self.navigationController?.pushViewController(restaurantDetailViewController, animated: true)
    }
    
    func pushImgProfile() {
        self.tabBarController?.selectedIndex = 4
    }
    
    func pushLike(liked: Bool) {
        if (AppUtility.isUserLogged(ShowAlert: true)) {
            
            EatopineAPI.likeDish(dish.rating_id, userId: AppUtility.currentUserId.integerValue, fromDev: 1, liked: liked, completionClosure: { (success) in
                if success {
                        
                }
            })
        }
    }
    
    func pushComment() {
        if AppUtility.isUserLogged(ShowAlert: true) {
            
            let commentListViewController = storyboard?.instantiateViewControllerWithIdentifier("CommentsListViewController") as! CommentsListViewController
            commentListViewController.ratingId = dish.rating_id
            commentListViewController.addComment = true
            self.navigationController?.pushViewController(commentListViewController, animated: true)
        }
    }
    
    func pushGetLikes() {
        let likesUserListViewController = storyboard?.instantiateViewControllerWithIdentifier("LikesUserListViewController") as! LikesUserListViewController
        likesUserListViewController.ratingId = dish.rating_id
        self.navigationController?.pushViewController(likesUserListViewController, animated: true)
    }
    
    func pushGetComments() {
        let commentListViewController = storyboard?.instantiateViewControllerWithIdentifier("CommentsListViewController") as! CommentsListViewController
        commentListViewController.ratingId = dish.rating_id
        commentListViewController.addComment = true
        self.navigationController?.pushViewController(commentListViewController, animated: true)
    }
    
    func pushOption() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let doReport = UIAlertAction(title: "Report", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
        })
        alertController.addAction(doReport)
        
        let shareOnFacebook = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
        })
        alertController.addAction(shareOnFacebook)
        
        let shareOnInstagram = UIAlertAction(title: "Share on Instagram", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
        })
        alertController.addAction(shareOnInstagram)
        
        let copyURL = UIAlertAction(title: "Copy URL", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
        })
        alertController.addAction(copyURL)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil)
        alertController.addAction(cancelButton)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func pushDishName() {
        
    }
    
    // CommentsListViewController Protocol
    
    func refreshComments() {
        
    }
}
