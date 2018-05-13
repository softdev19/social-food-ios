//
//  LikesUserListViewController.swift
//  Eatopine
//
//  Created by Tony on 9/21/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class LikesUserListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ratingId: Int = 0
    var users: [LikeUser] = []
    var pageNumber = 0
    var currentUserID = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onBackBtnClick(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserListCell", forIndexPath: indexPath) as! UserListCell
        let user = users[indexPath.row]
        
        cell.lbUserName.text = user.username
        cell.lbDisplayName.text = user.fullname
        cell.btnFollow.setImage(UIImage(named: "Follow.png"), forState: UIControlState.Normal)
        cell.btnFollow.setImage(UIImage(named: "Following.png"), forState: UIControlState.Selected)
        
        if user.followed == user.loged_id && user.loged_id != 0 {
            cell.btnFollow.selected = true
        }
        else {
            cell.btnFollow.selected = false
        }
        cell.btnFollow.tag = user.loged_id
        
        cell.profileImage.sd_setImageWithURL(NSURL(string: user.profilePhoto), placeholderImage: UIImage(named: "generic_avatar"))
        AppUtility.makeCircleImageView(cell.profileImage)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func onFollowBtnClick(sender: UIButton) {
        if (AppUtility.isUserLogged(ShowAlert: true)) {
            if (sender.selected) {
                EatopineAPI.followUser(AppUtility.currentUserId.integerValue, followId: sender.tag, fromDev: 1, liked: false, completionClosure: { (success) in
                    if success == true {
                        sender.selected = false
                    }
                })
            }
            else {
                EatopineAPI.followUser(AppUtility.currentUserId.integerValue, followId: sender.tag, fromDev: 1, liked: true, completionClosure: { (success) in
                    if success == true {
                        sender.selected = true
                    }
                })
            }
        }
    }
    
    func downloadUsers() {
        AppUtility.showActivityOverlay("")
        if (AppUtility.isUserLogged(ShowAlert: false)) {
            currentUserID = AppUtility.currentUserId.integerValue
        }
        
        EatopineAPI.getLikes(self.ratingId, userId: currentUserID, pageNumber: self.pageNumber, limit: 40) { (success, users) in
            AppUtility.hideActivityOverlay()
            if users == nil {
                print("GET LIKE USER NULL")
            }
            else {
                self.users = users!
                self.tableView.reloadData()
            }
        }

    }

}
