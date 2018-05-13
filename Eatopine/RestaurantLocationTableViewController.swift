//
//  RestaurantLocationTableViewController.swift
//  Eatopine
//
//  Created by jcb on 9/28/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantLocationTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var restaurants = [EPRestaurant]()
    var locValue:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRestaurants("")
        self.searchBar.delegate = self
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let num = tableView.numberOfRowsInSection(indexPath.section)
        
        if indexPath.row < num - 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath) as! LocationCell
            
            let rest = restaurants[indexPath.row]
            cell.lblResName.text = rest.name
            cell.lblResLocation.text = rest.address
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AddResCell", forIndexPath: indexPath) as! AddResCell
        cell.lblAddRes.text = "Click here to create a restaurant..."
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let num = tableView.numberOfRowsInSection(indexPath.section)
        
        if indexPath.row < num - 1 {
            
            for viewController in self.navigationController!.viewControllers {
                if viewController is AddRatingViewController {
                    (viewController as! AddRatingViewController).restaurant = restaurants[indexPath.row]
                    (viewController as! AddRatingViewController).restaurantDict = nil
                }
            }
            
            self.navigationController?.popViewControllerAnimated(true)
        }
        else {
            let addRestaurantViewController = storyboard?.instantiateViewControllerWithIdentifier("AddRestaurantViewController") as! AddRestaurantViewController
            
            self.navigationController?.pushViewController(addRestaurantViewController, animated: true)
        }
    }
    
    @IBAction func onLocationBtnClick(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func onCancelBtnClick(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getRestaurants(resName: String) {
        if restaurants.count == 0 {
            AppUtility.showActivityOverlay("")
        }
        var parameters:[String:AnyObject]! = [String: AnyObject]()
        
        if resName != "" {
            parameters["name"] = resName
        }
        if locValue != nil {
            parameters["latitude"] = locValue.latitude
            parameters["longitude"] = locValue.longitude
        }
        EatopineAPI.getRestaurant(parameters, completionClosure: { (success, restaurants) in
            AppUtility.hideActivityOverlay()
            if restaurants == nil {
                self.restaurants = [EPRestaurant]()
            }
            else {
                self.restaurants = restaurants!
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        })
    }
    
    //MARK: Search Bar Protocol
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search Start")
        getRestaurants(searchBar.text!)
    }
    
}

class LocationCell: UITableViewCell {
    @IBOutlet weak var lblResName : UILabel!
    @IBOutlet weak var lblResLocation : UILabel!
}

class AddResCell: UITableViewCell {
    @IBOutlet weak var lblAddRes : UILabel!
}