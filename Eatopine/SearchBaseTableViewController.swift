
//
//  SearchBaseTableViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 18/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

protocol EatopineSearchControllerDelegate {
    func didSelect(object:AnyObject)
}

class SearchBaseTableViewController: UITableViewController,UISearchResultsUpdating, UISearchBarDelegate,UISearchControllerDelegate {

    var delegate: EatopineSearchControllerDelegate?
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = backButton
        
        // sets StatusBar background color while SearchController is Active
        let bgView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, self.tableView.frame.height))
        let colorSubview = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, 20))
        colorSubview.backgroundColor = COLOR_EATOPINE_RED
        bgView.addSubview(colorSubview)
        
    //    self.tableView.backgroundView = bgView
        
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self;
        searchController.searchBar.sizeToFit()
        searchController.delegate = self
        searchController.initialSetup()
        
        self.tableView.tableHeaderView = searchController.searchBar
        self.definesPresentationContext = true
        self.searchController.hidesNavigationBarDuringPresentation = false
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


    //MARK: UISearchResultsUpdating delegate methods
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        if searchString!.characters.count >= 3 {
            makeSearch(searchString!)
        }
    }
    
    func makeSearch(search:String) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        if self.presentingViewController != nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
}
