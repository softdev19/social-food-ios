//
//  ReviewListViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 20/09/15.
//  Copyright © 2015 Eatopine. All rights reserved.
//

import UIKit

class ReviewListViewController: UITableViewController {

    var restaurant:EPRestaurant!
    var reviews = [EPReview]()
    var currentPage = 0
    var shouldLoadMore = true
    var isDownloading = false
    var sortType = "date_desc"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ReviewListViewController.popController))
        self.navigationItem.leftBarButtonItem = backButton
        
        downloadReviews()
    }

    func popController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func downloadReviews() {
        isDownloading = true
        AppUtility.showActivityOverlay("")
        EatopineAPI.downloadRestaurantReviews(restaurant.id, page:currentPage, downloadLimit:DOWNLOAD_OBJECT_LIMIT, order:sortType, completionClosure: { (success, reviews) -> () in
            AppUtility.hideActivityOverlay()
            self.isDownloading = false
            if success {
                self.updateTableWithData(reviews!)
            }
        })
    }
    
    func updateTableWithData(reviewsArray:[EPReview]) {
        
        print("downloaded \(reviewsArray.count)")
        if reviewsArray.count < DOWNLOAD_OBJECT_LIMIT {
            shouldLoadMore = false
        }
        
        for review in reviewsArray {
            self.reviews.append(review)
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func sort() {
        optionsSort()
    }
    
    @IBAction func openUserProfile(gesture:UITapGestureRecognizer) {
        let review = reviews[gesture.view!.tag]
    //    if review != nil {
            let profileController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            profileController.userId = review.author_id
            self.navigationController?.pushViewController(profileController, animated: true)
      //  }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return reviews.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    /*
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        /*
        let sectionView = ReviewSectionView.instanceFromNib()
        sectionView.sortButton.addTarget(self, action: "sortReviewPressed:", forControlEvents: UIControlEvents.TouchDown)
        if sortedUp == true {
            sectionView.sortButton.setImage(UIImage(named: "arrowUpGrey"), forState: UIControlState.Normal)
        }else{
            sectionView.sortButton.setImage(UIImage(named: "arrowDownGrey"), forState: UIControlState.Normal)
        }
*/
        return nil
    }
    */
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell", forIndexPath: indexPath) as! ReviewCell
        let review = reviews[indexPath.section]
        cell.lblReview.text = "                        \(review.review)"
        cell.lblAuthor_name.text = review.author_display_name
        cell.lblAuthor_points.text = "\(review.author_points)"
        cell.author_photo.sd_setImageWithURL(NSURL(string: review.author_profilePhoto), placeholderImage: UIImage(named: "placeholder_profile"))

        cell.rating.rating = CGFloat(review.rating)
        cell.lblDate.text = AppUtility.reviewCellDateString(review.createdDate)
        
        // set index for User profile Tap
        cell.lblAuthor_name.tag = indexPath.row
        cell.lblAuthor_points.tag = indexPath.row
        cell.author_photo.tag = indexPath.row
        
        // add tap gesture to open author profile view
        let tap = UITapGestureRecognizer(target: self, action: #selector(ReviewListViewController.openUserProfile(_:)))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(ReviewListViewController.openUserProfile(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ReviewListViewController.openUserProfile(_:)))
        cell.lblAuthor_name.addGestureRecognizer(tap)
        cell.lblAuthor_points.addGestureRecognizer(tap1)
        cell.author_photo.addGestureRecognizer(tap2)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let review = reviews[indexPath.section]
        
        let reviewController = storyboard?.instantiateViewControllerWithIdentifier("ReviewDetailTableViewController") as! ReviewDetailTableViewController
        reviewController.title = review.dish_name
        reviewController.review = review
        reviewController.isRestaurantReviewType = true
        self.navigationController?.pushViewController(reviewController, animated: true)
    }
    
    //MARK: Scroll delegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y > self.tableView.contentSize.height - self.tableView.frame.size.height*2)
        {
            if isDownloading == false && shouldLoadMore == true {
                currentPage += 1
                downloadReviews()
            }
        }
    }
    
    //MARK: AlertController
    func optionsSort() {
        
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let newest = UIAlertAction(title: "Newest First", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
                self.sortType = "date_desc"
                self.reviews.removeAll()
                self.shouldLoadMore = true
                self.downloadReviews()
            })
            alertController.addAction(newest)
            let oldest = UIAlertAction(title: "Oldest First", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
                self.sortType = "date_asc"
                self.reviews.removeAll()
                self.shouldLoadMore = true
                self.downloadReviews()
            })
            alertController.addAction(oldest)
            let ratingHigh = UIAlertAction(title: "Rating(High > Low)", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
                self.sortType = "rating_desc"
                self.reviews.removeAll()
                self.shouldLoadMore = true
                self.downloadReviews()
            })
            alertController.addAction(ratingHigh)
            let ratingLow = UIAlertAction(title: "Rating(Low > High)", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
                self.sortType = "rating_asc"
                self.reviews.removeAll()
                self.shouldLoadMore = true
                self.downloadReviews()
            })
            alertController.addAction(ratingLow)
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil)
            alertController.addAction(cancelButton)
            self.presentViewController(alertController, animated: true, completion: nil)
    }
}
