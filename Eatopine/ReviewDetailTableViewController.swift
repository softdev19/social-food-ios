//
//  ReviewDetailViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 04/09/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class ReviewDetailTableViewController: UITableViewController,PhotoCollectionCellDelegate {

    @IBOutlet weak private var author_photo: UIImageView!
    @IBOutlet weak private var rating: TPFloatRatingView!
    @IBOutlet weak private var lblPhotoNumber: UILabel!
    @IBOutlet weak private var lblAuthor_name: UILabel!
    @IBOutlet weak private var lblAuthor_points: UILabel!
    @IBOutlet weak private var lblDate: UILabel!
    @IBOutlet weak private var lblReview: UITextView!
    // Other Dish section
    @IBOutlet weak private var reviewCell: ReviewCollectionCell!
    
    var review:EPReview!
    var isRestaurantReviewType:Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // add tap gesture to open author profile view
        let tap = UITapGestureRecognizer(target: self, action: #selector(ReviewDetailTableViewController.openUserProfile(_:)))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(ReviewDetailTableViewController.openUserProfile(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ReviewDetailTableViewController.openUserProfile(_:)))
        lblAuthor_name.addGestureRecognizer(tap)
        lblAuthor_points.addGestureRecognizer(tap1)
        author_photo.addGestureRecognizer(tap2)
        
        
        let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ReviewDetailTableViewController.popController))
        self.navigationItem.leftBarButtonItem = backButton
        reviewCell.delegate = self
        rating.setupForEatopineMiddle()
        
        AppUtility.showActivityOverlay("")
        EatopineAPI.downloadSingleReview(review.id, isRestaurantReviewType: isRestaurantReviewType) { (success, review) -> () in
            AppUtility.hideActivityOverlay()
            if success {
                self.review = review
                self.title = self.review.restaurant_name
                self.updateViews()
                
                if self.review.photos?.count > 0 {
                    self.reviewCell.objectArray = self.review.photos!
                    self.reviewCell.collection.reloadData()
                    self.lblPhotoNumber.text = "\(self.review.photos!.count)"
                }else{
                    self.lblPhotoNumber.text = "0"
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateViews() {
        lblReview.text = review.review
        lblAuthor_name.text = review.author_display_name
        lblAuthor_points.text = "\(review.author_points)"
        rating.rating = CGFloat(review.rating)
        lblDate.text = AppUtility.reviewCellDateString(review.createdDate)
        author_photo.sd_setImageWithURL(NSURL(string: review.author_profilePhoto), placeholderImage: UIImage(named: "placeholder_profile"))
    }
    
    @IBAction func openUserProfile(gesture:UITapGestureRecognizer) {
        
        let profileController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        profileController.userId = review.author_id
        self.navigationController?.pushViewController(profileController, animated: true)
    }
    
    //MARK: HotDishCollection delegate
    
    func didSelectPhotoCell(objects: [AnyObject], atIndex: Int) {
        
    }

    func popController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
