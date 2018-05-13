//
//  MapResultsTableViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 17/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class MapResultsTableViewController: UITableViewController {

    var results = [EPRestaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MapResultCell")
   //     self.tableView.backgroundColor = COLOR_EATOPINE_RED
        
        let footerView = UIView(frame: CGRectMake(0, 0, 10, 10))
        footerView.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = footerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return results.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MapResultCell", forIndexPath: indexPath) 

        let restaurant = results[indexPath.row]
        cell.textLabel?.text = restaurant.name
        
        
        return cell
    }

}
