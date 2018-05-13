//
//  FilterCuisineTableViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 16/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class FilterCuisineTableViewController: UITableViewController,UISearchResultsUpdating, UISearchBarDelegate,UISearchControllerDelegate {

    
    var allCuisines = [EPCuisine]()
    var cuisines = [String:[EPCuisine]]()
    var sectionTitles = [String]()
    
    var filteredCuisines = [String:[EPCuisine]]()
    var filteredSectionTitles = [String]()
    
    var searchController: UISearchController!
    var filter:EPFilter!
    
    var filterDict = [String:Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Cuisines"
        let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FilterCuisineTableViewController.popController))
        self.navigationItem.leftBarButtonItem = backButton
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self;
        searchController.delegate = self
        searchController.initialSetup()
        searchController.searchBar.placeholder = "Search cuisines"
        
        
        self.tableView.tableHeaderView = searchController.searchBar
        self.definesPresentationContext = true
        
        updateFilterDict()
        downloadAllCuisines()
    }

    func downloadAllCuisines() {
        
        AppUtility.showActivityOverlay("Downloading")
        EatopineAPI.getCuisines { (success, cuisine) -> () in
            AppUtility.hideActivityOverlay()
            if success {
                self.allCuisines = cuisine!
                
                let tuple = self.sortCuisine(cuisine!)
                self.cuisines = tuple.0
                self.sectionTitles = tuple.1
                self.tableView.reloadData()
                
            }
        }
    }
    
    func updateFilterDict() {
        filterDict.removeAll()
        for (index, cuisin) in filter.cuisine.enumerate() {
            filterDict[cuisin.name] = index
        }
    }

    func sortCuisine(array:[EPCuisine]) -> ([String:[EPCuisine]],[String]){
        
        var localCuisines = [String:[EPCuisine]]()
        
        for cuisine in array {
            let key = (cuisine.name as NSString).substringToIndex(1)
            if localCuisines[key] == nil {
                localCuisines[key] = [EPCuisine]()
            }
            localCuisines[key]?.append(cuisine)
        }
        //FIXME
        let allKeys = localCuisines.keys
        let localSectionTitles = allKeys.sort(<)
        
        return (localCuisines,localSectionTitles)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    
    func popController() {
        self.navigationController?.popViewControllerAnimated(true)
        PersistancyManager.saveFilter(filter)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if searchController.active {
            return filteredSectionTitles.count
        }else{
            return sectionTitles.count
        }
        
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.active {
            return filteredSectionTitles[section]
        }else{
            return sectionTitles[section]
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            let array = filteredCuisines[filteredSectionTitles[section]]
            return array!.count
        }else{
            let array = cuisines[sectionTitles[section]]
            return array!.count
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CuisineFilterCell", forIndexPath: indexPath) 

        var array:[EPCuisine]!
        
        if searchController.active {
            array = filteredCuisines[filteredSectionTitles[indexPath.section]]
        }else{
            array = cuisines[sectionTitles[indexPath.section]]
        }
        
        let cuisine = array![indexPath.row]
        
        print("cu \(filter.cuisine)")
        if (filterDict[cuisine.name] != nil) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        cell.textLabel?.text = cuisine.name
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var array:[EPCuisine]!
        
        // mark List as Needed refresh because filter changed
        UserDefaults.setBool(true, forKey: LIST_NEEDS_REFRESH)
        UserDefaults.synchronize()
        
        if searchController.active {
            array = filteredCuisines[filteredSectionTitles[indexPath.section]]
        }else{
            array = cuisines[sectionTitles[indexPath.section]]
        }
        
        let cuisine = array![indexPath.row]
        
        let filterValue = filterDict[cuisine.name]
        
        if (filterValue != nil) {
            filter.cuisine.removeAtIndex(filterValue!)
        }else{
            filter.cuisine.append(cuisine)
        }
        
        updateFilterDict()
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    
    //MARK: UISearchResultsUpdating delegate methods
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        let filtered = allCuisines.filter( { (cuisine: EPCuisine) -> Bool in
            
            if (cuisine.name.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil) {
                return true
            }else{
                return false
            }
        })
        
     //   println("filtered \(filtered.count)")
        
        
        let tuple = sortCuisine(filtered)
        filteredCuisines = tuple.0
        filteredSectionTitles = tuple.1
        self.tableView.reloadData()
    }

}
