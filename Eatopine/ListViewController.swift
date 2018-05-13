//
//  ListViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 26/09/15.
//  Copyright © 2015 Eatopine. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UISearchBarDelegate{

    enum SearchType: Int {
        case Dish = 1
        case People = 2
        case Restaurant = 3
    }
    
    var restaurants = [EPRestaurant]()
    var dishes = [EPDish]()
    var users = [EPUser]()
    
    var sortType = "date_desc"
    var currentPage = 0
    var shouldLoadMore = true
    var isDownloadingActions = false
    
    var dishListController: DishCollectionViewController!
    var userListController: UserTableViewController!
    var restaurantListController: ResturantListViewController!
    
    var currentViewController: UIViewController?
    var currentSearchType = SearchType.Dish
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnDish: UIButton!
    @IBOutlet weak var btnPeople: UIButton!
    @IBOutlet weak var btnRestaurant: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        dishListController = self.storyboard?.instantiateViewControllerWithIdentifier("DishCollectionViewController") as! DishCollectionViewController
        userListController = self.storyboard?.instantiateViewControllerWithIdentifier("UserTableViewController") as! UserTableViewController
        restaurantListController = self.storyboard?.instantiateViewControllerWithIdentifier("resturantControlers") as! ResturantListViewController
        
        btnDish.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btnDish.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
        btnPeople.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btnPeople.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
        btnRestaurant.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btnRestaurant.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
        
        searchButtonPressed(btnDish)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectedSearchType() -> SearchType {
        if btnDish.selected == true {
            currentSearchType = .Dish
        }
        else if btnPeople.selected == true {
            currentSearchType = .People
        }
        else {
            currentSearchType = .Restaurant
        }
        
        return currentSearchType
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if UserDefaults.boolForKey(LIST_NEEDS_REFRESH) == true {
            downloadRestaurants()
        }
    }
    
    @IBAction func searchButtonPressed(sender: UIButton) {
        if sender.tag == 0 {
            btnDish.selected = true
            btnPeople.selected = false
            btnRestaurant.selected = false
        }
        else if sender.tag == 1 {
            btnDish.selected = false
            btnPeople.selected = true
            btnRestaurant.selected = false
        }
        else {
            btnDish.selected = false
            btnPeople.selected = false
            btnRestaurant.selected = true
        }
        
        setupSearch()
    }
    
    func setupSearch() {
        if selectedSearchType() == .Dish {
            currentViewController = dishListController
        }
        else if selectedSearchType() == .People {
            currentViewController = userListController
        }
        else {
            currentViewController = restaurantListController
        }
        
        self.currentViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.containerView)
        downloadElements()
    }
    
    func addSubview(subView: UIView, toView parentView: UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func downloadElements() {
        
    }
    
    func downloadRestaurants() {
        
        if UserDefaults.boolForKey(LIST_NEEDS_REFRESH) == true {
            currentPage = 0;
            restaurants.removeAll()
            shouldLoadMore = true
        }
        
        isDownloadingActions = true
        let filter = PersistancyManager.getFilter()
        AppUtility.showActivityOverlay("")
        EatopineAPI.downloadRestaurantForCity(DefaultCityController.getDefault(), page: currentPage, price: filter.getPricesParam(), cuisine: filter.getAllCuisinesParam(), dish: filter.getDishNameParam(), limit: DOWNLOAD_OBJECT_LIMIT, order: sortType) { (success, restaurants) -> () in
            AppUtility.hideActivityOverlay()
            self.isDownloadingActions = false
            if UserDefaults.boolForKey(LIST_NEEDS_REFRESH) == true {
                UserDefaults.setBool(false, forKey: LIST_NEEDS_REFRESH)
                UserDefaults.synchronize()
            }
            if success{
                self.updateTableWithData(restaurants!)
            }else{
//                self.tblRestaurant.reloadData()
                self.shouldLoadMore = false
            }

        }
    }
    
    func updateTableWithData(restArray:[EPRestaurant]) {
        
        print("downloaded \(restArray.count)")
        if restArray.count < DOWNLOAD_OBJECT_LIMIT {
            shouldLoadMore = false
        }
        for rest in restArray {
            restaurants.append(rest)
        }
        
//        tblRestaurant.reloadData()
    }
    
    @IBAction func openCitySearchController(sender: AnyObject?) {
        let searchController = storyboard?.instantiateViewControllerWithIdentifier("SearchCityTableViewController") as! SearchCityTableViewController
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    @IBAction func openMap(sender: AnyObject?) {
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func openFilters(sender: AnyObject?) {
        
        let filtersViewController = storyboard?.instantiateViewControllerWithIdentifier("FiltersViewController") as! FiltersViewController
        let navController = RedNavigationController(rootViewController: filtersViewController)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    @IBAction func pushSearchController(sender: AnyObject?) {
        let searchController = storyboard?.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController

        self.navigationController?.pushViewController(searchController, animated: true)
    }
    
    //MARK: AlertController
    @IBAction func optionsSort() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let newest = UIAlertAction(title: "Newest First", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
            self.sortType = "date_desc"
            self.handleAlertSelection()
        })
        alertController.addAction(newest)
        let oldest = UIAlertAction(title: "Oldest First", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
            self.sortType = "date_asc"
            self.handleAlertSelection()
        })
        alertController.addAction(oldest)
        let ratingHigh = UIAlertAction(title: "Rating(High > Low)", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
            self.sortType = "rating_desc"
            self.handleAlertSelection()
        })
        alertController.addAction(ratingHigh)
        let ratingLow = UIAlertAction(title: "Rating(Low > High)", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
            self.sortType = "rating_asc"
            self.handleAlertSelection()
        })
        alertController.addAction(ratingLow)
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil)
        alertController.addAction(cancelButton)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func handleAlertSelection() {
        UserDefaults.setBool(true, forKey: LIST_NEEDS_REFRESH)
        UserDefaults.synchronize()
        self.downloadRestaurants()
    }
    
    //MARK: Scroll delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let searchString = searchBar.text!
        
        if (currentSearchType == .Dish) {
            dishListController.downloadDishes(searchString)
        }
        else if (currentSearchType == .People) {
            userListController.searchUsers(searchString)
        }
        else {
            restaurantListController.getSavedRes()
        }
    }
}
