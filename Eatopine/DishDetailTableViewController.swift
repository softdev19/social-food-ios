//
//  DishDetailTableViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 16/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class DishDetailTableViewController: UITableViewController {

    @IBOutlet private var lblDishName:UILabel!
    @IBOutlet private var lblNumberOfReviews:UILabel!
    @IBOutlet weak var lblNumberofLikes: UILabel!
    @IBOutlet weak var lblReviews: UILabel!
    
    @IBOutlet weak var lblVote: UILabel!
    @IBOutlet private var imgViewBgCollection:UIImageView!
    @IBOutlet private var dishRating:TPFloatRatingView!
    
    @IBOutlet private var lblAuthorName:UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var commentHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private var imgViewAuthor:UIImageView!
    @IBOutlet weak var lblCreated: UILabel!
    @IBOutlet weak var lblAutherRank: UILabel!
    
    
    @IBOutlet private var lblFooter:UILabel!
    @IBOutlet private var aivFooter:UIActivityIndicatorView!
    
    var sortedUp = false
    var itemIndex:Int!
    var dish:EPMapDish!
    var author:UserProfile!
    var dishId:Int!
    var visiblePhotoIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DishDetailTableViewController.popController))
        self.navigationItem.leftBarButtonItem = backButton
        
        NotificationCenter.addObserver(self, selector: #selector(DishDetailTableViewController.downloadData), name: "RefreshDishDetail", object: nil)
        
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        dishRating.setupForEatopineMiddle()
        
        downloadData()
    }

    deinit {
        NotificationCenter.removeObserver(self)
    }
    
    func downloadData() {
        AppUtility.showActivityOverlay("")
        EatopineAPI.downloadDish(664041, completionClosure: { (success, dish) -> () in
            AppUtility.hideActivityOverlay()
            
            if success {
                self.dish = dish
                self.updateViews()
                self.tableView.reloadData()
            }
        })
        
        aivFooter.startAnimating()
        lblFooter.text = ""
    }
    
    func updateViews() {
        
        lblDishName.text = dish.dishName
        let reviewText = dish.number_ratings == 1 ? "review" : "reviews"
        lblNumberOfReviews.text = "\(dish.number_ratings) " + reviewText
        lblNumberofLikes.text = "\(dish.number_likes) likes"
        lblReviews.text = "REVIEWS: \(dish.number_ratings)"
        lblVote.text = "\(dish.vote)"
        
        if dish.reviews.count > 0 {
            imgViewBgCollection.sd_setImageWithURL(NSURL(string: dish.reviews[0].photo))
            
            dishRating.rating = CGFloat(dish.reviews[0].vote)
            
            lblAuthorName.text = dish.reviews[0].username
            lblAutherRank.text = dish.reviews[0].rank
            lblCreated.text = AppUtility.getMinutesFromToday(dish.reviews[0].created)
            lblComment.text = dish.reviews[0].text
            commentHeightConstraint.constant = lblComment.text!.heightWithConstrainedWidth(self.view.frame.size.width, font: UIFont.systemFontOfSize(13.0))
        }
    }
    
    func updateFooter() {
        aivFooter.stopAnimating()
        if dish.reviews.count == 1 {
            lblFooter.text = "Be the first one to review this dish"
        }else{
            lblFooter.text = ""
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    func sortReviewPressed(button:UIButton) {
        if sortedUp == false {
            sortedUp = true
        }else{
            sortedUp = false
        }

        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (dish != nil) {
            if dish.reviews.count > 1 {
                return dish.reviews.count - 1
            }
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell", forIndexPath: indexPath) as! ReviewCell
        let review = dish.reviews[indexPath.row + 1]
        cell.lblReview.text = review.text
        cell.lblAuthor_name.text = review.username
        cell.lblAuthor_points.text = "\(review.rank)"
        cell.rating.rating = CGFloat(review.vote)
        cell.lblDate.text = AppUtility.getMinutesFromToday(review.created)
        cell.author_photo.sd_setImageWithURL(NSURL(string: review.photo), placeholderImage: UIImage(named: "dish_placeholder"))
        // set index for User profile Tap
        cell.lblAuthor_name.tag = indexPath.row
        cell.author_photo.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let review = dish.reviews[indexPath.row + 1]
        
        let reviewController = storyboard?.instantiateViewControllerWithIdentifier("ReviewDetailTableViewController") as! ReviewDetailTableViewController
//        reviewController.title = dish.name
//        reviewController.review = review
        reviewController.isRestaurantReviewType = false
        self.navigationController?.pushViewController(reviewController, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        recalculateVisiblePhoto()
//        lblPhotoNumber.text = "\(visiblePhotoIndex+1) of \(dish.photos!.count)"
    }
    
    
    func popController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
