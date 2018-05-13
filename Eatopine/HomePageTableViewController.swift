//
//  HomePageTableViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 01/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class HomePageTableViewController: UITableViewController, TPFloatRatingViewDelegate {

//    enum Section : Int {
//        case Restaurant = 0
//        case SeeMore
//        case HotDishes
//    }
    
    //@IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    
    var currentPage = 0
    var shouldLoadMore = true
    var isDownloadingActions = false
    var restaurantsArray = [EPRestaurant]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.addObserver(self, forKeyPath: "userLocation", options: NSKeyValueObservingOptions.New, context: nil)
    }

    deinit {
        LocationManager.removeObserver(self, forKeyPath: "userLocation")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {

        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBarHidden = false
        self.tableView.reloadData()
        self.tableView.scrollRectToVisible(CGRectMake(10, 10, 10, 10), animated: false)
        
        currentPage = 0;
        restaurantsArray.removeAll()
        shouldLoadMore = true
        
        downloadRestaurants()
    }
    
    
    func downloadRestaurants() {
        if restaurantsArray.count == 0 {
            AppUtility.showActivityOverlay("Loading")
        }
        isDownloadingActions = true
        
        EatopineAPI.downloadRestaurantFeed(currentPage) { (success, restaurants) in
            AppUtility.hideActivityOverlay()

            self.isDownloadingActions = false
            if success {
                self.updateTableWithData(restaurants!)
            }else{
                self.shouldLoadMore = false
                self.tableView.reloadData()
            }
        }
    }
    
    func updateTableWithData(restArray:[EPRestaurant]) {
        
        print("downloaded \(restArray.count)")
        if restArray.count < DOWNLOAD_OBJECT_LIMIT {
            shouldLoadMore = false
        }
        for rest in restArray {
            self.restaurantsArray.append(rest)
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func pushSearchController(sender: AnyObject?) {
        let searchController = storyboard?.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
  //      searchController.searchType = .All
        self.navigationController?.pushViewController(searchController, animated: true)
    }
    
    @IBAction func openCitySearchController(sender: AnyObject?) {
        let searchController = storyboard?.instantiateViewControllerWithIdentifier("SearchCityTableViewController") as! SearchCityTableViewController
        searchController.shouldReturnSelectedCity = false
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    @IBAction func showList(sender: AnyObject?) {
        
        self.tabBarController?.selectedIndex = 3
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(6, restaurantsArray.count)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 93
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      //  let section = indexPath.section
        let row = indexPath.row
        
        let restaurantCell = tableView.dequeueReusableCellWithIdentifier("RestaurantTableViewCell", forIndexPath: indexPath) as! RestaurantTableViewCell
        let restaurant = restaurantsArray[row]
        
        restaurantCell.lblName.text = restaurant.name
        restaurantCell.lblAddress.text = restaurant.fullAddress
        restaurantCell.lblDish.text = restaurant.dish_name
        if restaurant.dish_name.characters.count == 0 {
            restaurantCell.bestDishIcon.hidden = true
        }else{
            restaurantCell.bestDishIcon.hidden = false
        }
        
     //   restaurantCell.lblRatingNumber.text = "\(restaurant.number_ratings) votes"
        restaurantCell.rating.rating = CGFloat(restaurant.rating)
        restaurantCell.photo.sd_setImageWithURL(NSURL(string: restaurant.photo), placeholderImage: UIImage(named: "restaurant_placeholder"))
        
        restaurantCell.lblDistance.text = AppUtility.distanceFromRestaurantInMiles(restaurant)
        restaurantCell.lblPrice.text = restaurant.getPriceString()
            
        return restaurantCell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //    let section = indexPath.section
        let row = indexPath.row
        
        let restaurant = restaurantsArray[row]
        let restaurantDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("RestaurantDetailTableViewController") as! RestaurantDetailTableViewController
        restaurantDetailViewController.restaurant = restaurant
        self.navigationController?.pushViewController(restaurantDetailViewController, animated: true)
            
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: Scroll delegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y > self.tableView.contentSize.height - self.tableView.frame.size.height*2)
        {
            if isDownloadingActions == false && shouldLoadMore == true {
                currentPage += 1
                downloadRestaurants()
            }
        }
    }
    
    //MARK: KVO
//    
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        if keyPath == "userLocation" {
//            self.tableView.reloadData()
//        }
//    }
    
}
