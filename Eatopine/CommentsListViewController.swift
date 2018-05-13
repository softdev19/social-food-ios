//
//  AllCommentsViewController.swift
//  Eatopine
//
//  Created by Eden on 9/16/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

protocol CommentsListViewControllerDelegate {
    func refreshComments()
}

class CommentsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    var ratingId: Int = 0
    var comments: [Comment] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var editViewHContstraint: NSLayoutConstraint!
    
    @IBOutlet weak var editCommentView: UIView!
    @IBOutlet weak var txtComment: UITextField!
    
    var addComment = false
    
    let kEditViewHeight:CGFloat = 50
    
    private var lastContentOffset: CGFloat = 0
    
    var delegate : CommentsListViewControllerDelegate?
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtComment.delegate = self
        if AppUtility.isUserLogged(ShowAlert: false) {
            editViewHContstraint.constant = kEditViewHeight
            editCommentView.hidden = false
        }
        else {
            editViewHContstraint.constant = 0;
            editCommentView.hidden = true
        }
        
        tableView.separatorColor = UIColor.clearColor()
        downloadComments()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentsListViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentsListViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if addComment {
            txtComment.becomeFirstResponder()
        }
    }
    //Mark: Keyboard Show/Hide
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = (notification as NSNotification).userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height
        let changeInHeight = (keyboardFrame.height - tabBarHeight!) * (show ? 1 : -1)
        
        UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
            self.bottomConstraint.constant += changeInHeight
        })
    }
    
    //Mark: TextFleid Delegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("Editing End")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("Click Return")
        txtComment.resignFirstResponder()
        return true
    }
    
    //Mark: ScrollView Protocol
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            txtComment.resignFirstResponder()
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    @IBAction func onBackBtnClick(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    //Mark: TableView Delegate & DataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentCell
        let comment = comments[(indexPath as NSIndexPath).row]
        
        cell.lbUserName.text = comment.username
        cell.lbComment.text = comment.comment
        cell.lbCommentTime.text = AppUtility.getMinutesFromToday(comment.created)
        cell.profileImage.sd_setImageWithURL(NSURL(string: comment.profile_picture), placeholderImage: UIImage(named: "generic_avatar"))
        
        AppUtility.makeCircleImageView(cell.profileImage)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func downloadComments() {
        AppUtility.showActivityOverlay("")
        EatopineAPI.downloadDishComments(ratingId, limit: 30, completionClosure: { (success, comments) -> () in
            AppUtility.hideActivityOverlay()
            if success {
                self.comments = comments!
                self.tableView.reloadData()
            }
        })
    }
    
    func refreshComments() {
        EatopineAPI.downloadDishComments(ratingId, limit: 30, completionClosure: { (success, comments) -> () in
            if success {
                self.comments = comments!
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        })
    }
    @IBAction func onAddCommentBtnClick(sender: AnyObject) {
        
        if txtComment.text! == "" {
            return
        }
        
        EatopineAPI.addComment(ratingId, userId: AppUtility.currentUserId.integerValue, text: txtComment.text!, country: "En_US", fromDev: 1) { (success) in
            if success {
                print("Add Comment Success")
                self.txtComment.text = ""
                self.refreshComments()
            }
        }
    }
}
