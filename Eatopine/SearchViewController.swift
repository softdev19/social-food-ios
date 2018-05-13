//
//  SearchViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 19/09/15.
//  Copyright © 2015 Eatopine. All rights reserved.
//

import UIKit

//enum SearchType : String {
//    case Restaurant = "Restaurant"
//    case Dish = "Dish"
//    case City = "City"
//    case All = "All"
//}


class SearchViewController: SearchBaseTableViewController {

    var results = [AnyObject]()
    var cityArray = [CityDetails]()
//    var searchType:SearchType?
    var isCitySearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        // Do any additional setup after loading the view.
//        if searchType == .Restaurant {
//            self.title = "Search Restaurant"
//            searchController.searchBar.placeholder = "Search for restaurant"
//            downloadDefaultRestaurants()
//        }else if searchType == .Dish {
//            self.title = "Search Dish"
//            searchController.searchBar.selectedScopeButtonIndex = 1
//            searchController.searchBar.placeholder = "Search for dish"
//            downloadDefaultDishes()
//        }else if searchType == .City {
//            self.title = "Search City"
//            searchController.searchBar.selectedScopeButtonIndex = 2
//        }else if searchType == .All {
//            self.title = "Search"
//            searchController.searchBar.scopeButtonTitles = ["Restaurant","Dish","City"]
//            downloadDefaultRestaurants()
//            self.tableView.reloadData()
//        }
//        
//        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        searchController.active = true
        
    }

/*    override func viewDidAppear(animated: Bool) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func makeSearch(search: String) {
        
        if searchType == .Restaurant {
            searchRestaurants(search)
        }else if searchType == .Dish {
            self.title = "Search Dish"
            searchDish(search)
        }else if searchType == .City {
            searchCity(search)
        }else if searchType == .All {
            let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
            if selectedIndex == 0 {
                searchRestaurants(search)
            }else if selectedIndex == 1 {
                searchDish(search)
            }else{
                searchCity(search)
            }
        }
    }
    
    func downloadDefaultRestaurants() {
        EatopineAPI.downloadRestaurantHomePage { (success, restaurants) -> () in
            if restaurants != nil {
                self.results = restaurants!
                self.tableView.reloadData()
            }
        }
    }
    
    func downloadDefaultDishes() {
        EatopineAPI.downloadDishesForCity(DefaultCityController.getDefault(), page: 0, completionClosure: { (success, dishes) -> () in
            if dishes != nil {
                self.results = dishes!
                self.tableView.reloadData()
            }
        })
    }
    
    func searchRestaurants(searchText:String){
        EatopineAPI.searchRestaurants(searchText, completionClosure: { (success, restaurants) -> () in
            if success {
                self.results = restaurants!
                self.tableView.reloadData()
            }
        })
    }
    func searchDish(searchText:String){
        EatopineAPI.searchDishes(searchText, completionClosure: { (success, dishes) -> () in
            if success {
                self.results = dishes!
                self.tableView.reloadData()
            }
        })
    }
    func searchCity(searchText:String){
        EatopineAPI.searchCity(searchText, completionClosure: { (success, cities) -> () in
            if success {
                self.cityArray = cities!
                self.tableView.reloadData()
            }
        })
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCitySearch == false{
            return results.count
        }else{
            return cityArray.count
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        if selectedIndex == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchRestaurantTableViewCell", forIndexPath: indexPath) as! SearchRestaurantTableViewCell
            let restaurant = results[indexPath.row] as! EPRestaurant
            
            cell.lblName.text = restaurant.name
            cell.lblAddress.text = restaurant.fullAddress
            cell.lblDistance.text = AppUtility.distanceFromRestaurantInMiles(restaurant)
            
            return cell
        }else if selectedIndex == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchRestaurantTableViewCell", forIndexPath: indexPath) as! SearchRestaurantTableViewCell
            let dish = results[indexPath.row] as! EPDish
            print("name \(dish.name)")
            cell.lblName.text = dish.name
            cell.lblAddress.text = dish.restaurant_name
            cell.lblDistance.text = ""
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchRestaurantTableViewCell", forIndexPath: indexPath) as! SearchRestaurantTableViewCell
            let city = cityArray[indexPath.row] 
            
            cell.lblName.text = city.name
            cell.lblAddress.text = city.state
            cell.lblDistance.text = ""
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     //   searchController.active = false
        
        let row = indexPath.row
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        
        if delegate != nil && isCitySearch == false {
            
            let selected = results[indexPath.row]
            delegate?.didSelect(selected)
            
            if self.navigationController?.viewControllers.count > 1 {
                // go to restaurant search
                self.navigationController?.popToRootViewControllerAnimated(true)
            } else {
                // close
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }else{
            if selectedIndex == 0 {
                
                let restaurant = results[row] as! EPRestaurant
                let restaurantDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("RestaurantDetailTableViewController") as! RestaurantDetailTableViewController
                restaurantDetailViewController.restaurant = restaurant
                self.navigationController?.pushViewController(restaurantDetailViewController, animated: true)
                
            }else if selectedIndex == 1 {
                let dish = results[indexPath.row] as! EPDish
                
                let dishDetailController = storyboard?.instantiateViewControllerWithIdentifier("DishDetailTableViewController") as! DishDetailTableViewController
                dishDetailController.dish = dish
                dishDetailController.title = dish.restaurant_name
                self.navigationController?.pushViewController(dishDetailController, animated: true)
            }else{
                let city = cityArray[indexPath.row]
                DefaultCityController.setDefaultCity(city)
                UserDefaults.setBool(true, forKey: LIST_NEEDS_REFRESH)
                UserDefaults.synchronize()
                
                self.tabBarController?.selectedIndex = 3
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
        
        searchController.active = false
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let searchString = searchController.searchBar.text
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        if searchString!.characters.count >= 3 {
            if selectedIndex <= 1 {
                isCitySearch = false
            }else{
                isCitySearch = true
            }
            makeSearch(searchString!)
        }else{
            
            if selectedIndex == 0 {
                isCitySearch = false
                downloadDefaultRestaurants()
            }else if selectedIndex == 1 {
                isCitySearch = false
                downloadDefaultDishes()
            }else{
                isCitySearch = true
                self.results = []
                self.tableView.reloadData()
            }
        }
    }
*/
}
