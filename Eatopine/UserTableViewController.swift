//
//  UserTableViewController.swift
//  Eatopine
//
//  Created by  on 10/17/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var users = [LikeUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchUsers("")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchUserCell", forIndexPath: indexPath) as! UserListCell
        
        let user = users[indexPath.row]
        cell.lbUserName.text = user.username
        cell.lbDisplayName.text = user.fullname
        cell.profileImage.sd_setImageWithURL(NSURL(string: user.profilePhoto))
        cell.lblPhotos.text = "\(user.photos)"
        return cell
    }
    
    func searchUsers(searchString: String) {
        EatopineAPI.searchUsers(searchString) { (success, users) in
            if users == nil {
                self.users = [LikeUser]()
            }
            else {
                self.users = users!
            }
            
            self.tableView.reloadData()
        }
    }
}
