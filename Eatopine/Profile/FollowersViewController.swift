//
//  FollowersViewController.swift
//  Eatopine
//
//  Created by Ourangzaib khan on 9/10/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class FollowersViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    var isFollower = false
    var userId = 0
    var users = [LikeUser]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        downloadFollowers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("followerCell" , forIndexPath: indexPath) as! UserListCell
        let user = users[indexPath.row]
        cell.lbUserName.text = user.username
        cell.lbDisplayName.text = user.fullname
        cell.profileImage.sd_setImageWithURL(NSURL(string: user.profilePhoto))
        return cell
    }
    @IBAction func onBackBtnClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func downloadFollowers () {
        if isFollower {
            EatopineAPI.getFollowers(userId, limit: 20, completionClosure: { (success, users) in
                if users == nil {
                    self.users = [LikeUser]()
                }
                else {
                    self.users = users!
                }
                self.tableView.reloadData()
            })
        }
        else {
            EatopineAPI.getFollowing(userId, limit: 20, completionClosure: { (success, users) in
                if users == nil {
                    self.users = [LikeUser]()
                }
                else {
                    self.users = users!
                }
                self.tableView.reloadData()
            })
        }
    }
}
