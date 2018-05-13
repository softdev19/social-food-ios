//
//  FiltersViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 16/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {

    @IBOutlet weak var lblCuisines: UILabel!
    @IBOutlet weak var lblDish: UILabel!
    
    @IBOutlet weak var btnDollar1: UIButton!
    @IBOutlet weak var btnDollar2: UIButton!
    @IBOutlet weak var btnDollar3: UIButton!
    @IBOutlet weak var btnDollar4: UIButton!
    @IBOutlet weak var btnDollar5: UIButton!
    
    @IBOutlet weak var btnSearch: UIButton!
    
    var filter:EPFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSearch.hidden = true
        
        filter = PersistancyManager.getFilter()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshScreen()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshScreen() {
        
        lblCuisines.text = filter.getAllCuisines()
        lblDish.text = filter.getDishName()
        
        for buttonString in filter.price {
            let index = Int(buttonString)!
       //     println("index \(index)")
            
            if index == 1 {
                btnDollar1.setTitleColor(COLOR_EATOPINE_RED, forState: UIControlState.Normal)
            }
            if index == 2 {
                
                btnDollar2.setTitleColor(COLOR_EATOPINE_RED, forState: UIControlState.Normal)
            }
            if index == 3 {
                btnDollar3.setTitleColor(COLOR_EATOPINE_RED, forState: UIControlState.Normal)
            }
            if index == 4 {
                
                btnDollar4.setTitleColor(COLOR_EATOPINE_RED, forState: UIControlState.Normal)
            }
            if index == 5 {
                btnDollar5.setTitleColor(COLOR_EATOPINE_RED, forState: UIControlState.Normal)
            }
        }
    }
    
    @IBAction func showCuisineFilter(sender: AnyObject?) {
//        let filterCuisinseController = storyboard?.instantiateViewControllerWithIdentifier("FilterCuisineTableViewController") as! FilterCuisineTableViewController
//        filterCuisinseController.filter = filter
//        self.navigationController?.pushViewController(filterCuisinseController, animated: true)
    }
    
    @IBAction func showDishFilter(sender: AnyObject?) {
//        let filterDishesController = storyboard?.instantiateViewControllerWithIdentifier("FilterDishTableViewController") as! FilterDishTableViewController
//        filterDishesController.filter = filter
//        self.navigationController?.pushViewController(filterDishesController, animated: true)
    }
    
    
    @IBAction func priceButtonTyped(sender: UIButton?) {
        let tagString = "\(sender!.tag)"
        if let index = filter.price.indexOf(tagString) {
            filter.price.removeAtIndex(index)
            sender?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        }else{
            filter.price.append(tagString)
            sender?.setTitleColor(COLOR_EATOPINE_RED, forState: UIControlState.Normal)
        }
        
        // mark List as Needed refresh because filter changed
        UserDefaults.setBool(true, forKey: LIST_NEEDS_REFRESH)
        UserDefaults.synchronize()
    }
    
    
    @IBAction func dismiss(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
     //   println("price \(filter.price)")
        PersistancyManager.saveFilter(filter)
    }
    
    @IBAction func resetFilter(sender: AnyObject?) {
        filter = EPFilter(price: [String](), cuisine: [EPCuisine](), dish: "")
        PersistancyManager.saveFilter(filter)
        
        btnDollar1.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        btnDollar2.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        btnDollar3.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        btnDollar4.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        btnDollar5.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        
        UserDefaults.setBool(true, forKey: LIST_NEEDS_REFRESH)
        UserDefaults.synchronize()
        refreshScreen()
    }
}
