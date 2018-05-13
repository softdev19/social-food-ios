//
//  FeedViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 15/08/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    enum FeedType : Int {
        case list = 1
        case grid = 2
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet weak var btnGrid: UIButton!
    
    var listController: FeedListCollectionViewController!
    var gridController: FeedGridCollectionViewController!
    
    var currentViewController: UIViewController?
    var currentFeedType = FeedType.grid
    var currentPage = 0
    var friends = 0
    
    var shouldLoadMore = true
    var isDownloadingActions = false
    var feedArray = [EPDish]()
    
    var userScreen = false
    
    override func viewDidLoad() {

        listController = self.storyboard?.instantiateViewControllerWithIdentifier("FeedListCollectionViewController") as! FeedListCollectionViewController
        gridController = self.storyboard?.instantiateViewControllerWithIdentifier("FeedGridCollectionViewController") as! FeedGridCollectionViewController
        
        feedButtonPressed(btnList)
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectedFeedType() -> FeedType{
        if btnList.selected == true{
            currentFeedType = .list
        }else {
            currentFeedType = .grid
        }
        
        return currentFeedType
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        populateFeed()
    }
    
    func childController() -> FeedProtocol {
        if btnList.selected == true{
            return listController
        }else {
            return gridController
        }
    }
    
    
    @IBAction func feedButtonPressed(sender: UIButton) {
        
        if sender.tag == 0 {
            btnList.selected = true
            btnGrid.selected = false
        }else {
            btnList.selected = false
            btnGrid.selected = true
        }
        setupFeed()
    }
    
    
    func setupFeed() {

        if selectedFeedType() == .list {
            currentViewController = listController
        }else {
            currentViewController = gridController
        }
        
        
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.containerView)
        populateFeed()
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func populateFeed() {
        
        if feedArray.count == 0 {
            AppUtility.showActivityOverlay("Loading")
        }
        isDownloadingActions = true
        
        var userId = 0;
        if AppUtility.isUserLogged(ShowAlert: false) {
            userId = AppUtility.currentUserId.integerValue
        }
        EatopineAPI.downloadDishFeed(currentPage, type: currentFeedType.rawValue, userId: userId, userScreen: userScreen, friends: friends) { (success, dishes) in
            AppUtility.hideActivityOverlay()
            
            self.isDownloadingActions = false
            if dishes != nil {
                self.feedArray.removeAll()
                if dishes!.count < DOWNLOAD_OBJECT_LIMIT {
                    self.shouldLoadMore = false
                }
                for dish in dishes! {
                    self.feedArray.append(dish)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.childController().refresh(self.feedArray)
                })
            }else{
                self.shouldLoadMore = false
                dispatch_async(dispatch_get_main_queue(), {
                    self.childController().refresh(self.feedArray)
                })
            }
        }
    }
    
    func downloadMore() {
        if shouldLoadMore == false {
            return
        }
        
        isDownloadingActions = true
        
        var userId = 0;
        if AppUtility.isUserLogged(ShowAlert: false) {
            userId = AppUtility.currentUserId.integerValue
        }
        
        currentPage = currentPage + 1
        EatopineAPI.downloadDishFeed(currentPage, type: currentFeedType.rawValue, userId: userId, userScreen: userScreen, friends: friends) { (success, dishes) in
            AppUtility.hideActivityOverlay()
            
            self.isDownloadingActions = false
            if dishes != nil {
                if dishes!.count < DOWNLOAD_OBJECT_LIMIT {
                    self.shouldLoadMore = false
                }
                for dish in dishes! {
                    self.feedArray.append(dish)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.childController().refresh(self.feedArray)
                })
            }else{
                self.shouldLoadMore = false
                dispatch_async(dispatch_get_main_queue(), {
                    self.childController().refresh(self.feedArray)
                })
            }
        }

    }
    
 //   MARK:  My funcations
    
    @IBAction func topAction(sender: AnyObject) {
        
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                let savedProfile = UIAlertAction(title: "Show All Photos", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
                    self.friends = 0
                    self.populateFeed()
                })
                alertController.addAction(savedProfile)
                let editProfile = UIAlertAction(title: "Show Photos Only From Following Users", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
                    self.friends = AppUtility.currentUserId.integerValue
                    self.populateFeed()
                })
                alertController.addAction(editProfile)
                let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil)
                alertController.addAction(cancelButton)
                self.presentViewController(alertController, animated: true, completion: nil)
    }
}
