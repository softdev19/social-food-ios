//
//  ActivityViewController.swift
//  Eatopine
//
//  Created by Ourangzaib khan on 9/10/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {

    var userId = 0
    var activities = [EPActivity]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getActivities()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView Protocol
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell" , forIndexPath: indexPath) as! ActivityTableViewCell
        let activity = activities[indexPath.row]
        cell.firstName.text = activity.userName
        cell.dishName.text = activity.dishName
        cell.commentCount.text = "\(activity.comments)"
        cell.likesCount.text = "\(activity.likes)"
        cell.activityImage.sd_setImageWithURL(NSURL(string: activity.photo), placeholderImage: UIImage(named: "restaurant_placeholder"))
        cell.review.text = activity.review
        cell.fullComent.text = activity.description
        
        if activity.type == .RatingLike {
            cell.typeIcon.image = UIImage(named: "dish_small_heart_icon.png")
        }
        else if activity.type == .RatingComment {
            cell.typeIcon.image = UIImage(named: "dish_small_comment_icon.png")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        AppUtility.showAlert("I can't get dishID from user activities.", title: "API Error")
    }
    
    func getActivities() {
        //AppUtility.showActivityOverlay("")
        EatopineAPI.downloadUserActivity(userId, pageNumber: 0, limit: 20) { (success, actions) in
            if actions == nil {
                self.activities = [EPActivity]()
            }
            else {
                self.activities = actions!
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    func getDish(dishId: Int) {
        
    }
}
