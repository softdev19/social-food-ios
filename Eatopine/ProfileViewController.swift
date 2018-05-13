//
//  ProfileViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 27/07/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    enum ContentType : Int {
        case photo = 1
        case activity = 2
        case restaurant = 3
    }
    
    @IBOutlet weak var containerViw: UIView!
    
    @IBOutlet weak private var lblName: UILabel!
    @IBOutlet weak private var lblLocation: UILabel!
    @IBOutlet weak var vLocation: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak private var imgvProfilePhoto: UIImageView!
    
    @IBOutlet weak var locationLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblPhotos: UILabel!
    
    @IBOutlet weak var btnRestaurants: UIButton!
    @IBOutlet weak var btnPhotos: UIButton!
    @IBOutlet weak var btnActivities: UIButton!
    
    @IBOutlet weak var vPhoto: UIView!
    @IBOutlet weak var vActivity: UIView!
    @IBOutlet weak var vRestaurant: UIView!
    
    @IBOutlet weak private var lblRestReviews: UILabel!
    @IBOutlet weak private var lblDishReviews: UILabel!
    @IBOutlet weak private var lblCheckins: UILabel!
    @IBOutlet weak private var lblPoints: UILabel!
    @IBOutlet weak private var btnOptions: UIBarButtonItem!

    let kLabelHeight: CGFloat = 20
    
    let refreshControl = UIRefreshControl()
    var user:UserProfile!
    var userId = 0

    var currentPage = 0

    var shouldLoadMore = true
    var isDownloadingActions = false
    var shouldEmptyArray = false
    
    var btnBack: UIBarButtonItem!
    
    var photoController: FeedViewController!
    var activityController: ActivityViewController!
    var resturantControler: ResturantListViewController!
    var currentViewController: UIViewController?
    var currentContentType = ContentType.photo
    
    var isFollower = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoController = self.storyboard?.instantiateViewControllerWithIdentifier("FeedViewController") as! FeedViewController
        photoController.userScreen = true
        activityController = self.storyboard?.instantiateViewControllerWithIdentifier("activityController") as! ActivityViewController
        activityController.userId = (userId == 0) ? AppUtility.currentUserId.integerValue : userId
        resturantControler = self.storyboard?.instantiateViewControllerWithIdentifier("resturantControlers") as! ResturantListViewController

        btnBack = UIBarButtonItem(image: UIImage(named: "back_icon.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ProfileViewController.onBackBtnClick(_:)))
        
        if userId == 0 {
            self.navigationItem.leftBarButtonItem = nil
        }
        else {
            self.navigationItem.leftBarButtonItem = btnBack
        }
        
        refreshControl.endRefreshing()
        
        btnPhotos.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btnPhotos.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
        btnRestaurants.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btnRestaurants.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
        btnActivities.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btnActivities.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
        
        vPhoto.backgroundColor = UIColor.whiteColor()
        vActivity.backgroundColor = UIColor.whiteColor()
        vRestaurant.backgroundColor = UIColor.whiteColor()
        
        pushContentButton(btnPhotos)
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.title = ""
    }
    
    func endEditing(){
        self.view.endEditing(true)
    }
    func popController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidAppear(animated: Bool) {
        downloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackBtnClick(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func pushContentButton(sender: UIButton) {
        if sender.tag == 0 {
            btnPhotos.selected = true
            btnActivities.selected = false
            btnRestaurants.selected = false
            
            vPhoto.backgroundColor = UIColor.redColor()
            vActivity.backgroundColor = UIColor.whiteColor()
            vRestaurant.backgroundColor = UIColor.whiteColor()
        }
        else if sender.tag == 1 {
            btnPhotos.selected = false
            btnActivities.selected = true
            btnRestaurants.selected = false
            
            vPhoto.backgroundColor = UIColor.whiteColor()
            vActivity.backgroundColor = UIColor.redColor()
            vRestaurant.backgroundColor = UIColor.whiteColor()
        }
        else {
            btnPhotos.selected = false
            btnActivities.selected = false
            btnRestaurants.selected = false
            
            vPhoto.backgroundColor = UIColor.whiteColor()
            vActivity.backgroundColor = UIColor.whiteColor()
            vRestaurant.backgroundColor = UIColor.redColor()
        }
        
        setupContent()
    }
    
    func setupContent() {
        if selectedContentType() == .photo {
            currentViewController = photoController
        }
        else if selectedContentType() == .activity {
            currentViewController = activityController
        }
        else {
            currentViewController = resturantControler
        }
        
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubView(self.currentViewController!.view, toView: self.containerViw)
    }

    func addSubView(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func selectedContentType() -> ContentType {
        if btnPhotos.selected {
            currentContentType = .photo
        }
        else if btnActivities.selected {
            currentContentType = .activity
        }
        else {
            currentContentType = .restaurant
        }
        
        return currentContentType
    }
    
    func downloadData() {
        
        if user == nil {
            AppUtility.showActivityOverlay("")
        }
        
        if userId == 0 {
            userId = AppUtility.currentUserId.integerValue
        }
        EatopineAPI.downloadUser(userId, completionClosure: { (success, userObject) -> () in
            AppUtility.hideActivityOverlay()
            if success {
                self.user = userObject
                self.updateView()
            }
        })
    }
    
    func refreshControlPressed() {
        shouldEmptyArray = true
//        downloadActions()
    }
    
    func updateView() {
        lblName.text = user.username
        imgvProfilePhoto.sd_setImageWithURL(NSURL(string: user.profilePhoto), placeholderImage: UIImage(named: "placeholder_profile"))
        AppUtility.makeCircleImageView(imgvProfilePhoto)
        lblLocation.text = user.city
        lblDescription.text = user.description
        lblFollowers.text = "\(user.followers)"
        lblFollowing.text = "\(user.following)"
        lblPhotos.text = "\(user.photos)"
        
        locationLabelWidthConstraint.constant = user.city.widthWithConstrainedHeight(kLabelHeight, font: UIFont.systemFontOfSize(14.0))
        
        if user.city == "" {
            locationViewHeightConstraint.constant = 0
            vLocation.hidden = true
        }
        else {
            locationViewHeightConstraint.constant = kLabelHeight
            vLocation.hidden = false
        }
        
        if user.description == "" {
            descriptionLabelHeightConstraint.constant = 0
            lblDescription.hidden = true
        }
        else {
            descriptionLabelHeightConstraint.constant = kLabelHeight
            lblDescription.hidden = false
        }
    }
    
    func updateTableWithData(actions:[EPUserAction]) {
        
        if shouldEmptyArray == true {
//            actionArray.removeAll()
        }
        
        print("downloaded \(actions.count)")
        if actions.count < DOWNLOAD_OBJECT_LIMIT {
            shouldLoadMore = false
        }
//        for action in actions {
////           actionArray.append(action)
//        }
        
//        tblActions.reloadData()
    }
    
    // MARK: - Table view data source
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1;
////        return actionArray.count
//    }
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("ActionTableViewCell", forIndexPath: indexPath) as! ActionTableViewCell
//        let action = actionArray[indexPath.row]
//        cell.photoView.sd_setImageWithURL(NSURL(string: action.photo), placeholderImage: UIImage(named: "dish_placeholder"))
//        cell.rating.rating = CGFloat(action.rating)
//        
//        cell.lblName.text = action.name
//        if action.type == ActionType.ReviewDish {
//            cell.lblLocation.text = "\(action.restaurant_name) - \(action.locality), \(action.region)"
//            cell.lblType.text = "dish review"
//        }else{
//            cell.lblLocation.text = "\(action.locality), \(action.region)"
//            cell.lblType.text = "review"
//        }
//        cell.lblDate.text = AppUtility.reviewCellDateString(action.createdDate)
//        cell.lblReview.text = "                        \(action.review)"
//        return cell
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let action = actionArray[indexPath.row]
        
//        if action.type == ActionType.ReviewDish  {
//            AppUtility.showActivityOverlay("")
//            EatopineAPI.downloadDish(action.id, completionClosure: { (success, dish) -> () in
//                AppUtility.hideActivityOverlay()
//                if success == true{
//                    let dishDetailController = self.storyboard?.instantiateViewControllerWithIdentifier("DishDetailTableViewController") as! DishDetailTableViewController
//                    dishDetailController.dish = dish
//                    dishDetailController.title = dish!.restaurant_name
//                    self.navigationController?.pushViewController(dishDetailController, animated: true)
//                }
//            })
//        
//        }else {
//            AppUtility.showActivityOverlay("")
//            EatopineAPI.downloadRestaurant(action.id, completionClosure: { (success, restaurant) -> () in
//                AppUtility.hideActivityOverlay()
//                if success == true {
//                    let restaurantDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RestaurantDetailTableViewController") as! RestaurantDetailTableViewController
//                    restaurantDetailViewController.restaurant = restaurant
//                    self.navigationController?.pushViewController(restaurantDetailViewController, animated: true)
//                }
//            })
//        }
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: Scroll delegate
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        if (self.tblActions.contentOffset.y > self.tblActions.contentSize.height - self.tblActions.frame.size.height*2)
//        {
//            if isDownloadingActions == false && shouldLoadMore == true {
//                currentPage += 1
////                downloadActions()
//            }
//        }
//    }
    
    //MARK: AlertController
    @IBAction func options() {
        self.performSegueWithIdentifier("settings", sender: nil)
    }
    //MARK: My functions
    
    @IBAction func followersAction(sender: AnyObject) {
        isFollower = true
        self.performSegueWithIdentifier("follow", sender: nil)
    }
    
    @IBAction func followingAction(sender: AnyObject) {
        isFollower = false
        self.performSegueWithIdentifier("follow", sender: nil)
    }
    
    @IBAction func photosAction(sender: AnyObject) {
     
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "settings" {
            (segue.destinationViewController as! SettingsViewController).userData = user
        }
        if segue.identifier == "follow" {
            (segue.destinationViewController as! FollowersViewController).isFollower = isFollower
            (segue.destinationViewController as! FollowersViewController).userId = userId
        }
    }
}
