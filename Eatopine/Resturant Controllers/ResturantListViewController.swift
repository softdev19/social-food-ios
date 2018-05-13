//
//  ResturantListViewController.swift
//  Eatopine
//
//  Created by Ourangzaib khan on 9/9/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class ResturantListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!

    var restaurants = [EPRestaurant]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableview.registerClass(self.tableview, forCellWithReuseIdentifier: "Cellss")
        tableview.delegate = self;
        tableview.dataSource = self;
        getSavedRes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cellss" , forIndexPath: indexPath) as! ResturantListTableViewCell
        
        let restaurant = restaurants[indexPath.row]
        cell.resturantName.text = restaurant.name
        cell.resturantPhoto.sd_setImageWithURL(NSURL(string: restaurant.best_dish_photo))
        cell.bestDish.text = restaurant.best_dish_name
        cell.Dishes.text = "\(restaurant.number_dishes) dishes"
        cell.ratingView.setupForEatopineSmall()
        cell.ratingView.rating = restaurant.rating as! CGFloat
        return cell
    }
    
    func getSavedRes() {
        EatopineAPI.downloadUserSavedRes(AppUtility.currentUserId.integerValue, limit: 20, pageNum: 0) { (success, restaurants) in
            if restaurants == nil {
                self.restaurants = [EPRestaurant]()
            }
            else {
                self.restaurants = restaurants!
            }
        }
    }

}
