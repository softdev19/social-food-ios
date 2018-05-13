//
//  MenuTableViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 20/09/15.
//  Copyright © 2015 Eatopine. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    private var dishes = [EPResDish]()
    var restaurant:EPRestaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MenuTableViewController.popController))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        downloadDishes()
    }

    func popController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func downloadDishes() {
        AppUtility.showActivityOverlay("Loading")
        EatopineAPI.downloadRestaurantDishes(restaurant.id, page: 0, completionClosure: { (success, dishes) -> () in
            AppUtility.hideActivityOverlay()
            if dishes != nil {
                self.dishes = dishes!
                self.tableView.reloadData()
            }
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dishes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuTableViewCell", forIndexPath: indexPath) as! MenuTableViewCell
        let dish = dishes[indexPath.row]
        
        cell.dish_photo.sd_setImageWithURL(NSURL(string: dish.photo), placeholderImage: UIImage(named: "dish_placeholder"))
        cell.rating.rating = CGFloat(dish.vote)
        cell.lblDishName.text = dish.name
        cell.lblDishNumberOfReviews.text = "\(dish.number_rating) reviews"
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dish = dishes[indexPath.row]
        
        let dishDetailController = storyboard?.instantiateViewControllerWithIdentifier("DishDetailTableViewController") as! DishDetailTableViewController
     //   dishDetailController.dish = dish
        
        //dishDetailController.title = dish.r
        self.navigationController?.pushViewController(dishDetailController, animated: true)
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
