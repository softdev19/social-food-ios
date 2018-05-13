//
//  SavedRestaurantsTableViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 21/09/15.
//  Copyright © 2015 Eatopine. All rights reserved.
//

import UIKit

class SavedRestaurantsTableViewController: UITableViewController {

    var restaurantsArray = [EPRestaurant]()
    var userData:EPUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favourite Restaurants"
        
        let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SavedRestaurantsTableViewController.popController))
        self.navigationItem.leftBarButtonItem = backButton
    }

    func popController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func downloadFavouriteRestaurants(){
        EatopineAPI.getFavouriteRestaurant(userData.id) { (success, favourites) -> () in
            if success == true{
                self.restaurantsArray = favourites!
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurantsArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
