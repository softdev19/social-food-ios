//
//  FeedCollectionViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 15/08/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit
import SDWebImage



private let reuseIdentifier = "FeedListCell"
private let kStaticHeight:CGFloat = 464

class FeedListCollectionViewController: UITableViewController, FeedProtocol, FeedListCellDelegate {

    @IBOutlet weak var refresher: UIRefreshControl!
    
    var list = [EPDish]()
    let cell_height:CGFloat = 612.0
    var cellHeights: NSMutableDictionary?
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func refreshData(sender: AnyObject) {
        if let feedVC = self.parentViewController {
            if feedVC is FeedViewController {
                (feedVC as! FeedViewController).populateFeed()
            }
        }
        self.refresher.endRefreshing()
    }
    func refresh(dishes: [EPDish]) {
        self.list = dishes
//        if (dishes.count == 0) {
//            let noPostsLabel = UILabel()
//            noPostsLabel.text = "No posts yet"
//            noPostsLabel.font = UIFont.systemFontOfSize(17.0)
//            noPostsLabel.textAlignment = NSTextAlignment.Center
//            noPostsLabel.frame = self.view.frame
//            self.view.addSubview(noPostsLabel)
//        }
        cellHeights = NSMutableDictionary()
        getestimatedCellHeights()
        tableView.separatorColor = UIColor.clearColor()
        self.tableView.reloadData()
    }
    
    //Mark: TableView Delegate & DataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let dish = list[(indexPath as NSIndexPath).row]
        if let height = cellHeights?.objectForKey(dish.rating_id) {
            print("Cell Height : \(height as! CGFloat)")
            return height as! CGFloat
        }
        else {
            cellHeights?.setObject(464, forKey: dish.rating_id as NSCopying)
        }
        return 464
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FeedListCell
        let dish = list[(indexPath as NSIndexPath).row]
        cell.setScrollable(false)
        cell.delegate = self
        cell.setContent(dish)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        pushDishName(list[(indexPath as NSIndexPath).row])
    }
    //Mark: FeedListCell Protocol
    
    func heightChanged(feedCell: FeedListCell, newHeight: CGFloat, forceResize: CGSize) {
        if let oldHeight = cellHeights?.objectForKey(feedCell.theDish!.rating_id) {
            let height = oldHeight as! CGFloat
            if newHeight != height {
                cellHeights?.setObject(newHeight, forKey: (feedCell.theDish?.rating_id)! as NSCopying)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        }
    }

    func pushRestName(dish: EPDish) {
        let restaurantDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("RestaurantDetailTableViewController") as! RestaurantDetailTableViewController
        restaurantDetailViewController.restaurantId = dish.restaurant_id
        self.navigationController?.pushViewController(restaurantDetailViewController, animated: true)
    }
    
    func pushImgProfile(dish: EPDish) {
        let profileViewController = storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        profileViewController.userId = dish.login_id
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func pushLike(dish: EPDish, liked: Bool) {
            
        EatopineAPI.likeDish(dish.rating_id, userId: AppUtility.currentUserId.integerValue, fromDev: 1, liked: liked, completionClosure: { (success) in
            if success {
                        
            }
        })

    }
    
    func pushComment(dish: EPDish) {
        if AppUtility.isUserLogged(ShowAlert: true) {
            
            let commentListViewController = storyboard?.instantiateViewControllerWithIdentifier("CommentsListViewController") as! CommentsListViewController
            commentListViewController.ratingId = dish.rating_id
            commentListViewController.addComment = true
            self.navigationController?.pushViewController(commentListViewController, animated: true)
        }
    }
    
    func pushOption(dish: EPDish) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let doReport = UIAlertAction(title: "Report", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
            let reportViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ReportViewController") as! ReportViewController
            reportViewController.dish = dish
            reportViewController.type = ReportType.rating.rawValue
            self.navigationController?.pushViewController(reportViewController, animated: true)
        })
        doReport.setValue(UIColor.redColor(), forKey: "titleTextColor")
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
    
    func pushGetLikes(dish: EPDish) {
        let likesUserListViewController = storyboard?.instantiateViewControllerWithIdentifier("LikesUserListViewController") as! LikesUserListViewController
        likesUserListViewController.ratingId = dish.rating_id
        self.navigationController?.pushViewController(likesUserListViewController, animated: true)
    }
    
    func pushGetComments(dish: EPDish) {
        let commentListViewController = storyboard?.instantiateViewControllerWithIdentifier("CommentsListViewController") as! CommentsListViewController
        commentListViewController.ratingId = dish.rating_id
        commentListViewController.addComment = false
        self.navigationController?.pushViewController(commentListViewController, animated: true)
    }
    
    func pushDishName(dish: EPDish) {
        let dishDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("DishDetailViewController") as! DishDetailViewController
        dishDetailViewController.dish = dish
        self.navigationController?.pushViewController(dishDetailViewController, animated: true)
    }
    
    func getestimatedCellHeights() {
        for dish in list {
            var h = kStaticHeight
            if dish.dish_name != "" {
                h += kLabelHeight * 2
            }
            
            if (dish.comments.count > 0) {
                h += kLabelHeight * 2
            }
            
            if (dish.comments.count > 1) {
                h += kLabelHeight * 2
            }
            
            if dish.n_comments > 2 {
                h += kAllViewHeight
            }
            print("Cell Estimation: \(h)")
            cellHeights?.setObject(h, forKey: dish.rating_id as NSCopying)
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffsetX = scrollView.contentOffset.y
        
        if (scrollOffsetX != 0) {
            if scrollOffsetX + scrollViewHeight >= scrollContentSizeHeight {
                loadMore()
            }
        }
        
    }
    
    func loadMore() {
        if let feedVC = self.parentViewController {
            if feedVC is FeedViewController {
                (feedVC as! FeedViewController).downloadMore()
            }
        }
    }
}
