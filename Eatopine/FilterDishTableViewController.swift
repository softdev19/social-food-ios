//
//  FilterDishTableViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 17/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class FilterDishTableViewController: UITableViewController,UISearchResultsUpdating, UISearchBarDelegate,UISearchControllerDelegate {

    var downloadedDishes = [EPDish]()
    
    var searchController: UISearchController!
    var filter:EPFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Dishes"
        let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FilterDishTableViewController.popController))
        self.navigationItem.leftBarButtonItem = backButton
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self;
        searchController.delegate = self
        searchController.initialSetup()
        searchController.searchBar.placeholder = "Search for dish (min 3 char)"
        
        self.definesPresentationContext = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.tableView.tableHeaderView = searchController.searchBar
       // self.definesPresentationContext = true

    }

    override func viewWillAppear(animated: Bool) {
        searchController.active = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    
    func popController() {
        searchController.active = false
        
        self.navigationController?.popViewControllerAnimated(true)
        PersistancyManager.saveFilter(filter)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if downloadedDishes.count == 0 {
            /*
            let label = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.height))
            label.text = "Search for dishes by entering at least 3 charachters"
            label.textAlignment = NSTextAlignment.Center
            label.sizeToFit()
            label.backgroundColor = UIColor.greenColor()
          //  label.center = self.tableView.backgroundView!.center
            self.tableView.backgroundView? = label
            */
            return 0
        }
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return downloadedDishes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DishFilterCell", forIndexPath: indexPath) 

        let dish = downloadedDishes[indexPath.row]
        cell.textLabel?.text = dish.name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dish = downloadedDishes[indexPath.row]
        if filter.dish != dish.name {
            // mark List as Needed refresh because filter changed
            UserDefaults.setBool(true, forKey: LIST_NEEDS_REFRESH)
            UserDefaults.synchronize()
        }
        filter.dish = dish.name
        
        popController()
        
    }
    

    //MARK: UISearchResultsUpdating delegate methods
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        if searchString!.characters.count >= 3 {
            makeSearch(searchString!)
        }
    }
    
    
    func makeSearch(searchString:String) {
    //    AppUtility.showActivityOverlay("")
        EatopineAPI.searchDishes(searchString, completionClosure: { (success, dishes) -> () in
      //      AppUtility.hideActivityOverlay()
            if success {
                self.downloadedDishes = dishes!
                self.tableView.reloadData()
            }
        })
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.popController()
    }
}
